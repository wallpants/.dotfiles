local function set_background_transparent()
    local hl_groups = {
        "Normal",
        "NormalNC",
        "LineNr",
        "SignColumn",
        -- "Comment",
        -- "Constant",
        -- "Special",
        -- "Identifier",
        -- "Statement",
        -- "PreProc",
        -- "Type",
        -- "Underlined",
        -- "Todo",
        -- "String",
        -- "Function",
        -- "Conditional",
        -- "Repeat",
        -- "Operator",
        -- "Structure",
        -- "NonText",
        -- "CursorLineNr",
        -- "EndOfBuffer",
    }

    for _, hl_group in ipairs(hl_groups) do
        vim.api.nvim_set_hl(0, hl_group, { bg = "none" })
    end
end

return {
    {
        "folke/tokyonight.nvim",
        lazy = true,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme tokyonight]])
            set_background_transparent()
        end,
    },

    {
        "nyoom-engineering/oxocarbon.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            -- vim.opt.background = "light"
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

            -- disable semantic highlighting
            -- for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
            --     vim.api.nvim_set_hl(0, group, {})
            -- end

            set_background_transparent()
        end,
    },
}

-- "#FFF01F"
-- "#3ddbd9"
-- "#ee5396"
-- "#33b1ff"
-- "#ff7eb6"
-- "#be95ff"
-- "#82cfff"
-- "#131313"
-- "#37474F"
-- "#90A4AE"
-- "#525252"
-- "#08bdba"
-- "#FF6F00"
-- "#0f62fe"
-- "#673AB7"
-- "#42be65"
-- "#FFAB91"
-- "#FAFAFA"
