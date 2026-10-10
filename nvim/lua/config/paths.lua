local M = {}

function M.background_dir()
  local override = vim.env.NVIM_BACKGROUND_DIR
  if override and override ~= "" then
    return vim.fs.normalize(vim.fn.expand(override))
  end

  return vim.fs.joinpath(vim.fn.stdpath("config"), "backgrounds")
end

function M.find_powershell(modern_only)
  local candidates = {
    vim.fn.exepath("pwsh.exe"),
    vim.fn.exepath("pwsh"),
  }

  if vim.env.ProgramFiles and vim.env.ProgramFiles ~= "" then
    table.insert(candidates, vim.fs.joinpath(vim.env.ProgramFiles, "PowerShell", "7", "pwsh.exe"))
  end

  if not modern_only then
    table.insert(candidates, vim.fn.exepath("powershell.exe"))
    if vim.env.SystemRoot and vim.env.SystemRoot ~= "" then
      table.insert(candidates, vim.fs.joinpath(vim.env.SystemRoot, "System32", "WindowsPowerShell", "v1.0", "powershell.exe"))
    end
  end

  for _, path in ipairs(candidates) do
    if path ~= "" and (vim.uv or vim.loop).fs_stat(path) then
      return path
    end
  end

  return nil
end

-- Single-quoted PowerShell strings escape an apostrophe by doubling it.
function M.powershell_quote(value)
  return "'" .. value:gsub("'", "''") .. "'"
end

return M
