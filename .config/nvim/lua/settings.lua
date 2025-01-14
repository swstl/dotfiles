-- behaviour
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.opt.number = true
vim.opt.relativenumber = true
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })

--------- keymapping ----------
vim.g.mapleader = " "
vim.api.nvim_set_keymap("n", "j", "k", { noremap = true })
vim.api.nvim_set_keymap("n", "k", "j", { noremap = true })
vim.api.nvim_set_keymap("v", "j", "k", { noremap = true })
vim.api.nvim_set_keymap("v", "k", "j", { noremap = true })

-- Treesitter Incremental Selection
vim.keymap.set("v", "<A-o>", function()
  -- Increment the selection in visual mode
  vim.api.nvim_feedkeys("grn", "v", true)
end, { desc = "Treesitter Incremental Selection with Alt-o in Visual Mode" })

vim.keymap.set("v", "<A-i>", function()
  -- Decrement the selection in visual mode
  vim.api.nvim_feedkeys("grm", "v", true)
end, { desc = "Treesitter Decremental Selection with Alt-i in Visual Mode" })

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set("n", "<C-c>", "gcc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("v", "<C-c>", "gc", { remap = true, desc = "Toggle comment" })

-- copilot
-- vim.keymap.set("i", "<C-L>", "<Plug>(copilot-accept-word)", { desc = "Accept Copilot Word" })
-- vim.keymap.set("i", "<C-]>", "<Plug>(copilot-dismiss)", { desc = "Dismiss Copilot Suggestion" })
-- vim.keymap.set("i", "<M-]>", "<Plug>(copilot-next)", { desc = "Next Copilot Suggestion" })
-- vim.keymap.set("i", "<M-[>", "<Plug>(copilot-previous)", { desc = "Previous Copilot Suggestion" })
-- vim.keymap.set("n", "<C-k>", "<Plug>(copilot-suggest)", { desc = "Request Copilot Suggestion" })
-- vim.keymap.set("n", "<M-C-Right>", "<Plug>(copilot-accept-line)", { desc = "Accept Copilot Line" })
vim.keymap.set("i", "<C-L>", "<Plug>(copilot-accept-word)")
-- vim.keymap.set("i", "<C-L>", "<Plug>(copilot-suggest)")
-- vim.keymap.set("i", "<C-K>", "<Plug>(copilot-suggest)", { silent = true })

