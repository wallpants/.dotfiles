local Utils = require("gual.utils")

return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "gbprod/yanky.nvim", lazy = true, opts = { ring = { history_length = 500 } } },
        },
        version = false,
        opts = {
            defaults = {
                file_ignore_patterns = { ".git/", "dist", "pnpm-lock.yaml", "**/*.min.js" },
                vimgrep_arguments = {
                    "rg",
                    -- Disables colored output (telescope handles highlighting)
                    "--color=never",
                    -- Outputs each match on its own line instead of grouping by filename
                    -- "--no-heading",
                    -- Includes the filename in each match line
                    -- "--with-filename",
                    -- Shows line numbers for matches
                    -- "--line-number",
                    -- Shows column numbers for matches
                    "--column",
                    -- Treats the pattern as a literal string, not a regex
                    "--fixed-strings",
                    "--smart-case",
                },
                path_display = {
                    truncate = 10, -- number: padding to the right
                },
                mappings = {
                    n = {
                        ["i"] = function(...)
                            return require("telescope.actions").file_split(...)
                        end,
                        ["s"] = function(...)
                            return require("telescope.actions").file_vsplit(...)
                        end,
                        ["t"] = function(...)
                            return require("trouble.providers.telescope").open_selected_with_trouble(...)
                        end,
                        ["q"] = function(...)
                            return require("telescope.actions").close(...)
                        end,
                        ["<leader>q"] = function(...)
                            return require("telescope.actions").delete_buffer(...)
                        end,
                    },
                },
            },
        },
        config = function(_, opts)
            require("telescope").setup(opts)
            require("telescope").load_extension("yank_history")
            ---@type any
            local builtin = require("telescope.builtin")

            Utils.map("n", "<leader>p", "<cmd>Telescope yank_history<cr>", { desc = "Yank history" })
            Utils.map("n", "<C-b>", function()
                builtin.buffers({ ignore_current_buffer = true })
            end, { desc = "Switch buffers" })
            Utils.map("n", "<C-p>", function()
                builtin.find_files({ hidden = true })
            end, { desc = "Search cwd files" })
            -- map("n", "<leader>ff", builtin.git_files, { desc = "Search git files" })
            Utils.map("n", "<leader>ll", function()
                builtin.diagnostics()
            end, { desc = "List diagnostic issues" })
            Utils.map("n", "<leader>fr", function()
                builtin.oldfiles({ only_cwd = true })
            end, { desc = "Search recent files" })
            Utils.map("n", "<leader>fg", function()
                builtin.git_status({ only_cwd = true })
            end, { desc = "Search github modified, staged, and untracked." })
            Utils.map("n", "<leader>sg", builtin.live_grep, { desc = "Live grep smart case" })
            Utils.map("n", "<leader>sG", function()
                builtin.live_grep({ additional_args = { "--case-sensitive" } })
            end, { desc = "Live grep case sensitive" })
            Utils.map("n", "<leader>sr", builtin.resume, { desc = "Resume search" })
            Utils.map("n", "<leader>sw", builtin.grep_string, { desc = "Search word" })
            Utils.map("n", "<leader>sa", builtin.autocommands, { desc = "Search autocommands" })
            Utils.map("n", "<leader>sk", builtin.keymaps, { desc = "Search keymaps" })
            Utils.map("n", "<leader>sc", function()
                builtin.colorscheme({ enable_preview = true })
            end, { desc = "Search colorschemes" })
            -- Utils.map("n", "<leader>aco", builtin.lsp_outgoing_calls, { desc = "Lsp outgoing calls" })
            -- Utils.map("n", "<leader>aci", builtin.lsp_incoming_calls, { desc = "Lsp incoming calls" })
            Utils.map("n", "<leader>ag", builtin.lsp_definitions, { desc = "Lsp definitions" })
            Utils.map("n", "<leader>ai", builtin.lsp_implementations, { desc = "Lsp implementations" })
            Utils.map("n", "<leader>ar", function()
                builtin.lsp_references({ show_line = false, include_declaration = false })
            end, { desc = "Lsp references" })
            -- Utils.map("n", "<leader>ad", builtin.lsp_type_definitions, { desc = "Lsp type definition" })
            -- Utils.map("n", "<leader>sp", builtin.spell_suggest, { desc = "Spelling suggestions suggest" })
        end,
    },
}
