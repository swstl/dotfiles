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
						desc = "Find a specific file                    ",
						action = "Telescope find_files find_command=rg,--hidden,--files",
					},
					{
						icon = "  ",
						desc = "Browse directories                      ",
						action = "Telescope file_browser",
					},
					{
						icon = "  ",
						desc = "Search for a word in project            ",
						action = "Telescope live_grep",
					},
					{
						icon = "󰊢  ",
						desc = "Open Neovim configuration               ",
						action = "edit ~/.config/nvim/init.lua",
					},
					{
						icon = "󰁔  ",
						desc = "Quit Neovim                             ",
						action = "qa",
					},
				},
				footer = {
					"Using configs: " .. os.getenv("NVIM_APPNAME"),
				},
			},
		})
	end,
}
