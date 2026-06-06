local Utils = require("gual.utils")

vim.lsp.enable("gdscript")

-- This is a fucking mess, but oxlint is extremely slow and shows stale diagnostics
-- if I type quickly and immediately leave insert mode. I can't find another way
-- to configure it to run better.
vim.lsp.config("oxlint", {
    capabilities = { textDocument = { diagnostic = vim.NIL } },
    settings = { run = "onSave" },
})
vim.api.nvim_create_autocmd({ "InsertLeave", "BufReadPost", "TextChanged" }, {
    callback = function(args)
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf, name = "oxlint" })) do
            local params = {
                textDocument = vim.lsp.util.make_text_document_params(args.buf),
            }
            client:request("textDocument/diagnostic", params, function(err, result)
                if err or not result then
                    return
                end
                local items = result.items or {}
                local ns = vim.lsp.diagnostic.get_namespace(client.id)
                local diagnostics = vim.tbl_map(function(item)
                    return {
                        lnum = item.range.start.line,
                        col = item.range.start.character,
                        end_lnum = item.range["end"].line,
                        end_col = item.range["end"].character,
                        severity = item.severity,
                        message = item.message,
                        source = item.source or "oxlint",
                        code = item.code,
                    }
                end, items)
                vim.diagnostic.set(ns, args.buf, diagnostics)
            end, args.buf)
        end
    end,
})

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
        Utils.map("n", "<leader>ap", function()
            vim.diagnostic.jump({ count = -1, float = true })
        end, { desc = "Go to previous diagnostic" })
        Utils.map("n", "<leader>an", function()
            vim.diagnostic.jump({ count = 1, float = true })
        end, { desc = "Go to next diagnostic" })
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
