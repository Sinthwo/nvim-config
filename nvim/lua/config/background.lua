local M = {}

local background_dir = require("config.paths").background_dir

local function is_image(name)
  local lower = name:lower()
  return lower:match("%.png$")
    or lower:match("%.jpg$")
    or lower:match("%.jpeg$")
    or lower:match("%.gif$")
    or lower:match("%.bmp$")
    or lower:match("%.webp$")
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

  local images = {}

  for name, kind in vim.fs.dir(dir) do
    if kind == "file" and is_image(name) then
      table.insert(images, name)
    end
  end

  table.sort(images)

  if #images == 0 then
    vim.notify(
      "No images found in " .. dir .. "\nUse :BackgroundFolder to open it.",
      vim.log.levels.WARN,
      { title = "Background" }
    )
    return
  end

  vim.ui.select(images, {
    prompt = "Choose terminal background",
  }, function(choice)
    if not choice then
      return
    end

    local selected = vim.fs.joinpath(dir, "selected-background.txt")
    -- Store only the filename so the selection can move between user profiles.
    vim.fn.writefile({ choice }, selected)

    vim.notify(
      "Selected background: " .. choice,
      vim.log.levels.INFO,
      { title = "Background" }
    )
  end)
end

return M
