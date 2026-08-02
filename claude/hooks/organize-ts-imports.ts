#!/usr/bin/env bun
// PostToolUse hook (Edit|Write), run via bun: sort + combine import statements
// in the edited TypeScript file, using the project's own `typescript` package
// so the result matches what tsgo/tsserver's organizeImports produces on save
// in nvim. SortAndCombine mode only — never removes "unused" imports, so it
// can't drop an import the model just added but hasn't referenced yet.
// Silent no-op on anything unexpected: hooks must never block the session.

import fs from "node:fs";
import { createRequire } from "node:module";
import path from "node:path";

type TSModule = typeof import("typescript");

function organize(raw: string) {
  let file: string | undefined;
  try {
    file = JSON.parse(raw)?.tool_input?.file_path;
  } catch {
    return;
  }
  if (!file || !/\.(ts|tsx|mts|cts)$/.test(file) || file.endsWith(".d.ts")) return;
  if (!fs.existsSync(file)) return;

  // Prefer the project's own typescript so sorting matches its exact version,
  // but typescript >= 7 (the Go port) no longer ships the JS language-service
  // API — fall back to the TS 6 vendored in this directory (see claude-setup.sh)
  const candidates = [
    () => createRequire(file!)("typescript"),
    () => createRequire(import.meta.url)("typescript"),
  ];
  let ts: TSModule | undefined;
  for (const load of candidates) {
    try {
      const candidate = load();
      if (typeof candidate.createLanguageService === "function") {
        ts = candidate;
        break;
      }
    } catch {
      // try next candidate
    }
  }
  if (!ts) return;

  const text = fs.readFileSync(file, "utf8");

  const host: import("typescript").LanguageServiceHost = {
    getScriptFileNames: () => [file!],
    getScriptVersion: () => "0",
    getScriptSnapshot: (f) => {
      const src = f === file ? text : fs.existsSync(f) ? fs.readFileSync(f, "utf8") : undefined;
      return src === undefined ? undefined : ts.ScriptSnapshot.fromString(src);
    },
    getCurrentDirectory: () => path.dirname(file!),
    getCompilationSettings: () => ({ target: ts.ScriptTarget.Latest, jsx: ts.JsxEmit.Preserve }),
    getDefaultLibFileName: (opts) => ts.getDefaultLibFilePath(opts),
    fileExists: fs.existsSync,
    readFile: (f) => fs.readFileSync(f, "utf8"),
  };

  const service = ts.createLanguageService(host);
  const changes = service.organizeImports(
    { type: "file", fileName: file, mode: ts.OrganizeImportsMode.SortAndCombine },
    { newLineCharacter: "\n" },
    {},
  );

  let out = text;
  for (const change of changes) {
    if (change.fileName !== file) continue;
    const edits = [...change.textChanges].sort((a, b) => b.span.start - a.span.start);
    for (const e of edits) {
      out = out.slice(0, e.span.start) + e.newText + out.slice(e.span.start + e.span.length);
    }
  }
  if (out !== text) fs.writeFileSync(file, out);
}

try {
  organize(await Bun.stdin.text());
} catch {
  // never fail the hook
}
