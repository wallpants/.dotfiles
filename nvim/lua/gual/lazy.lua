local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  -- change_detection = {
  --   enabled = false,
  -- },
  dev = {
    -- directory where you store your local plugin projects
    path = "~/Projects/nvim-plugins",
    -- plugins that match these patterns will use your local versions
    -- instead of being fetched from GitHub
    ---@type string[]
    patterns = { "gualcasas" }, -- For example {"folke"}
    fallback = true, -- Fallback to git when local plugin doesn't exist
  },
})
