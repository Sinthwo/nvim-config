return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",

    config = function()
      require("nvim-treesitter").setup({})

      -- Map Neovim filetypes to their Tree-sitter parser names.
      vim.treesitter.language.register("bash", "sh")
      vim.treesitter.language.register("bicep", "bicep-params")
      vim.treesitter.language.register("terraform", "terraform-vars")

      local parsers = {
        "bash",
        "bicep",
        "csv",
        "hcl",
        "java",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "powershell",
        "python",
        "query",
        "regex",
        "terraform",
        "toml",
        "tsv",
        "vim",
        "vimdoc",
        "yaml",
      }

      local function install_parsers()
        if vim.fn.executable("tree-sitter") == 1 then
          local ok, err = pcall(function()
            require("nvim-treesitter").install(parsers)
          end)
          if not ok then
            vim.notify("Parser installation failed: " .. tostring(err), vim.log.levels.WARN)
          end
        end
      end

      local group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "MasonToolsUpdateCompleted",
        callback = function()
          vim.schedule(install_parsers)
        end,
      })
      vim.schedule(install_parsers)

      local supported = {
        bash = true,
        bicep = true,
        ["bicep-params"] = true,
        csv = true,
        hcl = true,
        java = true,
        json = true,
        lua = true,
        markdown = true,
        ps1 = true,
        python = true,
        sh = true,
        terraform = true,
        ["terraform-vars"] = true,
        toml = true,
        tsv = true,
        vim = true,
        yaml = true,
      }

      local indent_filetypes = {
        bash = true,
        bicep = true,
        ["bicep-params"] = true,
        hcl = true,
        java = true,
        json = true,
        lua = true,
        python = true,
        sh = true,
        terraform = true,
        ["terraform-vars"] = true,
        yaml = true,
      }

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(args)
          local ft = vim.bo[args.buf].filetype

          if not supported[ft] then
            return
          end

          pcall(vim.treesitter.start, args.buf)

          if indent_filetypes[ft] then
            vim.bo[args.buf].indentexpr =
              "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
