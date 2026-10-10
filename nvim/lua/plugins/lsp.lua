-- =========================================================
-- Helpers
-- =========================================================

local uv = vim.uv or vim.loop
local paths = require("config.paths")

local function file_exists(path)
  if not path or path == "" then
    return false
  end

  local ok, stat = pcall(uv.fs_stat, path)

  return ok and stat ~= nil
end

-- =========================================================
-- Plugins
-- =========================================================

return {
  -- =======================================================
  -- Mason
  -- =======================================================

  {
    "mason-org/mason.nvim",

    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUpdate",
      "MasonUninstall",
    },

    opts = {
      ui = {
        border = "rounded",
      },
    },
  },

  -- =======================================================
  -- Mason Tool Installer
  -- =======================================================

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    event = "VeryLazy",

    dependencies = {
      "mason-org/mason.nvim",
    },

    opts = {
      ensure_installed = {
        "debugpy",
        "stylua",
        "prettier",
        "shfmt",
        "tree-sitter-cli",
      },

      run_on_start = true,

      start_delay = 1000,

      debounce_hours = 24,
    },
  },

  -- =======================================================
  -- LSP
  -- =======================================================

  {
    "neovim/nvim-lspconfig",

    event = {
      "BufReadPre",
      "BufNewFile",
    },

    dependencies = {
      "saghen/blink.cmp",
    },

    config = function()
      local capabilities =
        require("blink.cmp").get_lsp_capabilities()

      -- ===================================================
      -- Python - BasedPyright
      -- ===================================================

      vim.lsp.config(
        "basedpyright",
        {
          capabilities = capabilities,

          settings = {
            basedpyright = {
              analysis = {
                autoSearchPaths = true,

                diagnosticMode =
                  "openFilesOnly",
              },
            },
          },
        }
      )

      -- ===================================================
      -- Python - Ruff
      -- ===================================================

      vim.lsp.config(
        "ruff",
        {
          capabilities = capabilities,

          on_attach = function(client)
            client.server_capabilities.hoverProvider =
              false
          end,
        }
      )

      -- ===================================================
      -- Bash
      -- ===================================================

      vim.lsp.config(
        "bashls",
        {
          capabilities = capabilities,
        }
      )

      -- ===================================================
      -- YAML
      -- ===================================================

      vim.lsp.config(
        "yamlls",
        {
          capabilities = capabilities,

          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        }
      )

      -- ===================================================
      -- Terraform
      -- ===================================================

      vim.lsp.config(
        "terraformls",
        {
          capabilities = capabilities,
        }
      )

      -- ===================================================
      -- Azure Pipelines YAML
      --
      -- This only starts in workspaces that contain an
      -- azure-pipelines.yml / azure-pipelines.yaml file.
      -- ===================================================

      vim.lsp.config(
        "azure_pipelines_ls",
        {
          capabilities = capabilities,
          workspace_required = true,

          cmd = {
            "azure-pipelines-language-server",
            "--stdio",
          },

          filetypes = {
            "yaml",
          },

          root_markers = {
            "azure-pipelines.yml",
            "azure-pipelines.yaml",
          },

          settings = {
            yaml = {
              schemas = {
                ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
                  "/azure-pipeline*.y*l",
                  "/*.azure*",
                  "Azure-Pipelines/**/*.y*l",
                  "Pipelines/*.y*l",
                },
              },
            },
          },
        }
      )

      -- ===================================================
      -- Azure Bicep - official bicep-ls
      --
      -- Install externally with:
      -- dotnet tool install --global Azure.Bicep.LangServer
      -- ===================================================

      local bicep_ls =
        vim.fn.exepath("bicep-ls")

      local bicep_enabled =
        bicep_ls ~= ""

      if bicep_enabled then
        vim.lsp.config(
          "bicep",
          {
            capabilities = capabilities,

            cmd = {
              bicep_ls,
            },

            filetypes = {
              "bicep",
              "bicep-params",
            },

            root_markers = {
              "bicepconfig.json",
              ".git",
            },
          }
        )
      else
        local bicep_warning_group =
          vim.api.nvim_create_augroup(
            "UserBicepMissingLsp",
            { clear = true }
          )

        local warned = false

        vim.api.nvim_create_autocmd("FileType", {
          group = bicep_warning_group,
          pattern = {
            "bicep",
            "bicep-params",
          },
          callback = function()
            if warned then
              return
            end

            warned = true

            vim.notify(
              "Bicep LSP is not installed. Run:\n"
                .. "dotnet tool install --global Azure.Bicep.LangServer",
              vim.log.levels.WARN,
              { title = "Bicep" }
            )
          end,
        })
      end

      -- ===================================================
      -- PowerShell
      -- ===================================================

      local powershell =
        paths.find_powershell()

      local mason_root =
        vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "powershell-editor-services")

      local pses_root =
        vim.fs.joinpath(mason_root, "PowerShellEditorServices")

      local pses_script =
        vim.fs.joinpath(pses_root, "Start-EditorServices.ps1")

      local powershell_enabled =
        false

      if
        powershell
        and file_exists(pses_script)
      then
        local cache =
          vim.fn.stdpath("cache")
          :gsub("\\", "/")
        vim.fn.mkdir(cache, "p")

        local script =
          pses_script:gsub("\\", "/")

        local command =
          string.format(
            "& %s "
              .. "-LogPath %s "
              .. "-SessionDetailsPath %s "
              .. "-FeatureFlags @() "
              .. "-AdditionalModules @() "
              .. "-HostName nvim "
              .. "-HostProfileId 0 "
              .. "-HostVersion 1.0.0 "
              .. "-Stdio "
              .. "-LogLevel Information",
            paths.powershell_quote(script),
            paths.powershell_quote(vim.fs.joinpath(cache, "powershell_es.log")),
            paths.powershell_quote(vim.fs.joinpath(cache, "powershell_es.session.json"))
          )

        vim.lsp.config(
          "powershell_es",
          {
            capabilities =
              capabilities,

            cmd = {
              powershell,

              "-NoLogo",

              "-NoProfile",

              "-NonInteractive",

              "-ExecutionPolicy",
              "Bypass",

              "-Command",

              command,
            },

            filetypes = {
              "ps1",
            },

            root_markers = {
              "PSScriptAnalyzerSettings.psd1",
              ".git",
            },

            init_options = {
              enableProfileLoading =
                false,
            },
          }
        )

        powershell_enabled =
          true
      else
        vim.schedule(function()
          local reasons = {}

          if not powershell then
            table.insert(
              reasons,
              "PowerShell executable not found"
            )
          end

          if not file_exists(pses_script) then
            table.insert(
              reasons,
              "PowerShell Editor Services not installed"
            )
          end

          vim.notify(
            "PowerShell LSP disabled: "
              .. table.concat(
                reasons,
                ", "
              ),
            vim.log.levels.WARN
          )
        end)
      end

      -- ===================================================
      -- Lua
      -- ===================================================

      vim.lsp.config(
        "lua_ls",
        {
          capabilities =
            capabilities,

          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },

              diagnostics = {
                globals = {
                  "vim",
                  "Snacks",
                },
              },

              workspace = {
                checkThirdParty = false,

                library =
                  vim.api.nvim_get_runtime_file(
                    "",
                    true
                  ),
              },
            },
          },
        }
      )

      -- ===================================================
      -- Enable the configured language servers
      -- ===================================================

      vim.lsp.enable("basedpyright")
      vim.lsp.enable("ruff")
      vim.lsp.enable("bashls")
      vim.lsp.enable("yamlls")
      vim.lsp.enable("terraformls")
      vim.lsp.enable("azure_pipelines_ls")
      vim.lsp.enable("lua_ls")

      if bicep_enabled then
        vim.lsp.enable("bicep")
      end

      if powershell_enabled then
        vim.lsp.enable(
          "powershell_es"
        )
      end

      -- ===================================================
      -- LSP keymaps
      -- ===================================================

      local lsp_group =
        vim.api.nvim_create_augroup(
          "UserLsp",
          {
            clear = true,
          }
        )

      vim.api.nvim_create_autocmd(
        "LspAttach",
        {
          group = lsp_group,

          callback = function(event)
            local opts = {
              buffer = event.buf,
              silent = true,
            }

            vim.keymap.set(
              "n",
              "gd",
              vim.lsp.buf.definition,
              vim.tbl_extend(
                "force",
                opts,
                {
                  desc =
                    "Go to definition",
                }
              )
            )

            vim.keymap.set(
              "n",
              "gD",
              vim.lsp.buf.declaration,
              vim.tbl_extend(
                "force",
                opts,
                {
                  desc =
                    "Go to declaration",
                }
              )
            )

            vim.keymap.set(
              "n",
              "gi",
              vim.lsp.buf.implementation,
              vim.tbl_extend(
                "force",
                opts,
                {
                  desc =
                    "Go to implementation",
                }
              )
            )

            vim.keymap.set(
              "n",
              "gr",
              vim.lsp.buf.references,
              vim.tbl_extend(
                "force",
                opts,
                {
                  desc =
                    "References",
                }
              )
            )

            vim.keymap.set(
              "n",
              "K",
              vim.lsp.buf.hover,
              vim.tbl_extend(
                "force",
                opts,
                {
                  desc =
                    "Hover documentation",
                }
              )
            )

            vim.keymap.set(
              "n",
              "<F2>",
              vim.lsp.buf.rename,
              vim.tbl_extend(
                "force",
                opts,
                {
                  desc =
                    "Rename symbol",
                }
              )
            )

            vim.keymap.set(
              {
                "n",
                "v",
              },

              "<leader>ca",

              vim.lsp.buf.code_action,

              vim.tbl_extend(
                "force",
                opts,
                {
                  desc =
                    "Code action",
                }
              )
            )

            vim.keymap.set(
              "n",
              "<leader>cd",

              vim.diagnostic.open_float,

              vim.tbl_extend(
                "force",
                opts,
                {
                  desc =
                    "Line diagnostics",
                }
              )
            )

            vim.keymap.set(
              "n",
              "]d",

              function()
                vim.diagnostic.jump({
                  count = 1,
                  float = true,
                })
              end,

              vim.tbl_extend(
                "force",
                opts,
                {
                  desc =
                    "Next diagnostic",
                }
              )
            )

            vim.keymap.set(
              "n",
              "[d",

              function()
                vim.diagnostic.jump({
                  count = -1,
                  float = true,
                })
              end,

              vim.tbl_extend(
                "force",
                opts,
                {
                  desc =
                    "Previous diagnostic",
                }
              )
            )
          end,
        }
      )

      -- ===================================================
      -- Diagnostics
      -- ===================================================

      vim.diagnostic.config({
        virtual_text = {
          spacing = 2,
          prefix = "●",
        },

        severity_sort = true,

        float = {
          border = "rounded",
          source = true,
        },

        signs = true,

        underline = true,

        update_in_insert = false,
      })
    end,
  },

  -- =======================================================
  -- Mason LSPConfig
  -- =======================================================

  {
    "mason-org/mason-lspconfig.nvim",

    event = {
      "BufReadPre",
      "BufNewFile",
    },

    dependencies = {
      "mason-org/mason.nvim",

      "neovim/nvim-lspconfig",
    },

    opts = {
      ensure_installed = {
        "basedpyright",
        "ruff",
        "powershell_es",
        "jdtls",
        "lua_ls",
        "bashls",
        "yamlls",
        "terraformls",
        "azure_pipelines_ls",
      },

      -- Server startup is controlled by the configuration above.
      automatic_enable = false,
    },
  },
}
