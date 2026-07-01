local Utils = require("gual.utils")

vim.lsp.enable("gdscript")

-- ============================================================================
-- OXLINT CONFIGURATION
-- ============================================================================
-- Problem: oxlint's pull diagnostics (textDocument/diagnostic) trigger on every
-- keystroke via Neovim's automatic didChange notifications. This causes:
--   1. Stale diagnostics appearing mid-edit
--
-- Solution: Disable automatic pull diagnostics and manually request them only
-- on specific events (InsertLeave, BufReadPost, TextChanged).
--
-- How it works:
--   - LSP has two diagnostic models:
--     * Push (textDocument/publishDiagnostics): Server sends diagnostics to client
--     * Pull (textDocument/diagnostic): Client requests diagnostics from server
--   - Neovim 0.11+ automatically requests pull diagnostics on every didChange event
--   - There's no built-in way to debounce or control when pull requests happen
--   - oxlint's `run` setting only affects push diagnostics, and only when the
--     editor "does not support textDocument/diagnostic"
--
-- Our workaround:
--   1. Tell Neovim that oxlint doesn't support pull diagnostics (vim.NIL)
--   2. Set `run = "onSave"` so oxlint doesn't push diagnostics on every keystroke
--   3. Manually request diagnostics on our preferred events
-- ============================================================================

vim.lsp.config("oxlint", {
    -- Disable pull diagnostics capability so Neovim won't auto-request on every edit.
    -- This makes oxlint's `run` setting take effect (it only works when the editor
    -- "does not support textDocument/diagnostic").
    -- https://oxc.rs/docs/guide/usage/linter/lsp-config-reference.html#run
    capabilities = { textDocument = { diagnostic = vim.NIL } },
    -- With pull diagnostics disabled, this controls when push diagnostics are sent.
    -- We set "onSave" to prevent diagnostics while typing, then manually trigger
    -- pull diagnostics on our preferred events below.
    settings = { run = "onSave" },
})

-- When oxlint attaches, create buffer-local autocmds to manually request diagnostics.
-- We bypass Neovim's automatic pull diagnostic system entirely.
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or client.name ~= "oxlint" then
            return
        end

        local function request_diagnostics()
            local params = {
                textDocument = vim.lsp.util.make_text_document_params(args.buf),
            }
            -- Manually send a textDocument/diagnostic request
            -- (even though we told Neovim the server doesn't support it, the server still does)
            client:request("textDocument/diagnostic", params, function(err, result)
                if err or not result then
                    return
                end
                local items = result.items or {}
                -- Use the same namespace Neovim's LSP diagnostic system would use
                local ns = vim.lsp.diagnostic.get_namespace(client.id)
                -- Convert LSP Diagnostic objects to vim.Diagnostic format
                -- (Neovim's internal handler does this automatically, but since we're
                -- bypassing it, we need to do the conversion ourselves)
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
                -- Set diagnostics for this buffer in the LSP namespace
                vim.diagnostic.set(ns, args.buf, diagnostics)
            end, args.buf)
        end

        -- Request diagnostics immediately on attach
        request_diagnostics()

        -- Create buffer-local autocmds for this buffer only
        local augroup = vim.api.nvim_create_augroup("OxlintDiagnostics" .. args.buf, { clear = true })
        vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
            group = augroup,
            buffer = args.buf,
            callback = request_diagnostics,
        })
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
    init_options = {
        preferences = {
            importModuleSpecifierPreference = "non-relative",
        },
    },
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
