-- Gentle, non-scheduled study checklist. No gamified pressure or reminders.
local M={}
local log=require('jp.study_log')
local vocab=require('jp.vocabulary')
local function lines()
  local day=log.get()
  local s=vocab.stats()
  local rows={
    'JAPANESE STUDY — '..log.today(), '',
    'A simple 20-minute practice suggestion (optional):','',
    '  1. Write 3–5 original Japanese sentences       :JPToday',
    '  2. Practise 15 Hiragana/Katakana characters     :JPKanaQuiz',
    '  3. Recall up to 10 saved vocabulary entries    :JPVocabQuiz',
    '  4. Try a grammar or writing exercise           :JPExercises',
    '  5. Browse Kana / 80 first-grade Kanji         :JPKanaChart / :JPKanjiList',
    '',
    'TODAY (local practice only)',
    '  Kana prompts: '..tostring(day.kana_seen or 0),
    '  Kana correct: '..tostring(day.kana_correct or 0),
    '  Vocabulary prompts: '..tostring(day.vocab_seen or 0),
    '  Vocabulary recalled (self-rated): '..tostring(day.vocab_recalled or 0),
    '  Kanji prompts: '..tostring(day.kanji_seen or 0),
    '  Vocabulary notes: '..tostring(s and s.total or 0),
    '  Vocabulary learning: '..tostring(s and s.learning or 0),
    '',
    'Writing statistics: :JPProgress',
    'Vocabulary statistics: :JPVocabStats',
    '',
    'Counters update only from interactive quizzes. Writing notes are',
    'counted separately from saved Japanese answer/writing blocks.',
    'You can skip anything. No automatic Anki scheduling is performed.',
  }
  return rows
end
function M.show()
  vim.cmd('botright new')
  local buf=vim.api.nvim_get_current_buf()
  vim.bo[buf].buftype='nofile';vim.bo[buf].bufhidden='wipe'
  vim.api.nvim_buf_set_lines(buf,0,-1,false,lines())
  vim.bo[buf].modifiable=false
  vim.keymap.set('n','q','<cmd>close<CR>',{buffer=buf})
end
return M
