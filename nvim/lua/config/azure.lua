local M = {}

local function root()
  return require("config.project").root()
end

local function open_terminal(command)
  local ok, snacks = pcall(require, "snacks")

  if not ok then
    vim.notify("snacks.nvim is not available.", vim.log.levels.ERROR)
    return
  end

  snacks.terminal(command, {
    cwd = root(),
  })
end

local function require_executable(name, install_hint)
  if vim.fn.executable(name) == 1 then
    return true
  end

  vim.notify(
    name .. " was not found in PATH.\n" .. install_hint,
    vim.log.levels.ERROR,
    { title = "Azure" }
  )

  return false
end

local function azure_cli(command)
  if not require_executable(
    "az",
    "Install Azure CLI, then restart WezTerm/Neovim."
  ) then
    return
  end

  open_terminal(command)
end

local function azure_powershell()
  local powershell = require("config.paths").find_powershell(true)
  if not powershell then
    vim.notify("PowerShell 7 was not found. Install it and restart WezTerm/Neovim.", vim.log.levels.ERROR, { title = "Azure" })
    return
  end

  local script = table.concat({
    "$az = Get-Module -ListAvailable -Name Az; ",
    "if ($az) { ",
    "Import-Module Az; ",
    "Write-Host 'Az module loaded. Use Connect-AzAccount to sign in.' ",
    "-ForegroundColor Green ",
    "} else { ",
    "Write-Host 'Az module is not installed. Run: Install-Module -Name Az -Scope CurrentUser -Repository PSGallery' ",
    "-ForegroundColor Yellow ",
    "}",
  })

  -- An argument list keeps PowerShell variables and paths out of the outer shell.
  open_terminal({ powershell, "-NoLogo", "-NoExit", "-Command", script })
end

function M.setup()
  vim.api.nvim_create_user_command("AzureTerminal", function()
    open_terminal(nil)
  end, {
    desc = "Open an Azure-ready Snacks terminal",
  })

  vim.api.nvim_create_user_command("AzureLogin", function()
    azure_cli("az login")
  end, {
    desc = "Azure CLI login",
  })

  vim.api.nvim_create_user_command("AzureAccount", function()
    azure_cli("az account show -o table")
  end, {
    desc = "Show active Azure account",
  })

  vim.api.nvim_create_user_command("AzureGroups", function()
    azure_cli("az group list -o table")
  end, {
    desc = "List Azure resource groups",
  })

  vim.api.nvim_create_user_command("AzureResources", function()
    azure_cli("az resource list -o table")
  end, {
    desc = "List Azure resources",
  })

  vim.api.nvim_create_user_command("AzurePowerShell", azure_powershell, {
    desc = "Open PowerShell with the Az module",
  })

  vim.keymap.set("n", "<leader>zt", "<cmd>AzureTerminal<CR>", {
    desc = "Azure terminal",
  })

  vim.keymap.set("n", "<leader>zl", "<cmd>AzureLogin<CR>", {
    desc = "Azure login",
  })

  vim.keymap.set("n", "<leader>za", "<cmd>AzureAccount<CR>", {
    desc = "Azure account",
  })

  vim.keymap.set("n", "<leader>zg", "<cmd>AzureGroups<CR>", {
    desc = "Azure resource groups",
  })

  vim.keymap.set("n", "<leader>zr", "<cmd>AzureResources<CR>", {
    desc = "Azure resources",
  })

  vim.keymap.set("n", "<leader>zp", "<cmd>AzurePowerShell<CR>", {
    desc = "Azure PowerShell",
  })
end

return M
