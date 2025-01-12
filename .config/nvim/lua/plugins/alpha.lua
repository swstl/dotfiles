return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("dashboard").setup({
			theme = "hyper", -- You can use 'doom' or 'hyper' theme
			config = {
				header = {
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                     ]],
					[[       ████ ██████           █████      ██                     ]],
					[[      ███████████             █████                             ]],
					[[      █████████ ███████████████████ ███   ███████████   ]],
					[[     █████████  ███    █████████████ █████ ██████████████   ]],
					[[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
					[[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
					[[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                       ]],
				},
				center = {
					{
						icon = "  ",
						desc = "Recently opened files                   ",
						action = "Telescope oldfiles",
					},
					{
						icon = "  ",
						desc = "Find File                               ",
						action = "Telescope find_files find_command=rg,--hidden,--files",
					},
					{
						icon = "  ",
						desc = "File Browser                            ",
						action = "Telescope file_browser",
					},
					{
						icon = "  ",
						desc = "Find word                               ",
						action = "Telescope live_grep",
					},
				},
				footer = {
					"Neovim Dashboard with Custom Logo",
				},
			},
		})
	end,
}
