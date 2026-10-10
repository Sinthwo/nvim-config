-- Image previews are intentionally handled without an image-rendering plugin.
-- Stable WezTerm's own `wezterm imgcat` implementation renders the image in a
-- real WezTerm pane, avoiding Kitty/Sixel passthrough limitations on Windows.
return {}
