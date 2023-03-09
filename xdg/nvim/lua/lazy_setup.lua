local get_setup = function(name)
    return function()
        require('setup/' .. name)
    end
end

return {
    -- colorschemes
    {
        'navarasu/onedark.nvim',
        lazy = false,
        priority = 1000,
        config = get_setup('onedark'),
    },

    -- core
    'kburdett/vim-nuuid',
    { 'echasnovski/mini.nvim',             config = get_setup('mini') },
    { 'lewis6991/gitsigns.nvim',           config = get_setup('gitsigns') },

    -- ui
    { 'nvim-lualine/lualine.nvim',         config = get_setup('lualine') },
    { 'kdheepak/tabline.nvim',             config = get_setup('tabline') },
    { 'nvim-tree/nvim-web-devicons' },
    { 'nvim-tree/nvim-tree.lua',           config = get_setup('tree') },

    -- filetypes
    { 'chrisbra/csv.vim',                  ft = 'csv' },
    { 'stephpy/vim-yaml',                  ft = { 'yaml', 'yml' } },
    { 'PProvost/vim-ps1',                  ft = 'ps1' },
    { 'ekalinin/Dockerfile.vim',           ft = 'Dockerfile' },

    -- lsp
    { 'williamboman/mason.nvim',           config = get_setup('mason') },
    { 'williamboman/mason-lspconfig.nvim', config = get_setup('mason-lspconfig') },
    { 'neovim/nvim-lspconfig',             config = get_setup('lspconfig') },

    -- snippets
    { 'L3MON4D3/LuaSnip' },
    { 'rafamadriz/friendly-snippets' },

    -- completion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        config = get_setup('cmp'),
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip'
        },
    },

}
