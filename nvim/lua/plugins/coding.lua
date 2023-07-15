return {
  {
    "alvan/vim-closetag",
    event = { "InsertEnter" },
    init = function()
      vim.g.closetag_filetypes = "html,js,typescriptreact"
      vim.g.closetag_enable_react_fragment = 0
      vim.g.closetag_emptyTags_caseSensitive = 1
      vim.g.closetag_regions = {
        ["typescript.tsx"] = "jsxRegion,tsxRegion",
        ["javascript.jsx"] = "jsxRegion",
      }
    end,
  },

  {
    "echasnovski/mini.pairs",
    event = { "InsertEnter" },
    config = true,
  },

  {
    "tpope/vim-surround",
    event = { "BufReadPost", "BufNewFile" },
  },

  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = function()
      return {
        options = {
          pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        },
      }
    end,
  },
}
