-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.cmd([[
  " Customize visual-multi highlights for visibility
  highlight VM_Cursor guifg=NONE guibg=#FFFFFF gui=bold
  highlight VM_Insert guifg=NONE guibg=#33FFFF gui=bold
]])

vim.cmd([[
highlight CopilotSuggestion guifg=#009999 ctermfg=220
]])
