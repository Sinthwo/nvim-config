local uv = vim.uv or vim.loop

-- =========================================================
-- Helpers
-- =========================================================

-- =========================================================
-- RAM
-- =========================================================

local function ram_usage()
  if not uv or not uv.resident_set_memory then
    return ""
  end

  local ok, bytes = pcall(uv.resident_set_memory)

  if not ok or type(bytes) ~= "number" then
    return ""
  end

  local mb = bytes / 1024 / 1024

  if mb >= 1024 then
    return string.format(
      "RAM %.1f GB",
      mb / 1024
    )
  end

  return string.format(
    "RAM %.0f MB",
    mb
  )
end

-- =========================================================
-- Find PowerShell
-- =========================================================

local powershell = require("config.paths").find_powershell()

-- =========================================================
-- CPU
-- =========================================================

local cpu_text = "CPU 0.0%%"
local cpu_pending = false

local last_cpu_seconds = nil
local last_wall_time = nil
local last_query_time = 0

local nvim_pid = vim.fn.getpid()

local processor_count =
  tonumber(vim.env.NUMBER_OF_PROCESSORS) or 1

local function cpu_usage()
  if not powershell then
    return "CPU N/A"
  end

  if not uv or not uv.hrtime then
    return "CPU N/A"
  end

  local now =
    uv.hrtime() / 1000000000

  if
    cpu_pending
    or (now - last_query_time) < 5
  then
    return cpu_text
  end

  cpu_pending = true
  last_query_time = now

  local command =
    string.format(
      "$p = Get-Process -Id %d -ErrorAction Stop; "
        .. "[Console]::Write("
        .. "$p.TotalProcessorTime.TotalSeconds.ToString("
        .. "[System.Globalization.CultureInfo]::InvariantCulture"
        .. "))",
      nvim_pid
    )

  local ok =
    pcall(function()
      vim.system(
        {
          powershell,
          "-NoLogo",
          "-NoProfile",
          "-NonInteractive",
          "-Command",
          command,
        },

        {
          text = true,
        },

        function(result)
          vim.schedule(function()
            cpu_pending = false

            if
              not result
              or result.code ~= 0
            then
              cpu_text = "CPU ?"
              return
            end

            local output =
              vim.trim(
                result.stdout or ""
              )

            local cpu_seconds =
              tonumber(output)

            if not cpu_seconds then
              cpu_text = "CPU ?"
              return
            end

            local wall_time =
              uv.hrtime()
              / 1000000000

            if
              last_cpu_seconds == nil
              or last_wall_time == nil
            then
              last_cpu_seconds =
                cpu_seconds

              last_wall_time =
                wall_time

              cpu_text =
                "CPU 0.0%%"

              return
            end

            local cpu_delta =
              cpu_seconds
              - last_cpu_seconds

            local wall_delta =
              wall_time
              - last_wall_time

            last_cpu_seconds =
              cpu_seconds

            last_wall_time =
              wall_time

            if wall_delta <= 0 then
              return
            end

            local percent =
              (cpu_delta / wall_delta)
              * 100
              / processor_count

            if percent < 0 then
              percent = 0
            end

            cpu_text =
              string.format(
                "CPU %.1f%%%%",
                percent
              )
          end)
        end
      )
    end)

  if not ok then
    cpu_pending = false
    cpu_text = "CPU ?"
  end

  return cpu_text
end

-- =========================================================
-- LSP
-- =========================================================

local function lsp_count()
  if
    not vim.lsp
    or not vim.lsp.get_clients
  then
    return ""
  end

  local ok, clients =
    pcall(
      vim.lsp.get_clients,
      {
        bufnr = 0,
      }
    )

  if
    not ok
    or type(clients) ~= "table"
  then
    return ""
  end

  return "LSP " .. #clients
end

-- =========================================================
-- Neovim uptime
-- =========================================================

local nvim_start_time =
  uv.hrtime()

local function nvim_uptime()
  if not uv or not uv.hrtime then
    return ""
  end

  local elapsed =
    (uv.hrtime() - nvim_start_time)
    / 1000000000

  local days =
    math.floor(
      elapsed / 86400
    )

  local hours =
    math.floor(
      (elapsed % 86400) / 3600
    )

  local minutes =
    math.floor(
      (elapsed % 3600) / 60
    )

  if days > 0 then
    return string.format(
      "UP %dd %dh",
      days,
      hours
    )
  end

  if hours > 0 then
    return string.format(
      "UP %dh %02dm",
      hours,
      minutes
    )
  end

  return string.format(
    "UP %dm",
    minutes
  )
end

-- =========================================================
-- Current time
-- =========================================================

local function current_time()
  return os.date("%H:%M")
end

-- =========================================================
-- Transparent UI
-- =========================================================

local function make_transparent()
  local groups = {
    -- Main editor
    "Normal",
    "NormalNC",
    "EndOfBuffer",

    -- Columns
    "SignColumn",
    "FoldColumn",

    -- Line numbers
    "LineNr",
    "LineNrAbove",
    "LineNrBelow",

    -- Neo-tree
    "NeoTreeNormal",
    "NeoTreeNormalNC",
    "NeoTreeEndOfBuffer",

    -- Floating windows
    "NormalFloat",

    -- Telescope
    "TelescopeNormal",
    "TelescopeBorder",
    "TelescopePromptNormal",
    "TelescopeResultsNormal",
    "TelescopePreviewNormal",

    -- Which-Key
    "WhichKeyNormal",

    -- Lazy / Mason
    "LazyNormal",
    "MasonNormal",

    -- Markdown
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

-- =========================================================
-- Plugins
-- =========================================================

return {
  -- =======================================================
  -- TokyoNight
  -- =======================================================

  {
    "folke/tokyonight.nvim",

    lazy = false,
    priority = 1000,

    opts = {
      style = "night",

      transparent = true,

      terminal_colors = true,

      styles = {
        comments = {
          italic = true,
        },

        keywords = {
          italic = true,
        },

        sidebars =
          "transparent",

        floats =
          "transparent",
      },
    },

    config = function(_, opts)
      require(
        "tokyonight"
      ).setup(opts)

      vim.cmd.colorscheme(
        "tokyonight"
      )

      make_transparent()

      local transparency_group =
        vim.api.nvim_create_augroup(
          "UserTransparentUI",
          {
            clear = true,
          }
        )

      vim.api.nvim_create_autocmd(
        {
          "ColorScheme",
          "BufEnter",
          "WinEnter",
          "FileType",
        },

        {
          group =
            transparency_group,

          callback = function()
            vim.schedule(
              make_transparent
            )
          end,
        }
      )
    end,
  },

  -- =======================================================
  -- Lualine
  -- =======================================================

  {
    "nvim-lualine/lualine.nvim",

    event = "VeryLazy",

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    opts = function()
      return {
        options = {
          theme = "auto",

          globalstatus = true,

          component_separators =
            "|",

          section_separators = {
            left = "",
            right = "",
          },

          refresh = {
            statusline = 1000,
          },
        },

        sections = {
          -- LEFT

          lualine_a = {
            "mode",
          },

          lualine_b = {
            "branch",

            function()
              local ok, project =
                pcall(
                  require,
                  "config.project"
                )

              if not ok then
                return ""
              end

              return project.label()
            end,
          },

          lualine_c = {
            {
              "filename",

              path = 1,

              symbols = {
                modified = " ●",
                readonly = " ",
                unnamed = "[No Name]",
                newfile = "[New]",
              },
            },
          },

          -- RIGHT

          lualine_x = {
            "diagnostics",

            {
              ram_usage,

              cond = function()
                return
                  vim.o.columns
                  >= 100
              end,
            },

            {
              cpu_usage,

              cond = function()
                return
                  vim.o.columns
                  >= 110
              end,
            },

            {
              lsp_count,

              cond = function()
                return
                  vim.o.columns
                  >= 120
              end,
            },

            {
              nvim_uptime,

              cond = function()
                return
                  vim.o.columns
                  >= 130
              end,
            },

            {
              current_time,

              cond = function()
                return
                  vim.o.columns
                  >= 140
              end,
            },

            "filetype",
          },

          lualine_y = {
            "progress",
          },

          lualine_z = {
            "location",
          },
        },

        inactive_sections = {
          lualine_a = {},
          lualine_b = {},

          lualine_c = {
            {
              "filename",
              path = 1,
            },
          },

          lualine_x = {
            "location",
          },

          lualine_y = {},
          lualine_z = {},
        },
      }
    end,
  },

  -- =======================================================
  -- Bufferline
  -- VS Code-style tabs
  -- =======================================================

  {
    "akinsho/bufferline.nvim",

    version = "*",

    event = "VeryLazy",

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    opts = {
      options = {
        mode = "buffers",

        diagnostics =
          "nvim_lsp",

        always_show_bufferline =
          true,

        separator_style =
          "thin",

        -- Show X on each tab
        show_buffer_close_icons =
          true,

        -- No global X on the right
        show_close_icon =
          false,

        -- Left click = open
        left_mouse_command =
          "buffer %d",

        -- Middle click = close
        middle_mouse_command =
          "bdelete %d",

        -- Right click = close too
        right_mouse_command =
          "bdelete %d",

        -- Clicking X = close
        close_command =
          "bdelete %d",

        offsets = {
          {
            filetype =
              "neo-tree",

            text =
              "Explorer",

            text_align =
              "center",

            separator =
              true,
          },
        },
      },
    },

    config = function(_, opts)
      vim.opt.showtabline = 2

      require(
        "bufferline"
      ).setup(opts)
    end,

    keys = {
      -- ===================================================
      -- Direct Ctrl+Tab mappings
      -- ===================================================

      {
        "<C-Tab>",

        "<cmd>BufferLineCycleNext<CR>",

        desc =
          "Next file",
      },

      {
        "<C-S-Tab>",

        "<cmd>BufferLineCyclePrev<CR>",

        desc =
          "Previous file",
      },

      -- ===================================================
      -- WezTerm Ctrl+Tab forwarding
      --
      -- WezTerm:
      --   Ctrl+Tab       -> F13
      --   Ctrl+Shift+Tab -> F14
      -- ===================================================

      {
        "<F13>",

        "<cmd>BufferLineCycleNext<CR>",

        desc =
          "Next file",
      },

      {
        "<F14>",

        "<cmd>BufferLineCyclePrev<CR>",

        desc =
          "Previous file",
      },

      -- ===================================================
      -- Leader alternatives
      -- ===================================================

      {
        "<leader>bn",

        "<cmd>BufferLineCycleNext<CR>",

        desc =
          "Next file",
      },

      {
        "<leader>bp",

        "<cmd>BufferLineCyclePrev<CR>",

        desc =
          "Previous file",
      },

      {
        "<leader>bP",

        "<cmd>BufferLinePick<CR>",

        desc =
          "Pick file",
      },

      {
        "<leader>bl",

        "<cmd>BufferLineCloseLeft<CR>",

        desc =
          "Close files left",
      },

      {
        "<leader>br",

        "<cmd>BufferLineCloseRight<CR>",

        desc =
          "Close files right",
      },
    },
  },

  -- =======================================================
  -- Which-Key
  -- =======================================================

  {
    "folke/which-key.nvim",

    event = "VeryLazy",

    opts = {
      preset = "modern",

      spec = {
        {
          "<leader>a",
          group = "AI",
        },

        {
          "<leader>b",
          group = "Buffers",
        },

        {
          "<leader>c",
          group = "Code",
        },

        {
          "<leader>d",
          group = "Debug",
        },

        {
          "<leader>f",
          group = "Find",
        },

        {
          "<leader>g",
          group = "Git",
        },

        {
          "<leader>j",
          group = "Java",
        },

        {
          "<leader>m",
          group = "Markdown",
        },

        {
          "<leader>o",
          group = "Obsidian",
        },

        {
          "<leader>r",
          group = "Run",
        },

        {
          "<leader>s",
          group = "Splits",
        },

        {
          "<leader>t",
          group = "Terminal / Test",
        },

        {
          "<leader>u",
          group = "UI",
        },

        {
          "<leader>x",
          group = "Diagnostics",
        },
      },
    },
  },
}
