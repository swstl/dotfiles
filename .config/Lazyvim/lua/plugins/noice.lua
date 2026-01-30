return {
  "folke/noice.nvim",
  config = function()
    local noice = require("noice")
    noice.setup({
      notify = {
        enabled = false, -- Add this
      },
      routes = {
        {
          view = "notify",
          filter = { event = "msg_showmode" },
        },
      },
    })
  end,
}
