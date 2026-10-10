-- =========================================================
-- Additional filetype detection
-- =========================================================

vim.filetype.add({
  extension = {
    bicep = "bicep",
    bicepparam = "bicep-params",
    tf = "terraform",
    tfvars = "terraform-vars",
    csv = "csv",
    tsv = "tsv",
    yml = "yaml",
    yaml = "yaml",
  },

  filename = {
    ["azure-pipelines.yml"] = "yaml",
    ["azure-pipelines.yaml"] = "yaml",
  },
})
