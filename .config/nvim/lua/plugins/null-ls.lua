return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          require("none-ls.diagnostics.eslint"), -- requires none-ls-extras.nvim

          -- vue / javascript / typescript etc
          null_ls.builtins.formatting.prettier,
          -- null_ls.builtins.diagnostics.stylelint,
          -- null_ls.builtins.diagnostics.eslint,

          -- lua
          null_ls.builtins.formatting.stylua,

          -- c / c++ / c#
          null_ls.builtins.formatting.clang_format,
          -- null_ls.builtins.diagnostics.cpplint,
          null_ls.builtins.diagnostics.trivy,

          -- python
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.diagnostics.pylint,
        },
      })

      vim.keymap.set("n", "+", vim.lsp.buf.format, {})
    end,
  },
}


-- solution if pylint cant find venv modules : 
-- install "linux-cultist/venv-selector.nvim" 
-- and add the path to the venvs to it:
--    require("venv-selector").setup({
--      settings = {
--         search = {
--           anaconda_envs = {
--             command = "fd /bin/python$ /home/who/DevStuff/anaconda3/envs --full-path --color never -E /proc",
--             type = "anaconda",
--           },
--         },
--       },
--     })

