-- =========================================================
-- Neovim Options
-- =========================================================

local opt = vim.opt

-- =========================================================
-- Line numbers
-- =========================================================

-- Current line = absolute number
-- Other lines = relative distance
--
-- Example:
--
--  5
--  4
--  3
--  2
--  1
-- 17  <- current line
--  1
--  2
--  3
--  4
--
opt.number = true
opt.relativenumber = true

-- Highlight current line
opt.cursorline = true

-- Keep sign column permanently visible
-- Prevents the editor shifting when Git/LSP signs appear
opt.signcolumn = "yes"

-- =========================================================
-- Mouse
-- =========================================================

opt.mouse = "a"

-- =========================================================
-- Clipboard
-- =========================================================

-- Use Windows system clipboard
opt.clipboard = "unnamedplus"

-- =========================================================
-- Tabs / indentation
-- =========================================================

opt.expandtab = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4

opt.smartindent = true
opt.autoindent = true

-- =========================================================
-- Search
-- =========================================================

-- Ignore case normally
opt.ignorecase = true

-- But become case-sensitive when uppercase characters
-- are used in the search
opt.smartcase = true

-- Highlight matches
opt.hlsearch = true

-- Show matches while typing
opt.incsearch = true

-- =========================================================
-- Scrolling
-- =========================================================

-- Keep context above/below cursor
opt.scrolloff = 8

-- Keep horizontal context
opt.sidescrolloff = 8

-- Smooth horizontal scrolling
opt.sidescroll = 1

-- =========================================================
-- Splits
-- =========================================================

-- New horizontal split opens below
opt.splitbelow = true

-- New vertical split opens right
opt.splitright = true

-- =========================================================
-- Text display
-- =========================================================

opt.wrap = false

-- Better wrapped-line behaviour when enabled locally
opt.linebreak = true

-- Don't visually break words
opt.breakindent = true

-- Show invisible characters
opt.list = true

opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
}

-- =========================================================
-- Command line
-- =========================================================

-- Command line height
opt.cmdheight = 1

-- Better completion menu
opt.completeopt = {
  "menu",
  "menuone",
  "noselect",
}

-- =========================================================
-- Statusline
-- =========================================================

-- One global statusline
opt.laststatus = 3

-- =========================================================
-- Editing
-- =========================================================

-- Backspace behaves normally
opt.backspace = {
  "indent",
  "eol",
  "start",
}

-- Allow cursor slightly beyond text in visual block mode
opt.virtualedit = "block"

-- Don't continue comments automatically
opt.formatoptions:remove({
  "c",
  "r",
  "o",
})

-- =========================================================
-- Undo
-- =========================================================

opt.undofile = true

-- More undo history
opt.undolevels = 10000

-- =========================================================
-- Swap / backup
-- =========================================================

opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- =========================================================
-- Performance
-- =========================================================

-- Faster CursorHold / plugin reactions
opt.updatetime = 250

-- Faster mapped-key timeout
opt.timeout = true
opt.timeoutlen = 400

-- =========================================================
-- Colours
-- =========================================================

-- Full terminal colours
opt.termguicolors = true

-- =========================================================
-- Encoding
-- =========================================================

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- =========================================================
-- Window title
-- =========================================================

opt.title = true

opt.titlestring =
  "%{fnamemodify(getcwd(), ':t')} - Neovim"

-- =========================================================
-- Conceal
-- =========================================================

-- Useful for Markdown / render-markdown / Obsidian
opt.conceallevel = 2

-- =========================================================
-- Cursor
-- =========================================================

-- Always show current cursor location
opt.ruler = true

-- =========================================================
-- Fill characters
-- =========================================================

opt.fillchars = {
  eob = " ",
  fold = " ",
  foldopen = "",
  foldclose = "",
  foldsep = " ",
  diff = "╱",
}

-- =========================================================
-- Folding
-- =========================================================

-- Let Treesitter/LSP plugins manage folds later
opt.foldenable = true

-- Start files unfolded
opt.foldlevel = 99
opt.foldlevelstart = 99

-- =========================================================
-- Session behaviour
-- =========================================================

opt.sessionoptions = {
  "buffers",
  "curdir",
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
  "folds",
}

-- =========================================================
-- Short messages
-- =========================================================

-- Avoid unnecessary completion messages
opt.shortmess:append("c")