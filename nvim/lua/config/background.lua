
-- Wallpaper Manager for Neovim + WezTerm
-- Features:
--   Clean Snacks.nvim popup
--   Folder-based browsing
--   Persistent favorites
--   Random wallpaper selection
--   Automatic wallpaper rotation at startup
--   Manual and random-favorites modes

local M = {}
local uv = vim.uv or vim.loop

-- ============================================
-- PATHS
-- ============================================

local function normalize(path)
  if not path or path == "" then
    return path
  end

  return vim.fs.normalize(path)
end

local function background_dir()
  return require("config.paths").background_dir()
end

local function selected_file()
  return vim.fs.joinpath(
    background_dir(),
    "selected-background.txt"
  )
end

local function favorites_file()
  return vim.fs.joinpath(
    background_dir(),
    "favorite-backgrounds.txt"
  )
end

local function mode_file()
  return vim.fs.joinpath(
    background_dir(),
    "background-mode.txt"
  )
end

-- ============================================
-- UTILITIES
-- ============================================

local function notify(message, level)
  vim.notify(
    message,
    level or vim.log.levels.INFO,
    { title = "Wallpaper Manager" }
  )
end

local function read_lines(path)
  if vim.fn.filereadable(path) ~= 1 then
    return {}
  end

  local ok, lines = pcall(vim.fn.readfile, path)

  return ok and lines or {}
end

local function write_lines(path, lines)
  local ok, result = pcall(
    vim.fn.writefile,
    lines,
    path
  )

  if not ok or result ~= 0 then
    notify(
      "Could not write file:\n" .. tostring(result),
      vim.log.levels.ERROR
    )
    return false
  end

  return true
end

local function later(callback)
  vim.schedule(callback)
end

local extensions = {
  png = true,
  jpg = true,
  jpeg = true,
  gif = true,
  bmp = true,
  webp = true,
}

local function is_image(name)
  local ext = name:lower():match("%.([^.]+)$")

  return ext ~= nil and extensions[ext] == true
end

local function relative_name(path)
  local root = background_dir()

  if path:sub(1, #root):lower() == root:lower() then
    local separator = path:sub(
      #root + 1,
      #root + 1
    )

    if separator == "/" or separator == "\\" then
      return path:sub(#root + 2)
    end
  end

  return vim.fn.fnamemodify(path, ":t")
end

local function in_background_dir(path)
  local root = background_dir()

  if path:sub(1, #root):lower() ~= root:lower() then
    return false
  end

  local separator = path:sub(
    #root + 1,
    #root + 1
  )

  return separator == "/" or separator == "\\"
end

-- Accept older absolute records, but write portable paths for new selections.
local function resolve_record(path)
  if not path or path == "" then
    return nil
  end
  if not path:match("^%a:[/\\]") and not path:match("^[/\\]") then
    path = vim.fs.joinpath(background_dir(), path)
  end
  return normalize(path)
end

local function make_image(path)
  path = normalize(path)

  return {
    kind = "image",
    full = path,
    name = vim.fn.fnamemodify(path, ":t"),
    display = relative_name(path),
  }
end

-- ============================================
-- MODES
-- ============================================

local valid_modes = {
  random = true,
  random_favorite = true,
  manual = true,
}

local mode_names = {
  random = "Auto Random",
  random_favorite = "Auto Favorites",
  manual = "Manual",
}

local function get_mode()
  local lines = read_lines(mode_file())
  local mode = lines[1]

  if valid_modes[mode] then
    return mode
  end

  return "random"
end

local function save_mode(mode)
  if not valid_modes[mode] then
    return false
  end

  return write_lines(mode_file(), { mode })
end

-- ============================================
-- SELECTED WALLPAPER
-- ============================================

local function current_background()
  local lines = read_lines(selected_file())
  return resolve_record(lines[1])
end

local function save_selection(item, quiet)
  if not item then
    return false
  end

  local success = write_lines(
    selected_file(),
    { relative_name(item.full) }
  )

  if not success then
    return false
  end

  if not quiet then
    notify(
      "Selected wallpaper: " .. item.display
    )
  end

  return true
end

local function choose_manual(item)
  if save_selection(item) then
    save_mode("manual")
  end
end

-- ============================================
-- FAVORITES
-- ============================================

local function load_favorites()
  local items = {}
  local seen = {}

  for _, line in ipairs(read_lines(favorites_file())) do
    local full = resolve_record(line)

    if full
      and not seen[full]
      and in_background_dir(full)
      and is_image(full)
      and vim.fn.filereadable(full) == 1 then

      seen[full] = true

      table.insert(
        items,
        make_image(full)
      )
    end
  end

  table.sort(items, function(a, b)
    return a.display:lower() < b.display:lower()
  end)

  return items
end

local function toggle_favorite(item)
  local favorites = load_favorites()
  local found = nil

  for index, existing in ipairs(favorites) do
    if existing.full == item.full then
      found = index
      break
    end
  end

  if found then
    table.remove(favorites, found)
  else
    table.insert(
      favorites,
      make_image(item.full)
    )
  end

  table.sort(favorites, function(a, b)
    return a.display:lower() < b.display:lower()
  end)

  local paths = {}

  for _, favorite in ipairs(favorites) do
    table.insert(paths, relative_name(favorite.full))
  end

  if write_lines(favorites_file(), paths) then
    notify(
      (found and "Removed favorite: " or "Added favorite: ")
        .. item.display
    )
  end
end

function M.toggle_current_favorite()
  local path = current_background()

  if not path
    or not in_background_dir(path)
    or not is_image(path)
    or vim.fn.filereadable(path) ~= 1 then

    notify(
      "No valid wallpaper selected.",
      vim.log.levels.WARN
    )

    return
  end

  toggle_favorite(make_image(path))
end

-- ============================================
-- IMAGE COLLECTION
-- ============================================

local function collect_images(dir)
  local images = {}

  local function scan(current)
    local handle = uv.fs_scandir(current)

    if not handle then
      return
    end

    while true do
      local name, kind = uv.fs_scandir_next(handle)

      if not name then
        break
      end

      local full = normalize(
        vim.fs.joinpath(current, name)
      )

      if kind == "directory" then
        scan(full)

      elseif kind == "file" and is_image(name) then
        table.insert(
          images,
          make_image(full)
        )
      end
    end
  end

  scan(dir)

  return images
end

-- ============================================
-- RANDOM WALLPAPERS
-- ============================================

local random_seeded = false

local function pick_random(items, quiet)
  if #items == 0 then
    if not quiet then
      notify(
        "No wallpapers available.",
        vim.log.levels.WARN
      )
    end

    return false
  end

  if not random_seeded then
    math.randomseed(
      uv.hrtime() % 2147483647
    )

    random_seeded = true
  end

  local current = current_background()
  local choices = {}

  -- Avoid repeating the current wallpaper.
  if #items > 1 then
    for _, item in ipairs(items) do
      if item.full ~= current then
        table.insert(choices, item)
      end
    end
  end

  if #choices == 0 then
    choices = items
  end

  local selected = choices[
    math.random(#choices)
  ]

  return save_selection(selected, quiet)
end

function M.random(quiet)
  vim.fn.mkdir(background_dir(), "p")

  return pick_random(
    collect_images(background_dir()),
    quiet
  )
end

function M.random_favorite(quiet)
  return pick_random(
    load_favorites(),
    quiet
  )
end

function M.set_mode(mode)
  vim.fn.mkdir(background_dir(), "p")

  if not valid_modes[mode] then
    notify(
      "Invalid wallpaper mode.",
      vim.log.levels.ERROR
    )
    return
  end

  if mode == "random_favorite"
    and #load_favorites() == 0 then

    notify(
      "Add favorites before enabling this mode.",
      vim.log.levels.WARN
    )

    return
  end

  if not save_mode(mode) then
    return
  end

  if mode == "random" then
    M.random()

  elseif mode == "random_favorite" then
    M.random_favorite()

  else
    notify(
      "Manual mode enabled."
    )
  end
end

-- ============================================
-- FOLDER SCANNER
-- ============================================

local function list_folder(directory)
  local handle, err = uv.fs_scandir(directory)

  if not handle then
    notify(
      "Cannot open folder:\n" .. tostring(err),
      vim.log.levels.ERROR
    )

    return nil
  end

  local items = {}

  while true do
    local name, kind = uv.fs_scandir_next(handle)

    if not name then
      break
    end

    local full = normalize(
      vim.fs.joinpath(directory, name)
    )

    if kind == "directory" then
      table.insert(items, {
        kind = "directory",
        name = name,
        full = full,
      })

    elseif kind == "file" and is_image(name) then
      table.insert(
        items,
        make_image(full)
      )
    end
  end

  table.sort(items, function(a, b)
    if a.kind ~= b.kind then
      return a.kind == "directory"
    end

    return a.name:lower() < b.name:lower()
  end)

  return items
end

-- ============================================
-- SNACKS PICKER
-- ============================================

local function picker_entry(kind, name, hint, icon, hl, extra)
  local item = {
    kind = kind,
    name = name,
    hint = hint,
    icon = icon,
    hl = hl,
  }

  if extra then
    for key, value in pairs(extra) do
      item[key] = value
    end
  end

  return item
end

local function show_picker(items, title, callback)
  local ok_snacks, snacks = pcall(
    require,
    "snacks"
  )

  if ok_snacks
    and snacks.picker
    and type(snacks.picker.pick) == "function" then

    -- Solid background for better readability.
    vim.api.nvim_set_hl(
      0,
      "BackgroundPickerNormal",
      {
        bg = "#171923",
        fg = "#d6d9e6",
      }
    )

    local rows = {}

    for index, item in ipairs(items) do
      table.insert(rows, {
        idx = index,
        text = (item.name or "")
          .. " "
          .. (item.hint or ""),
        entry = item,
      })
    end

    local height = math.min(
      math.max(#rows + 3, 6),
      math.max(6, vim.o.lines - 6)
    )

    local ok, err = pcall(
      snacks.picker.pick,
      {
        source = "background_manager",
        title = title,
        items = rows,
        focus = "input",
        show_empty = true,

        win = {
          input = {
            wo = {
              winblend = 0,
              winhighlight =
                "Normal:BackgroundPickerNormal,"
                .. "NormalFloat:BackgroundPickerNormal",
            },
          },

          list = {
            wo = {
              winblend = 0,
              winhighlight =
                "Normal:BackgroundPickerNormal,"
                .. "NormalFloat:BackgroundPickerNormal",
            },
          },
        },

        layout = {
          preview = false,

          layout = {
            box = "vertical",
            width = 0.55,
            height = height,
            border = "rounded",
            title = "{title}",
            title_pos = "center",
            backdrop = 60,

            {
              win = "input",
              height = 1,
              border = "bottom",
            },

            {
              win = "list",
              border = "none",
            },
          },
        },

        matcher = {
          sort_empty = false,
        },

        sort = {
          fields = {
            "score:desc",
            "idx",
          },
        },

        format = function(row)
          local item = row.entry

          local parts = {
            {
              "  " .. (item.icon or "•") .. "   ",
              item.hl or "Special",
            },
            {
              item.name or "",
              "Normal",
            },
          }

          if item.hint and item.hint ~= "" then
            table.insert(parts, {
              "   " .. item.hint,
              "Comment",
            })
          end

          return parts
        end,

        confirm = function(picker, row)
          picker:close()

          if row then
            vim.schedule(function()
              callback(row.entry)
            end)
          end
        end,
      }
    )

    if ok then
      return
    end

    notify(
      "Snacks picker unavailable: " .. tostring(err),
      vim.log.levels.WARN
    )
  end

  -- Fallback to vim.ui.select.
  local ok, err = pcall(
    vim.ui.select,
    items,
    {
      prompt = title,

      format_item = function(item)
        return (item.icon or "•")
          .. "  "
          .. (item.name or "")
          .. (item.hint and "  " .. item.hint or "")
      end,
    },
    callback
  )

  if not ok then
    notify(
      "Wallpaper picker failed:\n" .. tostring(err),
      vim.log.levels.ERROR
    )
  end
end

-- ============================================
-- MENUS
-- ============================================

local menu
local browse
local favorites_menu
local show_favorites
local show_settings

-- Main menu
menu = function()
  local favorites = load_favorites()
  local active = mode_names[get_mode()]

  local items = {
    picker_entry(
      "browse",
      "Browse wallpapers",
      "Folders and images",
      "▣",
      "Directory"
    ),

    picker_entry(
      "favorites",
      "Favorites",
      #favorites .. " saved",
      "★",
      "Special"
    ),

    picker_entry(
      "shuffle",
      "Shuffle now",
      "Choose another wallpaper",
      "⤨",
      "Special"
    ),

    picker_entry(
      "settings",
      "Settings",
      active,
      "⚙",
      "Comment"
    ),
  }

  show_picker(
    items,
    "Wallpaper Manager · " .. active,
    function(choice)
      if not choice then
        return
      end

      if choice.kind == "browse" then
        later(function()
          browse(background_dir(), "normal")
        end)

      elseif choice.kind == "favorites" then
        later(favorites_menu)

      elseif choice.kind == "shuffle" then
        M.random()

      elseif choice.kind == "settings" then
        later(show_settings)
      end
    end
  )
end

-- Favorites submenu
favorites_menu = function()
  local count = #load_favorites()

  local items = {
    picker_entry(
      "back",
      "Back",
      "Wallpaper Manager",
      "←",
      "Comment"
    ),

    picker_entry(
      "view",
      "Browse favorites",
      count .. " saved",
      "★",
      "Special"
    ),

    picker_entry(
      "random_favorite",
      "Shuffle favorite",
      "Choose one now",
      "⤨",
      "Special"
    ),

    picker_entry(
      "manage",
      "Manage favorites",
      "Add or remove stars",
      "✎",
      "Directory"
    ),

    picker_entry(
      "toggle_current",
      "Toggle active favorite",
      "Star the current wallpaper",
      "☆",
      "Special"
    ),
  }

  show_picker(items, "Favorites", function(choice)
    if not choice then
      return
    end

    if choice.kind == "back" then
      later(menu)

    elseif choice.kind == "view" then
      later(show_favorites)

    elseif choice.kind == "random_favorite" then
      M.random_favorite()

    elseif choice.kind == "manage" then
      later(function()
        browse(background_dir(), "manage")
      end)

    elseif choice.kind == "toggle_current" then
      M.toggle_current_favorite()
      later(favorites_menu)
    end
  end)
end

-- Browse favorites
show_favorites = function()
  local items = {
    picker_entry(
      "back",
      "Back",
      "Favorites",
      "←",
      "Comment"
    ),
  }

  for _, image in ipairs(load_favorites()) do
    table.insert(
      items,
      picker_entry(
        "image",
        image.display,
        nil,
        "★",
        "Special",
        {
          full = image.full,
          display = image.display,
        }
      )
    )
  end

  show_picker(
    items,
    "Favorite wallpapers",
    function(choice)
      if not choice then
        return
      end

      if choice.kind == "back" then
        later(favorites_menu)

      elseif choice.kind == "image" then
        choose_manual(choice)
      end
    end
  )
end

-- Startup settings
show_settings = function()
  local current = get_mode()

  local modes = {
    {
      mode = "random",
      name = "Random at startup",
      hint = "All wallpaper folders",
    },
    {
      mode = "random_favorite",
      name = "Random favorites at startup",
      hint = "Favorites only",
    },
    {
      mode = "manual",
      name = "Manual wallpaper",
      hint = "Keep current image",
    },
  }

  local items = {
    picker_entry(
      "back",
      "Back",
      "Wallpaper Manager",
      "←",
      "Comment"
    ),
  }

  for _, option in ipairs(modes) do
    local active = current == option.mode

    table.insert(
      items,
      picker_entry(
        "mode",
        option.name,
        option.hint,
        active and "●" or "○",
        active and "Special" or "Comment",
        {
          mode = option.mode,
        }
      )
    )
  end

  show_picker(
    items,
    "Startup Settings · " .. mode_names[current],
    function(choice)
      if not choice then
        return
      end

      if choice.kind == "back" then
        later(menu)

      elseif choice.kind == "mode" then
        M.set_mode(choice.mode)
        later(show_settings)
      end
    end
  )
end

-- ============================================
-- FOLDER BROWSER
-- ============================================

browse = function(directory, mode)
  directory = normalize(directory)
  mode = mode or "normal"

  local files = list_folder(directory)

  if not files then
    return
  end

  local items = {}
  local root = background_dir()
  local is_root = directory == root

  local back_hint = "Parent folder"

  if is_root then
    back_hint = mode == "manage"
      and "Favorites"
      or "Wallpaper Manager"
  end

  table.insert(
    items,
    picker_entry(
      "back",
      "Back",
      back_hint,
      "←",
      "Comment",
      {
        full = not is_root
          and normalize(vim.fs.dirname(directory))
          or nil,
      }
    )
  )

  local favorite_set = {}

  for _, image in ipairs(load_favorites()) do
    favorite_set[image.full] = true
  end

  local current = current_background()

  for _, file in ipairs(files) do
    if file.kind == "directory" then
      table.insert(
        items,
        picker_entry(
          "directory",
          file.name,
          nil,
          "▸",
          "Directory",
          {
            full = file.full,
          }
        )
      )

    elseif file.kind == "image" then
      local starred = favorite_set[file.full] or false

      local icon = starred and "★" or "◧"
      local hint = nil

      if current == file.full then
        hint = "Active"

      elseif mode == "manage" then
        hint = starred
          and "Favorited"
          or "Add favorite"
      end

      table.insert(
        items,
        picker_entry(
          "image",
          file.name,
          hint,
          icon,
          starred and "Special" or "Normal",
          {
            full = file.full,
            display = file.display,
          }
        )
      )
    end
  end

  local subtitle = is_root
    and "Backgrounds"
    or relative_name(directory):gsub("[/\\]", " / ")

  local title = (
    mode == "manage"
      and "Manage favorites · "
      or "Browse · "
  ) .. subtitle

  show_picker(
    items,
    title,
    function(choice)
      if not choice then
        return
      end

      if choice.kind == "back" then
        if is_root then
          if mode == "manage" then
            later(favorites_menu)
          else
            later(menu)
          end
        else
          later(function()
            browse(choice.full, mode)
          end)
        end

      elseif choice.kind == "directory" then
        later(function()
          browse(choice.full, mode)
        end)

      elseif choice.kind == "image" then
        if mode == "manage" then
          toggle_favorite(choice)

          later(function()
            browse(directory, mode)
          end)
        else
          choose_manual(choice)
        end
      end
    end
  )
end

-- ============================================
-- PUBLIC FUNCTIONS
-- ============================================

function M.pick()
  vim.fn.mkdir(background_dir(), "p")
  menu()
end

function M.favorites()
  vim.fn.mkdir(background_dir(), "p")
  show_favorites()
end

function M.manage_favorites()
  vim.fn.mkdir(background_dir(), "p")

  browse(
    background_dir(),
    "manage"
  )
end

function M.open_folder()
  local dir = background_dir()

  vim.fn.mkdir(dir, "p")

  if vim.fn.has("win32") == 1 then
    vim.fn.jobstart(
      { "explorer.exe", dir },
      { detach = true }
    )
  else
    vim.ui.open(dir)
  end
end

-- ============================================
-- AUTOMATIC STARTUP
-- ============================================

local startup_registered = false

function M.setup()
  if startup_registered then
    return
  end

  startup_registered = true

  vim.api.nvim_create_user_command("BackgroundRandom", function() M.random() end, {})
  vim.api.nvim_create_user_command("BackgroundFavorites", M.favorites, {})
  vim.api.nvim_create_user_command("BackgroundFavorite", M.toggle_current_favorite, {})
  vim.api.nvim_create_user_command("BackgroundMode", function(opts) M.set_mode(opts.args) end, {
    nargs = 1,
    complete = function() return { "random", "random_favorite", "manual" } end,
  })

  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,

    desc = "Automatically rotate wallpaper on startup",

    callback = function()
      -- Skip headless Neovim.
      if #vim.api.nvim_list_uis() == 0 then
        return
      end

      vim.schedule(function()
        local mode = get_mode()

        if mode == "random" then
          M.random(true)

        elseif mode == "random_favorite" then
          M.random_favorite(true)
        end
      end)
    end,
  })
end

return M
