local Utils = require("gual.utils")

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
            lspconfig.jsonls.setup({
                settings = {
                    json = {
                        schemas = require("schemastore").json.schemas(),
                        validate = { enable = true },
                    },
                },
            })

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
        opts = {
            -- spawn additional tsserver instance to calculate diagnostics on it
            separate_diagnostic_server = false,
        },
    },

    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvimtools/none-ls-extras.nvim",
        },
        config = function()
            Utils.ensure_mason_install("selene")
            Utils.ensure_mason_install("markdownlint")

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
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({
                                    async = false,
                                    bufnr = bufnr,
                                    filter = function(_client)
                                        return _client.name == "null-ls"
                                    end,
                                })
                            end,
                        })
                    end
                end,
            })
        end,
    },
}
