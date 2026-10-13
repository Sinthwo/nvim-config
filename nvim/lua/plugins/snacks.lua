local function run_ai(command, title)
  return function()
    if vim.fn.executable(command) ~= 1 then
      vim.notify(
        command .. " was not found in PATH.",
        vim.log.levels.ERROR,
        { title = title }
      )
      return
    end

    Snacks.terminal(command, {
      cwd = require("config.project").root(),
    })
  end
end

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      terminal = { enabled = true },
      dashboard = {
        enabled = true,
        -- Keep the menu below the logo, with each shortcut beside its label.
        width = 42,
        row = 1,
        formats = {
          -- Shortcut letters are already shown beside the labels.
          key = function(_)
            return { { "", hl = "key" } }
          end,
        },
        preset = {
          header = "NEOVIM",
          keys = {
            { icon = "F", key = "f", desc = "Find file", action = ":FzfLua files" },
            { icon = "G", key = "g", desc = "Search text", action = ":FzfLua live_grep" },
            { icon = "R", key = "r", desc = "Recent files", action = ":FzfLua oldfiles" },
            { icon = "E", key = "e", desc = "File explorer", action = ":Neotree show left" },
            { icon = "N", key = "n", desc = "New file", action = ":ene | startinsert" },
            { icon = "L", key = "l", desc = "Manage plugins", action = ":Lazy" },
            { icon = "C", key = "c", desc = "Config files", action = function()
              require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
            end },
            { icon = "T", key = "t", desc = "Terminal", action = ":TerminalPanel" },
            { icon = "Q", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          -- Reserve logo space in WezTerm, or show a text header otherwise.
          require("config.dashboard_logo").section,
          -- Keep actions close together on smaller terminals.
          { section = "keys", gap = 0, padding = 1 },
          {
            icon = "R",
            title = "Recent files",
            section = "recent_files",
            limit = 4,
            padding = 1,
            enabled = function()
              return vim.o.lines >= 31
            end,
          },
          { section = "startup" },
        },
      },
      notifier = { enabled = true, timeout = 3500, style = "compact" },
      statuscolumn = {
        enabled = true,
        left = { "mark", "sign" },
        right = { "fold", "git" },
        folds = { open = false, git_hl = false },
      },
      picker = { enabled = true },
      gitbrowse = { enabled = true },
      lazygit = { enabled = true },
      -- config.image_preview handles image and PDF previews through WezTerm.
      image = { enabled = false },

      input = { enabled = true },
      indent = {
        enabled = true,
        animate = { enabled = false },
      },
    },

    keys = {
      {
        "<leader>tt",
        function()
          Snacks.terminal(nil, {
            cwd = require("config.project").root(),
            win = { position = "bottom", height = 0.30 },
          })
        end,
        desc = "Toggle terminal",
      },
      { "<leader>ac", run_ai("codex", "Codex"), desc = "Open Codex" },
      { "<leader>aC", run_ai("claude", "Claude Code"), desc = "Open Claude Code" },
      {
        "<leader>tf",
        function()
          Snacks.terminal(nil, {
            cwd = require("config.project").root(),
            win = { position = "float", height = 0.75, width = 0.86, border = "rounded" },
          })
        end,
        desc = "Toggle floating terminal",
      },
      {
        "<leader>ud",
        function() Snacks.notifier.hide() end,
        desc = "Dismiss notifications",
      },
      {
        "<leader>un",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notification history",
      },
    },
  },
}
