# Background images for Windows

Put your wallpapers in this folder or its subfolders. The picker supports PNG,
JPG/JPEG, GIF, BMP, and WebP files. Sources for the included images are listed
in [CREDITS.md](CREDITS.md).

The images from [ThePrimeagen/anime](https://github.com/ThePrimeagen/anime)
were removed because the wallpaper collection was replaced. The credits file
keeps a link to that earlier collection.

## Choose a wallpaper

Inside Neovim, use these commands or shortcuts:

| Command | Keys | Action |
| --- | --- | --- |
| `:BackgroundPick` | Space u b | Choose a wallpaper |
| `:BackgroundFolder` | Space u B | Open the image folder in Windows Explorer |

The picker searches this folder and its subfolders. It uses fzf-lua when
available, or Neovim's built-in selector otherwise. SVG files are not listed.

Your choice is saved in `selected-background.txt` as a **relative image path**,
such as `Magi/01-Magi-Star.jpg`. Git ignores this generated file. Cancelling
the picker keeps your previous choice.

## Use a different image folder

The default folder is Neovim's `stdpath("config")` plus `backgrounds`, normally
`$env:LOCALAPPDATA\nvim\backgrounds` on Windows. Set `NVIM_BACKGROUND_DIR` to the
same absolute directory, or the same `~/...` home-relative directory, in
Neovim and WezTerm. Restart both applications after changing the variable.

## Display the wallpaper in WezTerm

Install the included
[`WezTerminal-Config/.wezterm.lua`](../../WezTerminal-Config/.wezterm.lua)
at `$HOME\.wezterm.lua`. WezTerm reads your selection and displays a darkened
wallpaper while Neovim is active. The terminal window stays opaque, and the
image is dimmed to keep text readable.

An empty selection or a missing image restores the normal terminal appearance.
Older selections that contain an absolute path still work locally. Choosing
another wallpaper replaces that path with a relative one.

See the [Windows manual](../../MANUAL.md#wezterm-and-wallpapers) and the
[current image sources](CREDITS.md).
