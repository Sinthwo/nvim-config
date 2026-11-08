vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.filetypes")
require("config.lazy")
require("config.autocmds")
require("config.keymaps")
require("config.background").setup()
-- Extra commands do not affect existing keymaps or wallpaper controls.
require("config.ai_context").setup()
