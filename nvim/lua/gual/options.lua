vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- disable netrw at the very start of your init.lua
-- https://github.com/nvim-tree/nvim-tree.lua/tree/master
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

opt.linebreak = true
opt.shiftwidth = 3 -- Size of an indent
opt.tabstop = 3 -- Number of spaces tabs count for

-- za fold
vim.opt.fillchars = { fold = " " }
vim.opt.foldmethod = "indent"
vim.opt.foldenable = false
vim.opt.foldlevel = 99

opt.background = "light"
opt.guicursor = "n-c-sm:block,i-ci:ver25,r-cr-o-v-ve:hor20"
opt.autowrite = true -- Enable auto write
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.swapfile = false
opt.completeopt = "menu,menuone,noinsert"
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 2
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "n" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 15 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 15 -- Lines of context
opt.shiftround = true -- Round indent
opt.sidescrolloff = 10 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.termguicolors = true -- True color support
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.splitkeep = "screen"

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

vim.g.sql_type_default = "sqlanywhere"
