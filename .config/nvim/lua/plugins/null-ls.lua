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
          -- null_ls.builtins.diagnostics.flake8,
          null_ls.builtins.diagnostics.pylint.with({
            command = function()
              -- Check if `pylint` exists in the active virtual environment
              local venv = os.getenv("VIRTUAL_ENV")
              if venv then
                local pylint_path = venv .. "/bin/pylint"
                if vim.fn.executable(pylint_path) == 1 then
                  return pylint_path
                end
              end
              -- if no pylint is found in the venv, use the pylint_venv:
              return "pylint"
            end,
            args = function()
              -- Adjust args based on whether we're using venv
              local venv = os.getenv("VIRTUAL_ENV")
              if venv then
                -- Regular usage if venv pylint exists
                return { "-f", "json", "$FILENAME" }
              else
                return {
                  "-f",
                  "json",
                  "--init-hook=import pylint_venv; pylint_venv.inithook(quiet=True); import warnings; warnings.filterwarnings('ignore')",
                  "$FILENAME",
                } -- Use pylint_venv for global pylint which likes to give unnecessary warnings, so we ignore them
              end
            end,
          }),
        },
      })

      vim.keymap.set("n", "+", vim.lsp.buf.format, {})
    end,
  },
}

-- solution if pylint cant find venv modules :
-- tips:
-- install "linux-cultist/venv-selector.nvim" if the lsp isn't finding the venv modules (i think (atleast its a useful plugin))
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
--
--
-- For the pylint not finding the venv i used this solution:
-- 1. install the pylint_venv package globally: https://github.com/jgosmann/pylint-venv
-- 2. uninstall the pylint linter from mason (X) (not really necessary but i did it since i wont use that version)
-- 3. then specify the command in the null-ls config like this:
-- command = function()
--     -- Check if `pylint` exists in the active virtual environment
--     local venv = os.getenv("VIRTUAL_ENV")
--     if venv then
--         local pylint_path = venv .. "/bin/pylint"
--         if vim.fn.executable(pylint_path) == 1 then
--             return pylint_path
--         end
--     end
--     -- if no pylint is found in the venv, use the pylint_venv:
--     return "pylint"
-- end,
-- args = function()
--     -- Adjust args based on whether we're using venv
--     local venv = os.getenv("VIRTUAL_ENV")
--     if venv then
--         -- Regular usage if venv pylint exists
--         return { "-f", "json", "$FILENAME" }
--     else
--         return {
--             "-f",
--             "json",
--             "--init-hook=import pylint_venv; pylint_venv.inithook(quiet=True); import warnings; warnings.filterwarnings('ignore')",
--             "$FILENAME",
--           } -- Use pylint_venv for global pylint which likes to give unnecessary warnings, so we ignore them
--     end
-- end,
--
