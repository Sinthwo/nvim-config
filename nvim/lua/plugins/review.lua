-- Optional Git review features. No existing keymaps are replaced.
return {
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    opts = {},
  },
  {
    "nvim-mini/mini.diff",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- Use line numbers so Gitsigns keeps ownership of the sign column.
      view = { style = "number" },
    },
    config = function(_, opts)
      require("mini.diff").setup(opts)
      vim.api.nvim_create_user_command("MiniDiffOverlay", function()
        require("mini.diff").toggle_overlay(0)
      end, { desc = "Toggle inline Git changes in the current buffer" })
    end,
  },
}
