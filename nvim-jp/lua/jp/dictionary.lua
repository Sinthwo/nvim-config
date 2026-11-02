local M={}
function M.encode(text)
  return (text:gsub("([^A-Za-z0-9%-._~])",function(c) return string.format("%%%02X",string.byte(c)) end))
end
function M.open(url)
  if vim.ui and vim.ui.open then
    local ok,err=vim.ui.open(url)
    if not ok then vim.notify("Could not open browser: "..tostring(err),vim.log.levels.ERROR) end
    return
  end
  -- Windows shell-independent fallback; do not concatenate into cmd /c.
  local result=vim.fn.jobstart({"rundll32.exe","url.dll,FileProtocolHandler",url},{detach=true})
  if result<=0 then vim.notify("Could not open URL. Copy manually: "..url,vim.log.levels.ERROR) end
end
function M.selected()
  local b=0
  local a=vim.fn.getpos("'<")
  local z=vim.fn.getpos("'>")
  if a[2]<1 or z[2]<1 then return nil end
  local from={a[2]-1,math.max(a[3]-1,0)}
  local to={z[2]-1,z[3]}
  local ok,segments=pcall(vim.api.nvim_buf_get_text,b,from[1],from[2],to[1],to[2],{})
  return ok and table.concat(segments,"\n") or nil
end
function M.lookup(text)
  if text and text~="" then
    M.open("https://jisho.org/search/"..M.encode(text))
  else
    vim.ui.input({prompt="Lookup word (JP/EN): "},function(value)
      if value and value~="" then M.lookup(value) end
    end)
  end
end
return M
