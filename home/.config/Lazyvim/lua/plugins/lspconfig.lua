return {
  -- add tsserver and setup with typescript.nvim instead of lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
    },
    keys = {
      { "<leader>co", "<cmd>TypescriptOrganizeImports<cr>", desc = "Organize Imports" },
      { "<leader>cR", "<cmd>TypescriptRenameFile<cr>", desc = "Rename File" },
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- tsserver will be automatically installed with mason and loaded with lspconfig
        rust_analyzer = {},
        tsserver = {},
        -- pylyzer = {},
        pyright = {},
        gdscript = {},
        r_language_server = {
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern("DESCRIPTION", "NAMESPACE", ".Rbuildignore")(fname)
              ---@diagnostic disable-next-line: deprecated
              or require("lspconfig.util").find_git_ancestor(fname)
              or vim.loop.os_homedir()
          end,
        },
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        tsserver = function(_, opts)
          require("typescript").setup({ server = opts })
          return true
        end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- "pylyzer",
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "black",
        "eslint_d",
        "kotlin-lsp",
        "jq",
      },
    },
  },
  {
    "shunsambongi/neotest-testthat",
  },
}
