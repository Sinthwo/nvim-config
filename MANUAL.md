# Windows user manual

**This Neovim and WezTerm configuration is for Windows.** This manual covers
installation, everyday shortcuts, optional tools, and customization. The
examples use PowerShell and resolve paths for the current user.

## Contents

- [Installation and first launch](#installation-and-first-launch)
- [Editing and shortcuts](#editing-and-shortcuts)
- [Finding files and using the explorer](#finding-files-and-using-the-explorer)
- [Language support and formatting](#language-support-and-formatting)
- [Python debugging](#python-debugging)
- [Git and project terminals](#git-and-project-terminals)
- [AI session workspaces](#ai-session-workspaces)
- [Azure and cloud tools](#azure-and-cloud-tools)
- [CSV and TSV tables](#csv-and-tsv-tables)
- [Image and PDF previews](#image-and-pdf-previews)
- [Markdown and Obsidian](#markdown-and-obsidian)
- [WezTerm and wallpapers](#wezterm-and-wallpapers)
- [Customization and privacy](#customization-and-privacy)
- [Plugin management](#plugin-management)
- [Troubleshooting](#troubleshooting)
- [Validate the configuration](#validate-the-configuration)

## Installation and first launch

Follow the [README installation steps](README.md#install-on-windows). The copy
command puts the files directly in Neovim's configuration directory. Check that
it has not created an extra `nvim` folder inside that directory. The first launch
needs an internet connection to download plugins and language tools.

After installing command-line tools, open a new PowerShell window so it picks
up the updated `PATH`. Check that the core tools are available:

```powershell
nvim --version
git --version
fzf --version
rg --version
wezterm --version
```

The pinned Tree-sitter version
[requires](https://github.com/nvim-treesitter/nvim-treesitter/blob/e289100ff98969e118c702199d88b764ce9e7fdf/README.md)
Neovim 0.12 or newer, Tree-sitter CLI 0.26.1 or newer, `curl`, `tar`, and a
C compiler. Mason installs the CLI automatically. Install a compiler separately.
If you use MSVC, start WezTerm from Developer PowerShell so Neovim can find
the compiler and its environment settings.

Language-server installation starts when you open a source file. Formatters and
debugpy begin installing shortly after startup. Leave the first session open until
`:Lazy` and `:Mason` show that installation has finished, then restart Neovim.
Neovim retries parser installation after Mason finishes installing its tools.

Use these commands to check the setup:

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

The leader key is **Space**, and the local leader is **backslash**. A shortcut such
as `Space b c` means press the keys one after another in normal mode. Uppercase
letters matter. Press Space and wait for Which-Key to show the available shortcuts.

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

The tabs along the top show **buffers**, usually open files. WezTerm has its
own terminal tabs. Save modified files before closing them to avoid prompts
or a refused close.

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
and `s` or Ctrl+S opens a horizontal split. Ctrl+B closes the explorer.
Ctrl+S therefore has two uses: it opens a split in the explorer and saves a file
in the editor.

The explorer follows the active file and shows dotfiles and Git-ignored files.
File pickers search the current working directory. Launch Neovim from your
project folder or use `:cd` to change it. Text search on Windows requires
ripgrep; see the [fzf-lua Windows notes](https://github.com/ibhagwan/fzf-lua/blob/main/README-Win.md).

## Language support and formatting

Mason installs tools in Neovim's data directory. The supported languages and
their tools are listed below:

| Language or feature | Tools | Requirements outside Neovim |
| --- | --- | --- |
| Python | BasedPyright, Ruff, debugpy | Python; Node.js/npm for BasedPyright |
| PowerShell | PowerShell Editor Services | PowerShell, preferably version 7 |
| Java | jdtls | JDK 21+ for the server, Python 3.9+ for its launcher |
| Lua | Lua language server, StyLua | Mason-managed binaries |
| JSON / YAML formatting | Prettier | Node.js/npm |
| YAML / Azure Pipelines | yamlls, azure_pipelines_ls | Node.js/npm |
| Bash / shell scripts | bashls, shfmt | Node.js/npm for the server; Bash for running scripts |
| Terraform / HCL | terraformls, terraform_fmt | Terraform CLI for formatting and validation |
| Azure Bicep / parameters | bicep-ls | .NET SDK and separately installed Bicep language server |
| CSV / TSV | csvview.nvim and syntax parsers | No external server required |
| Syntax highlighting | Tree-sitter parsers | Tree-sitter CLI, curl, tar, C compiler |

See [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls#configuration) for
Java's server requirements. Your project can target a different Java version.
Maven and Gradle projects have more complete support than standalone Java files.

Open `:Mason` to check installation progress. You can also install the configured
tools manually:

```vim
:MasonInstall basedpyright ruff powershell-editor-services jdtls lua-language-server debugpy stylua prettier tree-sitter-cli
:MasonInstall bash-language-server yaml-language-server terraform-ls azure-pipelines-language-server shfmt
```

Restart Neovim after installing language servers. PowerShell Editor Services
needs both a PowerShell executable and Mason's service script. Java shows a
notification if jdtls is missing.

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

These shortcuts are available when a language server is attached to the file.
Use `:checkhealth vim.lsp` to check servers and `:messages` to view startup errors.

Formatting is **manual**: press Space c f. Python uses Ruff, Lua uses StyLua,
JSON/YAML use Prettier, Bash uses shfmt, and Terraform uses `terraform fmt`.
Other languages use the attached language server's formatter when available.
Files are not formatted automatically on save. Use `:ConformInfo` to check
which formatter is available for the current file.

Java-specific shortcuts are Space j o to organize imports, Space j v to extract
a variable, and Space j c to extract a constant. Each Java project has a separate
workspace cache, even when two project folders have the same name. The first
time a new cache is used, jdtls may need to index the project.

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
setup supports Python debugging. Java debugging requires an additional adapter
and configuration.

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

The terminal opens at the project root, identified using Git, Python project
files, Java build files, PowerShell analyzer settings, or Obsidian vault markers.
If no root is found, it uses the current working directory.

Space a c starts Codex, and Space a C starts Claude Code. Install the CLIs,
sign in, and make sure their commands are available in `PATH` before using
these shortcuts.

## AI session workspaces

Install the external [Codex CLI](https://learn.chatgpt.com/docs/codex/cli) and/or
[Claude Code](https://code.claude.com/docs/en/setup), sign in using their own
instructions. Check `codex --version` and `claude --version` in the terminal
you use to start Neovim. Space a c and Space a C each open a single terminal.
The commands below create a dedicated **Neovim tab page** with one or more sessions:

| Command | Action |
| --- | --- |
| `:Codex` / `:Claude` | Open one CLI session |
| `:Codex 8` / `:Claude 8` | Open eight independent sessions |
| `:Codex1` through `:Codex8` | Open the specified number of Codex sessions |
| `:Claude1` through `:Claude8` | Open the specified number of Claude sessions |
| `:CodexEnd` / `:ClaudeEnd` | Close all Codex / Claude workspace tabs |

Counts must be whole numbers from 1 to 8. `:Codex_8`, `:Claude_8`,
`:Codex_End`, and `:Claude_End` are interactive command-line abbreviations.
Use the forms without underscores in scripts and mappings.

Your code stays in its original tab. In the AI tab, Bufferline hides the file
tabs so you can focus on the sessions. One session fills the tab, two are stacked
vertically, and three to eight are arranged in two columns. Each session starts
at the current project root. Enlarge the terminal when using many sessions.

Use `gt` and `gT` to switch Neovim tabs. In normal mode, Ctrl+H/J/K/L moves
between splits, and `i` enters terminal input mode. Press Esc twice to return
to normal mode.

`:CodexEnd` closes all Codex workspace tabs; `:ClaudeEnd` closes all Claude
workspace tabs. Both return to the original coding tab if it is still open.
Closing a session ends its process. Sign-in, permissions, and account usage
are managed by the CLIs.

## Azure and cloud tools

Follow the [Windows cloud setup guide](nvim/SETUP-CLOUD-TOOLS.md) for optional
Azure CLI, PowerShell Az, Terraform CLI, and Bicep language-server installation.
Mason manages the configured Bash, YAML, Terraform, and Azure Pipelines servers.

| Keys | Command | Action |
| --- | --- | --- |
| Space z t | `:AzureTerminal` | Open a project terminal |
| Space z l | `:AzureLogin` | Run `az login` |
| Space z a | `:AzureAccount` | Show the active Azure account |
| Space z g | `:AzureGroups` | List resource groups |
| Space z r | `:AzureResources` | List resources |
| Space z p | `:AzurePowerShell` | Open PowerShell 7 and import Az when installed |

The account and resource commands use your current Azure sign-in.
`:AzurePowerShell` shows an installation command if Az is missing. Use
`Connect-AzAccount` inside that terminal to sign in to Azure PowerShell.

Bicep uses regular LSP shortcuts for diagnostics, completion, hover, definitions,
references, rename, and code actions. Restart Neovim after installing `bicep-ls`.
`.bicepparam` uses the Bicep parameter filetype. Bicep CLI (`bicep` or `az bicep`)
and the language server (`bicep-ls`) are separate tools.

Azure Pipelines LSP requires a workspace containing `azure-pipelines.yml` or
`azure-pipelines.yaml`. Microsoft schema patterns also cover templates in
`Azure-Pipelines/` and `Pipelines/`. General YAML uses yamlls. Terraform `.tf`
and `.tfvars` use terraform-ls; formatting requires the Terraform CLI. Bash
support applies to shell files detected as `sh` or `bash`.

Project detection also recognizes `bicepconfig.json`, pipeline files, `.terraform`,
and `main.tf`. Azure Functions debugging is an optional addition and requires
a .NET debug adapter and the relevant tools.

## CSV and TSV tables

Opening `.csv` or `.tsv` enables csvview.nvim's aligned table view with borders
and an automatically detected sticky header. CSV uses commas and TSV uses tabs.
Lines starting with `#` or `//` are treated as comments.

Space c v / `:CsvViewToggle` toggles the display. `:CsvViewEnable`,
`:CsvViewDisable`, and `:CsvViewInfo` enable, disable, or inspect it. For example:

```vim
:CsvViewEnable delimiter=; header_lnum=1
```

You can edit the file normally while the table view is active. Tab and Shift+Tab
keep their usual behavior.

## Image and PDF previews

Open a supported file in the explorer, use `:edit`, or run
`:ImagePreview path/to/image.jpg`. With no argument, `:ImagePreview` uses the
current file. Use filename completion for paths with spaces; the command accepts
the whole path without shell quotes.

Each preview opens in a separate **WezTerm tab** named after the file. Previous
previews stay open. Neovim returns to your previous code buffer instead of
displaying the image or PDF as binary text.

| Format | Viewer |
| --- | --- |
| PNG, JPG/JPEG, GIF | Direct `wezterm imgcat` |
| WebP, AVIF, SVG, BMP, TIF/TIFF | ImageMagick converts to a temporary PNG |
| PDF | ImageMagick converts page 1 to a temporary PNG |

Neovim must run inside WezTerm, with `wezterm.exe` in `PATH` and `WEZTERM_PANE`
inherited from the terminal. Extra formats need
[ImageMagick](https://imagemagick.org/script/download.php#windows).
PDF reading may need Ghostscript and a local ImageMagick policy that permits
PDF conversion. Conversion failures appear in notifications.

`:ImagePreviewClose` closes the latest preview; `:ImagePreviewCloseAll` closes
all previews created by this Neovim process. The WezTerm tab close button or
Ctrl+Shift+W can close one directly. Neovim closes its preview panes and deletes
temporary files on exit. The viewer runs through Windows Command Prompt
(`cmd.exe`).

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
vault. Note and tag completion uses the plugin's built-in language server with
Blink. Markdown rendering also works for files outside the vault.

## WezTerm and wallpapers

Sources for the included wallpapers are listed in
[image credits](nvim/backgrounds/CREDITS.md). The images from
[ThePrimeagen/anime](https://github.com/ThePrimeagen/anime) were removed because
the wallpaper collection was replaced.

Install the companion configuration at `$HOME\.wezterm.lua`. WezTerm uses
Tokyo Night colors and displays a darkened wallpaper while Neovim is active.
It restores the normal terminal appearance when Neovim exits or the selected
image is missing. The terminal window stays opaque.

| Keys or command | Action |
| --- | --- |
| Space u b / `:BackgroundPick` | Choose an image |
| Space u B / `:BackgroundFolder` | Open the image folder in Windows Explorer |
| Ctrl+Tab / Ctrl+Shift+Tab | Cycle Neovim buffers while active, terminal tabs otherwise |
| Alt+Enter | Toggle WezTerm fullscreen |
| Ctrl+Shift+L | Open the WezTerm debug overlay |

The picker searches the image folder and its subfolders for PNG,
JPG/JPEG, GIF, BMP, and WebP files. It uses fzf-lua when available and Neovim's
built-in selector otherwise. SVG files are not listed.

The default folder is Neovim's config directory plus `backgrounds`, normally
`$env:LOCALAPPDATA\nvim\backgrounds`. A selection is saved as a relative path such as
`Magi/01-Magi-Star.jpg` in `selected-background.txt`. Cancelling leaves the selection
unchanged. WezTerm checks the selection about once a second. Older selections
with absolute paths still work locally. Choosing another image saves a relative path.

To use a custom folder, set the same environment variable before launching
WezTerm and Neovim:

```powershell
$backgroundDir = Join-Path $HOME 'Pictures\Terminal Backgrounds'
New-Item -ItemType Directory -Path $backgroundDir -Force | Out-Null
[Environment]::SetEnvironmentVariable('NVIM_BACKGROUND_DIR', $backgroundDir, 'User')
```

Place images there, restart WezTerm, and choose one in Neovim. Use an absolute
directory or a `~/...` home-relative directory. Both applications must receive
the same value. WezTerm also uses `XDG_CONFIG_HOME` and
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
WezTerm's appearance, wallpaper brightness, and terminal shortcuts are set in
`WezTerminal-Config/.wezterm.lua`. Choose a locally installed Nerd Font in
WezTerm to display all icons.

Choosing a wallpaper creates a local selection file containing a relative image
path. Git ignores selections, logs, sessions, editor temporary files, and local
validation backups. It also ignores `.env` files, `.terraform/`, Terraform state
and plan files, and crash logs. Keep private vault paths and credentials in
local settings.

Ignore rules apply to untracked files. They do not remove files that Git already
tracks, and they do not filter a ZIP you create manually. Review the files you
share, especially archives and backups that may contain old private paths.

Filenames, project names, recent files, and buffer paths are visible in the
editor. Keep this in mind when sharing screenshots or your screen.

Git controls the author name and email attached to commits. To review the
identities in the repository's history, run:

```powershell
git log --all --format='%h %an <%ae>'
```

If you prefer a public alias and a GitHub noreply address for future commits,
set them for this repository. Replace both placeholders with your own values:

```powershell
git config user.name 'YOUR_PUBLIC_ALIAS'
git config user.email 'YOUR_GITHUB_NOREPLY_EMAIL'
```

Copy your actual noreply address from GitHub's email settings; see
[GitHub's commit email instructions](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-email-preferences/setting-your-commit-email-address).
Changing these settings affects future commits. Existing commits keep their
original author and committer details unless the history is rewritten.

## Plugin management

Use `:Lazy` to inspect plugin status. `:Lazy restore` returns installed plugins
to the versions recorded in `lazy-lock.json`. `:Lazy update` installs newer
versions and can change the lockfile. Keep the lockfile when sharing the config.
Plugins without a lockfile entry are installed when first needed.

Use `:Mason` to inspect language tools, `:MasonUpdate` to refresh its registry,
and `:MasonInstall` to install packages. Mason's tool-installer also requests the
configured formatters, debugpy, and Tree-sitter CLI automatically.

With the compiler available, parsers can be installed explicitly:

```vim
:TSInstall bash bicep csv hcl java json lua markdown markdown_inline powershell python query regex terraform toml tsv vim vimdoc yaml
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
| AI sessions fail | Check the CLI in PATH, use a whole count from 1 to 8, and enlarge the terminal for many splits. |
| AI underscore alias fails in a script | Use `Codex8`, `Claude8`, `CodexEnd`, or `ClaudeEnd`; underscore forms are interactive abbreviations. |
| Bicep LSP is absent | Verify `bicep-ls` in PATH and restart; installing Bicep CLI alone is insufficient. |
| Terraform formatting fails | Check `terraform version`; Mason installs the language server separately. |
| Azure shortcuts fail | Check `az version`, authentication/account, and PowerShell 7/Az for `AzurePowerShell`. |
| Image preview fails | Run Neovim inside WezTerm, check `wezterm` in PATH, and inspect `:messages`. |
| Image or PDF conversion fails | Check `magick -version`; PDF may also need Ghostscript and policy support. |

If an external program is missing, Neovim shows a notification. Use `:messages`
or Space u n to review notifications you missed.

## Validate the configuration

Run these from the repository folder in PowerShell. They do not install plugins
or change your active Neovim configuration:

```powershell
nvim --headless -u NONE -i NONE -n -l tools/verify-config.lua
wezterm --config-file '.\WezTerminal-Config\.wezterm.lua' show-keys
```

The first command checks Lua syntax, documentation links, and shortcuts. It also
tests path handling with sample Windows profiles, wallpaper selection,
debugger loading, Obsidian settings, parser installation retries, Java caches,
cloud tools, AI sessions, and preview commands.

These checks simulate plugin behavior. Test interactive features in your normal
Neovim session as well. The second command loads the WezTerm configuration and
prints its keybindings.
