-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Clean up the UI on split terminals opened via <leader>th / <leader>tv
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom_term_open", { clear = true }),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

-- Kitty <-> Neovim seamless split navigation.
-- kitty.conf maps ctrl+hjkl to neighboring_window, then passes those keys
-- through to nvim (instead of moving kitty panes) whenever the focused
-- window's IS_VIM user var is "true". Nvim's own <C-h/j/k/l> window nav then
-- takes over. This sets/clears that user var as nvim gains/loses focus, so
-- one keybind moves seamlessly between kitty splits and nvim splits
-- (including terminal splits).
if vim.env.KITTY_LISTEN_ON and vim.fn.executable("kitty") == 1 then
  local function set_is_vim(value)
    vim.system({ "kitty", "@", "set-user-vars", "IS_VIM=" .. value })
  end

  local kitty_group = vim.api.nvim_create_augroup("kitty_is_vim", { clear = true })
  vim.api.nvim_create_autocmd({ "VimEnter", "VimResume", "FocusGained" }, {
    group = kitty_group,
    callback = function()
      set_is_vim("true")
    end,
  })
  vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend", "FocusLost" }, {
    group = kitty_group,
    callback = function()
      set_is_vim("false")
    end,
  })
end
