local M = {}

function M.visible()
  local pane = vim.env.WEZTERM_PANE
  local config_dir = vim.fn.stdpath("config")
  return pane ~= nil and pane ~= ""
    and vim.o.lines >= 25
    and vim.o.columns >= 24
    and vim.fn.filereadable(vim.fs.joinpath(config_dir, "dashboard-logo.png")) == 1
    and vim.fn.filereadable(vim.fs.joinpath(config_dir, "wezterm_dashboard_logo.lua")) == 1
end

function M.section()
  if not M.visible() then
    return { header = "NEOVIM", padding = 1 }
  end

  -- Reserve the same rows used by the WezTerm logo layer.
  local reserve = vim.o.lines >= 34 and 12 or 10
  return { header = string.rep(" \n", reserve - 1) .. " ", padding = 0 }
end

return M
