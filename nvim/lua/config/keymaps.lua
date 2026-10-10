local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

map("n", "<C-s>", "<cmd>write<CR>", { desc = "Save file" })
map("i", "<C-s>", "<Esc><cmd>write<CR>a", { desc = "Save file" })

map("n", "<C-h>", "<C-w>h", { desc = "Focus left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus right window" })

map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Horizontal split" })
map("n", "<leader>sc", "<cmd>close<CR>", { desc = "Close split" })

map("n", "<leader>bc", function()
  local ok, snacks = pcall(require, "snacks")
  if ok and snacks.bufdelete then
    snacks.bufdelete()
  else
    vim.cmd("bdelete")
  end
end, { desc = "Close current file" })

map("n", "<leader>bo", function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.bo[buf].buflisted then
      pcall(vim.api.nvim_buf_delete, buf, { force = false })
    end
  end
end, { desc = "Close other files" })

map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Leave terminal input mode" })

vim.api.nvim_create_user_command("BackgroundPick", function()
  require("config.background").pick()
end, {})

vim.api.nvim_create_user_command("BackgroundFolder", function()
  require("config.background").open_folder()
end, {})

map("n", "<leader>ub", function()
  require("config.background").pick()
end, { desc = "Choose wallpaper" })

map("n", "<leader>uB", function()
  require("config.background").open_folder()
end, { desc = "Open wallpaper folder" })

-- =========================================================
-- Multi-session AI workspaces
-- =========================================================

require("config.ai_sessions").setup()

-- =========================================================
-- Azure terminal workflows
-- =========================================================

require("config.azure").setup()

-- =========================================================
-- WezTerm image and PDF previews
-- =========================================================

require("config.image_preview").setup()
