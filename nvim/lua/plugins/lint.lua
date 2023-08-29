-- cspell:ignore mfussenegger williamboman markdownlint
local Utils = require("gual.utils")

return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    dev = true,
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      local lint = require("lint")
      local lspconfig_util = require("lspconfig.util")

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

      Utils.ensure_mason_install("eslint_d")
      Utils.ensure_mason_install("markdownlint")
      Utils.ensure_mason_install("cspell")

      local markdownlint = require("lint").linters.markdownlint
      table.insert(markdownlint.args, "--disable MD041")

      lint.linters_by_ft = {
        json = {},
        text = {},
        css = {},
        lua = {},
        markdown = { "markdownlint" },
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      }

      local cspell_config_path = lspconfig_util.root_pattern(".cspell.json")(vim.api.nvim_buf_get_name(0))
      if cspell_config_path ~= nil then
        for ft in pairs(lint.linters_by_ft) do
          table.insert(lint.linters_by_ft[ft], "cspell")
        end
      end

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufEnter", "TextChanged", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
