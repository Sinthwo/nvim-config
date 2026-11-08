-- Optional edit-as-a-buffer file manager alongside the existing Neo-tree sidebar.
return {
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      default_file_explorer = false,
      columns = { "icon", "permissions", "size", "mtime" },
      view_options = { show_hidden = true },
      skip_confirm_for_simple_edits = false,
    },
  },
}
