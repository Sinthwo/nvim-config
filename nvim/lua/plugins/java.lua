local function start_jdtls()
  local jdtls = require("jdtls")

  local root = jdtls.setup.find_root({
    ".git",
    "mvnw",
    "gradlew",
    "pom.xml",
    "build.gradle",
    "build.gradle.kts",
    "settings.gradle",
    "settings.gradle.kts",
  })

  if not root or root == "" then
    root = vim.fn.getcwd()
  end

  local cmd = vim.fn.exepath("jdtls")

  if cmd == "" then
    vim.notify(
      "jdtls is not installed yet. Run :MasonInstall jdtls and reopen the Java file.",
      vim.log.levels.ERROR,
      { title = "Java" }
    )
    return
  end

  local normalized_root = vim.fs.normalize(root)
  if vim.fn.has("win32") == 1 then
    normalized_root = normalized_root:lower()
  end
  local project_name = vim.fs.basename(root) .. "-" .. vim.fn.sha256(normalized_root):sub(1, 12)
  local workspace_dir = vim.fs.joinpath(
    vim.fn.stdpath("cache"),
    "jdtls-workspaces",
    project_name
  )

  local capabilities = require("blink.cmp").get_lsp_capabilities()

  jdtls.start_or_attach({
    cmd = { cmd, "-data", workspace_dir },
    root_dir = root,
    capabilities = capabilities,
    settings = {
      java = {
        eclipse = {
          downloadSources = true,
        },
        maven = {
          downloadSources = true,
        },
        implementationsCodeLens = {
          enabled = true,
        },
        referencesCodeLens = {
          enabled = true,
        },
        signatureHelp = {
          enabled = true,
        },
      },
    },
  })
end

return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = {
      "saghen/blink.cmp",
      "mason-org/mason.nvim",
    },

    config = function()
      start_jdtls()

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = start_jdtls,
      })
    end,

    keys = {
      {
        "<leader>jo",
        function()
          require("jdtls").organize_imports()
        end,
        desc = "Java organize imports",
      },
      {
        "<leader>jv",
        function()
          require("jdtls").extract_variable()
        end,
        desc = "Java extract variable",
      },
      {
        "<leader>jc",
        function()
          require("jdtls").extract_constant()
        end,
        desc = "Java extract constant",
      },
    },
  },
}
