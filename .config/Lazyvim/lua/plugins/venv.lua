local function shorter_name(filename)
  local cwd = vim.fn.getcwd()
  local result = filename
  if result:sub(1, #cwd) == cwd then
    result = "." .. result:sub(#cwd + 1)
  end
  return result:gsub("/bin/python", "")
end

return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  },
  ft = "python",
  keys = {
    { ",v", "<cmd>VenvSelect<cr>" },
  },
  opts = {
    search = {
      cwd = {
        command = 'find "$(pwd)" -type l -name python',
        on_telescope_result_callback = shorter_name,
      },
      workspace = false,
      venv = false,
      poetry = false,
      pipenv = false,
      pyenv = false,
      hatch = false,
      conda = false,
    },
    options = {
      notify_user_on_venv_activation = true,
      statusline_func = {
        lualine = function()
          local venv_path = require("venv-selector").venv()
          if not venv_path or venv_path == "" then
            return ""
          end

          local venv_name = vim.fn.fnamemodify(venv_path, ":t")
          if not venv_name then
            return ""
          end

          local output = "🐍 " .. venv_name .. " " -- Changes only the icon but you can change colors or use powerline symbols here.
          return output
        end,
      },
    },
  },
}
