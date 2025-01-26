return {
	{
		"folke/tokyonight.nvim",
		dependencies = {
			"norcalli/nvim-colorizer.lua",
		},
		name = "catppuccin",
		priority = 1000,
		config = function()
			-- Lua
			-- require("onedark").setup({
			--   -- Main options --
			--   style = "cool",            -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
			--   transparent = true,       -- Show/hide background
			--   term_colors = true,        -- Change terminal color as per the selected theme style
			--   ending_tildes = false,     -- Show the end-of-buffer tildes. By default they are hidden
			--   cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu
			--
			--   -- Plugins Config --
			--   diagnostics = {
			--     darker = true, -- darker colors for diagnostic
			--     undercurl = true, -- use undercurl instead of underline for diagnostics
			--     background = true, -- use background color for virtual text
			--   },
			-- })
			vim.cmd.colorscheme("tokyonight")
		end,
	},
	{
		"folke/noice.nvim",
	},
}
