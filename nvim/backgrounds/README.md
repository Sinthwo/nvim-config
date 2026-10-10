# Background images for Windows

Sources for the current images are listed in [CREDITS.md](CREDITS.md).
The owner deleted the previous [ThePrimeagen/anime](https://github.com/ThePrimeagen/anime)
images from this collection; the historical credit remains in that document.

Put your wallpaper images in this folder.

Supported by the included picker:

- PNG
- JPG / JPEG
- GIF
- BMP
- WEBP

Inside Neovim:

- `:BackgroundPick` chooses an image.
- `<Space>ub` does the same.
- `:BackgroundFolder` opens this folder in Explorer.
- `<Space>uB` opens this folder in Explorer.

The selected **relative image path**, rather than a user-specific absolute path, is written
to `selected-background.txt`. This generated file is ignored by Git.

The default folder is Neovim's `stdpath("config")` plus `backgrounds`, normally
`$env:LOCALAPPDATA\nvim\backgrounds` on Windows. Set `NVIM_BACKGROUND_DIR` to the
same absolute directory (or `~/...` home-relative directory) for Neovim and
WezTerm to use a different location. Restart both after changing their environment.

The picker searches this folder and subfolders recursively using fzf-lua when
available, with a built-in selector fallback. SVG files are not listed.
Selections retain subfolders, for example `Magi/01-Magi-Star.jpg`.

Neovim itself cannot draw a real image *behind* terminal text. The included
[`WezTerminal-Config/.wezterm.lua`](../../WezTerminal-Config/.wezterm.lua) reads this file and renders the selected image as an
opaque, darkened terminal background. The terminal window itself remains fully
opaque; only the image brightness is reduced for readability.

Install that config at `$HOME\.wezterm.lua`. The wallpaper appears while Neovim
is active. A missing image or an empty selection restores the normal terminal
appearance. Existing local absolute selections remain supported; choosing an
image again saves only its relative path. Cancelling leaves the selection unchanged.

Three supplied files were WebP data under `.jpg`/`.jpeg` names. They now have
`.webp` extensions so the picker and terminal can identify them correctly.

See the [Windows manual](../../MANUAL.md#wezterm-and-wallpapers) and the
[current image sources](CREDITS.md).
