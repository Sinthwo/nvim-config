# Neovim and WezTerm configuration for Windows

**Languages:** English | [Français](README.fr.md) | [Deutsch](README.de.md) | [日本語](README.ja.md)

A Windows setup for Neovim, PowerShell, and WezTerm, with a file explorer,
completion, language servers, Git tools, and Python debugging.

Optional tools add cloud development, AI terminal sessions, Markdown and
Obsidian workflows, Japanese writing, image previews, and wallpapers.
See the [Windows user manual](MANUAL.md) for the full reference.

**Quick links:** [Install on Windows](#install-on-windows) · [First successful session](#first-successful-session) · [Updating and restoring](MANUAL.md#updating-and-restoring) · [Useful shortcuts](#useful-shortcuts) · [Optional features](#optional-features) · [Files and sharing](#files-and-sharing)

## Screenshots

| Startup dashboard | Editor and file explorer |
| --- | --- |
| [![Neovim startup dashboard with a shark logo and shortcuts](docs/screenshots/dashboard.png)](docs/screenshots/dashboard.png) | [![Neovim editing a Lua file beside the file explorer](docs/screenshots/editor-explorer.png)](docs/screenshots/editor-explorer.png) |

Browse all 31 screenshots in the [feature gallery](docs/screenshots/README.md),
including the wallpaper manager and Japanese writing profile.

## Requirements

- [Neovim](https://github.com/neovim/neovim/releases) **0.12 or newer**.
- [Git for Windows](https://git-scm.com/downloads/win), [fzf](https://github.com/junegunn/fzf),
  and [ripgrep](https://github.com/BurntSushi/ripgrep) available in `PATH`.
- [WezTerm](https://wezterm.org/installation.html) for the terminal wallpaper
  and `Ctrl+Tab` integration; Neovim also works without those terminal features.
- PowerShell 7 is the preferred shell. Windows PowerShell is also supported for
  editor services and the CPU status indicator.
- For syntax parsers: Tree-sitter CLI **0.26.1 or newer**, `curl`, `tar`, and a
  C compiler in `PATH`, such as MSVC in a Developer PowerShell session or Clang.
  These match the [pinned Tree-sitter requirements](https://github.com/nvim-treesitter/nvim-treesitter/blob/a2f694478be07f89c2d03cc17858a8745a400c4b/README.md).
- Python, Node.js/npm, and a JDK as needed for the language tools described
  in the manual. A Nerd Font is optional for displaying icons.

## Install on Windows

Download this repository or clone it from PowerShell:

```powershell
git clone https://github.com/Sinthwo/nvim-config.git
Set-Location -LiteralPath '.\nvim-config'
```

Close Neovim, then open PowerShell in the repository folder and run the commands
below. Any existing configuration is moved to a timestamped backup before the
new files are copied. Installed plugin data is kept.

The commands stop on file-operation errors. Keep the printed backup path.
For an existing installation, read [Updating and restoring](MANUAL.md#updating-and-restoring)
before replacing files; it explains how to keep local settings.

```powershell
# Ask the executable directly, bypassing any PowerShell profile launcher.
$nvimDir = (& nvim.exe --headless -u NONE -i NONE -n --cmd 'lua io.write(vim.fn.stdpath("config"))' +qa).Trim()
if ($LASTEXITCODE -ne 0 -or -not $nvimDir) { throw 'Could not find the Neovim config directory.' }
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$nvimBackup = "$nvimDir.backup-$stamp"
if (Test-Path -LiteralPath $nvimDir) {
    Move-Item -LiteralPath $nvimDir -Destination $nvimBackup -ErrorAction Stop
    Write-Host "Neovim backup: $nvimBackup"
}
New-Item -ItemType Directory -Path (Split-Path -Parent $nvimDir) -Force -ErrorAction Stop | Out-Null
Copy-Item -LiteralPath '.\nvim' -Destination $nvimDir -Recurse -ErrorAction Stop
```

### Optional: WezTerm configuration

Run this separate block only if you want to replace your WezTerm configuration.
It saves the existing file first.

```powershell
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$weztermFile = Join-Path $HOME '.wezterm.lua'
if (Test-Path -LiteralPath $weztermFile) {
    $weztermBackup = "$weztermFile.backup-$stamp"
    Move-Item -LiteralPath $weztermFile -Destination $weztermBackup -ErrorAction Stop
    Write-Host "WezTerm backup: $weztermBackup"
}
Copy-Item -LiteralPath '.\WezTerminal-Config\.wezterm.lua' -Destination $weztermFile -ErrorAction Stop
```

Neovim normally uses `$env:LOCALAPPDATA\nvim`. WezTerm reads
`$HOME\.wezterm.lua`. Restart WezTerm, launch `nvim`, and allow the initial
plugin and tool downloads to finish. Open a source file to trigger language
server installation. Restart Neovim after the first installation, then run
`:checkhealth` and `:Mason`.

## First successful session

Open WezTerm in a disposable Git project, then run `nvim README.md`. Wait for
the initial downloads, restart Neovim, and return to that project. Use Normal
mode (`Esc`) for the shortcuts below; press each Space sequence one key at a time.

| Try | Expected result |
| --- | --- |
| Press `Space f f`, type part of a filename, then `Enter` | The file picker opens the selected file. |
| Press `Space f g` and search for text you know exists | Matches appear with a preview; `Esc` closes the picker. |
| Press `i`, make a small edit, then `Esc` and `Ctrl+S` | The file is saved; its modified indicator clears. |
| Open a Lua file and press `Space c f` | StyLua formats it once its Mason installation has finished. |
| Press `Space g g` | Neogit shows the project's changed files; use `:close` to return. |

Use a practice file for editing and formatting. If an action fails, check
`:messages`, `:Mason`, and `:ConformInfo`, then see [Troubleshooting](MANUAL.md#troubleshooting).
The [manual](MANUAL.md) explains the other commands.

## Useful shortcuts

The leader key is **Space**. Press the listed keys in sequence; for example,
`Space f f` opens the file picker. Press Space and wait to see Which-Key help.

| Keys | Action |
| --- | --- |
| `Ctrl+S` | Save the current file |
| `Ctrl+B` | Toggle the file explorer |
| `Ctrl+P` / `Space f f` | Find a file |
| `Space f g` | Search text in the project |
| `Ctrl+Tab` / `Ctrl+Shift+Tab` | Next / previous file in WezTerm |
| `Space b c` | Close the current file |
| `Space c f` | Format the current file |
| `Space g g` | Open Git status |
| `Space u b` | Choose a terminal background |
| `Space t t` | Toggle a project terminal |
| `Space c v` | Toggle CSV/TSV table view |
| `Space z t` | Open an Azure project terminal |

Use `:Codex 8` or `:Claude 8` to open eight independent CLI sessions in a
dedicated Neovim tab. Opening an image or PDF creates a separate WezTerm preview
tab. Install the required external tools before using these features; see the
[manual](MANUAL.md#ai-session-workspaces) and
[cloud setup guide](nvim/SETUP-CLOUD-TOOLS.md).

## Optional features

Review changes with `:CodeDiff` or `:MiniDiffOverlay`, toggle split filenames
with `:InclineToggle`, and open an editable directory buffer with `:Oil`.
Use `:AICopyPath` or `:AICopyContext` to copy code references for AI tools.
Web and Markdown formatting uses prettierd or prettier when available.
See the [upgrade notes](nvim/UPGRADE_NOTES.md) for usage and installation details.

`Space u b` opens a wallpaper manager with folder browsing, favorites, shuffle,
and startup modes. Random startup rotation is the default; choose Manual in
Settings to keep an image. `Space m p` toggles browser Markdown/Mermaid preview.

The optional `nvim-jp/` profile adds Japanese writing, vocabulary, Kana/Kanji
practice, and Obsidian notes. The PowerShell launcher offers Coding/Japanese
when interactive `nvim` has no arguments; use `nvim-code` or `nvim-jp` directly.
See the [profile installation guide](NeovimProfiles/README.md) and
[manual](MANUAL.md#japanese-writing-profile). Personal profile settings, favorites,
and startup mode are ignored by Git.

The startup dashboard provides shortcuts for files, search, plugins, and
terminals. See [dashboard and notifications](MANUAL.md#dashboard-and-notifications)
for its commands, and [AI session workspaces](MANUAL.md#ai-session-workspaces)
for focusing and enlarging running sessions.

## Files and sharing

- `nvim/` is the Neovim configuration to install.
- `WezTerminal-Config/.wezterm.lua` is the companion Windows terminal config.
- [MANUAL.md](MANUAL.md) explains all configured features and local settings.
- `nvim/lazy-lock.json` records plugin revisions; keep it when sharing the config.

Source repository: [Sinthwo/nvim-config](https://github.com/Sinthwo/nvim-config).
Paths resolve for the current Windows user; no fixed username or drive letter
is needed.

Wallpaper selections use paths relative to the image folder. Git ignores the
selection file, logs, temporary files, local environment files, and Terraform
state and plan files. Set personal paths through local environment variables
such as `OBSIDIAN_VAULT` and `NVIM_BACKGROUND_DIR`.

Sources for the current images are listed in
[wallpaper credits](nvim/backgrounds/CREDITS.md).

Before sharing new changes, run the [validation commands](MANUAL.md#validate-the-configuration)
and review any personal customization you added.
