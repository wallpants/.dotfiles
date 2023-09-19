local Utils = require("gual.utils")

local function func1()
    vim.fn.jobstart("bun run src/tests.ts", {
        cwd = vim.fn.expand("~/Projects/nvim-plugins/bunvim/"),
    })
end

local function func2()
    vim.rpcnotify(0, "something")
end

Utils.map("n", "<leader>bt1", func1)
Utils.map("n", "<leader>bt2", func2)
