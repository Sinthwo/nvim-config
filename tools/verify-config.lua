-- Run from the repository root: nvim --headless -u NONE -i NONE -n -l tools/verify-config.lua
-- Test doubles keep these checks independent of plugin downloads and local profiles.
local real = vim
local checks = 0

local function check(value, message)
  assert(value, message)
  checks = checks + 1
end

local function eq(actual, expected, message)
  check(actual == expected, message .. ": expected " .. tostring(expected) .. ", got " .. tostring(actual))
end

local function normalize(path)
  return path:gsub("\\", "/"):gsub("/+$", "")
end

local function contains(list, item)
  for _, value in ipairs(list) do if value == item then return true end end
  return false
end

local home = "Q:/Profiles/Test User O'Example"
local profile = {
  config = home .. "/AppData/Local/nvim",
  data = home .. "/AppData/Local/nvim-data",
  cache = home .. "/AppData/Local/Temp/nvim-data",
}

local function fake_vim()
  local fake = {
    env = { ProgramFiles = "R:/Program Files", SystemRoot = "R:/Windows" },
    g = {},
    fs = {
      joinpath = real.fs.joinpath,
      normalize = normalize,
      basename = function(path) return normalize(path):match("([^/]+)$") end,
    },
    fn = {
      stdpath = function(kind) return profile[kind] end,
      expand = function(path) return path:gsub("^~", home) end,
      exepath = function() return "" end,
      executable = function() return 0 end,
      has = function(name) return name == "win32" and 1 or 0 end,
      getpid = function() return 1 end,
      sha256 = function(value) return real.api.nvim_call_function("sha256", { value }) end,
      getcwd = function() return "Q:/projects/demo" end,
      mkdir = function() end,
    },
    uv = { fs_stat = function() return nil end, hrtime = function() return 0 end },
    api = {
      nvim_create_augroup = function() return 1 end,
      nvim_create_autocmd = function() end,
      nvim_create_user_command = function() end,
      nvim_get_runtime_file = function() return {} end,
    },
    keymap = { set = function() end },
    log = { levels = { WARN = 2, ERROR = 3, INFO = 1 } },
    notify = function() end,
    schedule = function(fn) fn() end,
    tbl_contains = contains,
    tbl_extend = real.tbl_extend,
  }
  fake.loop = fake.uv
  return fake
end

local function with_vim(fake, fn)
  _G.vim = fake
  local ok, err = pcall(fn)
  _G.vim = real
  if not ok then error(err, 0) end
end

local paths = dofile("nvim/lua/config/paths.lua")
package.loaded["config.paths"] = paths

-- Syntax checks include the deployed Neovim files and the hidden terminal config.
local files = real.fn.glob("nvim/**/*.lua", false, true)
table.insert(files, "WezTerminal-Config/.wezterm.lua")
for _, file in ipairs(files) do
  local chunk, err = loadfile(file)
  check(chunk ~= nil, file .. ": " .. tostring(err))
end

local fake = fake_vim()
with_vim(fake, function()
  eq(paths.background_dir(), profile.config .. "/backgrounds", "Current-profile background path")
  fake.env.NVIM_BACKGROUND_DIR = "~/Pictures/Terminal Backgrounds"
  eq(paths.background_dir(), home .. "/Pictures/Terminal Backgrounds", "Home-relative override")
  fake.env.NVIM_BACKGROUND_DIR = "S:\\Shared Pictures\\backgrounds"
  eq(paths.background_dir(), "S:/Shared Pictures/backgrounds", "Absolute override")
  fake.env.NVIM_BACKGROUND_DIR = ""
  eq(paths.background_dir(), profile.config .. "/backgrounds", "Empty override falls back")
  local preferred = "T:/Tools/PowerShell/pwsh.exe"
  fake.fn.exepath = function(name) return name == "pwsh.exe" and preferred or "" end
  fake.uv.fs_stat = function(path) return path == preferred and {} or nil end
  eq(paths.find_powershell(), preferred, "Prefer executable from PATH")
  fake.fn.exepath = function() return "" end
  fake.uv.fs_stat = function(path) return path == "R:/Program Files/PowerShell/7/pwsh.exe" and {} or nil end
  eq(paths.find_powershell(), "R:/Program Files/PowerShell/7/pwsh.exe", "ProgramFiles on another drive")
  fake.uv.fs_stat = function(path) return path == "R:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe" and {} or nil end
  eq(paths.find_powershell(), "R:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe", "SystemRoot fallback")
  fake.uv.fs_stat = function() return nil end
  eq(paths.find_powershell(), nil, "Missing PowerShell")
  eq(paths.powershell_quote("Q:/O'Example/a b"), "'Q:/O''Example/a b'", "PowerShell apostrophe escaping")
end)

-- Exercise the actual picker without creating folders or changing a real selection.
fake = fake_vim()
with_vim(fake, function()
  local writes, choice, listed, notices = {}, "a picture.png", {}, 0
  fake.fs.dir = function()
    local entries = { { "notes.md", "file" }, { "nested", "directory" }, { "z.jpg", "file" }, { "a picture.png", "file" } }
    local i = 0
    return function() i = i + 1; if entries[i] then return unpack(entries[i]) end end
  end
  fake.ui = { select = function(items, _, callback) listed = items; callback(choice) end }
  fake.fn.writefile = function(lines, file) writes[#writes + 1] = { lines = lines, file = file } end
  fake.notify = function() notices = notices + 1 end
  local background = dofile("nvim/lua/config/background.lua")
  background.pick()
  eq(#listed, 2, "Picker excludes non-images and folders")
  eq(listed[1], "a picture.png", "Picker sorts filenames")
  eq(writes[1].lines[1], "a picture.png", "Selection contains only filename")
  eq(writes[1].file, profile.config .. "/backgrounds/selected-background.txt", "Selection uses current profile")
  choice = nil
  background.pick()
  eq(#writes, 1, "Cancellation preserves selection")
  fake.env.NVIM_BACKGROUND_DIR = "~/Pictures/Terminal Backgrounds"
  choice = "z.jpg"
  background.pick()
  eq(writes[2].file, home .. "/Pictures/Terminal Backgrounds/selected-background.txt", "Picker shares directory override")
  fake.fs.dir = function() return function() end end
  background.pick()
  eq(#writes, 2, "Empty folder leaves selection unchanged")
  eq(notices, 3, "Empty folder reports a notice")
end)

-- Load the standalone WezTerm config in a sandbox with virtual files and panes.
local function wezterm_fixture(environment, selection, existing)
  local events, watched = {}, nil
  local actions = setmetatable({}, { __index = function(_, key)
    return function(arg) return { name = key, arg = arg } end
  end })
  local wez = {
    home_dir = home,
    config_builder = function() return {} end,
    action = actions,
    action_callback = function(fn) return fn end,
    on = function(event, callback) events[event] = callback end,
    add_to_config_reload_watch_list = function(path) watched = path end,
  }
  local sandbox = setmetatable({
    require = function(name) assert(name == "wezterm"); return wez end,
    os = { getenv = function(name) return environment[name] end },
    io = { open = function(file)
      if file == watched and selection ~= nil then
        return { read = function() return selection end, close = function() end }
      end
      if existing[normalize(file)] then return { close = function() end } end
    end },
  }, { __index = _G })
  local config = setfenv(assert(loadfile("WezTerminal-Config/.wezterm.lua")), sandbox)()
  return { config = config, events = events, watched = watched }
end

local function test_wallpaper(fixture, expected)
  local overrides = { font_size = 15, window_background_image = "old.png", window_background_image_hsb = {}, text_background_opacity = 0.72 }
  local calls, active = 0, "1"
  local pane = { get_user_vars = function() return { NVIM_ACTIVE = active } end }
  local window = {
    get_config_overrides = function() return overrides end,
    set_config_overrides = function(_, value) overrides = value; calls = calls + 1 end,
  }
  fixture.events["update-right-status"](window, pane)
  eq(overrides.window_background_image, expected, "Wallpaper resolution")
  eq(overrides.text_background_opacity, expected and 0.72 or 1.0, "Wallpaper opacity")
  eq(overrides.font_size, 15, "Unrelated terminal settings preserved")
  local previous_calls = calls
  fixture.events["update-right-status"](window, pane)
  eq(calls, previous_calls, "Unchanged selection does not refresh overrides")
  active = "0"
  fixture.events["user-var-changed"](window, pane, "NVIM_ACTIVE", active)
  eq(overrides.window_background_image, nil, "Exit clears wallpaper")
  eq(overrides.window_background_image_hsb, nil, "Exit clears image adjustment")
  eq(overrides.text_background_opacity, 1.0, "Exit restores terminal opacity")
  return window, pane
end

local default_dir = profile.config .. "/backgrounds"
local environment = { LOCALAPPDATA = home .. "/AppData/Local", ProgramFiles = "R:/Program Files" }
local relative = wezterm_fixture(environment, "  a picture.png  ", { [default_dir .. "/a picture.png"] = true })
eq(relative.watched, default_dir .. "/selected-background.txt", "WezTerm current-profile directory")
test_wallpaper(relative, default_dir .. "/a picture.png")
for _, value in ipairs({ "", "   ", "missing.png" }) do
  test_wallpaper(wezterm_fixture(environment, value, {}), nil)
end
test_wallpaper(wezterm_fixture(environment, nil, {}), nil)
local legacy = "S:/My Pictures/old.jpg"
test_wallpaper(wezterm_fixture(environment, legacy, { [legacy] = true }), legacy)
local legacy_backslash = "S:\\My Pictures\\old.jpg"
test_wallpaper(wezterm_fixture(environment, legacy_backslash, { [legacy] = true }), legacy_backslash)
local custom_dir = home .. "/Pictures/Terminal Backgrounds"
local custom = wezterm_fixture({ NVIM_BACKGROUND_DIR = "~/Pictures/Terminal Backgrounds" }, "z.jpg", { [custom_dir .. "/z.jpg"] = true })
eq(custom.watched, custom_dir .. "/selected-background.txt", "WezTerm home override agrees with Neovim")
test_wallpaper(custom, custom_dir .. "/z.jpg")
local xdg = wezterm_fixture({ XDG_CONFIG_HOME = "S:/Configs", NVIM_APPNAME = "editor" }, nil, {})
eq(xdg.watched, "S:/Configs/editor/backgrounds/selected-background.txt", "Alternate app and XDG directory")
local fallback = wezterm_fixture({ LOCALAPPDATA = "", NVIM_BACKGROUND_DIR = "" }, nil, {})
eq(fallback.watched, default_dir .. "/selected-background.txt", "WezTerm home fallback")
local shell = wezterm_fixture({ PATH = '"T:/Tools With Spaces";R:/Other', ProgramFiles = "R:/Program Files" }, nil, {
  ["T:/Tools With Spaces/pwsh.exe"] = true,
})
eq(shell.config.default_prog[1], "T:/Tools With Spaces/pwsh.exe", "WezTerm discovers PowerShell in PATH")
local shell_fallback = wezterm_fixture(environment, nil, { ["R:/Program Files/PowerShell/7/pwsh.exe"] = true })
eq(shell_fallback.config.default_prog[1], "R:/Program Files/PowerShell/7/pwsh.exe", "WezTerm ProgramFiles fallback")

-- The debugger dependency graph must initialize UI listeners before launch.
local open_count, close_count, launched = 0, 0, 0
local dap = { listeners = { before = { attach = {}, launch = {}, event_terminated = {}, event_exited = {} } } }
local dapui = { setup = function() end, open = function() open_count = open_count + 1 end, close = function() close_count = close_count + 1 end }
package.loaded.dap, package.loaded.dapui = dap, dapui
dap.continue = function()
  for _, listener in pairs(dap.listeners.before.launch) do listener() end
  launched = launched + 1
end
local debug_specs = dofile("nvim/lua/plugins/debug.lua")
eq(debug_specs[1].dependencies[1], "rcarriga/nvim-dap-ui", "Debugger loads UI dependency")
check(not real.tbl_contains(debug_specs[2].dependencies, "mfussenegger/nvim-dap"), "No circular debugger dependency")
debug_specs[2].config()
debug_specs[1].keys[1][2]()
eq(launched, 1, "F5 launches debugger")
eq(open_count, 1, "Debugger UI opens on launch")
dap.listeners.before.event_terminated.dapui_config()
eq(close_count, 1, "Debugger UI closes on termination")

-- Inspect all declared shortcuts, then verify the same strings are documented.
local key_counts, declared = {}, {}
local plugin_files = real.fn.glob("nvim/lua/plugins/*.lua", false, true)
local function record(key)
  if key:match("^<leader>") then
    key_counts[key] = (key_counts[key] or 0) + 1
    declared[key] = true
  end
end
fake = fake_vim()
with_vim(fake, function()
  fake.keymap.set = function(_, key) record(key) end
  dofile("nvim/lua/config/keymaps.lua")
  for _, file in ipairs(plugin_files) do
    for _, spec in ipairs(dofile(file)) do
      for _, key in ipairs(spec.keys or {}) do record(key[1]) end
    end
  end
end)
eq(key_counts["<leader>bc"], 1, "One current-buffer close mapping")
eq(key_counts["<leader>bo"], 1, "One other-buffers close mapping")
for key, count in pairs(key_counts) do eq(count, 1, "Unique shortcut " .. key) end

fake = fake_vim()
with_vim(fake, function()
  local obsidian = dofile("nvim/lua/plugins/obsidian.lua")[1]
  local opts = obsidian.opts()
  eq(opts.workspaces[1].path, home .. "/Documents/Obsidian", "Default vault resolves current home")
  eq(opts.completion.blink, nil, "Removed obsolete Blink option")
  eq(opts.completion.nvim_cmp, nil, "Removed obsolete nvim-cmp option")
  fake.env.OBSIDIAN_VAULT = "~/Notes"
  eq(obsidian.opts().workspaces[1].path, home .. "/Notes", "Environment vault override")
  fake.g.nvim_obsidian_vault = "~/Preferred Notes"
  eq(obsidian.opts().workspaces[1].path, home .. "/Preferred Notes", "Global vault override takes precedence")
end)

-- Generate the real LSP command with synthetic paths containing an apostrophe.
fake = fake_vim()
with_vim(fake, function()
  local configured, enabled = {}, {}
  fake.uv.fs_stat = function() return {} end
  fake.lsp = {
    config = function(name, config) configured[name] = config end,
    enable = function(name) enabled[name] = true end,
  }
  fake.diagnostic = { config = function() end }
  package.loaded["blink.cmp"] = { get_lsp_capabilities = function() return {} end }
  for _, spec in ipairs(dofile("nvim/lua/plugins/lsp.lua")) do
    if spec[1] == "neovim/nvim-lspconfig" then spec.config() end
  end
  check(enabled.powershell_es, "PowerShell LSP enabled when dependencies exist")
  local command = configured.powershell_es.cmd[#configured.powershell_es.cmd]
  check(command:find("O''Example", 1, true), "LSP command escapes profile apostrophe")
  check(command:find(paths.powershell_quote(profile.cache .. "/powershell_es.log"), 1, true), "LSP log path is safely quoted")
  check(command:find(paths.powershell_quote(profile.cache .. "/powershell_es.session.json"), 1, true), "LSP session path is safely quoted")
end)

fake = fake_vim()
with_vim(fake, function()
  local events, installs = {}, 0
  fake.api.nvim_create_autocmd = function(event, opts) events[event] = opts end
  package.loaded["nvim-treesitter"] = { setup = function() end, install = function(parsers)
    check(contains(parsers, "powershell"), "Parser list includes PowerShell")
    installs = installs + 1
  end }
  dofile("nvim/lua/plugins/treesitter.lua")[1].config()
  eq(installs, 0, "No install attempt before CLI exists")
  eq(events.User.pattern, "MasonToolsUpdateCompleted", "Parser retry listens for tool completion")
  fake.fn.executable = function() return 1 end
  events.User.callback()
  eq(installs, 1, "CLI becoming available triggers parser installation")
end)

fake = fake_vim()
with_vim(fake, function()
  local root, workspaces, filetype = "Q:/work/demo", {}, nil
  fake.fn.exepath = function(name) return name == "jdtls" and "T:/Tools/jdtls.cmd" or "" end
  fake.api.nvim_create_autocmd = function(_, opts) filetype = opts.callback end
  package.loaded.jdtls = {
    setup = { find_root = function() return root end },
    start_or_attach = function(config) workspaces[#workspaces + 1] = config.cmd[3] end,
  }
  dofile("nvim/lua/plugins/java.lua")[1].config()
  root = "Q:/other/demo"
  filetype()
  check(workspaces[1] ~= workspaces[2], "Equally named Java projects have distinct caches")
  filetype()
  eq(workspaces[2], workspaces[3], "Java cache is stable for the same project")
end)

local manual = table.concat(real.fn.readfile("MANUAL.md"), "\n")
for key in pairs(declared) do
  local suffix = key:sub(#"<leader>" + 1)
  local label = "Space " .. suffix:gsub("(.)", "%1 "):gsub(" $", "")
  check(manual:find(label, 1, true), "Manual documents " .. key)
end
for _, file in ipairs({ "README.md", "MANUAL.md", "nvim/backgrounds/README.md" }) do
  local content = table.concat(real.fn.readfile(file), "\n")
  check(content:find("Windows", 1, true), file .. " identifies Windows")
  for target in content:gmatch("%]%(([^%)]+)%)") do
    if not target:match("^https?://") and target:sub(1, 1) ~= "#" then
      local path = target:gsub("#.*$", "")
      local dir = real.fs.dirname(file) or "."
      check(real.uv.fs_stat(real.fs.joinpath(dir, path)), file .. " has valid link " .. target)
    end
  end
end
check(not real.uv.fs_stat("nvim/backgrounds/anime/.git"), "Bundled Git metadata removed")
local selection_file = "nvim/backgrounds/selected-background.txt"
if real.fn.filereadable(selection_file) == 1 then
  local selected = real.fn.readfile(selection_file)[1]
  check(selected and not selected:find("[/\\:]"), "Local selection is a filename")
else
  check(not real.uv.fs_stat(selection_file), "Local selection is optional in a fresh clone")
end

print(string.format("PASS: %d checks (syntax, paths, wallpapers, plugins, and documentation)", checks))
