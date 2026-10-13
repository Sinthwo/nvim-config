local M = {}

local uv = vim.uv or vim.loop

local function background_dir()
  return require("config.paths").background_dir()
end

local function is_image(name)
  local lower = name:lower()
  return lower:match("%.png$")
    or lower:match("%.jpg$")
    or lower:match("%.jpeg$")
    or lower:match("%.gif$")
    or lower:match("%.bmp$")
    or lower:match("%.webp$")
end

local function normalize(path)
  if not path or path == "" then
    return path
  end

  return vim.fs.normalize(path)
end

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

      local full = vim.fs.joinpath(current, name)

      if kind == "directory" then
        scan(full)
      elseif kind == "file" and is_image(name) then
        local relative = full:sub(#dir + 2)

        table.insert(images, {
          display = relative,
          full = normalize(full),
        })
      end
    end
  end

  scan(dir)

  table.sort(images, function(a, b)
    return a.display:lower() < b.display:lower()
  end)

  return images
end

local function save_selection(item)
  if not item then
    return
  end

  local dir = background_dir()
  local selected = vim.fs.joinpath(dir, "selected-background.txt")
  -- Save the path relative to the wallpaper folder, including any subfolders.
  local ok, err = pcall(vim.fn.writefile, { (item.display:gsub("\\", "/")) }, selected)

  if not ok then
    vim.notify(
      "Could not write selected-background.txt:\n" .. tostring(err),
      vim.log.levels.ERROR,
      { title = "Background" }
    )
    return
  end

  vim.notify(
    "Selected wallpaper: " .. item.display,
    vim.log.levels.INFO,
    { title = "Background" }
  )
end

local function choose_image(images)
  -- Keep the image record with its label when using the configured selection UI.
  local ok, err = pcall(vim.ui.select, images, {
    prompt = "Choose a terminal wallpaper",
    format_item = function(item)
      return item.display
    end,
  }, function(item)
    if item then
      save_selection(item)
    end
  end)
  if not ok then
    vim.notify("Wallpaper selection failed: " .. tostring(err), vim.log.levels.ERROR, { title = "Background" })
  end
end

function M.open_folder()
  local dir = background_dir()
  vim.fn.mkdir(dir, "p")

  if vim.fn.has("win32") == 1 then
    vim.fn.jobstart({ "explorer.exe", dir }, { detach = true })
  else
    vim.ui.open(dir)
  end
end

function M.pick()
  local dir = background_dir()
  vim.fn.mkdir(dir, "p")

  local images = collect_images(dir)

  if #images == 0 then
    vim.notify(
      "No wallpapers found in " .. dir .. "\nUse :BackgroundFolder to open the folder.",
      vim.log.levels.WARN,
      { title = "Background" }
    )
    return
  end

  choose_image(images)
end

return M
