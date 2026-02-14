return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    scroll = {
      enabled = false,
      speed = 0,
      exclude = { "n", "N", "/", "?" },
      duration = { step = 5, total = 10 },
    },
  },
}
