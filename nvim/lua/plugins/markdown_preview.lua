return {
  {
    "iamcco/markdown-preview.nvim",

    cmd = {
      "MarkdownPreview",
      "MarkdownPreviewStop",
      "MarkdownPreviewToggle",
    },

    ft = { "markdown" },

    -- Load plugin before calling its installer.
    build = function()
      require("lazy").load({
        plugins = { "markdown-preview.nvim" },
      })

      vim.fn["mkdp#util#install"]()
    end,

    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_theme = "dark"
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
    end,

    keys = {
      {
        "<leader>mp",
        "<cmd>MarkdownPreviewToggle<CR>",
        ft = "markdown",
        desc = "Markdown / Mermaid preview",
      },
    },
  },
}