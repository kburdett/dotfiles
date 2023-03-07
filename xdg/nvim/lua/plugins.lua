-- init for lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

    -- core
    'nvim-lualine/lualine.nvim',
    'nvim-tree/nvim-web-devicons',
    'nvim-tree/nvim-tree.lua',
    'kdheepak/tabline.nvim',
    'terrortylor/nvim-comment',
    'lewis6991/gitsigns.nvim',
    'kburdett/vim-nuuid',
    'kylechui/nvim-surround',
    'mhartington/formatter.nvim',

    -- filetypes
    'chrisbra/csv.vim',
    'stephpy/vim-yaml',
    'PProvost/vim-ps1',
    'elzr/vim-json',
    'ekalinin/Dockerfile.vim',
    'vim-scripts/nginx.vim',

    -- colorschemes
    'joshdick/onedark.vim',

    -- lsp
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',

    -- completion
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
        },
    },

})

require('lualine').setup({
    extensions = {'nvim-tree', 'fugitive'}
})
require('tabline').setup()
require('nvim-tree').setup()
require('nvim_comment').setup()
require('nvim-surround').setup()
require('gitsigns').setup()
