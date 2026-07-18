-- Minimal config loaded by the `vim` alias: `nvim -u ~/.dotfiles/nvim/minimal.lua`
-- Core options & keymaps, but only the plugins allowlisted below.

require("gual.options")
require("gual.keymaps")
require("gual.autocmds")

---grab a plugin spec from the main config so minimal mode
---reuses the same opts/keymaps instead of duplicating them
---@param module string
---@param name string
local function from_main_config(module, name)
    for _, spec in ipairs(require(module)) do
        if spec[1] == name then
            return spec
        end
    end
    error("spec not found in " .. module .. ": " .. name)
end

-- plugins allowed in minimal mode, add lazy.nvim specs as needed
local plugins = {
    { "tpope/vim-surround" },
    { "echasnovski/mini.pairs", config = true },
    from_main_config("plugins.editor", "nvim-tree/nvim-web-devicons"),
    from_main_config("plugins.editor", "nvim-tree/nvim-tree.lua"),
    from_main_config("plugins.telescope", "nvim-telescope/telescope.nvim"),
}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(plugins, {
    change_detection = {
        enabled = false,
    },
    -- keep the main config's lazy-lock.json out of reach so a
    -- lazy operation in minimal mode can't rewrite it
    lockfile = vim.fn.stdpath("state") .. "/minimal-lazy-lock.json",
})
