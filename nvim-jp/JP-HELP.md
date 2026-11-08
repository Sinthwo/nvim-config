# Japanese writing profile — Help / はじめに

Use this profile for Japanese writing and study in an Obsidian vault. It runs
in a separate Neovim process from the coding profile, with its own plugins,
settings, and study history.

On Windows, install and launch this profile using the
[profile guide](../NeovimProfiles/README.md). Use Neovim 0.12+ with the bundled
plugin lockfile. Vault paths and Anki settings are configured locally with
`:JPSetup` and `:JPAnkiSetup`; no personal settings are bundled.

## Contents

- [First session](#first-session)
- [A complete practice example](#a-complete-practice-example)
- [Commands](#commands)
  - [Writing and review](#writing-and-review)
  - [Vocabulary and references](#vocabulary-and-references)
  - [Navigation and help](#navigation-and-help)
  - [Anki](#anki)
- [Shortcuts](#shortcuts)
- [Limits](#limits)
- [Vocabulary and privacy](#vocabulary-and-privacy)
- [Romaji and translated sentences](#romaji-and-translated-sentences)
- [Obsidian Markdown display](#obsidian-markdown-display)

## First session

1. Run `nvim-jp` in PowerShell after installing and loading the launcher.
2. Press `o` or run `:JPSetup`. Choose an existing Obsidian vault containing
   `.obsidian`, confirm the Japanese folder, then restart the profile.
3. Press `j` to start or reopen today's journal. Type `i` to enter Insert mode.
4. Use `Win+Space` to select the Japanese IME, then select Hiragana mode (あ)
   from its taskbar menu. With Romaji input enabled, type `watashi` to enter わたし,
   press `Space` to convert it to 私, then `Enter` to confirm. See
   [Microsoft’s IME instructions](https://support.microsoft.com/en-us/windows/hardware/input-devices/advanced-input-methods-for-east-asian-languages).
5. Return to English input, then `Esc` for Normal mode, `:w` to save, `:q` to quit.

## A complete practice example

Exercises are templates for your own prompts. `:JPExercises` lets you choose
a stage and type; `:JPNewExercise 1 translation` creates one directly. Enter
a topic such as “First sentences” when asked, then fill in **Prompt** yourself.
The four stages organize practice; they do not provide a complete course or
automatically select matching questions and answers.

For a first exercise, use “I am a student.” as the prompt. Your saved note
might contain the following sections after you have written an answer and
compared it with a reference:

```markdown
## Prompt
I am a student.

## My answer
<!-- JP:ANSWER:BEGIN -->
わたしはがくせいです。
<!-- JP:ANSWER:END -->

## Mistakes
No difference from this reference example; grammar has not been independently reviewed.

## Review notes
The topic particle は is pronounced wa. Next time, write a new sentence about myself.

## Reference
Stage 1: わたしはがくせいです。 (one acceptable answer)
```

Write your answer before running `:JPRevealAnswer 1`. The command opens the
stage's reference sheet in a separate split. It does not match or grade your
prompt; stages 1–3 have a few examples, and stage 4 offers writing topics.
If your prompt differs, consult an appropriate reference or reviewer. Close
the reference split with `:close`, return to your exercise, use `:JPComplete`,
then `:w`. `:JPProgress` counts Japanese characters inside the saved answer
markers; it does not measure correctness or proficiency. In your own practice,
write an original answer instead of copying the demonstration above.

## Commands

### Writing and review

| Command | Action |
| --- | --- |
| `:JP` / `:JPDashboard` | Japanese start dashboard |
| `:JPSetup` | Confirm existing Obsidian vault and Japanese directory |
| `:JPToday` | Today's journal; reuses existing entry |
| `:JPWriting` | New independent writing note |
| `:JPExercises` / `:JPNewExercise 1 translation` | Create an exercise template; supply your own prompt |
| `:JPRevealAnswer 1` | Separate reference examples; never alters answer |
| `:JPVocabulary` / `:JPGrammar` / `:JPKanji` | Create a vocabulary, grammar, or Kanji note from a template |
| `:JPDaily` | Optional 20-minute plan + daily practice counts |
| `:JPCorrection` / `:JPWeekly` | Review templates |
| `:JPProgress` | Statistics from saved answer/writing blocks |
| `:JPComplete` | Mark answer as completed **in current buffer**; `:w` to save |

### Vocabulary and references

| Command | Action |
| --- | --- |
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

### Navigation and help

| Command | Action |
| --- | --- |
| `:JPFind` / `:JPSearch` | Find note by filename / text |
| `:JPDictionary` | Browser dictionary query (only on request) |
| `:JPFocus` | Toggle distraction-free interface |
| `:JPObsidianOpen` | Open currently saved vault note in Obsidian |
| `:JPHelp` | This reference |

### Anki

| Command | Action |
| --- | --- |
| `:JPAnkiSetup` / `:JPAnki` | Choose existing Anki fields; reviewed single-card creation |
| `:JPAnkiStatus` | Show whether Anki is configured |

## Shortcuts

Press the keys in sequence in Normal mode. For example, `Space j j` opens
today's journal. Uppercase letters matter.

| Keys | Action |
| --- | --- |
| `Space j d` / `Space j o` | Dashboard / vault setup |
| `Space j j` / `Space j w` | Today's journal / independent writing |
| `Space j e` / `Space j r` | Exercise / reveal reference examples |
| `Space j v` / `Space j g` / `Space j k` | Vocabulary / grammar / Kanji template |
| `Space j i` / `Space j b` | Add vocabulary / browse vocabulary |
| `Space j q` / `Space j m` / `Space j z` | Vocabulary quiz / mark status / statistics |
| `Space j x` / `Space j t` | Kana quiz / daily plan |
| `Space j 1` / `Space j 2` | Kana chart / Kanji reference |
| `Space j 3` / `Space j 4` | Kanji quiz / existing-word pronunciation and translation |
| `Space j l` / `Space j a` | Dictionary lookup / prepare an Anki card |
| `Space j c` / `Space j p` | Mark complete / writing progress |
| `Space j s` / `Space j n` | Search text / find a note |
| `Space j f` / `Space j h` | Focus mode / help |
| `Space j R` | Toggle Markdown decoration |

On the dashboard, `1` through `4` also open the corresponding references and
vocabulary tools. In Visual mode, `Space j l` looks up the selection and
`Space j a` prepares a card using the selected text.

## Limits

- No automatic grammatical corrections, Kanji handwriting assessment, AI requests, or Anki synchronization.
- References are examples, not grades or certified corrections.
- Only manually-entered Japanese inside `<!-- JP:ANSWER:BEGIN/END -->` and `<!-- JP:WRITING:BEGIN/END -->` counts toward statistics.
- Writing is always the same Markdown file Obsidian sees; the editor does not rewrite existing notes.
- A new Neovim process is necessary to change profiles. Use `:qa`, then `nvim-code` or `nvim-jp`.

## Vocabulary and privacy

Vocabulary entries are Markdown files in the configured Obsidian vault.
Existing vocabulary notes from earlier profile versions are included. The
optional local study log stays in the Japanese profile's data directory.

Dictionary queries and Anki card creation require your action. Quizzes do not
create cards. Optional Anki commands need Anki, AnkiConnect at
`127.0.0.1:8765`, and `curl`; review each card before confirming it.

## Romaji and translated sentences

To add pronunciation and a translation to a word such as 食べる (たべる):

1. Run `:JPVocabDetails` and choose 食べる.
2. Enter the example reading `まいにち ごはん を たべます。` and meaning
   `I eat rice every day.`
3. Review the suggested Romaji, `mainichi gohan o tabemasu.`, before confirming.
4. Use `:w` to save the note.

Keep English translations in **Meaning of my sentence**, below the
`JP:WRITING` markers, so they do not count as Japanese writing.

Kana charts are comprehensive for normal beginner syllabary use, including 46 base + 25 voiced + 33 combined forms. Kanji are not an alphabet: the supplied 80 first-grade Kanji are a starting point, not every Kanji in Japanese.

Automatic Romaji is based **only** on the Kana reading you provide; Kanji readings, sentence segmentation, particles は/へ, meanings and translation are never inferred.

## Obsidian Markdown display

| Command | Action |
| --- | --- |
| `:JPMarkdownToggle` / `Space j R` | Toggle decorated Markdown |
| `:JPMarkdownStatus` | Check the renderer, parsers, and verified vault |
| `:JPMarkdownParsers` | Install Markdown, inline Markdown, YAML, and HTML parsers |
| `:Lazy` | Inspect this profile's plugin installations |
| `:Obsidian quick_switch` / `:Obsidian search` | Find a vault note / search vault text |
| `:Obsidian backlinks` / `:Obsidian toc` | Show backlinks / headings |
| `:Obsidian follow_link` | Follow the wikilink under the cursor |

The renderer decorates headings, callouts, checkboxes, links, and tables inside
Neovim. Decoration appears in Normal and Command modes; Insert mode shows the
Markdown source. The renderer leaves the underlying file untouched. Mermaid
diagrams and embedded graphics remain as source text.

Decoration works in Markdown files outside the vault. Obsidian navigation
requires the configured vault, and text search requires ripgrep (`rg`). Restart
`nvim-jp` after configuring a vault. Plugins and parsers are installed separately
from the coding profile.

See [Markdown and Obsidian setup](docs/MARKDOWN-OBSIDIAN.md) for installation
requirements and troubleshooting.
