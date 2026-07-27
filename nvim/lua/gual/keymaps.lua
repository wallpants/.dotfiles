local Utils = require("gual.utils")

local cmd = vim.cmd
cmd("command Vs vs")
cmd("command Sp sp")
cmd("command Wq wq")
cmd("command W w")
cmd("command Q q")
cmd("command Bd bd")

Utils.map("i", "<Up>", "<Nop>", { desc = "Disabled arrow key" })
Utils.map("i", "<Down>", "<Nop>", { desc = "Disabled arrow key" })
Utils.map("i", "<Left>", "<Nop>", { desc = "Disabled arrow key" })
Utils.map("i", "<Right>", "<Nop>", { desc = "Disabled arrow key" })

Utils.map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
Utils.map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
Utils.map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
Utils.map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

Utils.map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
Utils.map("v", "<leader>c", '"+y', { desc = "Copy to clipboard" })

Utils.map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })
-- Utils.map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
-- Utils.map({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

Utils.map("n", "<leader>wt", "<cmd>resize +8<CR>", { desc = "Resize window TALLER" })
Utils.map("n", "<leader>ws", "<cmd>resize -8<CR>", { desc = "Resize window SHORTER" })
Utils.map("n", "<leader>ww", "<cmd>vertical resize +15<CR>", { desc = "Resize window WIDER" })
Utils.map("n", "<leader>wn", "<cmd>vertical resize -15<CR>", { desc = "Resize window NARROWER" })

local function mouse_click_focus()
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

Utils.map("n", "<LeftMouse>", mouse_click_focus, { desc = "Focus clicked window" })

local function disable_next_line()
    local keys = vim.api.nvim_replace_termcodes("Oeslint-disable-next-line <esc>gccw", true, true, true)
    vim.fn.feedkeys(keys)
end
Utils.map("n", "<leader>dnl", disable_next_line, { desc = "Insert eslint-disable-next-line above" })

Utils.map("n", "<leader>o", function()
    -- call twice to enter diagnostic's floating window
    vim.diagnostic.open_float()
    vim.diagnostic.open_float()
end, { desc = "Open diagnostic float and focus it" })

Utils.map("n", "<leader>df", function()
    -- format-on-save autocmd lives in the FormatConfig group (plugins/formatting.lua)
    pcall(vim.api.nvim_del_augroup_by_name, "FormatConfig")
    vim.print("format-on-save disabled")
end, { desc = "Disable format-on-save" })

Utils.map("n", "<leader>cp", function()
    vim.cmd("let @+ = expand('%:~:.')")
    vim.print("relative path copied")
end, { desc = "Copy relative path to clipboard" })

Utils.map("n", "<leader>ca", function()
    vim.cmd("let @+ = expand('%:p')")
    vim.print("absolute path copied")
end, { desc = "Copy absolute path to clipboard" })

Utils.map("n", "<leader>bd", function()
    vim.cmd("%bd|e#|bd#")
end, { desc = "Delete all buffers except current" })
