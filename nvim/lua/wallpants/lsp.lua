local Utils = require("wallpants.utils")

vim.lsp.enable("gdscript")

local oxlint_base = assert(loadfile(vim.api.nvim_get_runtime_file("lsp/oxlint.lua", false)[1]))()

vim.lsp.config("oxlint", {
    settings = {
        run = "onSave",
    },
    before_init = function(init_params, config)
        oxlint_base.before_init(init_params, config)

        if init_params.capabilities.workspace then
            init_params.capabilities.workspace.diagnostics = nil
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
                -- eagerly index every plugin's lua/ dir so all types
                -- (LazyPluginSpec, plugin config classes, ...) are visible
                -- without a require. One root per plugin, not the parent lazy
                -- dir: a parent root breaks .luarc.json's pathStrict require
                -- resolution for plugins whose repo name ends in .lua
                -- (nvim-tree.lua). lazydev.nvim adds the vim runtime.
                library = vim.fn.glob(vim.fn.stdpath("data") .. "/lazy/*/lua", true, true),
            },
        },
    },
})

-- nvim-lspconfig renamed the "tsgo" config to "tsc" (TS7 ships the native
-- compiler as tsc). The default cmd resolves the project's node_modules/.bin/tsc
-- first, then tsc/tsgo on PATH — keep global installs off PATH so only the
-- project binary can match.
-- keep server-emitted edits (organize imports) matching oxfmt's tabWidth,
-- so they don't get re-indented by conform right after
local ts_js_format = {
    indentSize = 3,
    tabSize = 3,
    convertTabsToSpaces = true,
}

vim.lsp.config("tsc", {
    settings = {
        typescript = {
            preferences = {
                importModuleSpecifier = "shortest",
                preferTypeOnlyAutoImports = true,
            },
            format = ts_js_format,
            inlayHints = {
                parameterNames = { enabled = false },
                parameterTypes = { enabled = false },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
                functionLikeReturnTypes = { enabled = false },
                enumMemberValues = { enabled = false },
            },
        },
        javascript = {
            format = ts_js_format,
        },
    },
})

vim.lsp.enable("tsc")

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
        Utils.map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
        Utils.map("n", "<leader>ap", function()
            vim.diagnostic.jump({ count = -1, float = true })
        end, { desc = "Go to previous diagnostic" })
        Utils.map("n", "<leader>an", function()
            vim.diagnostic.jump({ count = 1, float = true })
        end, { desc = "Go to next diagnostic" })
        Utils.map("i", "<c-k>", vim.lsp.buf.signature_help, {
            desc = "Signature help",
        })
        -- <leader>rn/<leader>rp belong to vim-illuminate reference navigation
        Utils.map("n", "<leader>rb", vim.lsp.buf.rename, {
            desc = "Rename symbol (replace in buffer)",
        })
        Utils.map("n", "<leader>rr", function()
            vim.cmd("lsp restart")
        end, { desc = "Restart LSP clients" })
        -- never used; <leader>ca now copies the absolute path (wallpants/keymaps.lua)
        -- Utils.map("n", "<leader>ca", vim.lsp.buf.code_action, {
        --     desc = "Code action",
        -- })

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
