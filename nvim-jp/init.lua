-- Independent Japanese-writing profile. Does not import coding plugins.
vim.g.mapleader = " "
vim.g.maplocalleader = ","
if vim.fn.has("nvim-0.12") == 0 then
  error("Japanese profile requires Neovim 0.12 or newer for its pinned Markdown plugins")
end
require("jp.core").setup()
require("jp.plugins").setup()
require("jp.commands").setup()
