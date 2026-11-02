-- Optional Markdown/Obsidian enhancements for the Japanese profile only.
-- All plugin packages are kept under NVIM_APPNAME=nvim-jp's own data dir.
local M = {}
local function msg(text, level)
  vim.schedule(function()
    vim.notify(text, level or vim.log.levels.WARN, { title = "Japanese Markdown" })
  end)
end

local function active_vault()
  local s = require("jp.settings").load()
  if type(s.vault) ~= "string" or s.vault == "" then return nil end
  local vault = vim.fs.normalize(s.vault)
  if vim.fn.isdirectory(vault) ~= 1 or vim.fn.isdirectory(vault .. "/.obsidian") ~= 1 then
    return nil
  end
  return vault
end

function M.setup()
  -- The Japanese profile continues working if Git/internet/plugins are unavailable.
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    if vim.fn.executable("git") ~= 1 then
      msg("Git is needed once to install optional Markdown plugins. Japanese writing still works.")
      return
    end
    local output = vim.fn.system({
      "git", "clone", "--filter=blob:none", "--branch=stable",
      "https://github.com/folke/lazy.nvim.git", lazypath,
    })
    if vim.v.shell_error ~= 0 then
      msg("Could not install lazy.nvim. Check network/Git. " .. tostring(output), vim.log.levels.ERROR)
      return
    end
  end
  vim.opt.rtp:prepend(lazypath)

  local ok, err = pcall(function()
    require("lazy").setup({
      {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
          require("nvim-treesitter").setup({})
        end,
      },
      {
        "nvim-mini/mini.pick",
        version = "*",
        lazy = true,
        opts = {},
        config = function(_, opts)
          require("mini.pick").setup(opts)
        end,
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown" },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {
          preset = "obsidian",
          enabled = true,
          file_types = { "markdown" },
          -- Display pretty Markdown in Normal/Command mode; raw text in Insert mode.
          render_modes = { "n", "c" },
          heading = { enabled = true, sign = false },
          code = { enabled = true, sign = false },
          bullet = { enabled = true },
          checkbox = { enabled = true },
          pipe_table = { enabled = true },
          link = { enabled = true },
        },
      },
      {
        "obsidian-nvim/obsidian.nvim",
        version = "*",
        ft = { "markdown" },
        cmd = { "Obsidian" },
        -- Enable vault navigation only after setup has confirmed a real vault.
        cond = function()
          return vim.fn.has("nvim-0.11") == 1 and active_vault() ~= nil
        end,
        dependencies = { "nvim-mini/mini.pick" },
        opts = function()
          return {
            legacy_commands = false,
            workspaces = { { name = "japanese-vault", path = assert(active_vault()) } },
            -- Preserve ALL existing JP YAML fields and avoid write-time changes.
            frontmatter = { enabled = false },
            -- :JPToday remains authoritative; no second journal creator.
            daily_notes = { enabled = false },
            completion = { nvim_cmp = false, blink = false },
            picker = { name = "mini.pick" },
            -- Let render-markdown own the visuals. Do not stack both renderers.
            ui = { enable = false },
          }
        end,
      },
    }, {
      root = vim.fn.stdpath("data") .. "/lazy",
      lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
      rocks = { enabled = false },
      checker = { enabled = false },
      change_detection = { notify = false },
      install = { colorscheme = { "habamax" } },
    })
  end)
  if not ok then
    msg("Markdown plugin manager setup failed: " .. tostring(err), vim.log.levels.ERROR)
  end
end

function M.setup_parsers()
  if not package.loaded["lazy"] then
    vim.notify("Plugin manager not installed. Run :Lazy sync after checking Git/network.", vim.log.levels.ERROR)
    return
  end
  local ok, result = pcall(function()
    require("lazy").load({ plugins = { "nvim-treesitter" } })
    return require("nvim-treesitter").install({ "markdown", "markdown_inline", "yaml", "html" })
  end)
  if not ok then
    vim.notify("Could not install Markdown parsers: " .. tostring(result), vim.log.levels.ERROR)
  else
    vim.notify("Markdown parser installation started. Wait for it to finish, then reopen the note. Check :checkhealth nvim-treesitter if needed.")
  end
end

function M.status()
  local version = vim.version()
  local has_lazy = package.loaded["lazy"] ~= nil
  local has_render = pcall(require, "render-markdown")
  local vault = active_vault()
  local parser_ok = pcall(vim.treesitter.get_parser, 0, "markdown")
  vim.notify(table.concat({
    "Neovim: " .. version.major .. "." .. version.minor .. "." .. version.patch,
    "Japanese plugin manager: " .. (has_lazy and "loaded" or "unavailable"),
    "Markdown renderer: " .. (has_render and "available" or "not loaded (open .md)"),
    "Markdown parser: " .. (parser_ok and "available" or "missing; run :JPMarkdownParsers"),
    "Verified vault: " .. (vault or "none; run :JPSetup"),
    "Obsidian integration: " .. ((vault and vim.fn.has("nvim-0.11") == 1) and "eligible" or "requires Neovim 0.11+ and verified vault"),
  }, "\n"))
end

return M
