return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      mappings = {
        -- neo-tree's default binds <C-;> to "clear_selection", which shadowed
        -- the global <C-;> toggle. Override it so it closes the tree instead.
        ["<C-;>"] = function()
          vim.cmd("Neotree close")
        end,
      },
    },
  },
}
