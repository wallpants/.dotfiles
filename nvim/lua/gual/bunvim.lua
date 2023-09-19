local Utils = require("gual.utils")

local function func1()
    vim.print("starting")

    vim.fn.jobstart("bun run src/tests.ts", {
        cwd = vim.fn.expand("~/Projects/nvim-plugins/bunvim/"),
        on_stderr = function(_, data)
            vim.print(data)
        end,
        on_stdout = function(_, data)
            vim.print(data)
        end,
    })
end

local function func2()
    vim.print("notifying")
    vim.rpcnotify(0, "something")
end

Utils.map("n", "<leader>bt1", func1)
Utils.map("n", "<leader>bt2", func2)
