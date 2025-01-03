-- package manager:
require("config.lazy")


----------- from plugins: -----------
-- catppuccin:
require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"


-- telescope:
local builtin = require('telescope.builtin')


-- behaviour 
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")


--------- keymapping ----------
vim.g.mapleader = " "
vim.api.nvim_set_keymap('n', 'j', 'k', { noremap = true })
vim.api.nvim_set_keymap('n', 'k', 'j', { noremap = true })
vim.api.nvim_set_keymap('v', 'j', 'k', { noremap = true })
vim.api.nvim_set_keymap('v', 'k', 'j', { noremap = true })


-- telescope:
vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>h', builtin.help_tags, { desc = 'Telescope help tags' })


-- Neo-tree:
vim.keymap.set('n', '<C-;>', ':Neotree focus<CR>', {})
