local Utils = require("gual.utils")

---@type LazyPluginSpec[]
return {
    {
        "nvim-tree/nvim-web-devicons",
        opts = {
            strict = true,
            override_by_filename = {
                [".env.dev"] = {
                    icon = "",
                    name = "Env",
                },
            },
        },
    },

    --{
    --    "wallpants/napoleon.nvim",
    --    dev = true,
    --    cmd = { "NapoleonSend" },
    --    keys = { "<leader>ns" },
    --    ---@type napoleon_config
    --    opts = {
    --        -- model = "phi3:medium",
    --        autoscroll = false,
    --        model = "qwen2:72b",
    --        temperature = 1,
    --        initial_message = {
    --            role = "system",
    --            message = {
    --                "You're an assistant embedded in a code editor called Neovim.",
    --                "If you provide any code examples and are not asked for a specific language, please provide code samples using typescript.",
    --            },
    --        },
    --        log_level = "debug",
    --    },
    --    config = function(_, opts)
    --        local napoleon = require("napoleon")
    --        napoleon.setup(opts)

    --        local fns = napoleon.fns
    --        vim.keymap.set("n", "<leader>ns", fns.send)
    --    end,
    --},

    {
        "wallpants/ghost-text.nvim",
        dev = true,
        ---@type ghost_text_config
        opts = {
            filetype_domains = {
                markdown = { "*.openai.com*", "*.github.com*", "*.reddit.com*" },
            },
            -- log_level = "debug",
        },
    },

    {
        "wallpants/github-preview.nvim",
        dev = true,
        cmd = { "GithubPreviewToggle" },
        keys = { "<leader>mpt" },
        ---@type github_preview_config
        opts = {
            theme = {
                high_contrast = true,
            },
            log_level = "debug",
        },
        config = function(_, opts)
            local gpreview = require("github-preview")
            gpreview.setup(opts)

            local fns = gpreview.fns
            vim.keymap.set("n", "<leader>mpt", fns.toggle)
            vim.keymap.set("n", "<leader>mpc", fns.clear_overrides)
            vim.keymap.set("n", "<leader>mps", fns.single_file_toggle)
            vim.keymap.set("n", "<leader>mpd", fns.details_tags_toggle)
        end,
    },

    {
        "NvChad/nvim-colorizer.lua",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            user_default_options = {
                tailwind = "both",
            },
        },
    },

    -- {
    --     "stevearc/oil.nvim",
    --     dependencies = { "nvim-tree/nvim-web-devicons" },
    --     opts = {},
    --     config = function(_, opts)
    --         require("oil").setup(opts)
    --         vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
    --     end,
    -- },

    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {},
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<CR>", noremap = true, desc = "NvimTree Toggle" },
            { "<leader>fe", "<cmd>NvimTreeFocus<CR>", noremap = true, desc = "NvimTree Focus" },
            { "<leader>ff", "<cmd>NvimTreeFindFile<CR>", noremap = true, desc = "NvimTree FindFile" },
            { "<leader>fF", "<cmd>NvimTreeFindFile!<CR>", noremap = true, desc = "NvimTree FindFile change root (!)" },
        },
        opts = {
            view = {
                adaptive_size = true,
            },
            filters = {
                dotfiles = true,
            },
            actions = {
                open_file = {
                    window_picker = {
                        enable = false,
                    },
                },
            },
            on_attach = function(buffer_id)
                local api = require("nvim-tree.api")
                -- default mappings
                api.config.mappings.default_on_attach(buffer_id)
                local opts = { buffer = buffer_id, silent = true, nowait = true }
                -- custom mappings
                Utils.map("n", ".", api.tree.toggle_hidden_filter, opts)
                Utils.map("n", "i", api.node.open.horizontal, opts)
                Utils.map("n", "o", api.node.run.system, opts)
                Utils.map("n", "s", api.node.open.vertical, opts)
                Utils.map("n", "y", api.fs.copy.node, opts)
                Utils.map("n", "G", api.tree.toggle_git_clean_filter, opts)
                Utils.map("n", "<C-j>", api.tree.change_root_to_node, opts)
                Utils.map("n", "<C-k>", api.tree.change_root_to_parent, opts)
            end,
        },
    },

    {
        "akinsho/bufferline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        keys = {
            { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
            { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
            { "<leader>gb", "<Cmd>BufferLinePick<CR>", desc = "Go to buffer" },
            { "<leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>", desc = "Go to buffer 1" },
            { "<leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>", desc = "Go to buffer 2" },
            { "<leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>", desc = "Go to buffer 3" },
            { "<leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>", desc = "Go to buffer 4" },
            { "<leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>", desc = "Go to buffer 5" },
            { "<leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>", desc = "Go to buffer 6" },
            { "<leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>", desc = "Go to buffer 7" },
            { "<leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>", desc = "Go to buffer 8" },
            { "<leader>9", "<Cmd>BufferLineGoToBuffer 9<CR>", desc = "Go to buffer 9" },
            { "<leader>,", "<Cmd>BufferLineMovePrev<CR>", desc = "Move buffer left (bufferline)" },
            { "<leader>.", "<Cmd>BufferLineMoveNext<CR>", desc = "Move buffer right (bufferline)" },
        },
        opts = {
            options = {
                show_close_icon = false,
                numbers = "ordinal",
                close_command = function(n)
                    require("mini.bufremove").delete(n, false)
                end,
                diagnostics = "nvim_lsp",
            },
        },
    },

    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            on_attach = function()
                ---@type any
                local gs = package.loaded.gitsigns
                Utils.map("n", "gn", gs.next_hunk, { desc = "Git Next Hunk" })
                Utils.map("n", "gp", gs.prev_hunk, { desc = "Git Prev Hunk" })
            end,
        },
    },

    {
        "RRethy/vim-illuminate",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            delay = 200,
            large_file_cutoff = 2000,
            large_file_overrides = {
                providers = { "lsp" },
            },
        },
        config = function(_, opts)
            local illuminate = require("illuminate")
            illuminate.configure(opts)
            Utils.map("n", "<leader>rn", illuminate.goto_next_reference)
            Utils.map("n", "<leader>rp", illuminate.goto_prev_reference)
        end,
        init = function()
            vim.api.nvim_set_hl(0, "IlluminatedWordText", { underline = true, italic = true })
            vim.api.nvim_set_hl(0, "IlluminatedWordRead", { underline = true, italic = true })
            vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { underline = true, italic = true })
        end,
    },

    {
        "echasnovski/mini.bufremove",
        -- stylua: ignore
        keys = {
            { "<leader>q", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
            { "<leader>Q", function() require("mini.bufremove").delete(0, true) end,  desc = "Delete Buffer (Force)" },
        },
    },

    {
        "echasnovski/mini.indentscope",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            -- symbol = "▏",
            symbol = "│",
            -- options = { try_as_border = true },
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                },
                callback = function()
                    ---@diagnostic disable-next-line: inject-field
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
    },

    {
        "nvim-pack/nvim-spectre",
        cmd = "Spectre",
        opts = { open_cmd = "noswapfile vnew" },
        -- stylua: ignore
        keys = {
            { "<leader>ra", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
        },
    },
}
