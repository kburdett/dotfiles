require('trouble').setup()

local opts = { silent = true }

vim.keymap.set('n', '<leader>xx', '<Cmd>Trouble diagnostics toggle filter.buf=0<CR>', opts)
vim.keymap.set('n', '<leader>xd', '<Cmd>Trouble diagnostics toggle filter.buf=0<CR>', opts)
vim.keymap.set('n', '<leader>xw', '<Cmd>Trouble diagnostics toggle<CR>', opts)
vim.keymap.set('n', '<leader>xl', '<Cmd>Trouble loclist toggle<CR>', opts)
vim.keymap.set('n', '<leader>xq', '<Cmd>Trouble qflist toggle<CR>', opts)
vim.keymap.set('n', 'gR', '<Cmd>Trouble lsp_references toggle<CR>', opts)
