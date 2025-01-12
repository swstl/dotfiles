return {
	"folke/which-key.nvim",
	lazy = true,
	event = "VeryLazy",
	opts = {
		delay = 0,
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = true })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
