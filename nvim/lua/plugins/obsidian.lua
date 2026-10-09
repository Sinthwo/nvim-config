local function vault_path()
  if vim.g.nvim_obsidian_vault and vim.g.nvim_obsidian_vault ~= "" then
    return vim.fn.expand(vim.g.nvim_obsidian_vault)
  end

  if vim.env.OBSIDIAN_VAULT and vim.env.OBSIDIAN_VAULT ~= "" then
    return vim.fn.expand(vim.env.OBSIDIAN_VAULT)
  end

  return vim.fn.expand("~/Documents/Obsidian")
end

return {
  {
    "obsidian-nvim/obsidian.nvim",
    name = "obsidian.nvim",
    version = "*",
    cmd = { "Obsidian" },

    dependencies = {
      "nvim-lua/plenary.nvim",
      "ibhagwan/fzf-lua",
    },

    opts = function()
      return {
        legacy_commands = false,

        workspaces = {
          {
            name = "vault",
            path = vault_path(),
          },
        },

        completion = {
          min_chars = 2,
        },

        picker = {
          name = "fzf-lua",
        },

        cache = {
          enabled = true,
        },
      }
    end,

    keys = {
      { "<leader>oq", "<cmd>Obsidian quick_switch<CR>", desc = "Obsidian quick switch" },
      { "<leader>os", "<cmd>Obsidian search<CR>", desc = "Obsidian search" },
      { "<leader>on", "<cmd>Obsidian new<CR>", desc = "Obsidian new note" },
      { "<leader>ot", "<cmd>Obsidian today<CR>", desc = "Obsidian today" },
      { "<leader>ob", "<cmd>Obsidian backlinks<CR>", desc = "Obsidian backlinks" },
      { "<leader>oc", "<cmd>Obsidian check<CR>", desc = "Obsidian check" },
    },
  },
}
