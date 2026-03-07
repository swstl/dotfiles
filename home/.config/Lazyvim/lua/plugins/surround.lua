return {
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    init = function()
      vim.g.nvim_surround_no_mappings = true
    end,
    config = function()
      require("nvim-surround").setup()
      vim.keymap.set("n", "gsa", "<Plug>(nvim-surround-normal)", { desc = "Add surrounding (normal)" })
      vim.keymap.set("n", "gsA", "<Plug>(nvim-surround-normal-line)", { desc = "Add surrounding (normal, line)" })
      vim.keymap.set("x", "gsa", "<Plug>(nvim-surround-visual)", { desc = "Add surrounding (visual)" })
      vim.keymap.set("x", "gsA", "<Plug>(nvim-surround-visual-line)", { desc = "Add surrounding (visual, line)" })
      vim.keymap.set("n", "gsd", "<Plug>(nvim-surround-delete)", { desc = "Delete surrounding" })
      vim.keymap.set("n", "gsf", "<Plug>(nvim-surround-find)", { desc = "Find surrounding (right)" })
      vim.keymap.set("n", "gsF", "<Plug>(nvim-surround-find-left)", { desc = "Find surrounding (left)" })
      vim.keymap.set("n", "gsh", "<Plug>(nvim-surround-highlight)", { desc = "Highlight surrounding" })
      vim.keymap.set("n", "gsr", "<Plug>(nvim-surround-change)", { desc = "Replace surrounding" })
      vim.keymap.set("n", "gsn", "<Plug>(nvim-surround-change-line)", { desc = "Replace surrounding (line)" })
    end,
  },
}

--
-- return {
--   "echasnovski/mini.surround",
--   recommended = true,
--   keys = function(_, keys)
--     -- Populate the keys based on the user's options
--     local opts = LazyVim.opts("mini.surround")
--     local mappings = {
--       { opts.mappings.add, desc = "Add Surrounding", mode = { "n", "v" } },
--       { opts.mappings.delete, desc = "Delete Surrounding" },
--       { opts.mappings.find, desc = "Find Right Surrounding" },
--       { opts.mappings.find_left, desc = "Find Left Surrounding" },
--       { opts.mappings.highlight, desc = "Highlight Surrounding" },
--       { opts.mappings.replace, desc = "Replace Surrounding" },
--       { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
--     }
--     mappings = vim.tbl_filter(function(m)
--       return m[1] and #m[1] > 0
--     end, mappings)
--     return vim.list_extend(mappings, keys)
--   end,
--   opts = {
--     mappings = {
--       add = "gsa", -- Add surrounding in Normal and Visual modes
--       delete = "gsd", -- Delete surrounding
--       find = "gsf", -- Find surrounding (to the right)
--       find_left = "gsF", -- Find surrounding (to the left)
--       highlight = "gsh", -- Highlight surrounding
--       replace = "gsr", -- Replace surrounding
--       update_n_lines = "gsn", -- Update `n_lines`
--     },
--   },
-- }
