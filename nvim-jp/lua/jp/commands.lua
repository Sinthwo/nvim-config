local M={}
local settings=require("jp.settings")
local notes=require("jp.notes")
local dictionary=require("jp.dictionary")
local exercises=require("jp.exercises")
local progress=require("jp.progress")
local anki=require("jp.anki")
local vocab=require("jp.vocabulary")
local function cmd(name,fn,opts) vim.api.nvim_create_user_command(name,fn,opts or {}) end
local function setup_vault()
  vim.ui.input({prompt="Absolute EXISTING Obsidian vault path: "},function(input)
    if not input or input=="" then return end
    local root=vim.fs.normalize(vim.fn.expand(input))
    if vim.fn.isdirectory(root)~=1 or vim.fn.isdirectory(root.."/.obsidian")~=1 then
      return vim.notify("Not a confirmed Obsidian vault (requires existing .obsidian directory). No files changed.",vim.log.levels.ERROR)
    end
    local candidates={}
    for _,relative in ipairs({"Japanese","Languages/Japanese","Learning/Japanese"}) do
      local f=root.."/"..relative
      if vim.fn.isdirectory(f)==1 then table.insert(candidates,f) end
    end
    local default=root.."/Japanese"
    if #candidates==0 then table.insert(candidates,default) end
    if #candidates>0 and vim.fn.index(candidates,default)<0 then table.insert(candidates,default) end
    vim.ui.select(candidates,{prompt="Select Japanese directory (missing directory created ONLY after confirmation)"},function(choice)
      if not choice then return end
      vim.ui.select({"Cancel","Confirm vault & Japanese folder"},{prompt=choice},function(answer)
        if answer~="Confirm vault & Japanese folder" then return end
        if vim.fn.isdirectory(choice)~=1 then vim.fn.mkdir(choice,"p") end
        local s=settings.load()
        s.vault=root;s.japanese_root=choice
        if settings.save(s) then vim.notify("Configured Japanese notes: "..choice) end
      end)
    end)
  end)
end
local function help()
  local file=vim.fn.stdpath("config").."/JP-HELP.md"
  vim.cmd("tabedit "..vim.fn.fnameescape(file))
end
function M.setup()
  cmd("JP",function() require("jp.dashboard").show() end)
  cmd("JPDashboard",function() require("jp.dashboard").show() end)
  cmd("JPSetup",setup_vault)
  cmd("JPToday",notes.journal)
  cmd("JPWriting",notes.writing)
  cmd("JPVocabulary",notes.vocabulary) -- original blank vocabulary template, preserved
  cmd("JPVocabAdd",vocab.add)
  cmd("JPVocabDetails",vocab.details)
  cmd("JPVocabLibrary",vocab.library)
  cmd("JPVocabSearch",function(o) vocab.search(o.args) end,{nargs="?"})
  cmd("JPVocabQuiz",vocab.quiz)
  cmd("JPVocabMark",vocab.mark)
  cmd("JPVocabStats",vocab.report)
  cmd("JPVocabExport",vocab.export)
  cmd("JPVocabImport",vocab.import)
  cmd("JPKanaQuiz",require("jp.kana").quiz)
  cmd("JPKanaChart",require("jp.reference").kana)
  cmd("JPKanjiList",require("jp.reference").kanji)
  cmd("JPKanjiSearch",function(o) require("jp.reference").search(o.args) end,{nargs="?"})
  cmd("JPKanjiQuiz",require("jp.reference").quiz)
  cmd("JPDaily",require("jp.study_plan").show)
  cmd("JPGrammar",notes.grammar)
  cmd("JPKanji",notes.kanji)
  cmd("JPCorrection",notes.correction)
  cmd("JPWeekly",notes.weekly)
  cmd("JPFind",notes.find)
  cmd("JPSearch",notes.grep)
  cmd("JPObsidianOpen",notes.obsidian)
  cmd("JPComplete",notes.complete)
  cmd("JPExercises",exercises.menu)
  cmd("JPNewExercise",function(o)
    local stage,kind=o.args:match("^(%d+)%s+(%w+)$")
    if not stage then return vim.notify("Usage: :JPNewExercise <stage 1-4> <translation|completion|vocabulary|grammar|free|kanji|recall>",vim.log.levels.WARN) end
    exercises.create(stage,kind)
  end,{nargs="+"})
  cmd("JPRevealAnswer",function(o) exercises.reveal(o.args) end,{nargs="?"})
  cmd("JPDictionary",function(o) dictionary.lookup(o.args) end,{nargs="?"})
  cmd("JPProgress",progress.show)
  cmd("JPAnkiSetup",anki.setup)
  cmd("JPAnki",function() anki.prepare() end)
  cmd("JPAnkiStatus",anki.status)
  cmd("JPFocus",require("jp.core").focus_toggle)
  -- Keep the traditional Japanese commands; add optional Obsidian navigation.
  cmd("JPMarkdownStatus",function() require("jp.plugins").status() end)
  cmd("JPMarkdownParsers",function() require("jp.plugins").setup_parsers() end)
  cmd("JPMarkdownToggle",function()
    local ok, render = pcall(require, "render-markdown")
    if not ok then return vim.notify("Markdown renderer unavailable. Install plugins with :Lazy sync",vim.log.levels.WARN) end
    render.toggle()
  end)
  cmd("JPHelp",help)
  local maps={
    d="<cmd>JPDashboard<CR>",j="<cmd>JPToday<CR>",w="<cmd>JPWriting<CR>",
    e="<cmd>JPExercises<CR>",r="<cmd>JPRevealAnswer<CR>",v="<cmd>JPVocabulary<CR>",
    g="<cmd>JPGrammar<CR>",k="<cmd>JPKanji<CR>",l="<cmd>JPDictionary<CR>",
    a="<cmd>JPAnki<CR>",c="<cmd>JPComplete<CR>",p="<cmd>JPProgress<CR>",
    f="<cmd>JPFocus<CR>",h="<cmd>JPHelp<CR>",o="<cmd>JPSetup<CR>",
    s="<cmd>JPSearch<CR>",n="<cmd>JPFind<CR>",
  }
  -- Extra JP shortcuts; the original ones remain unchanged.
  local extras={
    ["b"]="<cmd>JPVocabLibrary<CR>", ["i"]="<cmd>JPVocabAdd<CR>",
    ["q"]="<cmd>JPVocabQuiz<CR>", ["t"]="<cmd>JPDaily<CR>",
    ["x"]="<cmd>JPKanaQuiz<CR>", ["m"]="<cmd>JPVocabMark<CR>",
    ["z"]="<cmd>JPVocabStats<CR>",
    ["1"]="<cmd>JPKanaChart<CR>", ["2"]="<cmd>JPKanjiList<CR>",
    ["3"]="<cmd>JPKanjiQuiz<CR>", ["4"]="<cmd>JPVocabDetails<CR>",
    ["R"]="<cmd>JPMarkdownToggle<CR>",
  }
  for key,rhs in pairs(extras) do maps[key]=rhs end
  for key,rhs in pairs(maps) do vim.keymap.set("n","<leader>j"..key,rhs,{desc="Japanese: "..key,silent=true}) end
  vim.keymap.set("v","<leader>jl",function() dictionary.lookup(dictionary.selected()) end,{desc="Dictionary selected text"})
  vim.keymap.set("v","<leader>ja",function() anki.prepare(dictionary.selected()) end,{desc="Review selected text for Anki"})
  vim.api.nvim_create_autocmd("VimEnter",{once=true,callback=function()
    if vim.fn.argc()==0 and vim.fn.has("gui_running")==0 then
      vim.schedule(function() if vim.fn.bufname("%") == "" then require("jp.dashboard").show() end end)
    end
  end})
end
return M
