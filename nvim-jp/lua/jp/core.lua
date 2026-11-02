local M = {}
local focus = {}
local function writing_window()
  vim.wo.wrap = true
  vim.wo.linebreak = true
  vim.wo.breakindent = true
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = "no"
  vim.opt_local.textwidth = 0
  vim.opt_local.formatoptions:remove({"t", "a"})
  vim.opt_local.spell = false -- Japanese is not reliably spellchecked by the English spell checker.
end
function M.focus_toggle()
  local id = vim.api.nvim_get_current_win()
  if focus[id] then
    local previous = focus[id]
    for k,v in pairs(previous.window) do vim.wo[id][k] = v end
    vim.o.laststatus = previous.laststatus
    focus[id] = nil
    vim.notify("Focus mode off")
    return
  end
  local old = {}
  for _,k in ipairs({"wrap","linebreak","breakindent","number","relativenumber","signcolumn","cursorline"}) do old[k]=vim.wo[id][k] end
  focus[id] = {window=old,laststatus=vim.o.laststatus}
  writing_window()
  vim.wo.cursorline=false
  vim.o.laststatus=0
  vim.notify("Focus mode on - :JPFocus to restore")
end
function M.setup()
  vim.o.encoding="utf-8"
  vim.opt_global.fileencoding="utf-8"
  vim.o.termguicolors=true
  vim.o.mouse="a"
  vim.o.clipboard="unnamedplus"
  vim.o.updatetime=300
  vim.o.scrolloff=5
  vim.o.undofile=true
  vim.o.swapfile=true
  vim.o.number=false
  vim.o.relativenumber=false
  vim.o.wrap=true
  vim.o.linebreak=true
  vim.o.breakindent=true
  vim.o.showmode=true
  vim.o.laststatus=2
  vim.o.textwidth=0
  vim.o.conceallevel=0
  vim.cmd.colorscheme("habamax")
  vim.o.statusline=" %{mode()}  %{expand('%:t') == '' ? '[Japanese Writing]' : expand('%:t')} %= %y %l:%c "
  vim.api.nvim_create_autocmd("FileType", {pattern="markdown",callback=writing_window})
  vim.api.nvim_create_autocmd("WinClosed",{callback=function(e) focus[tonumber(e.match)] = nil end})
  vim.keymap.set("n", "<leader>jf", M.focus_toggle, {desc="Japanese: focus mode"})
end
return M
