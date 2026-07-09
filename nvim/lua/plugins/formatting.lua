return {
    {
        "stevearc/conform.nvim",
        ---@module "conform"
        ---@type conform.setupOpts
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "black" },
                javascript = { "oxfmt" },
                javascriptreact = { "oxfmt" },
                typescript = { "oxfmt" },
                typescriptreact = { "oxfmt" },
                json = { "oxfmt" },
                json5 = { "oxfmt" },
                jsonc = { "oxfmt" },
                yaml = { "oxfmt" },
                markdown = { "oxfmt" },
                css = { "oxfmt" },
                html = { "oxfmt" },
                gdscript = { "gdscript-formatter" },
            },
            default_format_opts = {
                lsp_format = "fallback",
            },
        },
        init = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
        config = function(_, opts)
            local conform = require("conform")
            conform.setup(opts)

            vim.api.nvim_create_autocmd("BufWritePre", {
                desc = "Format before save",
                pattern = "*",
                group = vim.api.nvim_create_augroup("FormatConfig", { clear = true }),
                callback = function(ev)
                    local conform_opts = { bufnr = ev.buf, lsp_format = "fallback", timeout_ms = 2000 }

                    -- 🚀 CHANGED: Fetch the active 'tsgo' client instead of the old 'ts_ls'
                    local client = vim.lsp.get_clients({ name = "tsgo", bufnr = ev.buf })[1]

                    if not client then
                        pcall(vim.cmd, "undojoin")
                        conform.format(conform_opts)
                        return
                    end

                    -- Use standard LSP code action for organizing imports (works with tsgo)
                    local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
                    params.context = {
                        only = { "source.organizeImports" },
                        diagnostics = {},
                    }

                    local result = client:request_sync("textDocument/codeAction", params, 1000, ev.buf)

                    if result and result.result and result.result[1] then
                        local action = result.result[1]
                        if action.edit then
                            pcall(vim.cmd, "undojoin")
                            vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
                        elseif action.command then
                            pcall(vim.cmd, "undojoin")
                            client:exec_cmd(action.command)
                        end
                    end

                    pcall(vim.cmd, "undojoin")
                    conform.format(conform_opts)
                end,
            })
        end,
    },
}
-- return {
--     {
--         "stevearc/conform.nvim",
--         -- This will provide type hinting with LuaLS
--         ---@module "conform"
--         ---@type conform.setupOpts
--         opts = {
--             -- Define your formatters
--             formatters_by_ft = {
--                 lua = { "stylua" },
--                 python = { "black" },
--                 javascript = { "oxfmt" },
--                 javascriptreact = { "oxfmt" },
--                 typescript = { "oxfmt" },
--                 typescriptreact = { "oxfmt" },
--                 json = { "oxfmt" },
--                 json5 = { "oxfmt" },
--                 jsonc = { "oxfmt" },
--                 yaml = { "oxfmt" },
--                 markdown = { "oxfmt" },
--                 css = { "oxfmt" },
--                 html = { "oxfmt" },
--                 gdscript = { "gdscript-formatter" },
--             },
--             -- Set default options
--             default_format_opts = {
--                 lsp_format = "fallback",
--             },
--             -- Set up format-on-save
--             -- format_on_save = { timeout_ms = 500 },
--         },
--         init = function()
--             -- If you want the formatexpr, here is the place to set it
--             vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
--         end,
--         config = function(_, opts)
--             local conform = require("conform")
--             conform.setup(opts)
--
--             vim.api.nvim_create_autocmd("BufWritePre", {
--                 desc = "Format before save",
--                 pattern = "*",
--                 group = vim.api.nvim_create_augroup("FormatConfig", { clear = true }),
--                 callback = function(ev)
--                     local conform_opts = { bufnr = ev.buf, lsp_format = "fallback", timeout_ms = 2000 }
--                     local client = vim.lsp.get_clients({ name = "ts_ls", bufnr = ev.buf })[1]
--                     -- local client = vim.lsp.get_clients({ name = "oxlint", bufnr = ev.buf })[1]
--                     -- local client = vim.lsp.get_clients({ name = "eslint", bufnr = ev.buf })[1]
--
--                     if not client then
--                         -- Join format changes with previous edit so they undo together
--                         pcall(vim.cmd, "undojoin")
--                         conform.format(conform_opts)
--                         return
--                     end
--
--                     -- vim.cmd("LspOxlintFixAll")
--                     -- vim.cmd("LspEslintFixAll")
--
--                     -- Join format changes with previous edit so they undo together
--                     pcall(vim.cmd, "undojoin")
--                     local request_result = client:request_sync("workspace/executeCommand", {
--                         command = "_typescript.organizeImports",
--                         arguments = { vim.api.nvim_buf_get_name(ev.buf) },
--                     })
--
--                     if request_result and request_result.err then
--                         vim.notify(request_result.err.message, vim.log.levels.ERROR)
--                         return
--                     end
--
--                     -- Join format changes with previous edit so they undo together
--                     pcall(vim.cmd, "undojoin")
--                     conform.format(conform_opts)
--                 end,
--             })
--         end,
--     },
-- }
