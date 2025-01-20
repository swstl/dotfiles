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
		vim.keymap.set("n", "<C-;>", function()
			-- Check if Neo-tree is currently open
			local is_open = vim.fn.bufname():match("neo%-tree")

			if is_open then
				-- Close Neo-tree if it's open
				vim.cmd("Neotree close")
			else
				-- Focus Neo-tree if it's not open
				vim.cmd("Neotree focus")
			end
		end, {})

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
