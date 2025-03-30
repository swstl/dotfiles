return {
  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
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
      },
    },
  },

  -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
  -- would overwrite `ensure_installed` with the new value.
  -- If you'd rather extend the default config, use the code below instead:
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Ensure `ensure_installed` is properly merged
      opts.ensure_installed = vim.tbl_deep_extend("force", opts.ensure_installed or {}, {
        "vue",
        "css",
        "typescript",
        "javascript",
        "html",
        "r",
        "rnoweb"
      })

      -- Add additional Treesitter configurations dynamically
      opts.incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<A-o>", -- Initialize selection
          node_incremental = "grn", -- Increment to the next node
          scope_incremental = "grc", -- Increment to the current scope
          node_decremental = "grm", -- Decrement selection
        },
      }

      opts.textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer", -- Select around a function
            ["if"] = "@function.inner", -- Select inside a function
            ["ac"] = "@class.outer", -- Select around a class
            ["ic"] = "@class.inner", -- Select inside a class
          },
        },
      }
    end,
  },
}
