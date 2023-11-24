local M = {}

M.insert_markdown_code_block = function()
    local lang = vim.fn.input("code block: ")
    local buffer = vim.api.nvim_get_current_buf()
    local current_line = vim.fn.line(".")
    vim.api.nvim_buf_set_lines(buffer, current_line - 1, current_line - 1, false, { "```" .. lang, "```" })
    vim.fn.feedkeys("kO")
end

M.get_highlight_group_under_cursor = function()
    local result = vim.treesitter.get_captures_at_cursor(0)
    print(vim.inspect(result))
end

M.mouse_click_focus = function()
    ---@type number
    local winid_under_mouse = vim.api.nvim_call_function("getmousepos", {}).winid
    ---@type number
    local current_winid = vim.api.nvim_call_function("win_getid", {})
    -- if we clicked on an unfocused window, focus it
    if winid_under_mouse ~= current_winid then
        vim.api.nvim_call_function("win_gotoid", { winid_under_mouse })
    else
        -- Fallback to default behavior
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<LeftMouse>", true, false, true), "n", true)
    end
end

M.cspell_ignore = function()
    local keys = vim.api.nvim_replace_termcodes("Ocspell:ignore <esc>gccA", true, true, true)
    vim.fn.feedkeys(keys)
end

M.disable_next_line = function()
    local keys = vim.api.nvim_replace_termcodes("Odisable-next-line <esc>gccw", true, true, true)
    vim.fn.feedkeys(keys)
end

return M
