return {
    -- {
    --     "alvan/vim-closetag",
    --     event = { "InsertEnter" },
    --     init = function()
    --         vim.g.closetag_filetypes = "html,js,typescriptreact"
    --         vim.g.closetag_enable_react_fragment = 0
    --         vim.g.closetag_emptyTags_caseSensitive = 1
    --         vim.g.closetag_regions = {
    --             ["typescript.tsx"] = "jsxRegion",
    --             ["javascript.jsx"] = "jsxRegion",
    --         }
    --     end,
    -- },
    {
        "windwp/nvim-ts-autotag",
        event = { "InsertEnter" },
        config = true,
    },

    {
        "echasnovski/mini.pairs",
        event = { "InsertEnter" },
        config = true,
    },

    {
        "tpope/vim-surround",
        event = { "BufReadPost", "BufNewFile" },
    },
}
