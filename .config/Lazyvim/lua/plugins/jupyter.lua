-- return {
--   {
--     "dccsillag/magma-nvim",
--     build = ":UpdateRemotePlugins",
--     config = function()
--       vim.g.magma_automatically_open_output = false
--     end
--   }
-- }
--
return {
  "hkupty/iron.nvim",
  config = function(plugins, opts)
    local iron = require("iron.core")
    local view = require("iron.view")
    local common = require("iron.fts.common")

    iron.setup({
      config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
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
      keymaps = {
        send_motion = "<space>rc",
        visual_send = "<space>rc",
        send_file = "<space>rf",
        send_line = "<space>rl",
        send_mark = "<space>rm",
        mark_motion = "<space>rmc",
        mark_visual = "<space>rmc",
        remove_mark = "<space>rmd",
        cr = "<space>r<cr>",
        interrupt = "<space>r<space>",
        exit = "<space>rq",
        clear = "<space>rx",
      },
      -- If the highlight is on, you can change how it looks
      -- For the available options, check nvim_set_hl
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function()
        -- Normal mode: Run `iron.send_line()` (send current line)
        vim.api.nvim_buf_set_keymap(
          0,
          "n",
          "<CR>",
          "<cmd>lua require('iron.core').send_line()<CR>",
          { noremap = true, silent = true }
        )

        -- Visual mode: Run `iron.visual_send()` (send selected block)
        vim.api.nvim_buf_set_keymap(
          0,
          "v",
          "<CR>",
          "<cmd>lua require('iron.core').visual_send()<CR>",
          { noremap = true, silent = true }
        )
      end,
    })
  end,

  -- {
  --   "kiyoon/jupynium.nvim",
  --   build = "pip3 install --user .",
  --   -- build = "uv pip install . --python=$HOME/.virtualenvs/jupynium/bin/python",
  --   -- build = "conda run --no-capture-output -n jupynium pip install .",
  -- },
  -- "rcarriga/nvim-notify", -- optional
  -- "stevearc/dressing.nvim", -- optional, UI for :JupyniumKernelSelect
}
