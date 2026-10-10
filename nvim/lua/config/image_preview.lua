local M = {}

-- Track each preview in its own WezTerm tab.
local previews = {}
local preview_order = {}

local direct_extensions = {
  png = true,
  jpg = true,
  jpeg = true,
  gif = true,
}

local supported_extensions = {
  png = true,
  jpg = true,
  jpeg = true,
  gif = true,
  webp = true,
  avif = true,
  svg = true,
  bmp = true,
  tif = true,
  tiff = true,
  pdf = true,
}

local patterns = {}
for ext in pairs(supported_extensions) do
  patterns[#patterns + 1] = "*." .. ext:gsub("%a", function(letter)
    return "[" .. letter:lower() .. letter:upper() .. "]"
  end)
end
table.sort(patterns)

local function trim(value)
  local text = tostring(value or "")
  text = text:gsub("^%s+", "")
  text = text:gsub("%s+$", "")
  return text
end

local function executable(name)
  local path = vim.fn.exepath(name)
  if path == "" then
    return nil
  end
  return path
end

local function extension(path)
  return (path:match("%.([^%.\\/]+)$") or ""):lower()
end

local function delete_file(path)
  if path and path ~= "" and vim.fn.filereadable(path) == 1 then
    pcall(vim.fn.delete, path)
  end
end

local function cleanup_preview_files(preview)
  if not preview then
    return
  end

  delete_file(preview.temp_file)
  delete_file(preview.script)
end

local function remove_preview_record(pane_id)
  local preview = previews[pane_id]
  cleanup_preview_files(preview)
  previews[pane_id] = nil

  for i = #preview_order, 1, -1 do
    if preview_order[i] == pane_id then
      table.remove(preview_order, i)
      break
    end
  end
end

local function kill_preview(pane_id, silent)
  if not pane_id then
    if not silent then
      vim.notify("No image preview tabs are open.", vim.log.levels.INFO, { title = "Image Preview" })
    end
    return
  end

  local wezterm = executable("wezterm")
  if wezterm then
    pcall(function()
      vim.system({
        wezterm,
        "cli",
        "kill-pane",
        "--pane-id",
        tostring(pane_id),
      }, { text = true }):wait(1500)
    end)
  end

  remove_preview_record(pane_id)

  if not silent then
    vim.notify("Image preview tab closed.", vim.log.levels.INFO, { title = "Image Preview" })
  end
end

local function close_latest_preview(silent)
  local pane_id = preview_order[#preview_order]
  kill_preview(pane_id, silent)
end

local function close_all_previews(silent)
  local ids = vim.deepcopy(preview_order)

  for i = #ids, 1, -1 do
    kill_preview(ids[i], true)
  end

  previews = {}
  preview_order = {}

  if not silent then
    vim.notify("All image preview tabs closed.", vim.log.levels.INFO, { title = "Image Preview" })
  end
end

-- Escape a value for use as a quoted argument inside a .cmd file.
-- Percent signs must be doubled because cmd.exe expands %VAR% even inside quotes.
local function cmd_quote(value)
  value = tostring(value or "")
  assert(not value:find('[\r\n"]'), "Invalid Windows preview path")
  value = value:gsub("%%", "%%%%")
  return '"' .. value .. '"'
end

local function write_preview_script(wezterm, path)
  local script_path = vim.fn.tempname() .. ".cmd"

  local lines = {
    "@echo off",
    "setlocal DisableDelayedExpansion",
    "title Image Preview",
    cmd_quote(wezterm) .. " imgcat " .. cmd_quote(path),
    "echo.",
    "echo Image Preview",
    "echo Close this preview using the WezTerm tab close button or Ctrl+Shift+W.",
    "echo This tab stays open until you close it.",
    -- Keep the preview open until the tab is closed.
    "ping -t 127.0.0.1 >nul",
  }

  local ok = pcall(vim.fn.writefile, lines, script_path)
  if not ok or vim.fn.filereadable(script_path) ~= 1 then
    pcall(vim.fn.delete, script_path)
    return nil
  end

  return script_path
end

local function spawn_wezterm_preview(path, original_path, temp_file)
  local wezterm = executable("wezterm")
  local current_pane = vim.env.WEZTERM_PANE

  if not wezterm then
    vim.notify(
      "wezterm.exe was not found in PATH.",
      vim.log.levels.ERROR,
      { title = "Image Preview" }
    )
    delete_file(temp_file)
    return
  end

  if not current_pane or current_pane == "" then
    vim.notify(
      "Run Neovim inside WezTerm to open image and PDF previews.",
      vim.log.levels.ERROR,
      { title = "Image Preview" }
    )
    delete_file(temp_file)
    return
  end

  -- Use the Windows command interpreter specified by COMSPEC.
  local cmd = vim.env.ComSpec
  if not cmd or cmd == "" then
    cmd = vim.env.COMSPEC
  end
  if not cmd or cmd == "" then
    cmd = "cmd.exe"
  end

  local source_path = original_path or path
  local display_name = vim.fn.fnamemodify(source_path, ":t")
  local cwd = vim.fn.fnamemodify(source_path, ":h")

  local script_path = write_preview_script(wezterm, path)
  if not script_path then
    delete_file(temp_file)
    vim.notify(
      "Could not create the temporary image preview script.",
      vim.log.levels.ERROR,
      { title = "Image Preview" }
    )
    return
  end

  -- Open each preview in a separate WezTerm tab.
  vim.system({
    wezterm,
    "cli",
    "spawn",
    "--pane-id",
    tostring(current_pane),
    "--cwd",
    cwd,
    "--",
    cmd,
    "/d",
    "/v:off",
    "/c",
    -- CALL preserves the quoted batch path when the temp directory has spaces.
    "call",
    script_path,
  }, { text = true }, function(result)
    vim.schedule(function()
      if not result or result.code ~= 0 then
        delete_file(script_path)
        delete_file(temp_file)
        vim.notify(
          "Could not open the WezTerm image tab for "
            .. display_name
            .. ":\n"
            .. trim(result and result.stderr or "Unknown error"),
          vim.log.levels.ERROR,
          { title = "Image Preview" }
        )
        return
      end

      -- Keep the pane identifier returned by WezTerm as a string.
      local output = trim(result.stdout)
      local pane_id = output:match("(%d+)")

      if not pane_id then
        delete_file(script_path)
        delete_file(temp_file)
        vim.notify(
          "The preview opened, but WezTerm did not return a pane identifier.\nOutput: " .. output,
          vim.log.levels.WARN,
          { title = "Image Preview" }
        )
        return
      end

      previews[pane_id] = {
        pane_id = pane_id,
        source = source_path,
        rendered = path,
        script = script_path,
        temp_file = temp_file,
      }
      table.insert(preview_order, pane_id)

      -- Name the preview tab after its source file.
      vim.system({
        wezterm,
        "cli",
        "set-tab-title",
        "--pane-id",
        pane_id,
        "Image: " .. display_name,
      }, { text = true })

      -- Bring the newly created image tab to the front.
      vim.system({
        wezterm,
        "cli",
        "activate-pane",
        "--pane-id",
        pane_id,
      }, { text = true })
    end)
  end)
end

local function convert_then_preview(path)
  local magick = executable("magick")

  if not magick then
    vim.notify(
      "ImageMagick (magick.exe) is required to preview this format.",
      vim.log.levels.ERROR,
      { title = "Image Preview" }
    )
    return
  end

  local target = vim.fn.tempname() .. ".png"
  local ext = extension(path)
  local input = path

  if ext == "pdf" then
    -- Preview the first page of a PDF.
    input = path .. "[0]"
  end

  vim.notify("Preparing preview...", vim.log.levels.INFO, { title = "Image Preview" })

  vim.system({
    magick,
    input,
    target,
  }, { text = true }, function(result)
    vim.schedule(function()
      if not result or result.code ~= 0 or vim.fn.filereadable(target) ~= 1 then
        pcall(vim.fn.delete, target)
        vim.notify(
          "Image conversion failed:\n" .. trim(result and result.stderr or "Unknown error"),
          vim.log.levels.ERROR,
          { title = "Image Preview" }
        )
        return
      end

      spawn_wezterm_preview(target, path, target)
    end)
  end)
end

function M.open(path)
  path = vim.fn.fnamemodify(path or "", ":p")

  if path == "" or vim.fn.filereadable(path) ~= 1 then
    vim.notify("Preview file not found: " .. path, vim.log.levels.ERROR, { title = "Image Preview" })
    return
  end

  local ext = extension(path)
  if not supported_extensions[ext] then
    vim.notify("Unsupported preview format: ." .. ext, vim.log.levels.WARN, { title = "Image Preview" })
    return
  end

  -- Existing previews stay open when another file is opened.
  if direct_extensions[ext] then
    spawn_wezterm_preview(path, path, nil)
  else
    convert_then_preview(path)
  end
end

function M.close()
  close_latest_preview(false)
end

function M.close_all()
  close_all_previews(false)
end

function M.setup()
  vim.api.nvim_create_user_command("ImagePreview", function(opts)
    local path = opts.args ~= "" and opts.args or vim.api.nvim_buf_get_name(0)
    M.open(path)
  end, {
    nargs = "?",
    complete = "file",
    desc = "Preview an image or PDF in a new WezTerm tab",
  })

  vim.api.nvim_create_user_command("ImagePreviewClose", function()
    M.close()
  end, {
    desc = "Close the most recently opened WezTerm image preview tab",
  })

  vim.api.nvim_create_user_command("ImagePreviewCloseAll", function()
    M.close_all()
  end, {
    desc = "Close all WezTerm image preview tabs",
  })

  local group = vim.api.nvim_create_augroup("UserStableWezTermImagePreview", { clear = true })

  -- Open a WezTerm preview before Neovim reads the file as binary text.
  vim.api.nvim_create_autocmd("BufReadCmd", {
    group = group,
    pattern = patterns,
    callback = function(args)
      local path = vim.api.nvim_buf_get_name(args.buf)
      local previous_buf = vim.fn.bufnr("#")
      local win = vim.api.nvim_get_current_win()

      vim.bo[args.buf].buftype = "nofile"
      vim.bo[args.buf].bufhidden = "wipe"
      vim.bo[args.buf].swapfile = false
      vim.bo[args.buf].modifiable = true

      vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, {
        "Opening a preview in a new WezTerm tab...",
        path,
        "",
        "The preview stays open until you close its tab.",
      })

      vim.bo[args.buf].modified = false
      vim.bo[args.buf].modifiable = false
      vim.bo[args.buf].filetype = "imagepreview"

      vim.schedule(function()
        M.open(path)

        if vim.api.nvim_win_is_valid(win) then
          if
            previous_buf > 0
            and previous_buf ~= args.buf
            and vim.api.nvim_buf_is_valid(previous_buf)
            and vim.api.nvim_buf_is_loaded(previous_buf)
          then
            pcall(vim.api.nvim_win_set_buf, win, previous_buf)
          else
            pcall(function()
              vim.api.nvim_set_current_win(win)
              vim.cmd("enew")
            end)
          end
        end

        if vim.api.nvim_buf_is_valid(args.buf) then
          pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
        end
      end)
    end,
  })

  -- When Neovim exits, clean up every image tab that it spawned.
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      close_all_previews(true)
    end,
  })
end

return M
