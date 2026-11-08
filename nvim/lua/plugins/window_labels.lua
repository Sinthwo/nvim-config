-- Split labels are intentionally subtle; no tabline/bufferline or keymaps are changed.
return {
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    opts = {
      hide = { cursorline = "smart", focused_win = false, only_win = true },
      window = { margin = { horizontal = 1, vertical = 0 } },
      render = function(props)
        local name = vim.api.nvim_buf_get_name(props.buf)
        name = name ~= "" and vim.fn.fnamemodify(name, ":t") or "[No Name]"
        if vim.bo[props.buf].modified then name = name .. " [+]" end
        return { { " " .. name .. " ", guifg = "#c0caf5", guibg = "#292e42" } }
      end,
    },
    config = function(_, opts)
      local incline = require("incline")
      incline.setup(opts)
      vim.api.nvim_create_user_command("InclineToggle", function()
        incline.toggle()
      end, { desc = "Toggle floating filename labels" })
    end,
  },
}
