return {
    {
        "windwp/nvim-ts-autotag",
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
