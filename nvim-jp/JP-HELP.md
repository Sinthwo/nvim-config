# Japanese Writing v4 — Help / はじめに

Your original coding Neovim config is a different process/profile.

On Windows, install and launch this profile using the
[profile guide](https://github.com/Sinthwo/nvim-config/blob/main/NeovimProfiles/README.md). Use Neovim 0.12+ with the bundled
plugin lockfile. Vault paths and Anki settings are configured locally with
`:JPSetup` and `:JPAnkiSetup`; no personal settings are bundled.

## First session

1. Run `nvim-jp` in PowerShell (after installer/profile reload).
2. Press `o` or run `:JPSetup`, then choose a **real existing Obsidian vault** (with `.obsidian`). No vault is guessed.
3. Press `j` to start or reopen today's journal. Type `i` to enter Insert mode.
4. Use `Win+Space` to choose Japanese IME. In Japanese A/あ mode, type `watashi` -> わたし, press Space to convert -> 私, Enter to confirm.
5. Return to English input, then `Esc` for Normal mode, `:w` to save, `:q` to quit.

## Commands

| Command | Description |
| --- | --- |
| `:JP` / `:JPDashboard` | Japanese start dashboard |
| `:JPSetup` | Confirm existing Obsidian vault and Japanese directory |
| `:JPToday` | Today's journal; reuses existing entry |
| `:JPWriting` | New independent writing note |
| `:JPExercises` / `:JPNewExercise 1 translation` | Exercise / explicit stage+type |
| `:JPRevealAnswer 1` | Separate reference examples; never alters answer |
| `:JPVocabulary` / `:JPGrammar` / `:JPKanji` | Original note templates (unchanged) |
| `:JPVocabAdd` | Create a word with Romaji and optional example translation/reading |
| `:JPVocabDetails` | Add missing pronunciation and translation fields to an old note; save with `:w` |
| `:JPVocabLibrary` / `:JPVocabSearch` | Browse/search Japanese, reading, meaning and status |
| `:JPVocabQuiz` | Self-rated meaning, Japanese and reading recall |
| `:JPVocabMark` | Change status in buffer; `:w` to save |
| `:JPVocabStats` / `:JPVocabExport` | Statistics and confirmed TSV export |
| `:JPVocabImport` | Confirm import of new vocabulary from a UTF-8 TSV file |
| `:JPKanaQuiz` | Choose basic, voiced or combined Kana recognition |
| `:JPKanaChart` | Full beginner Hiragana/Katakana chart |
| `:JPKanjiList` | Reference of 80 first-grade Kanji |
| `:JPKanjiSearch` | Search the Grade 1 Kanji, readings or English meaning |
| `:JPKanjiQuiz` | Self-rated recall quiz for 80 first-grade Kanji |
| `:JPDaily` | Optional 20-minute plan + daily practice counts |
| `:JPCorrection` / `:JPWeekly` | Review templates |
| `:JPFind` / `:JPSearch` | Find note by filename / text |
| `:JPDictionary` | Browser dictionary query (only on request) |
| `:JPProgress` | Statistics from saved answer/writing blocks |
| `:JPComplete` | Mark answer as completed **in current buffer**; `:w` to save |
| `:JPAnkiSetup` / `:JPAnki` | Choose existing Anki fields; reviewed single-card creation |
| `:JPAnkiStatus` | Show whether Anki is configured |
| `:JPFocus` | Toggle distraction-free interface |
| `:JPObsidianOpen` | Open currently saved vault note in Obsidian |
| `:JPHelp` | This reference |

v2 shortcuts: `Space+j+i` add vocabulary, `Space+j+b` browse, `Space+j+q` vocab quiz, `Space+j+m` mark, `Space+j+z` vocab stats, `Space+j+x` Kana quiz, `Space+j+t` daily plan.

New v3 dashboard shortcuts `1` Kana chart, `2` Kanji chart, `3` Kanji quiz, `4` existing-word pronunciation/translation. Global `Space+j+1/2/3/4` also work.

Shortcut prefix **Space+j** in Normal mode: `d` dashboard, `j` today, `w` writing, `e` exercise, `r` reveal, `v` vocab, `g` grammar, `k` Kanji, `l` dictionary, `a` Anki, `c` complete, `p` progress, `f` focus, `h` help, `o` setup, `s` search, `n` find. In Visual mode use `Space+j+l` lookup selection; `Space+j+a` prepares a card with selected text.

## Limits

- No automatic grammatical corrections, Kanji handwriting assessment, AI requests, or Anki synchronization.
- References are examples, not grades or certified corrections.
- Only manually-entered Japanese inside `<!-- JP:ANSWER:BEGIN/END -->` and `<!-- JP:WRITING:BEGIN/END -->` counts toward statistics.
- Writing is always the same Markdown file Obsidian sees; the editor does not rewrite existing notes.
- A new Neovim process is necessary to change profiles. Use `:qa`, then `nvim-code` or `nvim-jp`.

## Vocabulary and privacy

Vocabulary entries are files inside the **same configured Obsidian vault**, not a second database. Existing v1 vocabulary notes are automatically included. No online dictionary or AI is queried without your action; no Anki cards are created by quizzes. The optional local study log stays under the isolated Japanese profile data directory.

## Romaji and translated sentences (v3)

For your current word 食べる (たべる), run `:JPVocabDetails`, choose 食べる, and fill the example reading `まいにち ごはん を たべます。` plus example meaning `I eat rice every day.` The suggested Romaji is `mainichi gohan o tabemasu.` Review it before confirming. Press `:w` to save the note. Do not put an English translation between the JP:WRITING markers; use **Meaning of my sentence** below those markers.

Kana charts are comprehensive for normal beginner syllabary use, including 46 base + 25 voiced + 33 combined forms. Kanji are not an alphabet: the supplied 80 first-grade Kanji are a starting point, not every Kanji in Japanese.

Automatic Romaji is based **only** on the Kana reading you provide; Kanji readings, sentence segmentation, particles は/へ, meanings and translation are never inferred.

## Obsidian Markdown display (v4)

- **`:JPMarkdownToggle`** or **`Space j R`** switches between decorated and ordinary Markdown.
- **`:JPMarkdownStatus`** checks the renderer, the parser, and the verified vault.
- **`:JPMarkdownParsers`** installs the needed Tree-sitter Markdown, inline, YAML and HTML parsers (initial setup after `:Lazy sync`).
- **`:Lazy`** displays Japanese-only plugin installations. Plugins are NOT shared with the coding profile.
- In an Obsidian vault, run **`:Obsidian quick_switch`** to pick a note, **`:Obsidian search`** to search contents, **`:Obsidian backlinks`** to find links to current note, **`:Obsidian toc`** for headings, or **`:Obsidian follow_link`** while on a wikilink.
- For Obsidian navigation, use Neovim >= 0.11, an existing configured vault, and ripgrep (`rg`) for search. `:JPToday` and Japanese note creation remain separate and unchanged.
- The Markdown renderer decorates headings, callouts, checkboxes, links and tables **inside Neovim**. This isn't a browser or Obsidian Live Preview; Mermaid diagrams and embedded graphics are not visually rendered.
- Markdown appearance is normally on in Normal mode, off while you type in Insert mode. The underlying `.md` is never reformatted by the renderer.
- The preview works in `.md` notes even outside your vault. Obsidian commands require the configured vault. Reopen `nvim-jp` after configuring a vault.
- See [Markdown and Obsidian setup](docs/MARKDOWN-OBSIDIAN.md) for troubleshooting.
