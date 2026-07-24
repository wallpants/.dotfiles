return {
    {
        "mason-org/mason.nvim",
        opts = {},
    },
    {
        "neovim/nvim-lspconfig",
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            automatic_enable = {
                exclude = {
                    "oxfmt",
                    "ts_ls", -- installed for claude-code, nvim uses tsgo
                },
            },
        },
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = {
                "tsgo",
                "ts_ls", -- used by claude-code's typescript-lsp plugin, not nvim
                "bash-language-server",
                "css-lsp",
                "html-lsp",
                "tailwindcss-language-server",
                "prisma-language-server",
                "lua_ls",
                "json-lsp",
                "pyright",
                "pylint",
                "oxfmt",
                "oxlint",
                -- "eslint-lsp",
                "selene",
                "stylua",
                "commitlint",
                "yaml-language-server",
                "black",
                "gdscript-formatter",
            },
        },
    },
}
