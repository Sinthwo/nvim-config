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
    priority = 900,
    lazy = false,

    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      terminal = { enabled = true },
      input = { enabled = true },
      indent = {
        enabled = true,
        animate = { enabled = false },
      },
      notifier = { enabled = true },
    },

    keys = {
      {
        "<leader>tt",
        function()
          Snacks.terminal(nil, { cwd = require("config.project").root() })
        end,
        desc = "Toggle terminal",
      },
      { "<leader>ac", run_ai("codex", "Codex"), desc = "Open Codex" },
      { "<leader>aC", run_ai("claude", "Claude Code"), desc = "Open Claude Code" },
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
