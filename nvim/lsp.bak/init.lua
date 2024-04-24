-- cspell:ignore cspell tailwindcss jsonls gopls lspconfigs
-- local Utils = require("gual.utils")

-- local lspconfigs = {
--     require("plugins.lsp.jsonls"),
--     require("plugins.lsp.lua_ls"),
--     require("plugins.lsp.tailwindcss"),
--     require("plugins.lsp.tsserver"),
--     require("plugins.lsp.gopls"),
--     require("plugins.lsp.html"),
--     require("plugins.lsp.css"),
--     require("plugins.lsp.bash"),
--     require("plugins.lsp.marksman"),
--     require("plugins.lsp.python"),
--     require("plugins.lsp.prisma"),
--     -- require("plugins.lsp.langual"),
-- }

return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        cmd = "Mason",
        config = true,
    },

    -- {
    --     "neovim/nvim-lspconfig",
    --     event = { "BufReadPost", "BufNewFile" },
    --     dependencies = {
    --         "williamboman/mason.nvim",
    --         { "folke/neodev.nvim" },
    --         { "b0o/SchemaStore.nvim", version = false },
    --     },
    --     config = function()
    --         local lspconfig = require("lspconfig")
    --         local capabilities = require("cmp_nvim_lsp").default_capabilities()

    --         lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, {
    --             capabilities = capabilities,
    --         })

    --         vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    --             border = Utils.setup_border("rounded", "FloatBorder"),
    --         })

    --         vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    --             border = Utils.setup_border("rounded", "FloatBorder"),
    --         })

    --         Utils.map("n", "K", vim.lsp.buf.hover)
    --         Utils.map("n", "<leader>ap", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
    --         Utils.map("n", "<leader>an", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
    --         Utils.map("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
    --         Utils.map("n", "<leader>rb", vim.lsp.buf.rename, { desc = "Replace in buffer" })

    --         for _, config in pairs(lspconfigs) do
    --             config(lspconfig)
    --         end
    --     end,
    -- },
}
