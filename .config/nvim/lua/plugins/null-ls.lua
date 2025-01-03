return {
	{
		"nvimtools/none-ls.nvim",
	--	dependencies = {
    --	"nvimtools/none-ls-extras.nvim",
	--	},
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
                    -- vue / javascript / typescript etc
                    null_ls.builtins.formatting.prettier,
                    null_ls.builtins.diagnostics.eslint_d,

					-- lua
					null_ls.builtins.formatting.stylua,

					-- c / c++ / c#
					null_ls.builtins.formatting.clang_format,
					-- null_ls.builtins.diagnostics.cpplint,
					null_ls.builtins.diagnostics.trivy,

					-- python
					null_ls.builtins.formatting.black,
					null_ls.builtins.formatting.isort,
					null_ls.builtins.diagnostics.pylint,


--					require("none-ls.diagnostics.eslint"), -- requires none-ls-extras.nvim
				},
			})

			vim.keymap.set("n", "+", vim.lsp.buf.format, {})
		end,
	},
}
