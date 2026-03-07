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




-- for internal coder auto-sync on save
-- Toggle variable
_G.auto_sync_enabled = false

-- Function to toggle auto-sync
_G.toggle_auto_sync = function()
  _G.auto_sync_enabled = not _G.auto_sync_enabled
  if _G.auto_sync_enabled then
    vim.notify("Auto-sync ENABLED", vim.log.levels.INFO)
  else
    vim.notify("Auto-sync DISABLED", vim.log.levels.INFO)
  end
end

-- Autocommand to sync on save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.py",
  callback = function()
    if _G.auto_sync_enabled then
      vim.fn.jobstart("make sync", {
        on_exit = function(_, exit_code)
          if exit_code == 0 then
            vim.notify("Synced to Coder", vim.log.levels.INFO)
          else
            vim.notify("Sync failed!", vim.log.levels.ERROR)
          end
        end,
      })
    end
  end,
})

-- Key mapping to toggle (adjust to your preference)
vim.keymap.set("n", "<localleader>ts", toggle_auto_sync, { desc = "Toggle auto-sync to Coder" })






-- Auto-setup uv + Jupyter kernel when opening .ju.py files
local _jupy_setup_dirs = {}

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.ju.py",
  callback = function(args)
    local dir = vim.fn.fnamemodify(args.file, ":h")
    if _jupy_setup_dirs[dir] then return end
    _jupy_setup_dirs[dir] = true

    if vim.fn.isdirectory(dir .. "/.venv") == 1 then return end

    local project_name = vim.fn.fnamemodify(dir, ":t")

    local function install_kernel()
      vim.fn.jobstart(
        { "uv", "run", "python", "-m", "ipykernel", "install", "--user", "--name", project_name },
        {
          cwd = dir,
          on_exit = function(_, code)
            vim.schedule(function()
              if code == 0 then
                vim.notify("Jupyter kernel '" .. project_name .. "' ready", vim.log.levels.INFO)
              else
                vim.notify("ipykernel install failed", vim.log.levels.ERROR)
              end
            end)
          end,
        }
      )
    end

    local function add_packages()
      vim.notify("uv: adding ipython jupyter ipykernel...", vim.log.levels.INFO)
      vim.fn.jobstart({ "uv", "add", "ipython", "jupyter", "ipykernel" }, {
        cwd = dir,
        on_exit = function(_, code)
          vim.schedule(function()
            if code == 0 then
              install_kernel()
            else
              vim.notify("uv add failed", vim.log.levels.ERROR)
            end
          end)
        end,
      })
    end

    if vim.fn.filereadable(dir .. "/pyproject.toml") == 1 then
      add_packages()
    else
      vim.notify("uv: initializing project in " .. dir, vim.log.levels.INFO)
      vim.fn.jobstart({ "uv", "init" }, {
        cwd = dir,
        on_exit = function(_, code)
          vim.schedule(function()
            if code == 0 then
              add_packages()
            else
              vim.notify("uv init failed", vim.log.levels.ERROR)
            end
          end)
        end,
      })
    end
  end,
})


vim.cmd("colorscheme kanagawa")
