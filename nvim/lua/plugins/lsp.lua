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
                -- "ts_ls",
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
