local M={}
local function normal(path) return vim.fs.normalize(path) end
function M.join(...) return normal(table.concat({...}, "/")) end
function M.inside(path, root)
  local a=normal(path):gsub("\\", "/"):lower()
  local b=normal(root):gsub("\\", "/"):lower():gsub("/+$", "")
  return a == b or a:sub(1,#b+1) == b.."/"
end
function M.safe_filename(name)
  if name:match("^%.%.[/\\]") or name==".." then return nil end
  local s=name:gsub('[<>:"/\\|?*%c]', "-"):gsub("^%s+",""):gsub("%s+$",""):gsub("[%.%s]+$","")
  if s=="" or s=="." or s==".." then return nil end
  local stem = (s:match("^[^.]+") or s):upper():gsub("%s+$", "")
  local reserved = { CON = true, PRN = true, AUX = true, NUL = true }
  if reserved[stem] or stem:match("^COM[1-9]$") or stem:match("^LPT[1-9]$") then return nil end
  -- Unicode-safe length limit, important for Japanese filenames.
  if vim.fn.strcharpart then return vim.fn.strcharpart(s, 0, 60) end
  return s:sub(1,90) -- only used in pure-Lua mocked tests
end
function M.open(path)
  if vim.bo.modified then
    vim.notify("Save or discard your current unsaved changes before opening another file.",vim.log.levels.WARN)
    return false
  end
  vim.cmd.edit(vim.fn.fnameescape(path))
  return true
end
function M.new(path, contents)
  if vim.fn.filereadable(path)==1 or vim.fn.isdirectory(path)==1 then
    vim.notify("File already exists; opening without replacing: "..path)
    return M.open(path)
  end
  local folder=vim.fn.fnamemodify(path,":h")
  vim.fn.mkdir(folder,"p")
  if vim.fn.filereadable(path)==1 then return M.open(path) end
  local lines=vim.split(contents,"\n",{plain=true})
  if lines[#lines]=="" then table.remove(lines) end
  local ok,err=pcall(vim.fn.writefile,lines,path)
  if not ok then vim.notify(tostring(err),vim.log.levels.ERROR); return false end
  return M.open(path)
end
function M.read(path)
  if vim.fn.filereadable(path)~=1 then return nil end
  return table.concat(vim.fn.readfile(path),"\n")
end
return M
