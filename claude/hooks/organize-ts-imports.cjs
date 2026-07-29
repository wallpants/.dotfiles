#!/usr/bin/env node
// PostToolUse hook (Edit|Write): sort + combine import statements in the edited
// TypeScript file, using the project's own `typescript` package so the result
// matches what tsgo/tsserver's organizeImports produces on save in nvim.
// SortAndCombine mode only — never removes "unused" imports, so it can't drop
// an import the model just added but hasn't referenced yet.
// Silent no-op on anything unexpected: hooks must never block the session.

const fs = require("fs");
const path = require("path");
const { createRequire } = require("module");

function organize(raw) {
   let file;
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
      () => createRequire(file)("typescript"),
      () => require(path.join(__dirname, "node_modules", "typescript")),
   ];
   let ts;
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

   const host = {
      getScriptFileNames: () => [file],
      getScriptVersion: () => "0",
      getScriptSnapshot: (f) => {
         const src = f === file ? text : fs.existsSync(f) ? fs.readFileSync(f, "utf8") : undefined;
         return src === undefined ? undefined : ts.ScriptSnapshot.fromString(src);
      },
      getCurrentDirectory: () => path.dirname(file),
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

let input = "";
process.stdin.on("data", (chunk) => (input += chunk));
process.stdin.on("end", () => {
   try {
      organize(input);
   } catch {
      // never fail the hook
   }
});
