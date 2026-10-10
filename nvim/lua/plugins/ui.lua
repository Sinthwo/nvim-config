local uv = vim.uv or vim.loop

local function safe_buffer_delete(bufnr)
  bufnr = tonumber(bufnr) or vim.api.nvim_get_current_buf()

  if rawget(_G, "Snacks") and Snacks.bufdelete then
    Snacks.bufdelete({ buf = bufnr })
    return
  end

  local ok, err = pcall(vim.api.nvim_buf_delete, bufnr, { force = false })

  if not ok then
    vim.notify(tostring(err), vim.log.levels.WARN, { title = "Close buffer" })
  end
end

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

-- IMPORTANT:
-- nvim_set_hl() replaces the full highlight definition.
-- We therefore only touch groups that already exist and we preserve every
-- supported foreground/style attribute. This keeps Snacks (and other plugins)
-- from seeing an empty Normal foreground while still allowing the WezTerm
-- wallpaper to show through Neovim.
local function get_hl(group)
  local ok, hl = pcall(
    vim.api.nvim_get_hl,
    0,
    {
      name = group,
      link = false,
      create = false,
    }
  )

  if not ok or type(hl) ~= "table" or vim.tbl_isempty(hl) then
    return nil
  end

  return hl
end

local function make_group_transparent(group)
  local hl = get_hl(group)

  -- Do not create empty highlight groups for plugins that have not loaded yet.
  if not hl then
    return
  end

  local valid_keys = {
    "fg",
    "sp",
    "blend",
    "bold",
    "standout",
    "underline",
    "undercurl",
    "underdouble",
    "underdotted",
    "underdashed",
    "strikethrough",
    "italic",
    "reverse",
    "nocombine",
    "ctermfg",
    "ctermbg",
    "cterm",
  }

  local new_hl = {}

  for _, key in ipairs(valid_keys) do
    if hl[key] ~= nil then
      new_hl[key] = hl[key]
    end
  end

  -- If removing the background would leave a completely empty group, leave
  -- that group alone. This is especially important for background-only groups.
  if vim.tbl_isempty(new_hl) then
    return
  end

  vim.api.nvim_set_hl(0, group, new_hl)
end

local function ensure_normal_foreground()
  local normal = get_hl("Normal") or {}

  if normal.fg ~= nil then
    return
  end

  -- Normally TokyoNight already provides Normal.fg. These fallbacks are only
  -- here as a guard so Snacks can always resolve a usable foreground colour.
  local fallback_groups = {
    "NormalNC",
    "Identifier",
    "Statement",
    "Comment",
  }

  for _, group in ipairs(fallback_groups) do
    local fallback = get_hl(group)

    if fallback and fallback.fg ~= nil then
      vim.api.nvim_set_hl(0, "Normal", {
        fg = fallback.fg,
        bg = "NONE",
      })
      return
    end
  end

  -- TokyoNight's normal foreground as a last-resort safety fallback.
  vim.api.nvim_set_hl(0, "Normal", {
    fg = 0xc0caf5,
    bg = "NONE",
  })
end

local function make_transparent()
  -- Ensure Normal always has a foreground before Snacks or other plugins read
  -- it (Snacks GH/health code can blend colours using Normal as a fallback).
  ensure_normal_foreground()

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
    pcall(make_group_transparent, group)
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

        -- Keep the normal file tabs in the normal coding tab only. AI
        -- workspaces use their own Neovim tab page and show only the Codex /
        -- Claude terminal grid, never the user's coding buffers.
        custom_filter = function()
          return not vim.t.ai_workspace
        end,

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

        -- Middle click = close. Modified buffers get a save/discard/cancel
        -- prompt instead of throwing E89.
        middle_mouse_command = safe_buffer_delete,

        -- Right click = close with the same safe behaviour.
        right_mouse_command = safe_buffer_delete,

        -- Clicking X = close with the same safe behaviour.
        close_command = safe_buffer_delete,

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
