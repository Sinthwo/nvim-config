-- Built-in, offline reference charts; no modification of the user's Obsidian vault.
local M={}
local log=require('jp.study_log')
local kanji=require('jp.kanji_data')
local function show(file)
  local path=vim.fn.stdpath('config')..'/references/'..file
  if vim.fn.filereadable(path)~=1 then
    return vim.notify('Reference file missing: '..path,vim.log.levels.ERROR)
  end
  if vim.bo.modified then
    return vim.notify('Save or discard your unsaved changes before opening a reference',vim.log.levels.WARN)
  end
  vim.cmd('tabedit '..vim.fn.fnameescape(path))
  vim.bo.readonly=true
  vim.bo.modifiable=false
  vim.notify('Reference chart (read-only). Press / to search, :tabclose to return.')
end
function M.kana() show('kana-chart.md') end
function M.kanji() show('kanji-grade1.md') end
function M.search(query)
  local function go(term)
    if not term or term=='' then return end
    local results={}
    for _,record in ipairs(kanji) do
      for _,field in ipairs(record) do
        if field:lower():find(term:lower(),1,true) then
          results[#results+1]=record;break
        end
      end
    end
    if #results==0 then return vim.notify('No Grade 1 Kanji matching '..term) end
    vim.ui.select(results,{prompt='Grade 1 Kanji: '..term,
      format_item=function(r) return r[1]..' ['..r[2]..'] — '..r[3] end},
      function(r)
        if r then
          vim.notify(r[1]..' — '..r[2]..' — '..r[3]..' (one example reading)')
        end
      end)
  end
  if query and query~='' then go(query)
  else vim.ui.input({prompt='Search Kanji, reading or English meaning: '},go) end
end
function M.quiz()
  vim.ui.select({'Kanji → English meaning','English meaning → Kanji','Kanji → sample reading'},
    {prompt='Grade 1 Kanji recall'},function(mode)
      if not mode then return end
      local pool={}
      for i=1,#kanji do pool[i]=kanji[i] end
      for i=#pool,2,-1 do local j=math.random(i);pool[i],pool[j]=pool[j],pool[i] end
      local n=math.min(10,#pool);local i=1
      local function step()
        if i>n then return vim.notify('Finished '..n..' Grade 1 Kanji prompts.') end
        local record=pool[i]
        local prompt=mode=='English meaning → Kanji' and record[3] or record[1]
        local answer=mode=='English meaning → Kanji' and record[1]
          or (mode=='Kanji → sample reading' and record[2] or record[3])
        vim.ui.input({prompt='['..i..'/'..n..'] '..prompt..' > '},function(typed)
          if typed==nil then return end
          log.record('kanji_seen')
          vim.ui.select({'I recalled it','Need more practice','Stop'},
            {prompt='Your answer: '..typed..' | Reference: '..answer..' (other readings may exist)'},
            function(choice)
              if choice==nil or choice=='Stop' then return end
              if choice=='I recalled it' then log.record('kanji_recalled') end
              i=i+1;vim.schedule(step)
            end)
        end)
      end
      step()
    end)
end
return M
