local M = {}

local MAX_SESSIONS = 8

-- Keep track of AI workspaces so :Codex_End / :Claude_End can shut down
-- every terminal process and close the workspace tab cleanly.
local workspaces = {
  Codex = {},
  Claude = {},
}

local function normal_code_buffer()
  local current = vim.api.nvim_get_current_buf()

  if vim.bo[current].buftype == "" then
    return current
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if
      vim.api.nvim_buf_is_valid(buf)
      and vim.bo[buf].buflisted
      and vim.bo[buf].buftype == ""
    then
      return buf
    end
  end

  return current
end

local function project_root()
  local buf = normal_code_buffer()
  return require("config.project").root(buf)
end

local function mark_scratch_buffer(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  if vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) == "" then
    vim.bo[buf].buflisted = false
    vim.bo[buf].bufhidden = "wipe"
  end
end

local function start_terminal(command, cwd, label, family, index, total)
  -- Splits inherit the buffer from the source window. Replace it with a tiny
  -- unlisted scratch buffer before starting :terminal so normal coding buffers
  -- never become part of the AI workspace.
  vim.cmd("enew")

  local scratch = vim.api.nvim_get_current_buf()
  mark_scratch_buffer(scratch)

  vim.cmd("lcd " .. vim.fn.fnameescape(cwd))
  vim.cmd("terminal " .. command)

  local buf = vim.api.nvim_get_current_buf()

  vim.bo[buf].buflisted = false
  vim.bo[buf].bufhidden = "wipe"

  vim.b[buf].ai_workspace = true
  vim.b[buf].ai_family = family
  vim.b[buf].ai_session_index = index
  vim.b[buf].ai_session_total = total

  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = "no"
  vim.wo.winbar = " " .. label .. " "

  pcall(vim.cmd, "stopinsert")

  return {
    win = vim.api.nvim_get_current_win(),
    buf = buf,
    job = vim.b[buf].terminal_job_id,
  }
end

local function remove_workspace_record(family, target)
  local entries = workspaces[family] or {}

  for i = #entries, 1, -1 do
    if entries[i] == target then
      table.remove(entries, i)
      return
    end
  end
end

local function cleanup_workspace(workspace)
  if not workspace or workspace.closing then
    return
  end

  workspace.closing = true

  -- Close ONLY the dedicated AI tab page.
  -- We intentionally do not call jobstop() or delete terminal buffers here.
  -- The terminal buffers use bufhidden=wipe, so closing the AI tab naturally
  -- wipes those terminal buffers and ends their jobs without touching normal
  -- coding tabs or buffers.
  local tab = workspace.tab
  local origin_tab = workspace.origin_tab

  if tab and vim.api.nvim_tabpage_is_valid(tab) then
    local tabs = vim.api.nvim_list_tabpages()

    if #tabs > 1 then
      pcall(vim.api.nvim_set_current_tabpage, tab)
      pcall(vim.cmd, "tabclose!")

      -- Return to the tab the user had open before starting the AI workspace.
      if origin_tab and vim.api.nvim_tabpage_is_valid(origin_tab) then
        pcall(vim.api.nvim_set_current_tabpage, origin_tab)
      end
    else
      vim.notify(
        "Cannot close the only remaining tab page.",
        vim.log.levels.WARN,
        { title = workspace.family }
      )
    end
  end

  remove_workspace_record(workspace.family, workspace)
end

local function end_family(family)
  local entries = workspaces[family] or {}

  if #entries == 0 then
    vim.notify(
      "No " .. family .. " workspace is currently open.",
      vim.log.levels.INFO,
      { title = family }
    )
    return
  end

  -- Shallow-copy the list so cleanup can remove the original workspace
  -- records while we iterate over stable references.
  local targets = {}

  for i, workspace in ipairs(entries) do
    targets[i] = workspace
  end

  for _, workspace in ipairs(targets) do
    cleanup_workspace(workspace)
  end

  vim.cmd("redrawtabline")

  vim.notify(
    family .. " workspace tab closed.",
    vim.log.levels.INFO,
    { title = family }
  )
end

local function create_workspace(command, display_name, count)
  count = tonumber(count)

  if not count or count < 1 or count > MAX_SESSIONS or count ~= math.floor(count) then
    vim.notify(
      display_name .. " session count must be between 1 and " .. MAX_SESSIONS .. ".",
      vim.log.levels.WARN
    )
    return
  end

  if vim.fn.executable(command) ~= 1 then
    vim.notify(
      command .. " was not found in PATH.",
      vim.log.levels.ERROR,
      { title = display_name }
    )
    return
  end

  local root = project_root()
  local origin_tab = vim.api.nvim_get_current_tabpage()

  -- AI sessions live in their own tab page. The original tab remains exactly
  -- as it was: only the user's normal coding files stay there.
  vim.cmd("tabnew")

  local workspace_tab = vim.api.nvim_get_current_tabpage()
  local initial_scratch = vim.api.nvim_get_current_buf()

  vim.t.ai_workspace = true
  vim.t.ai_family = display_name

  mark_scratch_buffer(initial_scratch)

  local workspace = {
    family = display_name,
    command = command,
    tab = workspace_tab,
    origin_tab = origin_tab,
    root = root,
    terminals = {},
  }

  table.insert(workspaces[display_name], workspace)

  -- Session 1 uses the initial window. No code buffer is copied into this tab.
  local first = start_terminal(
    command,
    root,
    string.format("%s 1/%d", display_name, count),
    display_name,
    1,
    count
  )

  table.insert(workspace.terminals, first)

  if count == 1 then
    pcall(vim.cmd, "stopinsert")
    vim.cmd("redrawtabline")
    return
  end

  local first_column = { first.win }

  -- 2 sessions: one column with two rows.
  -- 3-8 sessions: two columns, balanced as evenly as possible.
  local use_two_columns = count >= 3
  local first_column_count = use_two_columns and math.ceil(count / 2) or count
  local current = first.win

  for i = 2, first_column_count do
    vim.api.nvim_set_current_win(current)
    vim.cmd("belowright split")

    local terminal = start_terminal(
      command,
      root,
      string.format("%s %d/%d", display_name, i, count),
      display_name,
      i,
      count
    )

    current = terminal.win
    table.insert(first_column, terminal.win)
    table.insert(workspace.terminals, terminal)
  end

  if use_two_columns then
    local remaining = count - first_column_count

    for i = 1, remaining do
      vim.api.nvim_set_current_win(first_column[i])
      vim.cmd("rightbelow vsplit")

      local session_index = first_column_count + i
      local terminal = start_terminal(
        command,
        root,
        string.format("%s %d/%d", display_name, session_index, count),
        display_name,
        session_index,
        count
      )

      table.insert(workspace.terminals, terminal)
    end
  end

  -- Fill the complete second tab with the AI terminal grid.
  vim.cmd("wincmd =")

  if workspace.terminals[1] and vim.api.nvim_win_is_valid(workspace.terminals[1].win) then
    vim.api.nvim_set_current_win(workspace.terminals[1].win)
  end

  pcall(vim.cmd, "stopinsert")
  vim.cmd("redrawtabline")
end

local function complete_count()
  local values = {}

  for i = 1, MAX_SESSIONS do
    table.insert(values, tostring(i))
  end

  return values
end

local function create_command_alias(alias_name, actual_name)
  vim.cmd(string.format(
    [[cnoreabbrev <expr> %s getcmdtype() ==# ':' && getcmdline() ==# '%s' ? '%s' : '%s']],
    alias_name,
    alias_name,
    actual_name,
    alias_name
  ))
end

local function create_family(command, display_name, command_name)
  vim.api.nvim_create_user_command(command_name, function(opts)
    create_workspace(command, display_name, opts.args ~= "" and opts.args or 1)
  end, {
    nargs = "?",
    complete = complete_count,
    desc = "Open multiple " .. display_name .. " sessions",
  })

  for i = 1, MAX_SESSIONS do
    local session_count = i
    local actual_name = command_name .. session_count
    local alias_name = command_name .. "_" .. session_count

    vim.api.nvim_create_user_command(actual_name, function()
      create_workspace(command, display_name, session_count)
    end, {
      desc = string.format("Open %d %s sessions", session_count, display_name),
    })

    -- User-command names cannot contain underscores, so keep the requested
    -- :Codex_8 / :Claude_8 syntax as a command-line abbreviation.
    create_command_alias(alias_name, actual_name)
  end

  local end_command = command_name .. "End"
  local end_alias = command_name .. "_End"

  vim.api.nvim_create_user_command(end_command, function()
    end_family(display_name)
  end, {
    desc = "Close the dedicated " .. display_name .. " workspace tab",
  })

  create_command_alias(end_alias, end_command)
end

function M.setup()
  create_family("codex", "Codex", "Codex")
  create_family("claude", "Claude", "Claude")
end

return M
