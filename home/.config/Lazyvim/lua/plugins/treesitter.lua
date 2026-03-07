return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Merge ensure_installed
      opts.ensure_installed = vim.tbl_deep_extend("force", opts.ensure_installed or {}, {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "rust",
        "gdscript",
        "godot_resource",
        "gdshader",
        "vue",
        "css",
        "r",
        "rnoweb",
        "kotlin"
      });
      -- Incremental selection
    opts.incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "gri",
          scope_incremental = "grc",
          node_decremental = "grd",
        },
      }
      -- Text objects
      opts.textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
      }

    opts.indent = {
      enable = true,
      disable = { "gdscript" },
    }
    end,
  },
    "habamax/vim-godot",
}
