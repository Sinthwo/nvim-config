return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    opts = {
      winopts = {
        height = 0.86,
        width = 0.86,
        border = "rounded",
        preview = {
          layout = "flex",
        },
      },
      files = {
        git_icons = true,
        file_icons = true,
        color_icons = true,
      },
    },

    keys = {
      { "<C-p>", "<cmd>FzfLua files<CR>", desc = "Find files" },
      { "<C-S-f>", "<cmd>FzfLua live_grep<CR>", desc = "Search project" },
      { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Search project text" },
      { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Find open buffers" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<CR>", desc = "Recent files" },
      { "<leader>fs", "<cmd>FzfLua lsp_document_symbols<CR>", desc = "Document symbols" },
      { "<leader>fS", "<cmd>FzfLua lsp_workspace_symbols<CR>", desc = "Workspace symbols" },
    },
  },
}
