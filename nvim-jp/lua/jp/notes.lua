local M={}
local settings=require("jp.settings")
local p=require("jp.paths")
local templates=require("jp.templates")
local function today() return os.date("%Y-%m-%d") end
local function new(kind,subdir,name,extra)
  if vim.bo.modified then return vim.notify("Save or discard current unsaved changes first.",vim.log.levels.WARN) end
  local root=settings.require_root()
  if not root then return end
  local safe=p.safe_filename(name)
  if not safe then vim.notify("Invalid filename",vim.log.levels.ERROR);return end
  local location=p.join(root,subdir,safe..".md")
  local content=templates.expand(kind,vim.tbl_extend("force",{DATE=today(),TITLE=safe,TOPIC="",WEEK=os.date("%Y-W%W")},extra or {}))
  if not content then vim.notify("Template missing: "..kind,vim.log.levels.ERROR);return end
  p.new(location,content)
end
function M.journal() new("journal","Journal",today()) end
function M.writing() vim.ui.input({prompt="Writing title: "},function(title) if title and title~="" then new("writing","Writing",today().." - "..title,{TITLE=title}) end end) end
function M.vocabulary() vim.ui.input({prompt="Japanese word (reading is not guessed): "},function(word) if word and word~="" then new("vocabulary","Vocabulary",word,{WORD=word}) end end) end
function M.grammar() vim.ui.input({prompt="Grammar point: "},function(word) if word and word~="" then new("grammar","Grammar",word,{GRAMMAR=word}) end end) end
function M.kanji() vim.ui.input({prompt="Kanji: "},function(word) if word and word~="" then new("kanji","Kanji",word,{KANJI=word}) end end) end
function M.correction()
  local filename=vim.fn.expand("%:t:r")
  vim.ui.input({prompt="Correction note title: ",default=filename~="" and filename or "review"},function(title)
    if title and title~="" then new("correction","Corrections",today().." - "..title) end
  end)
end
function M.weekly() new("weekly","Reviews",os.date("%Y-W%W")) end
function M.find()
  local root=settings.require_root()
  if not root then return end
  vim.ui.input({prompt="Filename contains: "},function(query)
    if not query or query=="" then return end
    local files=vim.fn.globpath(root,"**/*.md",false,true)
    local items={}
    for _,f in ipairs(files) do
      if f:lower():find(query:lower(),1,true) then table.insert(items,f) end
      if #items>=150 then break end
    end
    vim.ui.select(items,{prompt="Japanese notes"},function(choice) if choice then p.open(choice) end end)
  end)
end
function M.grep()
  local root=settings.require_root()
  if not root then return end
  vim.ui.input({prompt="Find in notes (literal): "},function(query)
    if not query or query=="" then return end
    local hits={}
    for _,filename in ipairs(vim.fn.globpath(root,"**/*.md",false,true)) do
      for i,line in ipairs(vim.fn.readfile(filename)) do
        if line:lower():find(query:lower(),1,true) then
          table.insert(hits,{filename=filename,line=i,text=line})
          if #hits>=120 then break end
        end
      end
      if #hits>=120 then break end
    end
    vim.ui.select(hits,{prompt="Matches",format_item=function(x)
      return vim.fn.fnamemodify(x.filename,":t")..":"..x.line.." "..x.text:sub(1,70)
    end},function(x) if x and p.open(x.filename) then vim.api.nvim_win_set_cursor(0,{x.line,0}) end end)
  end)
end
function M.complete()
  if vim.bo.buftype~="" or vim.fn.expand("%:p")=="" then return vim.notify("Open a saved exercise first",vim.log.levels.WARN) end
  local root=settings.require_root()
  if not root or not p.inside(vim.fn.expand("%:p"),root) then return vim.notify("Not a Japanese note",vim.log.levels.WARN) end
  local lines=vim.api.nvim_buf_get_lines(0,0,-1,false)
  local answer=false
  local contents={}
  for _,line in ipairs(lines) do
    if line:find("<!-- JP:ANSWER:BEGIN -->",1,true) or line:find("<!-- JP:WRITING:BEGIN -->",1,true) then answer=true
    elseif line:find("<!-- JP:ANSWER:END -->",1,true) or line:find("<!-- JP:WRITING:END -->",1,true) then answer=false
    elseif answer then table.insert(contents,line) end
  end
  local c=require("jp.progress").count(table.concat(contents,"\n"))
  if c.hiragana+c.katakana+c.kanji==0 then return vim.notify("Write a Japanese answer before marking complete",vim.log.levels.WARN) end
  local found=false
  for i,line in ipairs(lines) do
    if line:match("^status:%s*") then lines[i]="status: completed";found=true end
    if line:match("^completed_on:%s*") then lines[i]="completed_on: "..os.date("%Y-%m-%d") end
  end
  if not found then return vim.notify("This note has no tracked status field",vim.log.levels.WARN) end
  vim.api.nvim_buf_set_lines(0,0,-1,false,lines)
  vim.notify("Marked completed in buffer. Review and :write to save.")
end
function M.obsidian()
  local s=settings.load()
  local filename=vim.fn.expand("%:p")
  if s.vault=="" or filename=="" or not p.inside(filename,s.vault) then return vim.notify("Open a saved file inside the configured vault",vim.log.levels.WARN) end
  if vim.bo.modified then return vim.notify("Save the note before opening Obsidian",vim.log.levels.WARN) end
  local url="obsidian://open?path="..require("jp.dictionary").encode(filename:gsub("\\","/"))
  require("jp.dictionary").open(url)
end
return M
