-- variables
local map = vim.keymap.set
local cmd = vim.cmd
local apiMap = vim.api.nvim_set_keymap


-- behaviour
cmd("set expandtab")
cmd("set tabstop=2")
cmd("set softtabstop=2")
cmd("set shiftwidth=2")
vim.opt.number = true
vim.opt.relativenumber = true
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.opt.scrolloff = 4
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--------- keymapping ----------
vim.g.mapleader = " "
apiMap("n", "j", "k", { noremap = true })
apiMap("n", "k", "j", { noremap = true })
apiMap("v", "j", "k", { noremap = true })
apiMap("v", "k", "j", { noremap = true })
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--

-- Neotree keymapping
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

--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
-- Treesitter Incremental Selection
map("v", "<A-o>", function()
  -- Increment the selection in visual mode
  vim.api.nvim_feedkeys("grn", "v", true)
end, { desc = "Treesitter Incremental Selection with Alt-o in Visual Mode" })

-- Treesitter Decremental Selection
map("v", "<A-i>", function()
  -- Decrement the selection in visual mode
  vim.api.nvim_feedkeys("grm", "v", true)
end, { desc = "Treesitter Decremental Selection with Alt-i in Visual Mode" })

map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
map("n", "<C-c>", "gcc", { remap = true, desc = "Toggle comment" })
map("v", "<C-c>", "gc", { remap = true, desc = "Toggle comment" })
-- 
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
-- copilot
-- map("i", "<C-L>", "<Plug>(copilot-accept-word)", { desc = "Accept Copilot Word" })
-- map("i", "<C-]>", "<Plug>(copilot-dismiss)", { desc = "Dismiss Copilot Suggestion" })
-- map("i", "<M-]>", "<Plug>(copilot-next)", { desc = "Next Copilot Suggestion" })
-- map("i", "<M-[>", "<Plug>(copilot-previous)", { desc = "Previous Copilot Suggestion" })
-- map("n", "<C-k>", "<Plug>(copilot-suggest)", { desc = "Request Copilot Suggestion" })
-- map("n", "<M-C-Right>", "<Plug>(copilot-accept-line)", { desc = "Accept Copilot Line" })
map("i", "<C-L>", "<Plug>(copilot-accept-word)")
-- map("i", "<C-L>", "<Plug>(copilot-suggest)")
-- map("i", "<C-K>", "<Plug>(copilot-suggest)", { silent = true })
