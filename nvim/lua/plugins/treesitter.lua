return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",

    config = function()
      require("nvim-treesitter").setup({})

      local parsers = {
        "bash",
        "java",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "powershell",
        "python",
        "query",
        "regex",
        "toml",
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
        java = true,
        json = true,
        lua = true,
        markdown = true,
        ps1 = true,
        python = true,
        toml = true,
        vim = true,
        yaml = true,
      }

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(args)
          if not supported[vim.bo[args.buf].filetype] then
            return
          end

          pcall(vim.treesitter.start, args.buf)

          if vim.tbl_contains({ "java", "json", "lua", "python", "yaml" }, vim.bo[args.buf].filetype) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
