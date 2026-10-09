return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",

    dependencies = {
      "rafamadriz/friendly-snippets",
    },

    opts = {
      keymap = {
        preset = "super-tab",
      },

      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 300,
        },
        ghost_text = {
          enabled = true,
        },
      },

      signature = {
        enabled = true,
      },

      sources = {
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
        },
      },
    },
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },
}
