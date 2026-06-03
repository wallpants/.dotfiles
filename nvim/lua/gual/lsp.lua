local Utils = require("gual.utils")

vim.lsp.enable("gdscript")

vim.lsp.config("tailwindcss", {
    settings = {
        tailwindCSS = {
            classFunctions = { "cn" },
            lint = {
                suggestCanonicalClasses = "ignore",
            },
        },
    },
})

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                },
            },
        },
    },
})

vim.lsp.config("ts_ls", {
    settings = {
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
            },
        },
        javascript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
            },
        },
    },
})

vim.diagnostic.config({
    severity_sort = true,
    update_in_insert = false,
    float = {
        border = "rounded",
        source = "always",
    },
    underline = true,
    virtual_text = {
        spacing = 2,
        source = "always",
        prefix = "●",
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "E",
            [vim.diagnostic.severity.WARN] = "W",
            [vim.diagnostic.severity.INFO] = "I",
            [vim.diagnostic.severity.HINT] = "H",
        },
    },
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        -- local bufnr = args.buf

        Utils.map("n", "K", vim.lsp.buf.hover)
        Utils.map("n", "<leader>ap", vim.diagnostic.goto_prev, {
            desc = "Go to previous diagnostic",
        })
        Utils.map("n", "<leader>an", vim.diagnostic.goto_next, {
            desc = "Go to next diagnostic",
        })
        Utils.map("i", "<c-k>", vim.lsp.buf.signature_help, {
            desc = "Signature help",
        })
        Utils.map("n", "<leader>rn", vim.lsp.buf.rename, {
            desc = "Replace in buffer",
        })
        Utils.map("n", "<leader>ca", vim.lsp.buf.code_action, {
            desc = "Code action",
        })

        -- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
        --
        -- vim.api.nvim_create_autocmd("BufWritePre", {
        --     group = augroup,
        --     buffer = bufnr,
        --     callback = function()
        --         vim.lsp.buf.format({
        --             async = false,
        --             bufnr = bufnr,
        --         })
        --     end,
        -- })
        --
        -- Utils.map("n", "<leader>df", function()
        --     vim.cmd("autocmd! LspFormatting")
        --     vim.print("format-on-save disabled")
        -- end)
    end,
})
