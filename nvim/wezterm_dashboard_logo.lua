local M = {}

function M.setup(wezterm, config_dir)
  local logo = (config_dir .. "/dashboard-logo.png"):gsub("\\", "/")
  wezterm.add_to_config_reload_watch_list(logo)

  local function logo_exists()
    local file = io.open(logo, "rb")
    if not file then
      return false
    end
    file:close()
    return true
  end

  local function is_logo(layer)
    local source = type(layer) == "table" and layer.source
    local file = type(source) == "table" and source.File
    return type(file) == "string" and file:gsub("\\", "/") == logo
  end

  local function visible(pane)
    if not pane then
      return false
    end
    local vars = pane:get_user_vars() or {}
    return vars.NVIM_ACTIVE == "1" and vars.NVIM_DASHBOARD == "1" and logo_exists()
  end

  local function update(window, pane)
    local overrides = window:get_config_overrides() or {}
    local layers, current = {}, nil
    for _, layer in ipairs(overrides.background or {}) do
      if is_logo(layer) then
        current = layer
      else
        layers[#layers + 1] = layer
      end
    end

    if visible(pane) then
      local dimensions = pane:get_dimensions()
      local rows = dimensions.viewport_rows >= 34 and 10 or 8
      local size = tostring(rows) .. "cell"
      local layer = {
        source = { File = logo },
        width = tostring(rows * 2) .. "cell",
        height = size,
        horizontal_align = "Center",
        vertical_align = "Top",
        horizontal_offset = 0,
        vertical_offset = "1cell",
        repeat_x = "NoRepeat",
        repeat_y = "NoRepeat",
        opacity = 1.0,
      }
      if current then
        local same = true
        for key, value in pairs(layer) do
          if key ~= "source" and current[key] ~= value then
            same = false
            break
          end
        end
        if same then
          return
        end
      end
      layers[#layers + 1] = layer
      overrides.background = layers
      window:set_config_overrides(overrides)
    elseif current then
      -- Remove the logo while keeping unrelated background layers and settings.
      overrides.background = #layers > 0 and layers or nil
      window:set_config_overrides(overrides)
    end
  end

  wezterm.on("user-var-changed", function(window, pane, name)
    if name == "NVIM_ACTIVE" or name == "NVIM_DASHBOARD" then
      update(window, pane)
    end
  end)
  wezterm.on("update-right-status", update)

  return { visible = visible, update = update }
end

return M
