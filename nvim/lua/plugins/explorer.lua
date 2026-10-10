return {
  {
    "nvim-neo-tree/neo-tree.nvim",

    branch = "v3.x",

    cmd = "Neotree",

    dependencies = {
      "nvim-lua/plenary.nvim",

      "MunifTanjim/nui.nvim",

      "nvim-tree/nvim-web-devicons",
    },

    -- =====================================================
    -- Global key
    -- =====================================================

    keys = {
      {
        "<C-b>",

        "<cmd>Neotree toggle left reveal<CR>",

        mode = {
          "n",
          "v",
          "i",
          "t",
        },

        desc = "Toggle file explorer",
      },
    },

    opts = {
      close_if_last_window = false,

      popup_border_style =
        "rounded",

      enable_git_status =
        true,

      enable_diagnostics =
        true,

      -- ===================================================
      -- Filesystem
      -- ===================================================

      filesystem = {
        bind_to_cwd = false,

        follow_current_file = {
          enabled = true,

          leave_dirs_open =
            false,
        },

        hijack_netrw_behavior =
          "open_current",

        -- Better performance on large repositories.
        use_libuv_file_watcher =
          false,

        filtered_items = {
          visible = false,

          hide_dotfiles = false,

          hide_gitignored = false,

          hide_hidden = false,
        },
      },

      -- ===================================================
      -- Explorer window
      -- ===================================================

      window = {
        position = "left",

        width = 34,

        mappings = {
          -- Close the explorer.
          ["<C-b>"] =
            "close_window",

          -- Open the selected file or folder.
          ["<CR>"] =
            "open",

          -- Open in a vertical split.
          ["v"] =
            "open_vsplit",

          -- Open in a horizontal split.
          ["s"] =
            "open_split",

          -- Alternate shortcuts for opening splits.
          ["<C-v>"] =
            "open_vsplit",

          ["<C-s>"] =
            "open_split",
        },
      },

      -- ===================================================
      -- Default behaviour
      -- ===================================================

      default_component_configs = {
        git_status = {
          symbols = {
            added = "✚",
            modified = "",
            deleted = "✖",
            renamed = "󰁕",
            untracked = "",
            ignored = "",
            unstaged = "󰄱",
            staged = "",
            conflict = "",
          },
        },
      },
    },
  },
}
