#!/usr/bin/env bun
// PostToolUse hook (Edit|Write), run via bun: run the same formatter
// conform.nvim uses on the edited file (oxfmt / stylua / black), matching
// format-on-save in nvim. Formatters resolve their own project config from the
// file's location, so ignore rules (.oxfmtrc.json ignorePatterns,
// .styluaignore) are respected and ignored files are left untouched.
// Silent no-op on anything unexpected: hooks must never block the session.

import { spawnSync } from "node:child_process";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";

// extension -> formatter, mirroring nvim/lua/plugins/formatting.lua
const FORMATTERS = [
  {
    bin: "oxfmt",
    exts: [
      "js",
      "jsx",
      "ts",
      "tsx",
      "mts",
      "cts",
      "mjs",
      "cjs",
      "json",
      "json5",
      "jsonc",
      "yaml",
      "yml",
      "md",
      "markdown",
      "css",
      "html",
    ],
    // exit 2 when the file is covered by ignorePatterns would read as a hook error
    args: (file: string) => ["--no-error-on-unmatched-pattern", file],
  },
  {
    bin: "stylua",
    exts: ["lua"],
    // stylua formats explicitly-passed files even when ignored unless told not to;
    // without --search-parent-directories it only checks the cwd for stylua.toml
    args: (file: string) => ["--respect-ignores", "--search-parent-directories", file],
  },
  {
    bin: "black",
    exts: ["py"],
    args: (file: string) => ["--quiet", file],
  },
];

function format(raw: string) {
  let file: string | undefined;
  try {
    file = JSON.parse(raw)?.tool_input?.file_path;
  } catch {
    return;
  }
  if (!file || !fs.existsSync(file)) return;

  const ext = path.extname(file).slice(1).toLowerCase();
  const formatter = FORMATTERS.find((f) => f.exts.includes(ext));
  if (!formatter) return;

  // hooks don't run in a login shell, so PATH may lack mason's bin dir
  const masonBin = path.join(
    os.homedir(),
    ".local",
    "share",
    "nvim",
    "mason",
    "bin",
    formatter.bin,
  );
  const bin = fs.existsSync(masonBin) ? masonBin : formatter.bin;

  spawnSync(bin, formatter.args(file), {
    cwd: path.dirname(file),
    stdio: "ignore",
    timeout: 15000,
  });
}

try {
  format(await Bun.stdin.text());
} catch {
  // never fail the hook
}
