return {
  "folke/noice.nvim",
  config = function()
    local noice = require("noice")
    noice.setup({
      routes = {
        {
          view = "notify",
          filter = { event = "msg_showmode" },
        },
      },
    })
  end,
}
