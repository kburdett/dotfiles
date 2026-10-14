require('toggleterm').setup()

vim.keymap.set('n', '<leader>t', '<Cmd>ToggleTerm size=15 direction=horizontal<CR>', { silent = true })
