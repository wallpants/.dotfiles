local format_on_save = true

local function sql_formatter()
  return {
    exe = "sql-formatter",
    args = {
      "-l postgresql",
    },
    stdin = true,
  }
end

return {
  {
    "mhartington/formatter.nvim",
    event = { "VeryLazy" },
    opts = function()
      local Utils = require("gual.utils")
      Utils.ensure_mason_install("sql-formatter")
      Utils.ensure_mason_install("prettierd")
      Utils.ensure_mason_install("eslint_d")
      Utils.ensure_mason_install("stylua")

      if format_on_save then
        vim.api.nvim_create_autocmd("BufWritePost", {
          group = Utils.augroup("format"),
          pattern = { "*" },
          command = "FormatWrite",
        })

        vim.cmd("command NoFormat autocmd! gual_format")
      end

      local jsts_filetype = {
        require("formatter.defaults").eslint_d,
        require("formatter.defaults").prettierd,
      }

      return {
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = {
          lua = { require("formatter.filetypes.lua").stylua },
          sql = { sql_formatter },
          css = { require("formatter.defaults").prettierd },
          html = { require("formatter.defaults").prettierd },
          json = { require("formatter.defaults").prettierd },
          yaml = { require("formatter.defaults").prettierd },
          javascript = jsts_filetype,
          javascriptreact = jsts_filetype,
          typescript = jsts_filetype,
          typescriptreact = jsts_filetype,
        },
      }
    end,
  },
}
