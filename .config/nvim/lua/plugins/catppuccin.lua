return {
	"catppuccin/nvim",
  dependencies = {
    "norcalli/nvim-colorizer.lua",
  },
	name = "catppuccin",
	priority = 1000,
	config = function()
		vim.cmd.colorscheme("catppuccin")
	end,
}
