local Utils = require("gual.utils")

local function func()
    vim.fn.jobstart("bun run src/tests.ts", {
        cwd = vim.fn.expand("~/Projects/nvim-plugins/bunvim/"),
    })
end

Utils.map("n", "<leader>bt", func)
