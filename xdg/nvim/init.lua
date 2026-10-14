-- set this first to avoid mapping issues
vim.g.mapleader = ' '

-- disable unused built-in plugins
vim.g.loaded_gzip = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_zipPlugin = 1

require('options')
require('plugins')
require('mappings')
require('commands')
