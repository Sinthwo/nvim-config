local M={}
local log=require('jp.study_log')
local vocab=require('jp.vocabulary')
function M.show()
  -- Every dashboard is a fresh read; no background callbacks or writes.
  local today=log.get()
  local stat=vocab.stats()
  local items={
    '',
    '         日本語  |  JAPANESE WRITING / STUDY',
    '         ---------------------------------',
    '',
    '   Date: '..log.today(),
    '   Vocabulary: '..(stat and stat.total or 0)..' notes | '
      ..(stat and stat.learning or 0)..' learning | '..(stat and stat.known or 0)..' known',
    '   Today: '..(today.kana_seen or 0)..' kana + '..(today.vocab_seen or 0)..' vocab prompts',
    '',
    '   DAILY WRITING                   STUDY & PRACTICE',
    '   j  Today\'s journal             t  Daily study plan',
    '   w  Independent writing         x  Kana recognition quiz',
    '   e  Exercises                   z  Vocabulary recall quiz',
    '',
    '   VOCABULARY DATABASE           OTHER',
    '   v  Add verified vocabulary     f  Find notes',
    '   l  Browse vocabulary           s  Search note contents',
    '   /  Search vocabulary           d  Dictionary lookup',
    '   m  Mark vocabulary status      p  Writing progress',
    '   b  Vocabulary statistics       a  Prepare one Anki card',
    '   g  Grammar note                k  Kanji note',
    '   o  Configure vault             h  Help',
    '   R  Markdown appearance        :Obsidian quick_switch',
    '   q  Close dashboard',
    '',
    '   i = Insert | Esc = Normal | :w = Save | :q = Quit',
    '   Japanese input: Win+Space, then IME Hiragana (あ)',
    '   Coding Neovim stays separate.',
    '',
  }
  if vim.bo.modified then
    return vim.notify('Save or discard unsaved changes before showing dashboard',vim.log.levels.WARN)
  end
  vim.cmd('enew')
  local buf=vim.api.nvim_get_current_buf()
  vim.bo[buf].buftype='nofile'; vim.bo[buf].bufhidden='wipe';vim.bo[buf].swapfile=false
  vim.api.nvim_buf_set_lines(buf,0,-1,false,items)
  vim.bo[buf].modifiable=false;vim.bo[buf].filetype='jp_dashboard'
  local map=function(k,command) vim.keymap.set('n',k,'<cmd>'..command..'<CR>',{buffer=buf,nowait=true,silent=true}) end
  map('j','JPToday');map('w','JPWriting');map('e','JPExercises')
  map('t','JPDaily');map('x','JPKanaQuiz');map('z','JPVocabQuiz')
  map('1','JPKanaChart');map('2','JPKanjiList');map('3','JPKanjiQuiz');map('4','JPVocabDetails')
  map('v','JPVocabAdd');map('l','JPVocabLibrary');map('/','JPVocabSearch');map('m','JPVocabMark')
  map('b','JPVocabStats');map('g','JPGrammar');map('k','JPKanji')
  map('f','JPFind');map('s','JPSearch');map('d','JPDictionary');map('p','JPProgress')
  map('a','JPAnki');map('o','JPSetup');map('h','JPHelp');map('R','JPMarkdownToggle');map('q','bd!')
  vim.api.nvim_set_hl(0,'JPHeader',{fg='#7aa2f7',bold=true})
  vim.api.nvim_buf_add_highlight(buf,-1,'JPHeader',1,0,-1)
end
return M
