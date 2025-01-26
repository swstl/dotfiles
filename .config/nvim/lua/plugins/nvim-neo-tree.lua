return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	config = function()
		-- change the symbols for different actions
		require("neo-tree").setup({
			default_component_configs = {
				diagnostics = {
					symbols = {
						hint = "", -- Icon for hints
						info = "", -- Icon for informational messages
						warn = "", -- Icon for warnings
						error = "", -- Icon for errors
					},
					highlights = {
						hint = "DiagnosticHint",
						info = "DiagnosticInfo",
						warn = "DiagnosticWarn",
						error = "DiagnosticError",
					},
				},
			},
		})


		-- Autocommand to close Neo-tree when quitting Neovim
		vim.api.nvim_create_autocmd("QuitPre", {
			callback = function()
				-- Close Neo-tree if it's open
				if #vim.fn.getbufinfo({ bufloaded = true, buftype = "nofile" }) > 0 then
					vim.cmd("Neotree close")
				end
			end,
		})
	end,
}

