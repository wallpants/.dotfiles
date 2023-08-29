return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      local lint = require("lint")
      local Utils = require("gual.utils")

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
      markdownlint.stdin = true
      markdownlint.args = {
        "--stdin",
        "--disable MD041",
      }

      local js_ts_filetype = { "eslint_d", "cspell" }

      lint.linters_by_ft = {
        lua = { "cspell" },
        json = { "cspell" },
        markdown = { "markdownlint", "cspell" },
        javascript = js_ts_filetype,
        javascriptreact = js_ts_filetype,
        typescript = js_ts_filetype,
        typescriptreact = js_ts_filetype,
      }

      vim.api.nvim_create_autocmd({ "BufReadPost", "TextChanged", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
