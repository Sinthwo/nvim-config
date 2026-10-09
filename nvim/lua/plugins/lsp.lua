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
      -- Enable LSPs manually
      --
      -- We intentionally control this ourselves instead of
      -- Mason automatically enabling everything.
      -- ===================================================

      vim.lsp.enable(
        "basedpyright"
      )

      vim.lsp.enable(
        "ruff"
      )

      vim.lsp.enable(
        "lua_ls"
      )

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
      },

      -- IMPORTANT:
      --
      -- Do not automatically start LSPs.
      -- lsp.lua controls startup itself.
      automatic_enable = false,
    },
  },
}
