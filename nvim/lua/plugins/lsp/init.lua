local Utils = require("gual.utils")

local jsonls = require("plugins.lsp.jsonls")
local lua_ls = require("plugins.lsp.lua_ls")
local tailwindcss = require("plugins.lsp.tailwindcss")
local tsserver = require("plugins.lsp.tsserver")
local eslint = require("plugins.lsp.eslint")

return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = "Mason",
    config = true,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      { "folke/neodev.nvim", opts = { lsp_config = false } },
      { "b0o/SchemaStore.nvim", version = false },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.diagnostic.config({
        severity_sort = true,
        virtual_text = {
          source = "always",
        },
        float = {
          border = Utils.setup_border("single", "DiagnosticsBorder"),
          severity_sort = true,
          source = "always",
          max_width = 85,
        },
      })

      lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, {
        capabilities = capabilities,
      })

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = Utils.setup_border("rounded", "FloatBorder"),
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = Utils.setup_border("rounded", "FloatBorder"),
      })

      Utils.map("n", "K", vim.lsp.buf.hover)
      Utils.map("n", "<leader>ap", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
      Utils.map("n", "<leader>an", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
      Utils.map("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
      Utils.map("n", "<leader>rb", vim.lsp.buf.rename, { desc = "Replace in buffer" })

      jsonls(lspconfig)
      lua_ls(lspconfig)
      tailwindcss(lspconfig)
      tsserver(lspconfig)
      eslint(lspconfig)
    end,
  },
}
