# Neovim review upgrades (7 November 2026)

These changes preserve **all existing keybindings**, `config/background.lua`, the wallpaper assets, WezTerm behaviour, the Codex/Claude workspaces, Neo-tree, existing Git UI and your Japanese profile.

## New tools

Run `:Lazy sync` to install the added plugins. CodeDiff and Oil load on command;
MiniDiff loads when opening or creating a file, and Incline loads after startup.

- `:CodeDiff` — review working-tree changes side by side. `:CodeDiff history %` reviews the current file. Your existing Diffview commands still work.
- `:MiniDiffOverlay` — show/hide inline Git changes. MiniDiff uses the line-number column, leaving Gitsigns sign markers enabled.
- `:InclineToggle` — show/hide floating filenames for splits. Single-window labels are hidden.
- `:Oil` — open the directory in an editable buffer. Neo-tree remains the default sidebar and keeps Ctrl+B.
- `:AICopyPath` — copy relative filename with current line number, such as `src/app.ts#L42`.
- `:AICopyContext` — copy the current line with filename and fenced code.
- `:'<,'>AICopyContext` — visually select complete lines, then issue the command to copy the range (Neovim automatically inserts `'<,'>` when pressing `:` in Visual mode).

## Formatting

Added Conform formatter selection for JS/JSX, TS/TSX, CSS/SCSS, HTML, Markdown/MDX and Astro, using `prettierd` if present or falling back to `prettier`. The existing `<leader>cf` mapping is unchanged. These additions do not enable automatic format-on-save.

For Astro formatting, install `prettier` plus `prettier-plugin-astro` in the relevant project if needed; formatter availability depends on installed tools and project configuration.

## Install

1. Back up your current `%LOCALAPPDATA%\nvim`.
2. Copy the updated `nvim` directory into `%LOCALAPPDATA%\nvim`.
3. Start Neovim and run `:Lazy sync`, followed by `:checkhealth`.
4. Try `:CodeDiff`, `:MiniDiffOverlay`, `:InclineToggle`, and `:AICopyContext`.

CodeDiff includes a platform-specific diff library. On Windows it may download a supported DLL during installation; see its upstream instructions if security tools block it.

## Validation/limitations

The repository imports the improved configuration and uses `lua/config/lazy.lua`
from the separate Windows healthcheck patch. LuaRocks support is disabled there.
Machine-local wallpaper selections, favorites, and startup mode are not imported.

Integration retains newer repository fixes for portable wallpaper paths, profile
and PowerShell discovery, quoted process arguments, AI workspace cleanup, debugger
dependencies, Java workspace isolation, and Obsidian settings. The existing dashboard
and WezTerm module interface are retained together, including small-window behavior.
Duplicate buffer-close mappings from the archive are omitted. Existing wallpaper
documentation and source catalogs are retained; the README and manual in all four
languages describe the new tools.

The repository checks validate Lua syntax and existing configuration behavior without
downloading plugins. The AI context commands are also checked in a headless Neovim
session. Interactive plugin installation and Windows GUI behavior still need checking
with `:Lazy` and `:checkhealth` after installation.
