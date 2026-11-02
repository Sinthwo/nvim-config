local M={}
local settings=require("jp.settings")
local p=require("jp.paths")
local function utf8points(s)
  local i=1
  return function()
    if i>#s then return nil end
    local a=s:byte(i)
    local n,cp=1,a
    if a>=0xF0 and a<=0xF4 then n=4;cp=a%8
    elseif a>=0xE0 and a<=0xEF then n=3;cp=a%16
    elseif a>=0xC2 and a<=0xDF then n=2;cp=a%32 end
    for j=1,n-1 do
      local b=s:byte(i+j)
      if not b or b<0x80 or b>=0xC0 then n=1;cp=a;break end
      cp=cp*64+(b%64)
    end
    i=i+n
    return cp
  end
end
function M.count(s)
  local h,k,kan=0,0,0
  for cp in utf8points(s) do
    if cp>=0x3040 and cp<=0x309F then h=h+1
    elseif cp>=0x30A0 and cp<=0x30FF then k=k+1
    elseif (cp>=0x3400 and cp<=0x4DBF) or (cp>=0x4E00 and cp<=0x9FFF) then kan=kan+1 end
  end
  return {hiragana=h,katakana=k,kanji=kan}
end
function M.answer_blocks(text)
  local chunks={}
  for _,name in ipairs({"WRITING","ANSWER"}) do
    local start="<!-- JP:"..name..":BEGIN -->"
    local stop="<!-- JP:"..name..":END -->"
    local from=1
    while true do
      local a,b=text:find(start,from,true)
      if not a then break end
      local c,d=text:find(stop,b+1,true)
      if not c then break end
      table.insert(chunks,text:sub(b+1,c-1))
      from=d+1
    end
  end
  return table.concat(chunks,"\n")
end
local function unique_dates(records)
  local dates={}
  for d in pairs(records) do table.insert(dates,d) end
  table.sort(dates)
  return dates
end
function M.calculate(root)
  local report={sessions=0,days=0,hiragana=0,katakana=0,kanji=0,completed_exercises=0,streak=0,notes=0}
  local writing_dates={}
  for _,file in ipairs(vim.fn.globpath(root,"**/*.md",false,true)) do
    if not file:match("[/\\]Templates[/\\]") then
      local text=p.read(file)
      if text then
        report.notes=report.notes+1
        local content=M.answer_blocks(text)
        local counts=M.count(content)
        local has_japanese=counts.hiragana+counts.katakana+counts.kanji>0
        if has_japanese then
          report.sessions=report.sessions+1
          local date=text:match("\ndate:%s*(%d%d%d%d%-%d%d%-%d%d)") or file:match("(%d%d%d%d%-%d%d%-%d%d)")
          if date then writing_dates[date]=true end
          report.hiragana=report.hiragana+counts.hiragana
          report.katakana=report.katakana+counts.katakana
          report.kanji=report.kanji+counts.kanji
          if text:match("\nstatus:%s*completed") and text:match("\ntype:%s*exercise") then report.completed_exercises=report.completed_exercises+1 end
        end
      end
    end
  end
  local dates=unique_dates(writing_dates)
  report.days=#dates
  local current=os.time()
  local i=0
  while true do
    local date=os.date("%Y-%m-%d",current-i*86400)
    if writing_dates[date] then report.streak=report.streak+1
    elseif i==0 then -- An entry yesterday still counts as an active streak.
    else break end
    i=i+1
    if i>36500 then break end
  end
  return report
end
function M.show()
  local root=settings.require_root()
  if not root then return end
  local r=M.calculate(root)
  local lines={
    "Japanese Writing Progress (saved notes only)","",
    "Notes scanned: "..r.notes,
    "Sessions with Japanese in answer/writing blocks: "..r.sessions,
    "Distinct dated writing days: "..r.days,
    "Current streak (days): "..r.streak,
    "Hiragana characters: "..r.hiragana,
    "Katakana characters: "..r.katakana,
    "Han/Kanji characters: "..r.kanji,
    "Completed exercises with Japanese answers: "..r.completed_exercises,
    "", "Cautions:",
    "- Not an accurate Japanese word count.",
    "- Shared Han characters are counted as Kanji heuristically.",
    "- Only text inside JP:ANSWER or JP:WRITING markers is counted.",
    "- Templates, prompts, corrections and unsaved changes are excluded.",
    "- Streak uses valid ISO-dated notes currently retained on disk.",
  }
  vim.cmd("botright new")
  local buf=vim.api.nvim_get_current_buf()
  vim.bo[buf].buftype="nofile"
  vim.bo[buf].bufhidden="wipe"
  vim.api.nvim_buf_set_lines(buf,0,-1,false,lines)
  vim.bo[buf].modifiable=false
  vim.keymap.set("n","q","<cmd>close<CR>",{buffer=buf})
end
return M
