-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
vim.g.maplocalleader = "\\"

-- Swap 'j' and 'k' in normal and visual modes
map({ "n", "v" }, "j", "k", { noremap = true, silent = true })
map({ "n", "v" }, "k", "j", { noremap = true, silent = true })

-- Toggle neotree
map("n", "<C-;>", function()
  -- Get the buffer of the current window
  local current_buf = vim.api.nvim_get_current_buf()

  -- Check if the current buffer is a Neo-tree buffer
  if vim.fn.bufname(current_buf):match("neo%-tree") then
    -- Close Neo-tree if the focus is on it
    vim.cmd("Neotree close")
  else
    -- Focus Neo-tree if the focus is not on it
    vim.cmd("Neotree focus")
  end
end, {})

-- yank to clipboard
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })

-- change to comment
map("n", "<C-c>", "gcc", { remap = true, desc = "Toggle comment" })
map("v", "<C-c>", "gc", { remap = true, desc = "Toggle comment" })

-- format files
map("n", "+", function()
  require("conform").format({
    bufnr = vim.api.nvim_get_current_buf(), -- Format the current buffer
  })
end, { desc = "Format with conform.nvim" })

map("n", "_", vim.lsp.buf.format, { desc = "Format with LSP" })

-- Treesitter Decremental Selection
map("v", "<A-i>", function()
  -- Decrement the selection in visual mode
  vim.api.nvim_feedkeys("grm", "v", true)
end, { desc = "Treesitter Decremental Selection with Alt-i in Visual Mode" })
-- Treesitter Incremental Selection
map("v", "<A-o>", function()
  -- Increment the selection in visual mode
  vim.api.nvim_feedkeys("grn", "v", true)
end, { desc = "Treesitter Incremental Selection with Alt-o in Visual Mode" })


-- iron
vim.keymap.set("n", "<space>rs", "<cmd>IronRepl<cr>")
vim.keymap.set("n", "<space>rr", "<cmd>IronRestart<cr>")
vim.keymap.set("n", "<space>rF", "<cmd>IronFocus<cr>")
vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")
