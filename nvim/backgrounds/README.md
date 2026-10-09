# Background images for Windows

The bundled background images come from
[ThePrimeagen/anime](https://github.com/ThePrimeagen/anime).

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

The selected **filename**, rather than a user-specific absolute path, is written
to `selected-background.txt`. This generated file is ignored by Git.

The default folder is Neovim's `stdpath("config")` plus `backgrounds`, normally
`$env:LOCALAPPDATA\nvim\backgrounds` on Windows. Set `NVIM_BACKGROUND_DIR` to the
same absolute directory (or `~/...` home-relative directory) for Neovim and
WezTerm to use a different location. Restart both after changing their environment.

The picker lists only this folder's images. Place additional images directly in
this folder; the picker does not search subfolders. SVG files are not listed.

Neovim itself cannot draw a real image *behind* terminal text. The included
[`WezTerminal-Config/.wezterm.lua`](../../WezTerminal-Config/.wezterm.lua) reads this file and renders the selected image as an
opaque, darkened terminal background. The terminal window itself remains fully
opaque; only the image brightness is reduced for readability.

Install that config at `$HOME\.wezterm.lua`. The wallpaper appears while Neovim
is active. A missing image or an empty selection restores the normal terminal
appearance. Existing local absolute selections remain supported; choosing an
image again saves only its filename.

See the [Windows manual](../../MANUAL.md#wezterm-and-wallpapers) and the
[source repository and image credits](https://github.com/ThePrimeagen/anime).
