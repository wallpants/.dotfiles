local format_on_save = true

-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = {
--     "*.js",
--     "*.jsx",
--     "*.ts",
--     "*.tsx",
--     "*.cjs",
--     "*.mjs",
--   },
--   callback = function()
--     vim.cmd("EslintFixAll")
--     vim.cmd("write")
--   end,
-- })

return {
  {
    "mhartington/formatter.nvim",
    event = { "VeryLazy" },
    opts = function()
      local Utils = require("gual.utils")
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
        require("formatter.filetypes.javascript").eslint_d,
        require("formatter.filetypes.javascript").prettierd,
      }

      return {
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = {
          html = { require("formatter.filetypes.html").prettierd },
          json = { require("formatter.filetypes.json").prettierd },
          lua = { require("formatter.filetypes.lua").stylua },
          yaml = { require("formatter.filetypes.yaml").prettierd },
          javascript = jsts_filetype,
          javascriptreact = jsts_filetype,
          typescript = jsts_filetype,
          typescriptreact = jsts_filetype,
        },
      }
    end,
  },
}
