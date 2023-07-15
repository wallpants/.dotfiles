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

      -- override eslint_d to lint stdin
      lint.linters.eslint_d.stdin = true
      lint.linters.eslint_d.args = {
        "--stdin",
        "--stdin-filename",
        function()
          return vim.api.nvim_buf_get_name(0)
        end,
      }

      Utils.ensure_mason_install("eslint_d")
      local jsts_filetype = {
        "eslint_d",
      }

      lint.linters_by_ft = {
        javascript = jsts_filetype,
        javascriptreact = jsts_filetype,
        typescript = jsts_filetype,
        typescriptreact = jsts_filetype,
      }

      vim.api.nvim_create_autocmd({ "BufReadPost", "TextChanged", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
