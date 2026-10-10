# Completed configuration tasks for Windows

This checklist records the features in the supplied new config and the privacy
and portability fixes carried over from the earlier repository. External CLI
installation and account sign-in remain local setup steps.

## Features from the updated config

- [x] Image/PDF previews use `wezterm imgcat` in separate WezTerm tabs.
- [x] Multiple previews remain open independently, with close/latest/all commands.
- [x] Supported binary files are intercepted before Neovim reads them as text.
- [x] Codex and Claude support one to eight independent terminal sessions.
- [x] AI sessions use a dedicated Neovim tab; code remains in its original tab.
- [x] End commands close each CLI family's workspace tabs and return to code.
- [x] Bufferline hides normal file tabs in AI workspaces.
- [x] Bufferline mouse/X closing uses Snacks' safe buffer deletion when available.
- [x] Transparency preserves foreground colors and text styles, with a Normal foreground fallback.
- [x] Snacks keeps priority 1000; its image renderer stays disabled.
- [x] Recursive wallpaper discovery prefers fzf-lua with a native selector fallback.
- [x] Terraform/HCL filetypes, parsers, language server, and CLI formatting.
- [x] YAML/YML language server and Prettier formatting.
- [x] Azure Pipelines language server and Microsoft schema integration.
- [x] Bash language server, parser mapping, and shfmt formatting.
- [x] CSV/TSV aligned table view with sticky headers and Space c v.
- [x] Bicep/Bicep parameters, parser mapping, and external `bicep-ls` support.
- [x] Azure CLI commands and Az-module PowerShell terminal through Snacks.
- [x] Project roots and status labels cover the additional cloud/file types.
- [x] Azure Functions debugging remains optional, as described in the supplied task summary.
- [x] The owner removed the previous ThePrimeagen/anime wallpaper collection.
- [x] Ten replacement wallpapers are included with the owner's source links.
- [x] Three WebP files now have matching `.webp` extensions; image bytes are unchanged.

## Privacy and portability carried forward

- [x] Current-user directories use `stdpath()`, home helpers, and environment variables.
- [x] Shared PowerShell discovery uses PATH, ProgramFiles, and SystemRoot.
- [x] `NVIM_BACKGROUND_DIR` works in Neovim and WezTerm.
- [x] Wallpaper selections save relative paths, retaining subfolders.
- [x] Legacy local absolute selections still work; missing images reset terminal appearance.
- [x] PowerShell service paths handle spaces and apostrophes.
- [x] Azure PowerShell receives an argument list, preserving script variables.
- [x] Preview scripts quote paths, disable delayed expansion, and avoid shell commands from filenames.
- [x] Debugger UI loads with DAP without a circular dependency.
- [x] Buffer-close shortcuts are defined only in keymaps.lua.
- [x] Obsidian vault overrides are expanded and obsolete completion flags are removed.
- [x] Parser installation retries after Mason's tool installer finishes.
- [x] Equally named Java projects get distinct workspace caches.
- [x] Existing plugin lock revisions are preserved.
- [x] The original ZIP and local validation/backups are ignored.
- [x] Runtime selections, logs, editor files, environment files, and cloud state/plans are ignored.

See the [Windows manual](../MANUAL.md), [cloud setup guide](SETUP-CLOUD-TOOLS.md),
and [wallpaper credits](backgrounds/CREDITS.md) for current behavior.
