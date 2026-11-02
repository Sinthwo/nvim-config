-- Per-day quiz counters. Stored in NVIM_APPNAME's private data directory,
-- NOT in Obsidian and NOT in Anki scheduling data.
local M = {}
local function filename()
  return vim.fn.stdpath('data') .. '/jp-study-log.json'
end
local function empty() return { schema = 1, days = {} } end
local function load()
  local f = filename()
  if vim.fn.filereadable(f) ~= 1 then return empty() end
  local ok, data = pcall(vim.fn.json_decode, table.concat(vim.fn.readfile(f), '\n'))
  if not ok or type(data) ~= 'table' or type(data.days) ~= 'table' then
    vim.notify('Study log could not be read; original log left unchanged', vim.log.levels.ERROR)
    return nil
  end
  return data
end
local function save(data)
  local target = filename()
  vim.fn.mkdir(vim.fn.fnamemodify(target, ':h'), 'p')
  local tmp = target .. '.tmp'
  local ok, err = pcall(vim.fn.writefile, {vim.fn.json_encode(data)}, tmp)
  if not ok then return false, tostring(err) end
  -- Windows cannot reliably rename over an existing destination. Move the
  -- previous file aside first, restore it if publishing the new file fails.
  local previous = target .. '.bak'
  local had_previous = vim.fn.filereadable(target) == 1
  if had_previous then
    if vim.fn.filereadable(previous) == 1 then vim.fn.delete(previous) end
    if vim.fn.rename(target, previous) ~= 0 then
      return false, 'Could not back up study log. Temporary file: ' .. tmp
    end
  end
  if vim.fn.rename(tmp, target) ~= 0 then
    if had_previous then vim.fn.rename(previous, target) end
    return false, 'Could not publish study log. Temporary file: ' .. tmp
  end
  return true
end
function M.today() return os.date('%Y-%m-%d') end
function M.get(date)
  local data = load()
  if not data then return {} end
  return data.days[date or M.today()] or {}
end
function M.record(metric, amount)
  local allowed = { kana_seen=true, kana_correct=true, vocab_seen=true, vocab_recalled=true, kanji_seen=true, kanji_recalled=true }
  if not allowed[metric] then return false end
  local data = load()
  if not data then return false end
  local day = M.today()
  data.days[day] = data.days[day] or {}
  data.days[day][metric] = (tonumber(data.days[day][metric]) or 0) + (amount or 1)
  local ok, err = save(data)
  if not ok then vim.notify(err, vim.log.levels.ERROR) end
  return ok
end
return M
