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
  -- Keep subfolders without saving a username or machine-specific drive.
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
    "Selected background: " .. item.display,
    vim.log.levels.INFO,
    { title = "Background" }
  )
end

local function native_select(images)
  local labels = {}
  local by_label = {}

  for _, item in ipairs(images) do
    table.insert(labels, item.display)
    by_label[item.display] = item
  end

  vim.ui.select(labels, {
    prompt = "Choose terminal background",
  }, function(choice)
    if choice then
      save_selection(by_label[choice])
    end
  end)
end

local function fzf_select(images)
  local ok, fzf = pcall(require, "fzf-lua")

  if not ok then
    return false
  end

  local labels = {}
  local by_label = {}

  for _, item in ipairs(images) do
    table.insert(labels, item.display)
    by_label[item.display] = item
  end

  fzf.fzf_exec(labels, {
    prompt = "Background> ",
    actions = {
      ["default"] = function(selected)
        local choice = selected and selected[1]

        if choice then
          save_selection(by_label[choice])
        end
      end,
    },
  })

  return true
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
      "No images found in " .. dir .. "\nUse :BackgroundFolder to open it.",
      vim.log.levels.WARN,
      { title = "Background" }
    )
    return
  end

  -- Prefer the same fzf-lua UI already used elsewhere in this config. If it
  -- is unavailable for any reason, fall back to Neovim's built-in selector.
  if not fzf_select(images) then
    native_select(images)
  end
end

return M
