return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },

    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
        lua = { "stylua" },
        json = { "prettier" },
        yaml = { "prettier" },
      },
    },

    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({
            async = true,
            lsp_format = "fallback",
            timeout_ms = 2000,
          })
        end,
        desc = "Format file",
      },
    },
  },
}
