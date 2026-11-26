-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Open a terminal in a split (LazyVim's <leader>ft/<leader>fT/<c-/> already
-- cover the floating terminal; these cover splits). Window navigation between
-- them uses the same <C-h/j/k/l> LazyVim already maps in terminal mode.
vim.keymap.set("n", "<leader>th", function()
  vim.cmd.new()
  vim.cmd.term()
  vim.cmd.startinsert()
end, { desc = "Terminal (horizontal split)" })

vim.keymap.set("n", "<leader>tv", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.startinsert()
end, { desc = "Terminal (vertical split)" })
