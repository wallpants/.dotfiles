local Utils = require("gual.utils")

local cmd = vim.cmd
cmd("command Vs vs")
cmd("command Sp sp")
cmd("command Wq wq")
cmd("command W w")
cmd("command Q q")
cmd("command Bd bd")

-- Move to window using the <ctrl> hjkl keys
Utils.map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
Utils.map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
Utils.map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
Utils.map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Clear search with <esc>
Utils.map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
Utils.map({ "v" }, "<leader>c", '"+y', { desc = "Copy to clipboard" })

Utils.map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
Utils.map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
Utils.map({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

Utils.map("n", "<leader>wt", "<cmd>resize +8<CR>") -- resize window TALLER
Utils.map("n", "<leader>ws", "<cmd>resize -8<CR>") -- resize window SHORTER
Utils.map("n", "<leader>ww", "<cmd>vertical resize +15<CR>") -- resize window WIDER
Utils.map("n", "<leader>wn", "<cmd>vertical resize -15<CR>") -- resize window NARROWER

Utils.map("n", "<leader>hg", function()
  local result = vim.treesitter.get_captures_at_cursor(0)
  print(vim.inspect(result))
end, { silent = true })

Utils.map("n", "<LeftMouse>", function()
  local winid_under_mouse = vim.api.nvim_call_function("getmousepos", {}).winid
  local current_winid = vim.api.nvim_call_function("win_getid", {})
  -- if we clicked on an unfocused window, focus it
  if winid_under_mouse ~= current_winid then
    vim.api.nvim_call_function("win_gotoid", { winid_under_mouse })
  else
    -- Fallback to default behavior
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<LeftMouse>", true, false, true), "n", true)
  end
end)
