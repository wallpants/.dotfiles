-- Windows config, symlinked to %LOCALAPPDATA%\nvim\init.lua by scripts/windows-setup.ps1.
-- Always runs minimal mode: the full config's external tools (tree-sitter CLI,
-- mason builds, tsgo, oxlint, formatters) aren't installed on Windows.

local dotfiles_nvim = vim.fs.normalize("~/.dotfiles/nvim")
vim.opt.runtimepath:prepend(dotfiles_nvim)
dofile(dotfiles_nvim .. "/minimal.lua")
