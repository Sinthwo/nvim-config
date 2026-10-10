return {
  {
    "hat0uma/csvview.nvim",

    ft = {
      "csv",
      "tsv",
    },

    cmd = {
      "CsvViewEnable",
      "CsvViewDisable",
      "CsvViewToggle",
      "CsvViewInfo",
    },

    opts = {
      parser = {
        comments = {
          "#",
          "//",
        },
      },

      view = {
        display_mode = "border",
        header_lnum = true,

        sticky_header = {
          enabled = true,
          separator = "─",
        },
      },

      -- Use the existing Tab and Shift+Tab mappings.
      keymaps = {},
    },

    config = function(_, opts)
      require("csvview").setup(opts)

      local group = vim.api.nvim_create_augroup(
        "UserCsvView",
        { clear = true }
      )

      local function enable_csv_view()
        local ft = vim.bo.filetype

        if ft == "csv" or ft == "tsv" then
          pcall(vim.cmd, "CsvViewEnable")
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = {
          "csv",
          "tsv",
        },
        callback = function()
          vim.schedule(enable_csv_view)
        end,
      })

      vim.schedule(enable_csv_view)
    end,

    keys = {
      {
        "<leader>cv",
        "<cmd>CsvViewToggle<CR>",
        desc = "Toggle CSV table view",
      },
    },
  },
}
