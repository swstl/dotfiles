return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				ensure_installed = { "typescript", "javascript", "vue", "html", "css" }, -- Add more as needed
				auto_install = true,
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
				incremental_selection = { -- Add this for incremental selection
					enable = true,
					keymaps = {
						init_selection = "<A-o>", -- Initialize selection
						node_incremental = "grn", -- Increment to the next node
						scope_incremental = "grc", -- Increment to the current scope
						node_decremental = "grm", -- Decrement selection
					},
				},
				textobjects = { -- Add this for advanced text objects
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to text objects
						keymaps = {
							["af"] = "@function.outer", -- Select around a function
							["if"] = "@function.inner", -- Select inside a function
							["ac"] = "@class.outer", -- Select around a class
							["ic"] = "@class.inner", -- Select inside a class
						},
					},
				},
			})
		end,
	},
}
