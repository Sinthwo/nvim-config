local M={}
local p=require("jp.paths")
local settings=require("jp.settings")
local function today() return os.date("%Y-%m-%d") end
local types={
  translation="Translate this English prompt into Japanese.",
  completion="Fill the blank in the Japanese sentence.",
  vocabulary="Write an original sentence using the given vocabulary.",
  grammar="Write a sentence using the specified grammar pattern.",
  free="Write an original Japanese paragraph.",
  kanji="Type the appropriate Kanji from memory; handwriting is not assessed.",
  recall="Reconstruct a previously learned Japanese sentence from memory.",
}
function M.create(stage,kind)
  local root=settings.require_root()
  if not root then return end
  if not types[kind] then return vim.notify("Unknown type: "..tostring(kind),vim.log.levels.ERROR) end
  stage=tonumber(stage)
  if not stage or stage<1 or stage>4 then return vim.notify("Stage must be 1-4",vim.log.levels.ERROR) end
  vim.ui.input({prompt="Exercise topic (used in filename): "},function(topic)
    if not topic or topic=="" then return end
    local safe=p.safe_filename(topic)
    if not safe then return vim.notify("Invalid title",vim.log.levels.WARN) end
    local dst=p.join(root,"Exercises",today().." - "..safe..".md")
    local body=table.concat({
      "---", "type: exercise", "stage: "..stage, "exercise_type: "..kind,
      "date: "..today(), "difficulty: beginner", "status: pending", "completed_on: ", "---", "",
      "# "..topic, "", "## Instructions", types[kind],"",
      "## Prompt", "<!-- Write or paste the prompt here. Do not enter the solution here. -->", "",
      "## My answer", "<!-- JP:ANSWER:BEGIN -->", "", "<!-- JP:ANSWER:END -->", "",
      "## Mistakes", "", "## Review notes", "", "## Reference", "Use :JPRevealAnswer to open the separate reference file. A reference is not an automatic correction.",""
    },"\n")
    p.new(dst,body)
  end)
end
function M.menu()
  local names={"translation","completion","vocabulary","grammar","free","kanji","recall"}
  vim.ui.select(names,{prompt="Exercise type"},function(kind)
    if not kind then return end
    vim.ui.select({"1 - Kana/simple", "2 - Beginner grammar", "3 - Connected sentences", "4 - Paragraphs"},
      {prompt="Stage"},function(selected)
        if selected then M.create(tonumber(selected:sub(1,1)),kind) end
      end)
  end)
end
function M.reveal(stage)
  stage=tonumber(stage) or 1
  if stage<1 or stage>4 then return vim.notify("Stage 1-4",vim.log.levels.WARN) end
  local src=p.join(vim.fn.stdpath("config"),"references",string.format("stage%02d.md",stage))
  vim.cmd("belowright split "..vim.fn.fnameescape(src))
  vim.bo.readonly=true
  vim.bo.modifiable=false
end
return M
