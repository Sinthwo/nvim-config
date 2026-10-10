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
| YAML / Azure Pipelines | yamlls, azure_pipelines_ls | Node.js/npm |
| Bash / shell scripts | bashls, shfmt | Node.js/npm for the server; Bash for running scripts |
| Terraform / HCL | terraformls, terraform_fmt | Terraform CLI for formatting and validation |
| Azure Bicep / parameters | bicep-ls | .NET SDK and separately installed Bicep language server |
| CSV / TSV | csvview.nvim and syntax parsers | No external server required |
| Syntax highlighting | Tree-sitter parsers | Tree-sitter CLI, curl, tar, C compiler |

Java's server runtime requirements come from [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls#configuration).
The project itself can target a different Java version. Maven and Gradle
projects receive fuller support than standalone Java files.

Open `:Mason` to inspect installation state. To explicitly request the configured
tools, use:

```vim
:MasonInstall basedpyright ruff powershell-editor-services jdtls lua-language-server debugpy stylua prettier tree-sitter-cli
:MasonInstall bash-language-server yaml-language-server terraform-ls azure-pipelines-language-server shfmt
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
JSON/YAML use Prettier, Bash uses shfmt, and Terraform uses `terraform fmt`.
Other languages fall back to an attached language
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

## AI session workspaces

Install the external [Codex CLI](https://learn.chatgpt.com/docs/codex/cli) and/or
[Claude Code](https://code.claude.com/docs/en/setup), sign in using their own
instructions, and check `codex --version` / `claude --version` in the terminal
used to start Neovim. The setup uses the Windows commands found in `PATH`.
Space a c / Space a C still open one Snacks terminal. Multi-session commands
create a dedicated **Neovim tab page**:

| Command | Action |
| --- | --- |
| `:Codex` / `:Claude` | Open one CLI session |
| `:Codex 8` / `:Claude 8` | Open eight independent sessions |
| `:Codex1` through `:Codex8` | Open the specified number of Codex sessions |
| `:Claude1` through `:Claude8` | Open the specified number of Claude sessions |
| `:CodexEnd` / `:ClaudeEnd` | Close the family's AI workspace tabs |

Counts must be whole numbers from 1 to 8. `:Codex_8`, `:Claude_8`,
`:Codex_End`, and `:Claude_End` are interactive command-line abbreviations.
Use the forms without underscores in scripts and mappings.

Code stays in its original tab. Bufferline hides file tabs in the AI workspace.
One session fills the tab; two stack vertically; three to eight use two balanced
columns. Each process starts at the current project root. Use `gt` / `gT` to
switch Neovim tabs, Ctrl+H/J/K/L to focus a split in normal mode, `i` to enter
terminal input, and Esc twice to return to normal mode. Eight splits require a
sufficiently large terminal.

End commands close that family's workspace tabs, wipe their terminal buffers,
and return to the original coding tab when it exists. Closing a session ends
its process. CLI authentication, permissions, and account usage are controlled
by the external programs.

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

These account/resource shortcuts display information using your existing Azure
sign-in. `AzurePowerShell` reports how to install Az when it is missing; run
`Connect-AzAccount` yourself to authenticate.

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
and `main.tf`, with corresponding UI language labels. `azfunc.nvim` remains
optional; no .NET isolated Azure Functions debug adapter is configured.

## CSV and TSV tables

Opening `.csv` or `.tsv` enables csvview.nvim's aligned table view with borders
and an automatically detected sticky header. CSV uses commas and TSV uses tabs.
Lines starting with `#` or `//` are treated as comments.

Space c v / `:CsvViewToggle` toggles the display. `:CsvViewEnable`,
`:CsvViewDisable`, and `:CsvViewInfo` enable, disable, or inspect it. For example:

```vim
:CsvViewEnable delimiter=; header_lnum=1
```

The underlying text remains editable. CSV adds no Tab or Shift+Tab mappings.

## Image and PDF previews

Open a supported file in the explorer, use `:edit`, or run
`:ImagePreview path/to/image.jpg`. With no argument, `:ImagePreview` uses the
current file. Use filename completion for paths with spaces; the command accepts
the whole path without shell quotes.

Each preview opens and activates a separate **WezTerm tab** titled with the
filename. Earlier previews stay open. Neovim intercepts the binary file before
reading it and returns to the previous code buffer. Previews are separate from
Neovim's Bufferline and AI workspace tabs.

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
temporary files on exit. The viewer uses the current Windows `%COMSPEC%`/`cmd.exe`,
so it does not depend on PowerShell. Snacks.image stays disabled, and the image
plugin stub declares no rendering plugin.

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

See [image credits](nvim/backgrounds/CREDITS.md) for the current supplied collection.
The previous [ThePrimeagen/anime](https://github.com/ThePrimeagen/anime)
wallpapers have been replaced by the images from the updated configuration.

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

The picker recursively searches this folder and its subfolders for PNG,
JPG/JPEG, GIF, BMP, and WebP files. It uses fzf-lua when available and otherwise
falls back to `vim.ui.select`. SVG is not listed. Three supplied images contained
WebP data under JPEG names; their extensions now match their contents, without
re-encoding. PNG and JPEG are good choices for terminal compatibility.

The default folder is Neovim's config directory plus `backgrounds`, normally
`$env:LOCALAPPDATA\nvim\backgrounds`. A selection is saved as a relative path such as
`Magi/01-Magi-Star.jpg` in `selected-background.txt`. Cancelling leaves the selection
unchanged. WezTerm reads the choice about once a second. Old absolute selections
still work locally; selecting an image again replaces them with a relative path.

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

The picker saves only a relative image path; its local selection file is optional and is
created when you choose a background. Generated selections,
logs, sessions, and editor temporary files are ignored by Git. `.gitignore`
does not exclude files from a hand-made ZIP or remove files already tracked:
review what you actually share. Keep private vault paths and credentials in
local settings. The original import ZIP and `.validation/` backups are ignored;
these local inputs can contain old private paths and must also be excluded from
a manually prepared ZIP. Image provenance is recorded in the credits file,
and the asset folder has no nested local Git history.

Cloud state and local environment files (`.env`, `.terraform/`, `*.tfstate`,
`*.tfplan`, and crash logs) are ignored. Ignore rules do not sanitize files
already tracked by Git. Keep credentials and private cloud values out of Lua,
Markdown, and Terraform examples that you publish.

Ordinary filenames, project names, recent-file lists, and buffer paths remain
visible during use. This setup cleans shared configuration files rather than
providing a screen-sharing privacy mode. Git author details for commits are
controlled by your own Git settings.

Before committing, inspect the author metadata as well as the files:

```powershell
git log --all --format='%h %an <%ae>'
git config user.name 'YOUR_PUBLIC_ALIAS'
git config user.email 'YOUR_GITHUB_NOREPLY_EMAIL'
```

Copy your actual noreply address from GitHub's email settings; do not leave the
placeholder as your email. See [GitHub's commit email instructions](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-email-preferences/setting-your-commit-email-address).
These settings affect future commits. Existing commits retain their original
author and committer details; deleting personal paths from files does not erase
that history. Review it before publishing. Removing identity from existing
history is a separate Git history rewrite, which this cleanup does not perform.

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
It also checks documentation links and shortcut coverage.
The suite also covers recursive/fzf wallpaper picking, cloud/filetype settings,
AI workspace commands, and preview arguments/cleanup using test doubles.
WezTerm's command loads the real terminal config without opening a new terminal window.
