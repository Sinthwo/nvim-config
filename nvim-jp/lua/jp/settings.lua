local M = {}
local path = vim.fn.stdpath("config") .. "/jp-settings.json"
local defaults = { vault = "", japanese_root = "", anki = { enabled = false, deck = "", model = "", front_field = "", back_field = "" } }
local function notify(message, level) vim.notify(message, level or vim.log.levels.INFO, { title = "Japanese Profile" }) end
function M.path() return path end
function M.load()
  if vim.fn.filereadable(path) ~= 1 then return vim.deepcopy(defaults) end
  local ok, result = pcall(vim.fn.json_decode, table.concat(vim.fn.readfile(path), "\n"))
  if not ok or type(result) ~= "table" then
    notify("Invalid jp-settings.json. Keeping defaults; existing file untouched.", vim.log.levels.ERROR)
    return vim.deepcopy(defaults)
  end
  return vim.tbl_deep_extend("force", vim.deepcopy(defaults), result)
end
function M.save(settings)
  -- Guard against writing anything outside our separate profile.
  local encoded = vim.fn.json_encode(settings)
  local ok, err = pcall(vim.fn.writefile, vim.split(encoded, "\n", {plain=true}), path)
  if not ok then notify("Cannot save settings: " .. tostring(err), vim.log.levels.ERROR); return false end
  return true
end
function M.root()
  local s = M.load()
  local paths=require("jp.paths")
  if s.vault~="" and s.japanese_root~="" and vim.fn.isdirectory(s.vault)==1
    and vim.fn.isdirectory(s.vault.."/.obsidian")==1
    and vim.fn.isdirectory(s.japanese_root)==1
    and paths.inside(s.japanese_root,s.vault) then return s.japanese_root end
  return nil
end
function M.require_root()
  local root = M.root()
  if not root then notify("Configure a verified Obsidian vault first with :JPSetup", vim.log.levels.WARN) end
  return root
end
return M
