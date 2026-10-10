return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },

    opts = {
      current_line_blame = false,
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },

    keys = {
      { "]h", function() require("gitsigns").nav_hunk("next") end, desc = "Next Git hunk" },
      { "[h", function() require("gitsigns").nav_hunk("prev") end, desc = "Previous Git hunk" },
      { "<leader>gh", function() require("gitsigns").preview_hunk() end, desc = "Preview hunk" },
      { "<leader>gs", function() require("gitsigns").stage_hunk() end, desc = "Stage hunk" },
      { "<leader>gr", function() require("gitsigns").reset_hunk() end, desc = "Reset hunk" },
      { "<leader>gb", function() require("gitsigns").blame_line({ full = true }) end, desc = "Show line blame" },
    },
  },

  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "ibhagwan/fzf-lua",
    },
    opts = {
      kind = "split",
    },
    keys = {
      { "<leader>gg", "<cmd>Neogit<CR>", desc = "Git status" },
      { "<leader>gc", "<cmd>Neogit commit<CR>", desc = "Git commit" },
      { "<leader>gp", "<cmd>Neogit push<CR>", desc = "Git push" },
      { "<leader>gP", "<cmd>Neogit pull<CR>", desc = "Git pull" },
      { "<leader>gl", "<cmd>Neogit log<CR>", desc = "Git log" },
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Git diff view" },
      { "<leader>gH", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
    },
  },
}
