-- local DISABLE_HIGHLIGHT_THRESHOLD = 30000

return {
    -- {
    --     "nvim-treesitter/nvim-treesitter",
    --     dependencies = {
    --         "tpope/vim-commentary",
    --         "JoosepAlviste/nvim-ts-context-commentstring",
    --     },
    --     branch = "main",
    --     build = ":TSUpdate",
    --     event = { "BufReadPost", "BufNewFile" },
    --     cmd = { "TSUpdateSync" },
    --     opts = {
    --         highlight = {
    --             enable = true,
    --             additional_vim_regex_highlighting = false,
    --             disable = function(lang, bufnr)
    --                 return vim.api.nvim_buf_line_count(bufnr or 0) > DISABLE_HIGHLIGHT_THRESHOLD
    --             end,
    --         },
    --         indent = { enable = true },
    --         ensure_installed = {
    --             "bash",
    --             "c",
    --             "html",
    --             "javascript",
    --             "json",
    --             "lua",
    --             "luadoc",
    --             "luap",
    --             "markdown",
    --             "sql",
    --             "markdown_inline",
    --             "prisma",
    --             "python",
    --             "query",
    --             "regex",
    --             "tsx",
    --             "typescript",
    --             "vim",
    --             "vimdoc",
    --             "yaml",
    --         },
    --     },
    --     config = function(_, opts)
    --         require("nvim-treesitter").setup(opts)
    --     end,
    -- },
    {
        "romus204/tree-sitter-manager.nvim",
        dependencies = {}, -- tree-sitter CLI must be installed system-wide
        config = function()
            require("tree-sitter-manager").setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "html",
                    "javascript",
                    "json",
                    "lua",
                    "luadoc",
                    "luap",
                    "markdown",
                    "sql",
                    "markdown_inline",
                    "prisma",
                    "python",
                    "query",
                    "regex",
                    "tsx",
                    "typescript",
                    "vim",
                    "vimdoc",
                    "yaml",
                },
                -- Default Options
                -- border = nil, -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
                -- auto_install = false, -- if enabled, install missing parsers when editing a new file
                -- highlight = true, -- treesitter highlighting is enabled by default
                -- languages = {}, -- override or add new parser sources
                -- parser_dir = vim.fn.stdpath("data") .. "/site/parser",
                -- query_dir = vim.fn.stdpath("data") .. "/site/queries",
            })
        end,
    },
}
