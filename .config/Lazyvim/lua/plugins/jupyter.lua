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
    local python_format = require("iron.fts.common").bracketed_paste_python
    require("iron.core").setup({
    config = {
        repl_definition = {
          python = {
            command = { 'ipython', '--no-autoindent' },
            format = python_format,
          },
        },
        repl_open_cmd = require('iron.view').split.horizontal.botright(15),
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
            vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "<cmd>lua require('iron.core').send_line()<CR>", { noremap = true, silent = true })

            -- Visual mode: Run `iron.visual_send()` (send selected block)
            vim.api.nvim_buf_set_keymap(0, "v", "<CR>", "<cmd>lua require('iron.core').visual_send()<CR>", { noremap = true, silent = true })
        end,
    })


  end,
}


