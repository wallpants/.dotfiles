local Utils = require("gual.utils")

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line_count = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "PlenaryTestPopup",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "spectre_panel",
        "checkhealth",
    },
    callback = function(event)
        ---@type number
        local buffer = event.buf
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buffer, silent = true })
    end,
})

-- Set filetype of .env* files to bash
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { ".env*" },
    command = "set filetype=sh",
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.conf" },
    command = "set filetype=conf",
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = {
        "*.json",
        "*.md",
    },
    callback = function()
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
    end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        Utils.set_background_transparent()
    end,
})
