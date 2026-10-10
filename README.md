# Neovim and WezTerm configuration for Windows

**This configuration is for Windows.** It combines Neovim, PowerShell, and
WezTerm with a file explorer, completion, language servers, Git tools, Python
debugging, Markdown rendering, optional Obsidian integration, Azure/Bicep,
Terraform, YAML, Bash, CSV/TSV tables, AI session tabs, and image/PDF previews.

Source repository: [Sinthwo/nvim-config](https://github.com/Sinthwo/nvim-config).

Paths are resolved for the current Windows user. You do not need to put your
username or a fixed drive letter into the configuration.

Read the [Windows user manual](MANUAL.md) for the complete shortcut reference,
language setup, backgrounds, customization, and troubleshooting.

## Requirements

- [Neovim](https://github.com/neovim/neovim/releases) **0.12 or newer**.
- [Git for Windows](https://git-scm.com/downloads/win), [fzf](https://github.com/junegunn/fzf),
  and [ripgrep](https://github.com/BurntSushi/ripgrep) available in `PATH`.
- [WezTerm](https://wezterm.org/installation.html) for the terminal wallpaper
  and Ctrl+Tab integration; Neovim also works without those terminal features.
- PowerShell 7 for the preferred shell; Windows PowerShell is a fallback for
  editor services and the CPU status indicator.
- For syntax parsers: Tree-sitter CLI **0.26.1 or newer**, `curl`, `tar`, and a
  C compiler in `PATH`, such as MSVC in a Developer PowerShell session or Clang.
  These match the [pinned Tree-sitter requirements](https://github.com/nvim-treesitter/nvim-treesitter/blob/e289100ff98969e118c702199d88b764ce9e7fdf/README.md).
- Python, Node.js/npm, and a JDK as needed for the language tools described
  in the manual. A Nerd Font is optional for displaying icons.

## Install on Windows

Download this repository or clone it from PowerShell:

```powershell
git clone https://github.com/Sinthwo/nvim-config.git
Set-Location -LiteralPath '.\nvim-config'
```

Close Neovim before replacing an existing installation. Open PowerShell in
the repository folder and run the following. Existing configuration
files are moved to timestamped backups first; plugin data is kept.

```powershell
# Ask Neovim for its actual config directory, including environment overrides.
$nvimDir = (& nvim --headless -u NONE -i NONE -n --cmd 'lua io.write(vim.fn.stdpath("config"))' +qa).Trim()
if ($LASTEXITCODE -ne 0 -or -not $nvimDir) { throw 'Could not find the Neovim config directory.' }
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
if (Test-Path -LiteralPath $nvimDir) {
    Move-Item -LiteralPath $nvimDir -Destination "$nvimDir.backup-$stamp"
}
New-Item -ItemType Directory -Path (Split-Path -Parent $nvimDir) -Force | Out-Null
Copy-Item -LiteralPath '.\nvim' -Destination $nvimDir -Recurse

# Optional: install the companion WezTerm configuration.
$weztermFile = Join-Path $HOME '.wezterm.lua'
if (Test-Path -LiteralPath $weztermFile) {
    Move-Item -LiteralPath $weztermFile -Destination "$weztermFile.backup-$stamp"
}
Copy-Item -LiteralPath '.\WezTerminal-Config\.wezterm.lua' -Destination $weztermFile
```

The usual Neovim destination is `$env:LOCALAPPDATA\nvim`. WezTerm reads
`$HOME\.wezterm.lua`. Restart WezTerm, launch `nvim`, and allow the initial
plugin and tool downloads to finish. Open a source file to trigger language
server installation. Restart Neovim after the first installation, then run
`:checkhealth` and `:Mason`.

## First shortcuts

The leader key is **Space**. Press the listed keys in sequence; for example,
`Space f f` opens the file picker. Press Space and wait to see Which-Key help.

| Keys | Action |
| --- | --- |
| Ctrl+S | Save the current file |
| Ctrl+B | Toggle the file explorer |
| Ctrl+P / Space f f | Find a file |
| Space f g | Search text in the project |
| Ctrl+Tab / Ctrl+Shift+Tab | Next / previous file in WezTerm |
| Space b c | Close the current file |
| Space c f | Format the current file |
| Space g g | Open Git status |
| Space u b | Choose a terminal background |
| Space t t | Toggle a project terminal |
| Space c v | Toggle CSV/TSV table view |
| Space z t | Open an Azure project terminal |

Use `:Codex 8` or `:Claude 8` for up to eight independent CLI sessions in a
dedicated Neovim tab. Opening an image or PDF creates a separate WezTerm preview
tab. These optional features need their external tools; see the
[manual](MANUAL.md#ai-session-workspaces),
[cloud setup guide](nvim/SETUP-CLOUD-TOOLS.md), and
[completed task list](nvim/TODO-COMPLETED.md).

## Files and sharing

- `nvim/` is the Neovim configuration to install.
- `WezTerminal-Config/.wezterm.lua` is the companion Windows terminal config.
- [MANUAL.md](MANUAL.md) explains all configured features and local settings.
- `nvim/lazy-lock.json` records plugin revisions; keep it when sharing the config.

Wallpaper selections contain a path relative to the image folder, and `.gitignore` excludes them along
with logs and temporary files. Personal paths belong in local environment
variables, such as `OBSIDIAN_VAULT` and `NVIM_BACKGROUND_DIR`.

The current wallpaper collection comes from the supplied updated configuration.
See [image credits](nvim/backgrounds/CREDITS.md). Earlier releases used
[ThePrimeagen/anime](https://github.com/ThePrimeagen/anime); that collection has
been replaced. The original import ZIP is kept locally and ignored because it
contains an old user-specific path. Local environment files and Terraform
state/plan files are also ignored.

Before sharing new changes, run the [validation commands](MANUAL.md#validate-the-configuration)
and review any personal customization you added.
