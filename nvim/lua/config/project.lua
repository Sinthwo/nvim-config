local M = {}

local markers = {
  ".git",
  "pyproject.toml",
  "requirements.txt",
  "pom.xml",
  "mvnw",
  "build.gradle",
  "build.gradle.kts",
  "settings.gradle",
  "settings.gradle.kts",
  "PSScriptAnalyzerSettings.psd1",
  "bicepconfig.json",
  "azure-pipelines.yml",
  "azure-pipelines.yaml",
  ".terraform",
  "main.tf",
  ".obsidian",
}

function M.root(bufnr)
  bufnr = bufnr or 0

  local name = vim.api.nvim_buf_get_name(bufnr)
  local start = name ~= "" and vim.fs.dirname(name) or vim.fn.getcwd()
  local root = vim.fs.root(start, markers)

  return root or vim.fn.getcwd()
end

function M.label()
  local labels = {
    python = "PY",
    ps1 = "PS",
    java = "JAVA",
    markdown = "MD",
    lua = "LUA",
    json = "JSON",
    yaml = "YAML",
    sh = "BASH",
    bash = "BASH",
    terraform = "TF",
    ["terraform-vars"] = "TF",
    bicep = "BICEP",
    ["bicep-params"] = "BICEP",
    csv = "CSV",
    tsv = "TSV",
  }

  return labels[vim.bo.filetype] or vim.fs.basename(M.root()) or "NVIM"
end

return M
