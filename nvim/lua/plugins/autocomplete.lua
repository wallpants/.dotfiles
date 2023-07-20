local Utils = require("gual.utils")

return {
  {
    "L3MON4D3/LuaSnip",
    opts = {
      delete_check_events = "TextChanged",
    },
    -- stylua: ignore
    keys = {
      { "<s-tab>", function() return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<s-tab>" end, expr = true, silent = true, mode = "i" },
      { "<s-tab>", function() require("luasnip").jump(1) end, mode = "s" },
      -- { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },

  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "roobert/tailwindcss-colorizer-cmp.nvim",
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")

      return {
        window = {
          -- completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered({
            border = Utils.setup_border("rounded", "FloatBorder"),
            -- we manually set winhighlight to override defaults which
            -- override FloatBorder highlight
            winhighlight = "CursorLine:Visual,Search:None",
          }),
        },
        formatting = {
          format = require("tailwindcss-colorizer-cmp").formatter,
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item({
                behavior = cmp.SelectBehavior.Select,
              })
            else
              cmp.complete({
                config = {
                  sources = {
                    { name = "nvim_lsp" },
                  },
                },
              })
            end
          end),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "path" },
        }, {
          { name = "luasnip" },
        }, {
          { name = "buffer", keyword_length = 5 },
        }),
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
      }
    end,
  },
}
