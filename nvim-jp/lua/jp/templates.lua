local M={}
local path=require("jp.paths")
local config=vim.fn.stdpath("config")
local templates= {
  journal="daily-journal.md",
  writing="independent-writing.md",
  intro="self-introduction.md",
  sentence="sentence-construction.md",
  grammar="grammar-practice.md",
  vocabulary="vocabulary.md",
  kanji="kanji-practice.md",
  correction="correction-review.md",
  weekly="weekly-review.md",
}
function M.list() return vim.deepcopy(templates) end
function M.read(kind)
  local file=templates[kind]
  if not file then return nil end
  return path.read(path.join(config,"templates",file))
end
function M.expand(kind,values)
  local text=M.read(kind)
  if not text then return nil end
  for k,v in pairs(values or {}) do text=text:gsub("{{"..k.."}}",function() return tostring(v) end) end
  return text:gsub("{{[%w_]+}}", "")
end
return M
