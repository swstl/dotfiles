
-- behaviour
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.opt.number = true
vim.opt.relativenumber = true

--------- keymapping ----------
vim.g.mapleader = " "
vim.api.nvim_set_keymap('n', 'j', 'k', { noremap = true })
vim.api.nvim_set_keymap('n', 'k', 'j', { noremap = true })
vim.api.nvim_set_keymap('v', 'j', 'k', { noremap = true })
vim.api.nvim_set_keymap('v', 'k', 'j', { noremap = true })
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', {desc = 'Yank to clipboard'})
