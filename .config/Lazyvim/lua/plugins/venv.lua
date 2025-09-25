return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    -- "mfussenegger/nvim-dap",
    -- "mfussenegger/nvim-dap-python",
    -- { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  },
  lazy = true, -- Load lazily
  branch = "main",
  config = function()
    require("venv-selector").setup({
      settings = {
        search = {
          anaconda_envs = {
            command = "fd /bin/python$ /home/who/DevStuff/anaconda3/envs --full-path --color never -E /proc",
            type = "anaconda",
          },
        },
      },
    })
  end,
  keys = {
    { ",v", "<cmd>VenvSelect<cr>" }, -- Lazy load when pressing this keybinding
  },
}
