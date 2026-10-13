-- =========================================================
-- WezTerm integration
-- =========================================================

local function wezterm_set_nvim_state(active)
  if not vim.env.WEZTERM_PANE then
    return
  end

  local encoded

  if active then
    -- base64("1")
    encoded = "MQ=="
  else
    -- base64("0")
    encoded = "MA=="
  end

  io.stdout:write(
    string.format(
      "\027]1337;SetUserVar=NVIM_ACTIVE=%s\007",
      encoded
    )
  )

  io.stdout:flush()
end

vim.api.nvim_create_autocmd(
  "VimEnter",
  {
    callback = function()
      vim.schedule(function()
        wezterm_set_nvim_state(true)
      end)
    end,
  }
)

vim.api.nvim_create_autocmd(
  "VimLeavePre",
  {
    callback = function()
      wezterm_set_nvim_state(false)
    end,
  }
)
-- Dashboard logo state for the companion WezTerm configuration.

local last_dashboard_state = nil

local function set_dashboard_state(active)
  if not vim.env.WEZTERM_PANE then
    return
  end
  if last_dashboard_state == active then
    return
  end
  last_dashboard_state = active
  local encoded = active and "MQ==" or "MA==" -- base64("1") or base64("0")
  io.stdout:write("\027]1337;SetUserVar=NVIM_DASHBOARD=" .. encoded .. "\007")
  io.stdout:flush()
end

local function refresh_dashboard_state()
  local ok, ft = pcall(function()
    return vim.bo[vim.api.nvim_get_current_buf()].filetype
  end)
  set_dashboard_state(ok and ft == "snacks_dashboard" and require("config.dashboard_logo").visible())
end

local dashboard_group = vim.api.nvim_create_augroup("UserWeztermDashboardLogo", { clear = true })

vim.api.nvim_create_autocmd("User", {
  group = dashboard_group,
  pattern = "SnacksDashboardOpened",
  callback = function() vim.schedule(refresh_dashboard_state) end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufLeave", "WinEnter", "TabEnter", "BufWipeout", "VimResized" }, {
  group = dashboard_group,
  callback = function() vim.schedule(refresh_dashboard_state) end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = dashboard_group,
  callback = function() vim.schedule(refresh_dashboard_state) end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = dashboard_group,
  callback = function() set_dashboard_state(false) end,
})
