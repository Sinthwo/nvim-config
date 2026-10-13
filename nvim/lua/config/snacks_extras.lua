-- Dashboard, terminal, Git, notification, and scratch commands.
local M = {}
local terminal_serial = 1

local function project_root()
  return require("config.project").root()
end

local function register(name, fn, description)
  vim.api.nvim_create_user_command(name, fn, { desc = description })
end

local function require_executable(exe, feature)
  if vim.fn.executable(exe) == 1 then
    return true
  end
  vim.notify(feature .. " requires '" .. exe .. "' on PATH.", vim.log.levels.WARN)
  return false
end

local function terminal_panel()
  Snacks.terminal(nil, {
    cwd = project_root(),
    win = { position = "bottom", height = 0.30 },
  })
end

local function terminal_float()
  Snacks.terminal(nil, {
    cwd = project_root(),
    win = { position = "float", height = 0.75, width = 0.86, border = "rounded" },
  })
end

local function terminal_new()
  -- count gives the terminal a unique Snacks ID instead of toggling the first.
  terminal_serial = terminal_serial + 1
  Snacks.terminal.open(nil, {
    count = terminal_serial,
    cwd = project_root(),
    win = { position = "bottom", height = 0.30 },
  })
end

local function run_lazygit()
  if require_executable("lazygit", "LazyGit") then
    Snacks.lazygit({ cwd = project_root() })
  end
end

local function git_root_available()
  if vim.fn.executable("git") == 0 then
    vim.notify("Git was not found in PATH.", vim.log.levels.WARN)
    return false
  end
  local result = vim.fn.systemlist({ "git", "-C", project_root(), "rev-parse", "--is-inside-work-tree" })
  if vim.v.shell_error ~= 0 or result[1] ~= "true" then
    vim.notify("The current project is not a Git repository.", vim.log.levels.INFO)
    return false
  end
  return true
end

local function git_picker(method)
  if not git_root_available() then return end
  Snacks.picker[method]({ cwd = project_root() })
end

function M.setup()
  register("Dashboard", function() Snacks.dashboard() end, "Open Neovim dashboard")
  register("Notifications", function() Snacks.notifier.show_history() end, "Notification history")
  register("NotifyDismiss", function() Snacks.notifier.hide() end, "Dismiss notifications")

  register("TerminalPanel", terminal_panel, "Toggle bottom terminal panel")
  register("TerminalFloat", terminal_float, "Toggle floating terminal")
  register("TerminalNew", terminal_new, "Open another bottom terminal session")

  register("LazyGitFloat", run_lazygit, "Open LazyGit in Neovim")
  register("GitLogPicker", function() git_picker("git_log") end, "Git commit log")
  register("GitBranches", function() git_picker("git_branches") end, "Git branches")
  register("GitDiffPicker", function() git_picker("git_diff") end, "Git diff hunks")
  register("GitStatusPicker", function() git_picker("git_status") end, "Git status")
  register("GitLogLine", function() git_picker("git_log_line") end, "Git history of line")
  register("GitRebaseStatus", function()
    if not git_root_available() then return end
    -- Show Git status and recent commits in a read-only floating window.
    local status = vim.fn.systemlist({ "git", "-C", project_root(), "status" })
    local logs = vim.fn.systemlist({ "git", "-C", project_root(), "--no-pager", "log", "--graph", "--decorate", "--oneline", "-20" })
    local lines = { "Git status / rebase", "" }
    vim.list_extend(lines, status)
    vim.list_extend(lines, { "", "Recent commits", "" })
    vim.list_extend(lines, logs)
    Snacks.win({ text = lines, title = " Git / Rebase ", width = 0.86, height = 0.78, border = "rounded", ft = "git", bo = { modifiable = false } })
  end, "Git rebase status and recent commit graph")
  register("GitBrowse", function()
    if git_root_available() then Snacks.gitbrowse({ what = "file" }) end
  end, "Open current file in remote Git host")
  register("GitBlame", function()
    if not git_root_available() then return end
    local ok, gs = pcall(require, "gitsigns")
    if ok then gs.blame_line({ full = true }) end
  end, "Git blame current line")
  register("FloatScratch", function() Snacks.scratch() end, "Floating scratch / notes window")

  local map = vim.keymap.set
  map("n", "<leader>uD", "<cmd>Dashboard<CR>", { desc = "Dashboard" })
  map("n", "<leader>uN", "<cmd>NotifyDismiss<CR>", { desc = "Dismiss notifications" })
  map("n", "<leader>tN", "<cmd>TerminalNew<CR>", { desc = "New terminal session" })
  map("n", "<leader>gG", "<cmd>LazyGitFloat<CR>", { desc = "Open LazyGit" })
  map("n", "<leader>gB", "<cmd>GitBrowse<CR>", { desc = "Browse Git remote" })
  map("n", "<leader>gL", "<cmd>GitLogPicker<CR>", { desc = "Git log picker" })
  map("n", "<leader>gF", "<cmd>GitBranches<CR>", { desc = "Git branches" })
  map("n", "<leader>gS", "<cmd>GitStatusPicker<CR>", { desc = "Git status picker" })
  map("n", "<leader>gR", "<cmd>GitRebaseStatus<CR>", { desc = "Git / rebase status" })
  map("n", "<leader>u.", "<cmd>FloatScratch<CR>", { desc = "Floating notes" })
end

return M
