require('nvim-tree').setup()

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<C-t>', '<cmd>NvimTreeFocus<cr>', opts)
vim.keymap.set('n', '<C-f>', '<cmd>NvimTreeFindFile<cr>', opts)
