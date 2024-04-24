local Utils = require("gual.utils")

-- async_formatting
local async_formatting = function(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    vim.lsp.buf_request(bufnr, "textDocument/formatting", vim.lsp.util.make_formatting_params({}),
        function(err, res, ctx)
            if err then
                local err_msg = type(err) == "string" and err or err.message
                -- you can modify the log message / level (or ignore it completely)
                vim.notify("formatting: " .. err_msg, vim.log.levels.WARN)
                return
            end

            -- don't apply results if buffer is unloaded or has been modified
            if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, "modified") then
                return
            end

            if res then
                local client = vim.lsp.get_client_by_id(ctx.client_id)
                vim.lsp.util.apply_text_edits(res, bufnr, client and client.offset_encoding or "utf-16")
                vim.api.nvim_buf_call(bufnr, function()
                    vim.cmd("silent noautocmd update")
                end)
            end
        end)
end

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
            "folke/neodev.nvim",
            "b0o/SchemaStore.nvim",
        },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()



            lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, {
                capabilities = capabilities,
            })

            -- languages
            Utils.ensure_mason_install("bash-language-server")
            lspconfig.bashls.setup({})

            Utils.ensure_mason_install("css-lsp")
            lspconfig.cssls.setup({})

            Utils.ensure_mason_install("html-lsp")
            lspconfig.html.setup({})

            Utils.ensure_mason_install("tailwindcss-language-server")
            lspconfig.tailwindcss.setup({})

            Utils.ensure_mason_install("lua-language-server")
            lspconfig.lua_ls.setup({})

            Utils.ensure_mason_install("json-lsp")
            lspconfig.jsonls.setup {
                settings = {
                    json = {
                        schemas = require('schemastore').json.schemas(),
                        validate = { enable = true },
                    },
                },
            }

            -- visuals
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = Utils.setup_border("rounded", "FloatBorder"),
            })
            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                border = Utils.setup_border("rounded", "FloatBorder"),
            })
            vim.diagnostic.config({
                severity_sort = true,
                -- virtual_text = {
                --     source = "if_many",
                -- },
                float = {
                    border = Utils.setup_border("single", "DiagnosticsBorder"),
                    severity_sort = true,
                    source = "always",
                    max_width = 85,
                },
            })

            -- keymaps
            Utils.map("n", "K", vim.lsp.buf.hover)
            Utils.map("n", "<leader>ap", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
            Utils.map("n", "<leader>an", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
            Utils.map("n", "<leader>rr", ":LspRestart<cr>", { desc = "LspRestart" })
            Utils.map("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
            Utils.map("n", "<leader>rb", vim.lsp.buf.rename, { desc = "Replace in buffer" })
        end,
    },

    {
        "pmizio/typescript-tools.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {},
    },

    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvimtools/none-ls-extras.nvim",
        },
        config = function()
            local Utils = require("gual.utils")
            Utils.ensure_mason_install("selene")

            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    require("none-ls.code_actions.eslint_d"),

                    require("none-ls.formatting.eslint_d"),
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.markdownlint,
                    null_ls.builtins.formatting.prettierd,

                    require("none-ls.diagnostics.yamllint"),
                    require("none-ls.diagnostics.eslint_d"),
                    null_ls.builtins.diagnostics.selene,
                    null_ls.builtins.diagnostics.dotenv_linter,
                    null_ls.builtins.diagnostics.markdownlint,
                    null_ls.builtins.diagnostics.commitlint,
                },
                -- async_formatting
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePost", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                async_formatting(bufnr)
                            end,
                        })
                    end
                end,
            })
        end,
    },
}
