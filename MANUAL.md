# Windows user manual

**This Neovim and WezTerm configuration is designed for Windows.** Examples use
PowerShell and resolve directories for the current user. Linux, macOS, and WSL
installation are outside this manual's supported setup.

## Contents

- [Installation and first launch](#installation-and-first-launch)
- [Editing and shortcuts](#editing-and-shortcuts)
- [Finding files and using the explorer](#finding-files-and-using-the-explorer)
- [Language support and formatting](#language-support-and-formatting)
- [Python debugging](#python-debugging)
- [Git and project terminals](#git-and-project-terminals)
- [Markdown and Obsidian](#markdown-and-obsidian)
- [WezTerm and wallpapers](#wezterm-and-wallpapers)
- [Customization and privacy](#customization-and-privacy)
- [Plugin management](#plugin-management)
- [Troubleshooting](#troubleshooting)
- [Validate the configuration](#validate-the-configuration)

## Installation and first launch

Follow the [README installation steps](README.md#install-on-windows). Copy the
contents using the provided directory-copy command, rather than creating an
extra `nvim` folder inside the destination. The first launch needs an internet
connection so lazy.nvim and Mason can download plugins and language tools.

Open a new PowerShell window after installing command-line tools so it receives
the updated `PATH`. Check the core tools there:

```powershell
nvim --version
git --version
fzf --version
rg --version
wezterm --version
```

Neovim must be 0.12 or newer because the configured Tree-sitter revision uses
the new API. Its [requirements](https://github.com/nvim-treesitter/nvim-treesitter/blob/e289100ff98969e118c702199d88b764ce9e7fdf/README.md)
also include Tree-sitter CLI 0.26.1+, `curl`, `tar`, and a C compiler. Mason
requests the CLI automatically. Install the compiler yourself, and start
WezTerm from a Developer PowerShell session when using MSVC so Neovim inherits
the compiler environment.

Language servers install when a source file is opened. Formatters and debugpy
are requested shortly after startup. Leave the first session open until
`:Lazy` and `:Mason` show that installation has finished, then restart Neovim.
Parser installation is retried after Mason completes its tool installation.

Useful first checks are:

```vim
:checkhealth
:Mason
:ConformInfo
:messages
```

## Editing and shortcuts

Neovim has normal mode for navigation and commands, insert mode for typing,
and visual mode for selections. Press `i` to type, `Esc` to return to normal
mode, and `v` to select text. Enter commands with `:` in normal mode.

The leader is **Space**, and the local leader is **backslash**. A shortcut such
as `Space b c` means press the keys one after another in normal mode. Uppercase
letters matter. Which-Key displays available groups after pressing Space.

| Keys or command | Action |
| --- | --- |
| Ctrl+S | Save in normal or insert mode |
| `:w` / `:q` / `:wq` | Save / close window / save and close |
| Esc | Clear highlighted search results in normal mode |
| `/text`, then `n` / `N` | Search, next / previous match |
| `u` / Ctrl+R | Undo / redo |
| Ctrl+H / J / K / L | Focus the left / lower / upper / right split |
| Space s v / Space s h | Create a vertical / horizontal split |
| Space s c | Close the current split |
| Ctrl+Tab / Ctrl+Shift+Tab | Next / previous buffer, with WezTerm forwarding |
| Space b n / Space b p | Next / previous buffer using leader keys |
| Space b P | Pick a buffer by its displayed label |
| Space b c | Close the current buffer |
| Space b o | Close other buffers; unsaved buffers are retained |
| Space b l / Space b r | Close buffers to the left / right |
| Space u u | Toggle the undo-history tree |
| Space u z | Toggle Zen mode |
| Space u n | Show notification history |

The tabs along the top represent **buffers**, meaning open files. They are
separate from WezTerm terminal tabs. Saving before closing avoids prompts or
refused close operations for modified files.

Completion uses Blink's [super-tab preset](https://cmp.saghen.dev/configuration/keymap).
Tab accepts a suggestion or advances through a snippet; Shift+Tab moves back
through a snippet. Ctrl+Space opens completion, Ctrl+N/P selects suggestions,
and Ctrl+E dismisses the menu. Documentation opens automatically after a short
delay. Automatic bracket pairing and surround editing are also enabled.

## Finding files and using the explorer

| Keys | Action |
| --- | --- |
| Ctrl+P / Space f f | Find a file |
| Ctrl+Shift+F / Space f g | Search project text |
| Space f b | Pick an open buffer |
| Space f r | Pick a recently opened file |
| Space f s / Space f S | Document / workspace symbols from the language server |
| Space f t | Search TODO comments |
| `]t` / `[t` | Next / previous TODO comment |
| Ctrl+B | Open or close the file explorer |

Inside the explorer, Enter opens an item, `v` or Ctrl+V opens a vertical split,
and `s` or Ctrl+S opens a horizontal split. Ctrl+B closes the explorer. Its
Ctrl+S mapping opens a split; the regular editor's Ctrl+S saves a file.

The explorer follows the active file. Dotfiles and Git-ignored files are
available rather than forcibly hidden. File pickers use the current working
directory; launch Neovim from the project folder or use `:cd` to set it. Native
Windows grep requires ripgrep, as described in the [fzf-lua Windows notes](https://github.com/ibhagwan/fzf-lua/blob/main/README-Win.md).

## Language support and formatting

Mason stores tools in Neovim's data directory. The configuration requests:

| Language or feature | Tools | Requirements outside Neovim |
| --- | --- | --- |
| Python | BasedPyright, Ruff, debugpy | Python; Node.js/npm for BasedPyright |
| PowerShell | PowerShell Editor Services | PowerShell, preferably version 7 |
| Java | jdtls | JDK 21+ for the server, Python 3.9+ for its launcher |
| Lua | Lua language server, StyLua | Mason-managed binaries |
| JSON / YAML formatting | Prettier | Node.js/npm |
| Syntax highlighting | Tree-sitter parsers | Tree-sitter CLI, curl, tar, C compiler |

Java's server runtime requirements come from [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls#configuration).
The project itself can target a different Java version. Maven and Gradle
projects receive fuller support than standalone Java files.

Open `:Mason` to inspect installation state. To explicitly request the configured
tools, use:

```vim
:MasonInstall basedpyright ruff powershell-editor-services jdtls lua-language-server debugpy stylua prettier tree-sitter-cli
```

Installed servers become available to the next session. PowerShell editor
services are enabled only when the executable and service script exist; reopen
Neovim after installing them. Java also reports when jdtls is missing.

| Keys | Language-server action |
| --- | --- |
| `gd` / `gD` | Definition / declaration |
| `gi` / `gr` | Implementation / references |
| `K` | Hover documentation |
| F2 | Rename a symbol |
| Space c a | Code actions in normal or visual mode |
| Space c d | Diagnostics for the current line |
| `]d` / `[d` | Next / previous diagnostic |
| Space x x | Toggle project diagnostics |
| Space x X | Toggle current-buffer diagnostics |
| Space x s | Toggle the symbol panel |

Language-server mappings are attached to buffers with an active server.
Use `:checkhealth vim.lsp` to inspect servers and `:messages` for startup errors.

Formatting is **manual**: press Space c f. Python uses Ruff, Lua uses StyLua,
and JSON/YAML use Prettier. Other languages fall back to an attached language
server's formatter when one is available. Loading the formatter on save does
not enable automatic formatting. Inspect providers with `:ConformInfo`.

Java-specific shortcuts are Space j o to organize imports, Space j v to extract
a variable, and Space j c to extract a constant. Each project's normalized root
path is hashed into its workspace cache name, so equally named project folders
have separate caches. A new cache may cause one fresh indexing pass.

## Python debugging

Open a Python file and ensure debugpy has finished installing in Mason. The
adapter uses Mason's debugpy interpreter. For the application interpreter,
activate the project's virtual environment before launching Neovim, or set
`require("dap-python").resolve_python` in your local configuration if needed.

| Keys | Action |
| --- | --- |
| F9 | Toggle a breakpoint |
| F5 | Start / continue debugging |
| F10 | Step over |
| F11 / Shift+F11 | Step into / step out |
| Space d r | Open the debug REPL |
| Space d t | Terminate the session |

The debugger UI loads with the debugger, opens on launch or attach, and closes
when the session ends. Select a Python launch configuration if prompted. This
setup includes Python debugging; Java debugging needs additional adapter
configuration and is not enabled here.

## Git and project terminals

| Keys | Action |
| --- | --- |
| Space g g | Open Neogit status |
| Space g c | Open the commit interface |
| Space g p / Space g P | Push / pull |
| Space g l | View the Git log |
| Space g d | Open a diff view |
| Space g H | View history for the current file |
| `]h` / `[h` | Next / previous changed hunk |
| Space g h | Preview a hunk |
| Space g s / Space g r | Stage / reset the current hunk |
| Space g b | Show blame for the current line |
| Space t t | Toggle a terminal rooted at the current project |
| Esc, Esc | Leave terminal input mode |

Hunk reset discards that hunk's changes. Push and pull use your existing Git
credentials and remote configuration. This Neovim configuration does not set
a Git author name or email.

The project-root helper recognizes Git, Python project files, Java build files,
PowerShell analyzer settings, and Obsidian vault markers. It falls back to the
working directory. Space a c starts the `codex` CLI and Space a C starts the
`claude` CLI if those commands are installed and available in `PATH`. These
shortcuts only launch the external programs; install and authenticate them
separately if you use them.

## Markdown and Obsidian

Markdown rendering loads when a Markdown file opens. Space m r toggles the
rendering. Code blocks and headings retain transparent backgrounds so the
WezTerm wallpaper can remain visible.

Obsidian is optional and loads through an `:Obsidian` command or its shortcuts.
The vault path is selected in this order:

1. `vim.g.nvim_obsidian_vault`, set before the plugin loads.
2. The `OBSIDIAN_VAULT` environment variable.
3. `~/Documents/Obsidian`, expanded for the current user.

Point it at an existing vault in a PowerShell session before starting Neovim:

```powershell
$env:OBSIDIAN_VAULT = Join-Path $HOME 'Documents\Obsidian'
nvim
```

For a persistent local setting, use Windows' user environment variables or:

```powershell
[Environment]::SetEnvironmentVariable('OBSIDIAN_VAULT', (Join-Path $HOME 'Documents\Obsidian'), 'User')
```

Restart WezTerm after changing persistent environment variables. They are local
machine settings and do not need to be added to the shared Lua files.

| Keys | Action |
| --- | --- |
| Space o q | Quick-switch notes |
| Space o s | Search the vault |
| Space o n | Create a note |
| Space o t | Open today's daily note |
| Space o b | Show backlinks |
| Space o c | Check the vault and plugin setup |

Run `:Obsidian` once to load its integration, then open a note in the configured
vault. Note and tag completion uses the plugin's built-in LSP with Blink's `lsp`
source; the removed `completion.blink` and `completion.nvim_cmp` options are
unnecessary. Ordinary Markdown outside the vault can still use the renderer.

## WezTerm and wallpapers

The bundled background images come from
[ThePrimeagen/anime](https://github.com/ThePrimeagen/anime). See that repository
for the collection's original image credits.

The companion config belongs at `$HOME\.wezterm.lua`. It uses an opaque
Tokyo Night window. A darkened wallpaper appears while Neovim signals
`NVIM_ACTIVE=1`; it is cleared when Neovim exits or the selected file is missing.
Neovim itself does not render a terminal wallpaper.

| Keys or command | Action |
| --- | --- |
| Space u b / `:BackgroundPick` | Choose an image |
| Space u B / `:BackgroundFolder` | Open the image folder in Windows Explorer |
| Ctrl+Tab / Ctrl+Shift+Tab | Cycle Neovim buffers while active, terminal tabs otherwise |
| Alt+Enter | Toggle WezTerm fullscreen |
| Ctrl+Shift+L | Open the WezTerm debug overlay |

The picker lists PNG, JPG/JPEG, GIF, BMP, and WEBP files directly in the image
folder. PNG and JPEG are good choices for compatibility. The picker does not
search subfolders, and SVG files are not listed. Place any additional images
directly in the background folder to make them selectable.

The default folder is Neovim's config directory plus `backgrounds`, normally
`$env:LOCALAPPDATA\nvim\backgrounds`. A selection is saved as a filename such as
`n8-versace.png` in `selected-background.txt`. Cancelling leaves the selection
unchanged. WezTerm reads the choice about once a second. Old absolute selections
still work locally; selecting an image again replaces them with a filename.

To use a custom folder, set the same environment variable before launching
WezTerm and Neovim:

```powershell
$backgroundDir = Join-Path $HOME 'Pictures\Terminal Backgrounds'
New-Item -ItemType Directory -Path $backgroundDir -Force | Out-Null
[Environment]::SetEnvironmentVariable('NVIM_BACKGROUND_DIR', $backgroundDir, 'User')
```

Place images there, restart WezTerm, and choose one in Neovim. Use an absolute
directory or a `~/...` home-relative directory. Both applications must receive
the same value. The default WezTerm resolver also honors `XDG_CONFIG_HOME` and
`NVIM_APPNAME` if you use those Neovim settings.

## Customization and privacy

Neovim resolves configuration, data, and cache paths using `stdpath()`. View
the actual locations inside the editor:

```vim
:lua print(vim.fn.stdpath("config"))
:lua print(vim.fn.stdpath("data"))
:lua print(vim.fn.stdpath("cache"))
```

Use `vim.fn.expand("~/...")`, `vim.fs.joinpath()`, and environment variables
for new local paths. PowerShell discovery uses `PATH`, `ProgramFiles`, and
`SystemRoot`; no fixed drive or username is required.

The main settings are in `nvim/lua/config/options.lua`, editor shortcuts in
`nvim/lua/config/keymaps.lua`, and plugin settings under `nvim/lua/plugins/`.
WezTerm's appearance, background brightness, and terminal shortcuts live in
`WezTerminal-Config/.wezterm.lua`. The font is not forced; configure a locally
installed Nerd Font if you want every icon to render.

The picker saves only a filename; its local selection file is optional and is
created when you choose a background. Generated selections,
logs, sessions, and editor temporary files are ignored by Git. `.gitignore`
does not exclude files from a hand-made ZIP or remove files already tracked:
review what you actually share. Keep private vault paths and credentials in
local settings. The bundled images are credited to their source repository,
and the asset folder has no local Git history.

Ordinary filenames, project names, recent-file lists, and buffer paths remain
visible during use. This setup cleans shared configuration files rather than
providing a screen-sharing privacy mode. Git author details for commits are
controlled by your own Git settings.

## Plugin management

Use `:Lazy` to inspect plugin status. `:Lazy restore` returns installed plugins
to revisions recorded in `lazy-lock.json`; `:Lazy update` deliberately updates
them and can change the lockfile. Keep the lockfile with the shared config.
Plugins already declared without a lock entry are installed when first needed.

Use `:Mason` to inspect language tools, `:MasonUpdate` to refresh its registry,
and `:MasonInstall` to install packages. Mason's tool-installer also requests the
configured formatters, debugpy, and Tree-sitter CLI automatically.

With the compiler available, parsers can be installed explicitly:

```vim
:TSInstall bash java json lua markdown markdown_inline powershell python query regex toml vim vimdoc yaml
:TSUpdate
```

`TSInstall` adds the requested parsers; `TSUpdate` updates installed parsers
after a plugin update. Reopen the file if highlighting has not attached yet.

## Troubleshooting

| Symptom | What to check |
| --- | --- |
| Config appears unchanged | Print `stdpath("config")`; check for a nested `nvim/nvim` folder and environment overrides. |
| Plugin installation fails | Check Git, network access, `:Lazy`, and `:messages`. |
| File picker or grep fails | Verify `fzf --version` and `rg --version` in the terminal used to launch Neovim. |
| Icons appear as boxes | Configure a Nerd Font in WezTerm. |
| No syntax highlighting | Run `:checkhealth nvim-treesitter`, verify CLI/compiler availability, then `:TSInstall` and reopen the file. |
| No Python diagnostics | Inspect BasedPyright/Ruff in `:Mason`; restart after installation and activate the project environment. |
| PowerShell LSP is disabled | Install PowerShell Editor Services, check `pwsh`/`powershell.exe`, then restart Neovim. |
| Java server does not start | Check JDK and Python versions, jdtls in `:Mason`, and `:JdtShowLogs` after the plugin loads. |
| Format shortcut has no effect | Inspect `:ConformInfo`; install the provider and check `PATH`. |
| Debugging fails | Check debugpy in `:Mason`, the application interpreter, and messages in the debug REPL. |
| Obsidian reports no workspace | Set `OBSIDIAN_VAULT` to an existing vault and restart Neovim. |
| Wallpaper is missing | Check `$HOME\.wezterm.lua`, the background folder, the selection filename, and `NVIM_BACKGROUND_DIR` in both processes. |
| Ctrl+Tab changes terminal tabs | Restart Neovim inside WezTerm; try Space b n/p and verify the companion config is loaded. |
| Graphics rendering fails | Try `config.front_end = "OpenGL"` in your local WezTerm config. |

Missing external programs are reported rather than configured with personal
fallback paths. `:messages` and Space u n help recover notifications.

## Validate the configuration

Run these from the repository folder in PowerShell. They do not install plugins
or change your active Neovim configuration:

```powershell
nvim --headless -u NONE -i NONE -n -l tools/verify-config.lua
wezterm --config-file '.\WezTerminal-Config\.wezterm.lua' show-keys
```

The first command checks Lua syntax and regression scenarios using fake plugin
APIs and synthetic Windows profiles. It covers wallpaper paths, cancellation,
missing selections, debugger UI loading, unique buffer shortcuts, Obsidian
overrides, PowerShell quoting, parser-install retries, and Java cache separation.
It also checks documentation links and shortcut coverage. WezTerm's command
loads the real terminal config without opening a new terminal window.
