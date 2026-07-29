return {
    {
        -- Expanded type declarations on demand (closest nvim equivalent of
        -- VS Code's prettify-ts). Docs target ts_ls; testing against tsgo.
        "Sebastian-Nielsen/better-type-hover",
        ft = { "typescript", "typescriptreact" },
        config = function()
            require("better-type-hover").setup({
                -- default <C-P> collides with telescope find_files
                openTypeDocKeymap = "<leader>k",
            })
        end,
    },
}
