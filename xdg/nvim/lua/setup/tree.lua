require('nvim-tree').setup()

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>d', '<cmd>NvimTreeFocus<cr>', opts)
vim.keymap.set('n', '<leader>f', '<cmd>NvimTreeFindFile<cr>', opts)
