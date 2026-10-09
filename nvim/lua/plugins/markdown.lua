local function transparent_markdown()
  local groups = {
    "RenderMarkdownCode",
    "RenderMarkdownCodeBorder",
    "RenderMarkdownCodeFallback",
    "RenderMarkdownCodeInfo",
    "RenderMarkdownCodeInline",
    "RenderMarkdownPadding",

    "RenderMarkdownH1Bg",
    "RenderMarkdownH2Bg",
    "RenderMarkdownH3Bg",
    "RenderMarkdownH4Bg",
    "RenderMarkdownH5Bg",
    "RenderMarkdownH6Bg",
  }

  for _, group in ipairs(groups) do
    pcall(
      vim.api.nvim_set_hl,
      0,
      group,
      {
        bg = "NONE",
      }
    )
  end
end

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",

    ft = {
      "markdown",
    },

    dependencies = {
      "nvim-treesitter/nvim-treesitter",

      "nvim-tree/nvim-web-devicons",
    },

    opts = {
      -- ===================================================
      -- Code blocks
      -- ===================================================

      code = {
        enabled = true,

        sign = true,

        conceal_delimiters =
          true,

        language =
          true,

        language_icon =
          true,

        language_name =
          true,

        language_info =
          true,

        position =
          "left",

        -- Keep WezTerm wallpaper visible.
        disable_background =
          true,

        width =
          "full",

        border =
          "thin",
      },
    },

    config = function(_, opts)
      require(
        "render-markdown"
      ).setup(opts)

      transparent_markdown()

      local group =
        vim.api.nvim_create_augroup(
          "TransparentRenderMarkdown",
          {
            clear = true,
          }
        )

      vim.api.nvim_create_autocmd(
        {
          "BufEnter",
          "WinEnter",
          "FileType",
        },

        {
          group = group,

          pattern = {
            "*.md",
            "markdown",
          },

          callback = function()
            vim.schedule(
              transparent_markdown
            )
          end,
        }
      )
    end,

    keys = {
      {
        "<leader>mr",

        "<cmd>RenderMarkdown toggle<CR>",

        desc =
          "Toggle Markdown rendering",
      },
    },
  },
}