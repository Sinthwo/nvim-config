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
        sh = { "shfmt" },
        bash = { "shfmt" },
        terraform = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
        -- Web/project formats. prettier is used only when present.
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        markdown_mdx = { "prettierd", "prettier", stop_after_first = true },
        astro = { "prettierd", "prettier", stop_after_first = true },
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
