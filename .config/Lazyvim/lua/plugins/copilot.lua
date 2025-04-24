vim.g.copilot_no_tab_map = true
vim.g.augment_disable_tab_mapping = true

return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          auto_refresh = false,
          keymap = {
            accept = "<CR>",
            jump_prev = "[[",
            jump_next = "]]",
            refresh = "gr",
            open = "<M-CR>",
          },
        },
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = "<M-l>",
            prev = "<M-[>",
            next = "<M-]>",
            dismiss = "<C-]>",
          },
        },
      })
    end,
  },
  {
    'augmentcode/augment.vim',
    config = function()
        vim.api.nvim_set_keymap("i", "<C-l>", "<cmd>call augment#Accept()<CR>", { noremap = true, silent = true })
    end,
  },
}



