-- Markdown-backed vocabulary library: notes in the confirmed Obsidian vault
-- are the ONLY source of truth. No competing SQLite/Anki DB or background sync.
local M = {}
local paths = require('jp.paths')
local settings = require('jp.settings')
local log = require('jp.study_log')
local romaji = require('jp.romaji')
local function notice(text, level)
  vim.notify(text, level or vim.log.levels.INFO, {title='Japanese Vocabulary'})
end
local function trim(s) return tostring(s or ''):match('^%s*(.-)%s*$') end
local function stamp() return os.date('%Y-%m-%d') end
local function input(prompt, cb, default)
  vim.ui.input({prompt=prompt, default=default or ''}, function(s)
    if s ~= nil then cb(trim(s)) end
  end)
end
local function parse(text)
  -- Small, predictable subset of YAML and existing v1 Vocabulary templates.
  -- Never execute YAML, never attempt to infer readings/definitions.
  local rec = { word='', reading='', meaning='', word_type='', study_status='new',
                example='', example_reading='', example_romaji='', example_meaning='', romaji='', source='', anki_status='not_sent', tags='' }
  local frontmatter = text:match('^%-%-%-\r?\n(.-)\r?\n%-%-%-') or ''
  for line in (frontmatter .. '\n'):gmatch('(.-)\r?\n') do
    local key, val = line:match('^([%a_]+):%s*(.-)%s*$')
    if key and val and (key == 'study_status' or key == 'anki_status' or key == 'tags') then
      rec[key] = trim(val):gsub('^"(.-)"$', '%1')
    end
  end
  for line in (text .. '\n'):gmatch('(.-)\r?\n') do
    local key, val = line:match('^([%w ]+):%s*(.-)%s*$')
    if key and val then
      local field = ({ Word='word', Reading='reading', Meaning='meaning', ['Word type']='word_type',
                       Example='example', ['Example reading']='example_reading',
                       ['Example romaji']='example_romaji', ['Example meaning']='example_meaning',
                       Romaji='romaji', Source='source' })[key]
      if field then rec[field] = trim(val) end
    end
  end
  if rec.word == '' then rec.word = trim(text:match('\n# ([^\r\n]+)') or '') end
  return rec
end
M.parse = parse
local function root_dir()
  local root = settings.require_root()
  if not root then return nil end
  return paths.join(root, 'Vocabulary')
end
function M.all()
  local dir = root_dir()
  if not dir then return nil end
  if vim.fn.isdirectory(dir) ~= 1 then return {} end
  local list = {}
  for _, file in ipairs(vim.fn.globpath(dir, '*.md', false, true)) do
    local data = paths.read(file)
    if data then
      local item = parse(data)
      item.path = file
      if item.word ~= '' then list[#list+1] = item end
    end
  end
  table.sort(list, function(a,b) return a.word < b.word end)
  return list
end
local function choose(items, prompt, callback)
  if #items == 0 then notice('No vocabulary entries yet. Use :JPVocabAdd', vim.log.levels.WARN); return end
  vim.ui.select(items, {prompt=prompt, format_item=function(x)
    return x.word .. '  ' .. (x.reading ~= '' and ('['..x.reading..'] ') or '')
      .. (x.meaning ~= '' and ('— '..x.meaning) or '[meaning missing]')
      .. '  {' .. x.study_status .. '}'
  end}, callback)
end
function M.library()
  local list = M.all()
  if not list then return end
  choose(list, 'Vocabulary library ('..#list..' notes)', function(item)
    if item then paths.open(item.path) end
  end)
end
function M.search(query)
  local function go(q)
    if q == '' then return end
    local list = M.all()
    if not list then return end
    local results = {}
    for _, r in ipairs(list) do
      -- Ignore the generic tags applied to every vocabulary note;
      -- custom tags remain searchable.
      local custom_tags = r.tags:lower():gsub('[%[%],]', ' ')
        :gsub('%f[%a]japanese%f[%A]', ''):gsub('%f[%a]vocabulary%f[%A]', '')
      local fields = {r.word, r.reading, r.romaji, r.meaning, r.example, r.example_reading, r.example_romaji, r.example_meaning, r.word_type, r.study_status, custom_tags}
      for _, field in ipairs(fields) do
        if field:lower():find(q:lower(),1,true) then
          results[#results+1] = r; break
        end
      end
    end
    choose(results, 'Results for: '..q, function(item) if item then paths.open(item.path) end end)
  end
  if query and query ~= '' then go(query) else input('Search word, reading, meaning, tag: ', go) end
end
local function safe_line(s)
  -- Keep YAML scalar or Markdown field safely on one line; no arbitrary frontmatter injection.
  return trim(s):gsub('[\r\n]', ' ')
end
local function render_note(word, reading, meaning, kind, example, source, details)
  details=details or {}
  local word_romaji=details.romaji or romaji.convert(reading)
  local example_reading=details.example_reading or ''
  local example_romaji=details.example_romaji or romaji.convert(example_reading)
  local example_meaning=details.example_meaning or ''
  return {
    '---', 'type: vocabulary', 'date: '..stamp(),
    'tags: [japanese, vocabulary]', 'study_status: new', 'last_practised: ',
    'anki_status: not_sent', '---', '# '..safe_line(word), '',
    'Word: '..safe_line(word), 'Reading: '..safe_line(reading),
    'Romaji: '..safe_line(word_romaji), 'Meaning: '..safe_line(meaning), 'Word type: '..safe_line(kind),
    'Example: '..safe_line(example),
    'Example reading: '..safe_line(example_reading),
    'Example romaji: '..safe_line(example_romaji),
    'Example meaning: '..safe_line(example_meaning),
    'Source: '..safe_line(source), '',
    '## My own sentence', '<!-- JP:WRITING:BEGIN -->', '', '<!-- JP:WRITING:END -->', '',
    'Romaji of my sentence: ', 'Meaning of my sentence: ', '',
    '## Grammar notes', '', '## Anki status', 'not_sent — review manually before sending.', ''
  }
end
local function note(word, reading, meaning, kind, example, source, details)
  local dir = root_dir()
  if not dir then return end
  local filename = paths.safe_filename(word)
  if not filename then return notice('Invalid word/filename', vim.log.levels.ERROR) end
  local filepath = paths.join(dir, filename .. '.md')
  if vim.fn.filereadable(filepath) == 1 then
    notice('Already exists; opening original without replacing: '..word)
    paths.open(filepath)
    return
  end
  local text = table.concat(render_note(word, reading, meaning, kind, example, source, details), '\n')
  vim.ui.select({'Cancel', 'Create ONE vocabulary note'},
    {prompt=word..' ['..reading..'] = '..meaning}, function(choice)
      if choice == 'Create ONE vocabulary note' then
        paths.new(filepath, text)
      end
    end)
end
function M.add()
  if not settings.require_root() then return end
  input('Japanese word (required): ', function(word)
    if word == '' then return end
    input('Reading / よみ (verified by you): ', function(reading)
      input('Meaning (required): ', function(meaning)
        if meaning == '' then return notice('Meaning required; nothing created', vim.log.levels.WARN) end
        input('Word type (optional, e.g. noun): ', function(kind)
          input('Example sentence (optional): ', function(example)
            local function finish(details)
              input('Source (optional): ', function(source)
                note(word, reading, meaning, kind, example, source, details)
              end)
            end
            if example == '' then
              finish({})
            else
              input('Example reading in Hiragana (optional; needed for automatic Romaji): ', function(example_reading)
                input('Example meaning in English (optional): ', function(example_meaning)
                  local suggestion=romaji.convert(example_reading)
                  input('Example Romaji (check/edit; optional): ', function(example_romaji)
                    finish({example_reading=example_reading, example_meaning=example_meaning,
                      example_romaji=example_romaji})
                  end, suggestion)
                end)
              end)
            end
          end)
        end)
      end)
    end)
  end)
end

-- Enrich an existing vocabulary note without overwriting existing fields.
-- Operates ONLY on the current Neovim buffer; the user must review and :w.
function M.details()
  local list=M.all()
  if not list then return end
  choose(list,'Choose existing word for pronunciation and example meanings',function(item)
    if not item or not paths.open(item.path) then return end
    local buffer=vim.api.nvim_get_current_buf()
    local original=vim.api.nvim_buf_get_lines(buffer,0,-1,false)
    local function existing(key)
      for _,line in ipairs(original) do
        local val=line:match('^'..key..':%s*(.*)$')
        if val~=nil then return val end
      end
      return ''
    end
    local reading=existing('Reading')
    local example=existing('Example')
    input('Romaji for word (edit if needed): ',function(word_roman)
      if example=='' then
        return M._insert_details(buffer,word_roman,'','','')
      end
      input('Reading of example sentence in Kana: ',function(ex_reading)
        input('English meaning of example sentence: ',function(ex_meaning)
          input('Romaji for example (edit if needed): ',function(ex_roman)
            M._insert_details(buffer,word_roman,ex_reading,ex_roman,ex_meaning)
          end,romaji.convert(ex_reading))
        end,existing('Example meaning'))
      end,existing('Example reading'))
    end,existing('Romaji')~='' and existing('Romaji') or romaji.convert(reading))
  end)
end
function M._insert_details(buffer,word_roman,ex_reading,ex_roman,ex_meaning)
  if not vim.api.nvim_buf_is_valid(buffer) then return end
  local lines=vim.api.nvim_buf_get_lines(buffer,0,-1,false)
  local entries={
    {after='Reading',key='Romaji',value=word_roman},
    {after='Example',key='Example reading',value=ex_reading},
    {after='Example reading',key='Example romaji',value=ex_roman},
    {after='Example romaji',key='Example meaning',value=ex_meaning},
  }
  local by_key={}
  for i,line in ipairs(lines) do
    local k=line:match('^([%w ]+):')
    if k then by_key[k]=i end
  end
  local changed=false
  -- Existing populated fields are never replaced; empty placeholders may be filled.
  for _,entry in ipairs(entries) do
    local index=by_key[entry.key]
    local value=safe_line(entry.value)
    if value~='' then
      if index and lines[index]:match('^.-:%s*$') then
        lines[index]=entry.key..': '..value;changed=true
      elseif not index then
        local anchor=by_key[entry.after]
        if not anchor and entry.key:match('^Example') then
          anchor=by_key['Example romaji'] or by_key['Example reading'] or by_key['Example']
        end
        if anchor then
          table.insert(lines,anchor+1,entry.key..': '..value)
          changed=true
        end
      end
    end
    by_key={}
    for i,line in ipairs(lines) do
      local k=line:match('^([%w ]+):')
      if k then by_key[k]=i end
    end
  end
  if not by_key['Romaji of my sentence'] then
    -- Place user translation AFTER writing markers, never inside writing stats.
    local end_marker
    for i,line in ipairs(lines) do if line:find('JP:WRITING:END',1,true) then end_marker=i end end
    if end_marker then
      table.insert(lines,end_marker+1,'')
      table.insert(lines,end_marker+2,'Romaji of my sentence: ')
      if not by_key['Meaning of my sentence'] then
        table.insert(lines,end_marker+3,'Meaning of my sentence: ')
      end
      changed=true
    end
  elseif not by_key['Meaning of my sentence'] then
    for j,line in ipairs(lines) do
      if line:match('^Romaji of my sentence:') then
        table.insert(lines,j+1,'Meaning of my sentence: ')
        changed=true;break
      end
    end
  end
  if changed then
    vim.api.nvim_buf_set_lines(buffer,0,-1,false,lines)
    notice('Added missing details in buffer. Review and use :w to save, or u to undo.')
  else
    notice('No missing/empty fields to update. Existing content preserved.')
  end
end

local function show_summary()
  local list=M.all()
  if not list then return nil end
  local stats={total=#list,new=0,learning=0,known=0,incomplete=0,anki_not_sent=0}
  for _,r in ipairs(list) do
    local status=(r.study_status or 'new'):lower()
    if stats[status] ~= nil then stats[status]=stats[status]+1 end
    if r.meaning=='' or r.reading=='' then stats.incomplete=stats.incomplete+1 end
    if r.anki_status=='not_sent' then stats.anki_not_sent=stats.anki_not_sent+1 end
  end
  return stats
end
M.stats=show_summary
function M.report()
  local s=show_summary()
  if not s then return end
  local lines={
    'Japanese Vocabulary Database', '',
    'Source: Obsidian / Japanese / Vocabulary/*.md (editable Markdown)', '',
    'Total words: '..s.total, 'New: '..s.new, 'Learning: '..s.learning,
    'Known: '..s.known, 'Missing reading or meaning: '..s.incomplete,
    'Anki status not_sent: '..s.anki_not_sent, '',
    'Commands: :JPVocabAdd :JPVocabLibrary :JPVocabSearch :JPVocabQuiz',
    '          :JPVocabMark :JPVocabExport', '',
    'Vocabulary statuses are manual; this does not reschedule Anki cards.',
  }
  vim.cmd('botright new')
  local buf=vim.api.nvim_get_current_buf()
  vim.bo[buf].buftype='nofile'
  vim.bo[buf].bufhidden='wipe'
  vim.api.nvim_buf_set_lines(buf,0,-1,false,lines)
  vim.bo[buf].modifiable=false
  vim.keymap.set('n','q','<cmd>close<CR>',{buffer=buf})
end
-- Update only the current note buffer. User explicitly saves with :w, preserving
-- original fileformat/encoding and undo history; never silently rewrites a note.
function M.mark()
  local list=M.all()
  if not list then return end
  choose(list, 'Select word to update', function(item)
    if not item then return end
    vim.ui.select({'Cancel', 'new', 'learning', 'known'},
      {prompt='Study status for '..item.word}, function(status)
        if not status or status == 'Cancel' then return end
        if not paths.open(item.path) then return end
        local buf=vim.api.nvim_get_current_buf()
        local lines=vim.api.nvim_buf_get_lines(buf,0,-1,false)
        if lines[1]~='---' then
          return notice('Missing YAML frontmatter. Please update note manually.',vim.log.levels.WARN)
        end
        local boundary=nil
        for i=2,#lines do if lines[i]=='---' then boundary=i;break end end
        if not boundary then
          return notice('Incomplete YAML frontmatter; no change',vim.log.levels.WARN)
        end
        local state_pos=nil
        local date_pos=nil
        for i=2,boundary-1 do
          if lines[i]:match('^study_status:%s*') then state_pos=i end
          if lines[i]:match('^last_practised:%s*') then date_pos=i end
        end
        if state_pos then lines[state_pos]='study_status: '..status end
        if date_pos then lines[date_pos]='last_practised: '..stamp() end
        if not state_pos then table.insert(lines,boundary,'study_status: '..status);boundary=boundary+1 end
        if not date_pos then table.insert(lines,boundary,'last_practised: '..stamp()) end
        vim.api.nvim_buf_set_lines(buf,0,-1,false,lines)
        notice('Study status set to '..status..' in buffer. Review changes, then :w to save (u to undo).')
      end)
  end)
end
local function quiz_list()
  local records=M.all()
  if not records then return nil end
  local valid={}
  for _,r in ipairs(records) do
    if r.word~='' and r.meaning~='' then valid[#valid+1]=r end
  end
  return valid
end
function M.quiz()
  local valid=quiz_list()
  if not valid then return end
  if #valid==0 then return notice('Add vocabulary notes with Word and Meaning first.',vim.log.levels.WARN) end
  vim.ui.select({'Japanese → Meaning','Meaning → Japanese','Japanese → Reading'},
    {prompt='Vocabulary recall direction'}, function(mode)
      if not mode then return end
      local pool={}
      for _,r in ipairs(valid) do
        if mode~='Japanese → Reading' or r.reading~='' then pool[#pool+1]=r end
      end
      if #pool==0 then return notice('No entries with a reading',vim.log.levels.WARN) end
      -- Fisher-Yates random shuffle. Quiz operates on a copy; source data never changes.
      for i=#pool,2,-1 do local j=math.random(i); pool[i],pool[j]=pool[j],pool[i] end
      local count=math.min(10,#pool)
      local idx=1
      local function step()
        if idx>count then notice('Finished '..count..' vocabulary prompts. No Anki state changed.'); return end
        local r=pool[idx]
        local question=(mode=='Meaning → Japanese') and r.meaning or r.word
        local answer=(mode=='Japanese → Meaning') and r.meaning
          or (mode=='Meaning → Japanese' and r.word or r.reading)
        input('['..idx..'/'..count..'] '..question..' > ', function(typed)
          log.record('vocab_seen')
          -- Not exact-match graded: translations can have multiple acceptable answers.
          vim.ui.select({'I recalled it correctly','I need more practice','Stop'},
            {prompt='Your answer: '..typed..' | Reference: '..answer}, function(choice)
              if not choice or choice=='Stop' then return end
              if choice=='I recalled it correctly' then log.record('vocab_recalled') end
              idx=idx+1; vim.schedule(step)
            end)
        end)
      end
      step()
    end)
end
local function tsv(v)
  local clean=tostring(v or ''):gsub('[\t\r\n]',' ')
  -- Prevent spreadsheet formula evaluation on opening exported TSV.
  if clean:match('^%s*[=+@%-]') then clean="'"..clean end
  return clean
end
function M.export()
  local records=M.all()
  if not records then return end
  if #records==0 then return notice('Nothing to export',vim.log.levels.WARN) end
  local root=settings.require_root()
  if not root then return end
  local name='vocabulary-'..os.date('%Y%m%d-%H%M%S')..'.tsv'
  local dest=paths.join(root,'Exports',name)
  local lines={'Word\tReading\tMeaning\tWord type\tExample\tStudy status\tSource\tRomaji\tExample reading\tExample romaji\tExample meaning'}
  for _,r in ipairs(records) do
    lines[#lines+1]=table.concat({tsv(r.word),tsv(r.reading),tsv(r.meaning),tsv(r.word_type),
      tsv(r.example),tsv(r.study_status),tsv(r.source),tsv(r.romaji),
      tsv(r.example_reading),tsv(r.example_romaji),tsv(r.example_meaning)},'\t')
  end
  vim.ui.select({'Cancel','Export '..#records..' words as TSV'},
    {prompt=dest}, function(choice)
      if not choice or choice=='Cancel' then return end
      if vim.fn.filereadable(dest)==1 then return notice('Export already exists; not overwritten',vim.log.levels.WARN) end
      vim.fn.mkdir(vim.fn.fnamemodify(dest,':h'),'p')
      local ok, err=pcall(vim.fn.writefile,lines,dest)
      if not ok then return notice('Export failed: '..tostring(err),vim.log.levels.ERROR) end
      notice('Exported '..#records..' words: '..dest)
    end)
end
-- Import a user-provided UTF-8 TSV file (Word, Reading, Meaning; optional
-- Word type / Example / Source). Preview the operation, create *only* missing
-- files, and never alter the original TSV or existing Obsidian notes.
function M.import()
  local dir=root_dir()
  if not dir then return end
  input('Full path to UTF-8 TSV file: ',function(filepath)
    filepath=filepath:gsub('^"(.-)"$','%1')
    if vim.fn.filereadable(filepath)~=1 then
      return notice('TSV file does not exist',vim.log.levels.ERROR)
    end
    local source_lines=vim.fn.readfile(filepath)
    if #source_lines<2 then return notice('TSV needs header + one data row',vim.log.levels.WARN) end
    local header=vim.split(source_lines[1]:gsub('^\239\187\191',''),'\t',{plain=true})
    local header_idx={}
    for i,col in ipairs(header) do
      header[i]=trim(col):lower()
      header_idx[header[i]]=i
    end
    if not header_idx.word or not header_idx.reading or not header_idx.meaning then
      return notice('Expected TSV header: Word<TAB>Reading<TAB>Meaning',vim.log.levels.ERROR)
    end
    local records={}
    local skipped=0
    local names={}
    for row=2,#source_lines do
      if #records>=250 then
        return notice('Import limit: at most 250 nonempty rows per file. Split the TSV.',vim.log.levels.WARN)
      end
      local cols=vim.split(source_lines[row],'\t',{plain=true})
      local function field(key) return trim(cols[header_idx[key]]) end
      local word=field('word');local reading=field('reading');local meaning=field('meaning')
      local safe=paths.safe_filename(word)
      if not safe or meaning=='' then skipped=skipped+1
      else
        local path=paths.join(dir,safe..'.md')
        if names[path] or vim.fn.filereadable(path)==1 then skipped=skipped+1
        else
          names[path]=true
          records[#records+1]={path=path,word=word,reading=reading,meaning=meaning,
            word_type=field('word type'),example=field('example'),source=field('source'),
            romaji=field('romaji'), example_reading=field('example reading'),
            example_romaji=field('example romaji'),example_meaning=field('example meaning')}
        end
      end
    end
    if #records==0 then return notice('No new entries to import. '..skipped..' rows skipped.') end
    local summary='CREATE '..#records..' notes; skip '..skipped..' invalid/existing/duplicate rows. First: '
      ..records[1].word..' = '..records[1].meaning
    vim.ui.select({'Cancel','Confirm TSV import ('..#records..' new notes)'},
      {prompt=summary},function(choice)
        if choice~='Confirm TSV import ('..#records..' new notes)' then return end
        vim.fn.mkdir(dir,'p')
        local created,failed=0,0
        for _,r in ipairs(records) do
          if vim.fn.filereadable(r.path)~=1 then
            local lines=render_note(r.word,r.reading,r.meaning,r.word_type,r.example,
              r.source~='' and r.source or 'Personal TSV import',
              {romaji=(r.romaji~='' and r.romaji or nil),
               example_reading=r.example_reading, example_romaji=r.example_romaji,
               example_meaning=r.example_meaning})
            local ok=pcall(vim.fn.writefile,lines,r.path)
            if ok then created=created+1 else failed=failed+1 end
          else skipped=skipped+1 end
        end
        notice('Imported '..created..' word notes; '..skipped..' skipped, '..failed..' failed.')
      end)
  end)
end
return M
