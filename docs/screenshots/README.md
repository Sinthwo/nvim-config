# Neovim screenshot gallery

**Languages:** [English](README.md) | [Français](README.fr.md) | [Deutsch](README.de.md) | [日本語](README.ja.md)

Screenshots from the Windows Neovim and WezTerm configuration. These use sample files and an isolated preview. The AI views show layout or onboarding only; the debugger shows panels without a running session. Cloud deployment and account operations are not shown.

[Back to the main README](../../README.md)

- [Editing and navigation](#editing-and-navigation)
- [Writing and data](#writing-and-data)
- [Git and history](#git-and-history)
- [Terminals and tools](#terminals-and-tools)
- [AI workspaces](#ai-workspaces)
- [Japanese writing profile](#japanese-writing-profile)

## Editing and navigation

| Preview | Feature | Try it / guide |
| --- | --- | --- |
| [![Startup dashboard](dashboard.png)](dashboard.png) | **Startup dashboard** — Shark logo and shortcuts for files, search, plugins, and terminals. | `Space u D` · [Guide](../../MANUAL.md#dashboard-and-notifications) |
| [![Editor and file explorer](editor-explorer.png)](editor-explorer.png) | **Editor and file explorer** — Lua editing beside the project tree, with open files across the top. | `Ctrl+B` · [Guide](../../MANUAL.md#finding-files-and-using-the-explorer) |
| [![File picker](file-picker.png)](file-picker.png) | **File picker** — Filename search with a preview of the selected file. | `Space f f` · [Guide](../../MANUAL.md#finding-files-and-using-the-explorer) |
| [![Shortcut discovery](shortcuts.png)](shortcuts.png) | **Shortcut discovery** — Which-Key groups the available leader-key shortcuts by task. | `Space` · [Guide](../../MANUAL.md#editing-and-shortcuts) |
| [![Project text search](search.png)](search.png) | **Project text search** — Project text matches beside a preview of the selected line. | `Space f g` · [Guide](../../MANUAL.md#finding-files-and-using-the-explorer) |
| [![TODO search](todo.png)](todo.png) | **TODO search** — TODO matches with their surrounding code in the preview pane. | `Space f t` · [Guide](../../MANUAL.md#finding-files-and-using-the-explorer) |
| [![Scratch notes](scratch.png)](scratch.png) | **Scratch notes** — A floating scratch buffer keeps notes beside the current code. | `Space u .` · [Guide](../../MANUAL.md#git-and-project-terminals) |
| [![Notification history](notifications.png)](notifications.png) | **Notification history** — Earlier editor messages collected in notification history. | `Space u n` · [Guide](../../MANUAL.md#dashboard-and-notifications) |
| [![Zen mode](zen.png)](zen.png) | **Zen mode** — A centered Markdown buffer with surrounding editor panels hidden. | `Space u z` · [Guide](../../MANUAL.md#editing-and-shortcuts) |

## Writing and data

| Preview | Feature | Try it / guide |
| --- | --- | --- |
| [![Code completion](completion.png)](completion.png) | **Code completion** — Lua completion suggestions with documentation for the selected item. | `Ctrl+Space` · [Guide](../../MANUAL.md#editing-and-shortcuts) |
| [![Language diagnostics](diagnostics.png)](diagnostics.png) | **Language diagnostics** — A Python type error shown inline and in the diagnostics panel. | `Space x x` · [Guide](../../MANUAL.md#language-support-and-formatting) |
| [![Rendered Markdown](markdown.png)](markdown.png) | **Rendered Markdown** — Decorated headings, checkboxes, a callout, code, and a table. | `Space m r` · [Guide](../../MANUAL.md#markdown-and-obsidian) |
| [![CSV tables](csv.png)](csv.png) | **CSV tables** — CSV values aligned into columns while remaining editable as text. | `Space c v` · [Guide](../../MANUAL.md#csv-and-tsv-tables) |
| [![Obsidian notes](obsidian.png)](obsidian.png) | **Obsidian notes** — Quick-switch results for sample vault notes, with a note preview. | `Space o q` · [Guide](../../MANUAL.md#markdown-and-obsidian) |
| [![Image preview](image_preview.png)](image_preview.png) | **Image preview** — An image displayed in its own WezTerm preview tab. | `:ImagePreview path/to/image.jpg` · [Guide](../../MANUAL.md#image-and-pdf-previews) |

## Git and history

| Preview | Feature | Try it / guide |
| --- | --- | --- |
| [![Git status](git.png)](git.png) | **Git status** — Neogit status lists the changed file and its unstaged changes. | `Space g g` · [Guide](../../MANUAL.md#git-and-project-terminals) |
| [![Side-by-side diff](diff.png)](diff.png) | **Side-by-side diff** — A changed-file list beside a side-by-side code comparison. | `Space g d` · [Guide](../../MANUAL.md#git-and-project-terminals) |
| [![Undo history](undo.png)](undo.png) | **Undo history** — Undo-tree branches beside the buffer being reviewed. | `Space u u` · [Guide](../../MANUAL.md#editing-and-shortcuts) |

## Terminals and tools

| Preview | Feature | Try it / guide |
| --- | --- | --- |
| [![Project terminal](terminal.png)](terminal.png) | **Project terminal** — A project terminal below the code, showing a directory listing. | `Space t t` · [Guide](../../MANUAL.md#git-and-project-terminals) |
| [![Floating terminal](floating_terminal.png)](floating_terminal.png) | **Floating terminal** — A terminal floats over the editor without replacing the code view. | `Space t f` · [Guide](../../MANUAL.md#git-and-project-terminals) |
| [![Cloud-language editing](cloud_languages.png)](cloud_languages.png) | **Cloud-language editing** — Terraform and Azure Pipelines YAML open side by side. | `:vsplit azure-pipelines.yml` · [Guide](../../MANUAL.md#azure-and-cloud-tools) |
| [![Wallpaper manager](wallpapers.png)](wallpapers.png) | **Wallpaper manager** — Wallpaper Manager offers browsing, favorites, shuffle, and startup settings. | `Space u b` · [Guide](../../nvim/backgrounds/README.md) |
| [![Plugin manager](plugins.png)](plugins.png) | **Plugin manager** — Lazy lists installed plugins and their loading status. | `:Lazy` · [Guide](../../MANUAL.md#plugin-management) |
| [![Language-tool manager](language_tools.png)](language_tools.png) | **Language-tool manager** — Mason lists installed and available language-tool packages. | `:Mason` · [Guide](../../MANUAL.md#language-support-and-formatting) |
| [![Debugger panels (no active session)](debug.png)](debug.png) | **Debugger panels (no active session)** — Debugger panes arranged around Python code; no session is running. | `F5` · [Guide](../../MANUAL.md#python-debugging) |

## AI workspaces

| Preview | Feature | Try it / guide |
| --- | --- | --- |
| [![Claude session layout (onboarding)](claude_sessions.png)](claude_sessions.png) | **Claude session layout (onboarding)** — Two stacked Claude terminals at onboarding; no task is running. | `:Claude 2` · [Guide](../../MANUAL.md#ai-session-workspaces) |
| [![Codex session layout (blank preview)](codex_sessions.png)](codex_sessions.png) | **Codex session layout (blank preview)** — Two stacked terminal buffers show the workspace layout; the previews are blank. | `:Codex 2` · [Guide](../../MANUAL.md#ai-session-workspaces) |

## Japanese writing profile

| Preview | Feature | Try it / guide |
| --- | --- | --- |
| [![Japanese study dashboard](japanese_dashboard.png)](japanese_dashboard.png) | **Japanese study dashboard** — Study shortcuts for journals, vocabulary, references, and review. | `:JPDashboard` · [Guide](../../nvim-jp/JP-HELP.md#commands) |
| [![Kana reference](japanese_kana.png)](japanese_kana.png) | **Kana reference** — Hiragana, Katakana, and Romaji aligned in a reference table. | `:JPKanaChart` · [Guide](../../nvim-jp/JP-HELP.md#commands) |
| [![Kanji reference](japanese_kanji.png)](japanese_kanji.png) | **Kanji reference** — First-grade Kanji with example readings and English meanings. | `:JPKanjiList` · [Guide](../../nvim-jp/JP-HELP.md#commands) |
| [![Japanese writing](japanese_writing.png)](japanese_writing.png) | **Japanese writing** — A Japanese writing sample with a vocabulary table and practice checklist. | `:JPWriting` · [Guide](../../nvim-jp/JP-HELP.md#commands) |
