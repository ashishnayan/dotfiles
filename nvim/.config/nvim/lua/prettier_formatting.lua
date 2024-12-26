-- Prettier  Formatting
vim.keymap.set('n', '<leader>fp', ':!prettier --write %<CR><CR>',
  { noremap = false, silent = true, desc = "Prettier Format" })
