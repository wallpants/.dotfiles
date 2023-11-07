local function set_background_transparent()
    local hl_groups = {
        "Normal",
        "NormalNC",
        "LineNr",
        "SignColumn",
    }

    for _, hl_group in ipairs(hl_groups) do
        vim.api.nvim_set_hl(0, hl_group, { bg = "none" })
    end
end

-- vim.api.nvim_set_hl(0, "NormalFloat", {
--     link = "Normal",
-- })

return {
    {
        "marko-cerovac/material.nvim",
        -- enabled = false,
        event = { "BufRead" },
        config = function()
            vim.opt.background = "light"
            vim.g.material_style = "lighter"
            require("material").setup({
                plugins = {
                    "gitsigns",
                    "illuminate",
                    "indent-blankline",
                    "mini",
                    "nvim-cmp",
                    "nvim-tree",
                    "nvim-web-devicons",
                    "telescope",
                },
                disable = { colored_cursor = true },
                high_visibility = { lighter = true },
            })
            vim.cmd([[colorscheme material]])
        end,
    },

    {
        "nyoom-engineering/oxocarbon.nvim",
        enabled = false,
        config = function()
            vim.cmd([[colorscheme oxocarbon]])
            vim.api.nvim_set_hl(0, "@keyword", { fg = "#ee5396" })
            vim.api.nvim_set_hl(0, "@include", { fg = "#82cfff" })
            vim.api.nvim_set_hl(0, "@tag.attribute", { fg = "#08bdba" })
            vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#08bdba" })
            vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#ee5396" })
            vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = "#08bdba" })
            vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = "#ee5396" })
            vim.api.nvim_set_hl(0, "DiagnosticsBorder", { fg = "#FF6F00" }) -- diagnostics
            vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#82cfff" })
            vim.api.nvim_set_hl(0, "StatusLine", { fg = "#FAFAFA", bg = "#691a82", bold = true })
            vim.api.nvim_set_hl(0, "CursorLine", { bg = "#30233d" })

            set_background_transparent()
        end,
    },
}
