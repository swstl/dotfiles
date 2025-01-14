return {
	-- to install and manage the language servers
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	-- to ensure the language servers are installed and works as they shall
	-- For language servers: https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
	},
	-- to communicate with the language servers themselves, and estaablishes a connection back and fourth
	{
		"neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          mason = false,
        }
      },
    },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			-- Lua
			lspconfig.lua_ls.setup({ capabilities = capabilities })
			lspconfig.volar.setup({ capabilities = capabilities })
			-- lspconfig.vuels.setup({ capabilities = capabilities })
			-- lspconfig.ts_ls.setup({ capabilities = capabilities })
			lspconfig.clangd.setup({ capabilities = capabilities })
			lspconfig.rust_analyzer.setup({ capabilities = capabilities })
			lspconfig.yamlls.setup({ capabilities = capabilities })
			lspconfig.marksman.setup({ capabilities = capabilities })
			-- lspconfig.pylsp.setup({ capabilities = capabilities })
			lspconfig.pyright.setup({ capabilities = capabilities })
			lspconfig.omnisharp.setup({ capabilities = capabilities })

			-- Keybindings
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "show hover doc" })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "goto definition" })
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "goto declaration" })
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "goto implementation" })
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "code action" })
			vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "show references" })
		end,
	},

	-- for vue goto definition
	{
		"catgoose/vue-goto-definition.nvim",
		event = "BufReadPre",
		opts = {
			filters = {
				auto_imports = true,
				auto_components = true,
				import_same_file = true,
				declaration = true,
				duplicate_filename = true,
			},
			filetypes = { "vue", "typescript" },
			detection = {
				nuxt = function()
					return vim.fn.glob(".nuxt/") ~= ""
				end,
				vue3 = function()
					return vim.fn.filereadable("vite.config.ts") == 1 or vim.fn.filereadable("src/App.vue") == 1
				end,
				priority = { "nuxt", "vue3" },
			},
			lsp = {
				override_definition = true, -- override vim.lsp.buf.definition
			},
			debounce = 200,
		},
	},
}
