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
            -- lspconfig.bashls.setup({})
            -- vim.lsp.config("bashls")
            vim.lsp.enable({ "bashls" })

            Utils.ensure_mason_install("css-lsp")
            -- lspconfig.cssls.setup({})
            vim.lsp.enable({ "cssls" })

            Utils.ensure_mason_install("html-lsp")
            -- lspconfig.html.setup({})
            vim.lsp.enable({ "html" })

            Utils.ensure_mason_install("tailwindcss-language-server")
            -- lspconfig.tailwindcss.setup({})
            vim.lsp.enable({ "tailwindcss" })

            Utils.ensure_mason_install("prisma-language-server")
            -- lspconfig.prismals.setup({})
            vim.lsp.enable({ "prismals" })

            -- install with homebrew insted
            -- Utils.ensure_mason_install("pyright")
            -- lspconfig.pyright.setup({})
            vim.lsp.enable({ "pyright" })

            Utils.ensure_mason_install("lua-language-server")
            -- lspconfig.lua_ls.setup({})
            vim.lsp.enable({ "lua_ls" })

            Utils.ensure_mason_install("json-lsp")
            -- lspconfig.jsonls.setup({
            --     settings = {
            --         json = {
            --             schemas = require("schemastore").json.schemas(),
            --             validate = { enable = true },
            --         },
            --     },
            -- })
            vim.lsp.config("jsonls", {
                settings = {
                    json = {
                        schemas = require("schemastore").json.schemas(),
                        validate = { enable = true },
                    },
                },
            })
            vim.lsp.enable({ "jsonls" })

            -- visuals
            vim.diagnostic.config({
                severity_sort = true,
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
            -- Utils.ensure_mason_install("markdownlint")
            Utils.ensure_mason_install("prettierd")
            Utils.ensure_mason_install("eslint_d")
            Utils.ensure_mason_install("stylua")
            Utils.ensure_mason_install("commitlint")
            Utils.ensure_mason_install("yamllint")
            -- install with homebrew instead
            -- Utils.ensure_mason_install("pylint")
            Utils.ensure_mason_install("black")

            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    require("none-ls.code_actions.eslint_d"),

                    require("none-ls.formatting.eslint_d"),
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.black,
                    -- null_ls.builtins.formatting.markdownlint,
                    null_ls.builtins.formatting.prettierd,

                    require("none-ls.diagnostics.yamllint"),
                    require("none-ls.diagnostics.eslint_d").with({
                        condition = function(utils)
                            return utils.root_has_file({ ".eslintrc.js", ".eslintrc.json", ".eslintrc.cjs", "eslint.config.js" })
                        end,
                    }),
                    null_ls.builtins.diagnostics.selene,
                    -- null_ls.builtins.diagnostics.dotenv_linter,
                    -- null_ls.builtins.diagnostics.markdownlint,
                    null_ls.builtins.diagnostics.commitlint,
                    null_ls.builtins.diagnostics.pylint,
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
