local format_on_save = true

return {
    {
        "mhartington/formatter.nvim",
        event = { "VeryLazy" },
        opts = function()
            local Utils = require("gual.utils")
            Utils.ensure_mason_install("prettierd")
            Utils.ensure_mason_install("eslint_d")
            Utils.ensure_mason_install("stylua")
            Utils.ensure_mason_install("goimports")
            Utils.ensure_mason_install("shfmt")

            if format_on_save then
                vim.api.nvim_create_autocmd("BufWritePost", {
                    group = Utils.augroup("format"),
                    pattern = { "*" },
                    command = "FormatWrite",
                })

                vim.cmd("command NoFormat autocmd! gual_format")
            end

            local js_ts_filetype = {
                require("formatter.defaults").eslint_d,
                require("formatter.defaults").prettierd,
            }

            return {
                logging = true,
                log_level = vim.log.levels.WARN,
                filetype = {
                    zsh = { require("formatter.filetypes.sh").shfmt },
                    sh = { require("formatter.filetypes.sh").shfmt },
                    go = { require("formatter.filetypes.go").goimports },
                    lua = { require("formatter.filetypes.lua").stylua },
                    css = { require("formatter.defaults").prettierd },
                    scss = { require("formatter.defaults").prettierd },
                    html = { require("formatter.defaults").prettierd },
                    json = { require("formatter.defaults").prettierd },
                    jsonc = { require("formatter.defaults").prettierd },
                    yaml = { require("formatter.defaults").prettierd },
                    markdown = { require("formatter.defaults").prettierd },
                    javascript = js_ts_filetype,
                    javascriptreact = js_ts_filetype,
                    typescript = js_ts_filetype,
                    typescriptreact = js_ts_filetype,
                },
            }
        end,
    },
}
