-- Commands for supplying precise code context to an external AI agent.
-- Does not alter existing Codex/Claude workspaces or any mappings.
local M = {}

local function path_with_line()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    vim.notify("Save the file before copying its path", vim.log.levels.WARN)
    return nil
  end
  local path = vim.fn.fnamemodify(name, ":.")
  return path .. "#L" .. vim.api.nvim_win_get_cursor(0)[1], path
end

local function copy(value)
  -- Clipboard integration is configured elsewhere; never change those options here.
  vim.fn.setreg('"', value)
  local ok = pcall(vim.fn.setreg, "+", value)
  vim.notify(ok and "AI context copied to clipboard" or "AI context copied to unnamed register", vim.log.levels.INFO)
end

function M.setup()
  vim.api.nvim_create_user_command("AICopyPath", function()
    local loc = path_with_line()
    if loc then copy(loc) end
  end, { desc = "Copy relative file path and current line for AI agents" })

  vim.api.nvim_create_user_command("AICopyContext", function(args)
    local location, filename = path_with_line()
    if not location then return end
    local bufnr = vim.api.nvim_get_current_buf()
    local start_line = args.range > 0 and args.line1 or vim.api.nvim_win_get_cursor(0)[1]
    local end_line = args.range > 0 and args.line2 or start_line
    local selected = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)
    local ft = vim.bo[bufnr].filetype
    local fence = "```"
    -- Use a longer fence if the source code already contains triple backticks.
    for _, line in ipairs(selected) do
      local ticks = line:match("^%s*(`+)")
      if ticks and #ticks >= #fence then fence = string.rep("`", #ticks + 1) end
    end
    local content = string.format("%s#L%d-L%d\n%s%s\n%s\n%s", filename, start_line, end_line, fence, ft, table.concat(selected, "\n"), fence)
    copy(content)
  end, { range = true, desc = "Copy code with file path and line range for AI agents" })
end

return M
