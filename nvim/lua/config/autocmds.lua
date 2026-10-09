-- =========================================================
-- WezTerm integration
-- =========================================================

local function wezterm_set_nvim_state(active)
  if not vim.env.WEZTERM_PANE then
    return
  end

  local encoded

  if active then
    -- base64("1")
    encoded = "MQ=="
  else
    -- base64("0")
    encoded = "MA=="
  end

  io.stdout:write(
    string.format(
      "\027]1337;SetUserVar=NVIM_ACTIVE=%s\007",
      encoded
    )
  )

  io.stdout:flush()
end

vim.api.nvim_create_autocmd(
  "VimEnter",
  {
    callback = function()
      vim.schedule(function()
        wezterm_set_nvim_state(true)
      end)
    end,
  }
)

vim.api.nvim_create_autocmd(
  "VimLeavePre",
  {
    callback = function()
      wezterm_set_nvim_state(false)
    end,
  }
)