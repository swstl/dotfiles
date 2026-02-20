-- return {
--   {
--     "dccsillag/magma-nvim",
--     build = ":UpdateRemotePlugins",
--     config = function()
--       vim.g.magma_automatically_open_output = false
--     end
--   }
-- }

return {
  {
    "hkupty/iron.nvim",
    config = function(plugins, opts)
    local iron = require("iron.core")
    local view = require("iron.view")
    local common = require("iron.fts.common")

    iron.setup({
      config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        close_window_on_exit = false,
        -- Your repl definitions come here
        repl_definition = {
          python = {
            command = { "ipython", "--no-autoindent" },
            format = common.bracketed_paste_python,
            block_dividers = { "# %%", "#%%" }, -- Support for Jupyter-style cells
          },
        },
        -- Determine repl filetype based on buffer filetype
        repl_filetype = function(bufnr, ft)
          return ft
        end,
        -- Enable DAP integration (optional)
        dap_integration = true,
        -- How the repl window will be displayed
        repl_open_cmd = view.split.horizontal.botright(15),
      },
      -- Iron doesn't set keymaps by default anymore.
      -- You can set them here or manually add keymaps to the functions in iron.core
      keymaps = {},
      -- If the highlight is on, you can change how it looks
      -- For the available options, check nvim_set_hl
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    })

    -- Iron keymaps only for regular .py files (not .ju.py)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function()
        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname:match("%.ju%.py$") then
          return
        end

        local map = function(mode, lhs, rhs)
          vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, { noremap = true, silent = true })
        end

        -- Iron REPL keymaps
        map("n", "<space>rc", "<cmd>lua require('iron.core').send_motion()<CR>")
        map("v", "<space>rc", "<cmd>lua require('iron.core').visual_send()<CR>")
        map("n", "<space>rf", "<cmd>lua require('iron.core').send_file()<CR>")
        map("n", "<space>rl", "<cmd>lua require('iron.core').send_line()<CR>")
        map("n", "<space>rm", "<cmd>lua require('iron.core').send_mark()<CR>")
        map("n", "<space>rmc", "<cmd>lua require('iron.core').mark_motion()<CR>")
        map("v", "<space>rmc", "<cmd>lua require('iron.core').mark_visual()<CR>")
        map("n", "<space>rmd", "<cmd>lua require('iron.core').remove_mark()<CR>")
        map("n", "<space>r<cr>", "<cmd>lua require('iron.core').cr()<CR>")
        map("n", "<space>r<space>", "<cmd>lua require('iron.core').interrupt()<CR>")
        map("n", "<space>rq", "<cmd>lua require('iron.core').exit()<CR>")
        map("n", "<space>rx", "<cmd>lua require('iron.core').clear()<CR>")
        map("n", "<CR>", "<cmd>lua require('iron.core').send_line()<CR>")
        map("v", "<CR>", "<cmd>lua require('iron.core').visual_send()<CR>")
      end,
    })

    -- Jupynium keymaps only for .ju.py files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function()
        local bufname = vim.api.nvim_buf_get_name(0)
        if not bufname:match("%.ju%.py$") then
          return
        end

        local map = function(mode, lhs, rhs)
          vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, { noremap = true, silent = true })
        end

        -- Jupynium keymaps
        map("n", "<space>rx", "<cmd>JupyniumExecuteSelectedCells<CR>")
        map("n", "<space>rc", "<cmd>JupyniumClearSelectedCellsOutputs<CR>")
        map("n", "<space>rK", "<cmd>JupyniumKernelHover<CR>")
        map("n", "<space>rR", "<cmd>JupyniumKernelRestart<CR>")
        map("n", "<space>ri", "<cmd>JupyniumKernelInterrupt<CR>")
        map("n", "<space>rs", "<cmd>JupyniumStartSync<CR>")
        map("n", "<space>rS", "<cmd>JupyniumStopSync<CR>")
        map("n", "<space>ra", "<cmd>JupyniumStartAndAttachToServer<CR>")
        map("n", "<space>rk", "<cmd>JupyniumKernelSelect<CR>")
        map("n", "<space>ro", "<cmd>JupyniumToggleSelectedCellsOutputsScroll<CR>")
        map("n", "<space>rd", "<cmd>JupyniumDownloadIpynb<CR>")
        map("n", "<CR>", "<cmd>JupyniumExecuteSelectedCells<CR>")
      end,
    })
  end,
  },

  {
    "kiyoon/jupynium.nvim",
    -- build = "pip3 install --user .",
    build = "uv pip install . --python=$HOME/.virtualenvs/jupynium/bin/python",
    -- build = "conda run --no-capture-output -n jupynium pip install .",
    opts = {
      python_host = vim.fn.expand "~/.virtualenvs/jupynium/bin/python",
      jupyter_command = vim.fn.expand "~/.virtualenvs/jupynium/bin/jupyter",
    },
  },
  -- "rcarriga/nvim-notify", -- optional
  "stevearc/dressing.nvim", -- optional, UI for :JupyniumKernelSelect
}
