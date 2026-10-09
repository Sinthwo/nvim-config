local function debugpy_python()
  local base = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv"

  local candidates = {
    base .. "/Scripts/python.exe",
    base .. "/bin/python",
    base .. "/bin/python3",
  }

  for _, candidate in ipairs(candidates) do
    if (vim.uv or vim.loop).fs_stat(candidate) then
      return candidate
    end
  end

  return vim.fn.exepath("python") ~= "" and vim.fn.exepath("python") or "python"
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = { "rcarriga/nvim-dap-ui" },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug continue" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "Step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Step into" },
      { "<S-F11>", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Debug REPL" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Stop debugger" },
    },
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "nvim-neotest/nvim-nio",
    },

    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup({})

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-python").setup(debugpy_python())
    end,
  },
}
