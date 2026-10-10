local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- =========================================================
-- Paths
-- =========================================================

local function env(name)
  local value = os.getenv(name)
  return value and value ~= "" and value or nil
end

local function join_path(...)
  return table.concat({ ... }, "/"):gsub("\\", "/")
end

local function expand_home(path)
  if path == "~" then
    return wezterm.home_dir
  end
  if path:match("^~[/\\]") then
    return join_path(wezterm.home_dir, path:sub(3))
  end
  return path:gsub("\\", "/")
end

-- Match Neovim's standard Windows config location for the current user.
local config_home = env("XDG_CONFIG_HOME")
  or env("LOCALAPPDATA")
  or join_path(wezterm.home_dir, "AppData", "Local")
local backgrounds_dir = expand_home(env("NVIM_BACKGROUND_DIR")
  or join_path(config_home, env("NVIM_APPNAME") or "nvim", "backgrounds"))
local selected_file = join_path(backgrounds_dir, "selected-background.txt")

-- =========================================================
-- Helpers
-- =========================================================

local function file_exists(path)
  if not path or path == "" then
    return false
  end

  local file = io.open(path, "rb")

  if file then
    file:close()
    return true
  end

  return false
end

local function trim(value)
  if not value then
    return nil
  end

  return value
    :gsub("^%s+", "")
    :gsub("%s+$", "")
end

local function read_selected_background()
  local file =
    io.open(
      selected_file,
      "r"
    )

  if not file then
    return nil
  end

  local path =
    trim(
      file:read("*l")
    )

  file:close()

  if not path or path == "" then
    return nil
  end

  -- New selections are relative paths, including subfolders. Keep local legacy paths working.
  if not path:match("^%a:[/\\]") and not path:match("^[/\\]") then
    path = join_path(backgrounds_dir, path)
  end

  if file_exists(path) then
    return path
  end

  return nil
end

-- =========================================================
-- Automatic reload
-- =========================================================

config.automatically_reload_config =
  true

wezterm.add_to_config_reload_watch_list(
  selected_file
)

-- Re-check the selected image every second.
config.status_update_interval =
  1000

-- =========================================================
-- Appearance
-- =========================================================

config.color_scheme =
  "Tokyo Night"

-- The actual WezTerm window remains opaque.
config.window_background_opacity =
  1.0

-- Normal PowerShell / CMD:
-- no wallpaper visible.
config.text_background_opacity =
  1.0

-- IMPORTANT:
-- Do NOT define window_background_image globally here.
--
-- It will only be added while Neovim is active.

-- =========================================================
-- Font
-- =========================================================

-- Use the terminal's default font; a Nerd Font can be configured locally.
config.font_size =
  11.0

-- =========================================================
-- Window
-- =========================================================

config.window_decorations =
  "INTEGRATED_BUTTONS|RESIZE"

config.integrated_title_buttons = {
  "Hide",
  "Maximize",
  "Close",
}

config.integrated_title_button_alignment =
  "Right"

config.adjust_window_size_when_changing_font_size =
  false

config.window_padding = {
  left = 4,
  right = 4,
  top = 4,
  bottom = 4,
}

-- =========================================================
-- Tabs
-- =========================================================

config.hide_tab_bar_if_only_one_tab =
  false

config.use_fancy_tab_bar =
  false

config.tab_bar_at_bottom =
  false

config.show_new_tab_button_in_tab_bar =
  true

config.tab_max_width =
  32

-- =========================================================
-- Cursor
-- =========================================================

config.default_cursor_style =
  "BlinkingBar"

config.cursor_blink_rate =
  500

-- =========================================================
-- Scrollback
-- =========================================================

config.scrollback_lines =
  10000

-- =========================================================
-- Performance
-- =========================================================

config.front_end =
  "WebGpu"

config.max_fps =
  120

config.animation_fps =
  60

-- =========================================================
-- PowerShell
-- =========================================================

local pwsh
for directory in (env("PATH") or ""):gmatch("[^;]+") do
  local candidate = join_path(directory:gsub('^"(.*)"$', "%1"), "pwsh.exe")
  if file_exists(candidate) then
    pwsh = candidate
    break
  end
end

if not pwsh and env("ProgramFiles") then
  pwsh = join_path(env("ProgramFiles"), "PowerShell", "7", "pwsh.exe")
end

if file_exists(pwsh) then
  config.default_prog = {
    pwsh,
    "-NoLogo",
  }
end

-- =========================================================
-- Neovim-only dynamic background
-- =========================================================

local function update_nvim_background(
  window,
  pane
)
  local vars =
    pane:get_user_vars()

  local nvim_active =
    vars.NVIM_ACTIVE == "1"

  local overrides =
    window:get_config_overrides()
    or {}

  local background = nvim_active and read_selected_background() or nil
  local opacity = background and 0.72 or 1.0

  if overrides.window_background_image ~= background
    or overrides.text_background_opacity ~= opacity
    or (not background and overrides.window_background_image_hsb ~= nil)
  then
    overrides.window_background_image = background
    overrides.window_background_image_hsb = background and {
      brightness = 0.01,
      saturation = 0.55,
      hue = 1.0,
    } or nil
    overrides.text_background_opacity = opacity
    window:set_config_overrides(overrides)
  end
end

-- =========================================================
-- Detect Neovim state changes immediately
-- =========================================================

wezterm.on(
  "user-var-changed",

  function(
    window,
    pane,
    name,
    value
  )
    if name ~= "NVIM_ACTIVE" then
      return
    end

    update_nvim_background(
      window,
      pane
    )
  end
)

-- =========================================================
-- Detect selected-background.txt changes
-- =========================================================

wezterm.on(
  "update-right-status",

  function(
    window,
    pane
  )
    update_nvim_background(
      window,
      pane
    )
  end
)

-- =========================================================
-- Keybindings
-- =========================================================

config.keys = {
  -- =======================================================
  -- Ctrl+Tab
  --
  -- Inside Neovim:
  --   Ctrl+Tab       -> F13 -> next Neovim file
  --   Ctrl+Shift+Tab -> F14 -> previous Neovim file
  --
  -- Outside Neovim:
  --   Ctrl+Tab       -> next WezTerm tab
  --   Ctrl+Shift+Tab -> previous WezTerm tab
  -- =======================================================

  {
    key = "Tab",
    mods = "CTRL",

    action = wezterm.action_callback(
      function(window, pane)
        local vars =
          pane:get_user_vars()

        if vars.NVIM_ACTIVE == "1" then
          window:perform_action(
            act.SendKey({
              key = "F13",
              mods = "NONE",
            }),
            pane
          )
        else
          window:perform_action(
            act.ActivateTabRelative(1),
            pane
          )
        end
      end
    ),
  },

  {
    key = "Tab",
    mods = "CTRL|SHIFT",

    action = wezterm.action_callback(
      function(window, pane)
        local vars =
          pane:get_user_vars()

        if vars.NVIM_ACTIVE == "1" then
          window:perform_action(
            act.SendKey({
              key = "F14",
              mods = "NONE",
            }),
            pane
          )
        else
          window:perform_action(
            act.ActivateTabRelative(-1),
            pane
          )
        end
      end
    ),
  },

  -- =======================================================
  -- Fullscreen
  -- =======================================================

  {
    key = "Enter",

    mods = "ALT",

    action =
      act.ToggleFullScreen,
  },

  -- =======================================================
  -- Debug overlay
  -- =======================================================

  {
    key = "l",

    mods = "CTRL|SHIFT",

    action =
      act.ShowDebugOverlay,
  },
}

return config
