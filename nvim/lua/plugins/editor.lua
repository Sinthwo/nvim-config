return {
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Problems" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer problems" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "Symbols" },
    },
  },

  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous TODO" },
      { "<leader>ft", "<cmd>TodoFzfLua<CR>", desc = "Find TODOs" },
    },
  },

  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>uu", "<cmd>UndotreeToggle<CR>", desc = "Undo tree" },
    },
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = {
        width = 0.82,
      },
    },
    keys = {
      { "<leader>uz", "<cmd>ZenMode<CR>", desc = "Zen mode" },
    },
  },
}
