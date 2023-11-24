local M = {}

M.setup_border = function(type, highlight_group)
    local borders_map = {
        double = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
        single = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
        shadow = { "", "", " ", " ", " ", " ", " ", "" },
        rounded = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        solid = { " ", " ", " ", " ", " ", " ", " ", " " },
    }

    local result = {}

    for _, symbol in ipairs(borders_map[type]) do
        table.insert(result, { symbol, highlight_group })
    end

    return result
end

---@param mode string | string[]
---@param lhs string
---@param rhs string|function
---@param opts? table
M.map = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.noremap = opts.noremap == nil and true or opts.noremap
    vim.keymap.set(mode, lhs, rhs, opts)
end

---@param tool string
M.ensure_mason_install = function(tool)
    local mr = require("mason-registry")
    local package = mr.get_package(tool)
    if not package:is_installed() then
        package:install()
    end
end

M.set_background_transparent = function()
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

return M
