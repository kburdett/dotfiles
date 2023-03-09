local get_setup = function(name)
    return function()
        require("setup/" .. name)
    end
end

return {
    -- colorschemes
    {
        'joshdick/onedark.vim',
        lazy = false,
        priority = 1000,
        config = get_setup('onedark'),
    },

    -- core
    'kburdett/vim-nuuid',
    { 'kdheepak/tabline.nvim',             config = get_setup('tabline') },
    { 'terrortylor/nvim-comment',          config = get_setup('comment') },
    { 'lewis6991/gitsigns.nvim',           config = get_setup('gitsigns') },
    { 'kylechui/nvim-surround',            config = get_setup('surround') },
    { 'mhartington/formatter.nvim',        config = get_setup('formatter') },

    -- ui
    { 'nvim-lualine/lualine.nvim',         config = get_setup('lualine') },
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
