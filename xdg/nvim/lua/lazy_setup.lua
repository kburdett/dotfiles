local get_setup = function(name)
    return function()
        require('setup/' .. name)
    end
end

local isNative = not vim.g.vscode

return {
    -- colorschemes
    {
        'navarasu/onedark.nvim',
        lazy = false,
        priority = 1000,
        cond = isNative,
        config = get_setup('onedark'),
    },

    -- core
    { 'echasnovski/mini.nvim',             config = get_setup('mini') },
    { 'lewis6991/gitsigns.nvim',           cond = isNative,           config = get_setup('gitsigns') },

    -- ui
    { 'nvim-tree/nvim-web-devicons',       cond = isNative },
    { 'nvim-lualine/lualine.nvim',         cond = isNative,           config = get_setup('lualine') },
    { 'kdheepak/tabline.nvim',             cond = isNative,           config = get_setup('tabline') },
    { 'nvim-tree/nvim-tree.lua',           cond = isNative,           config = get_setup('tree') },
    { 'akinsho/toggleterm.nvim',           cond = isNative,           config = get_setup('toggleterm') },
    { 'folke/trouble.nvim',                cond = isNative,           config = get_setup('trouble') },

    -- filetypes
    { 'chrisbra/csv.vim',                  ft = 'csv' },
    { 'stephpy/vim-yaml',                  ft = { 'yaml', 'yml' } },
    { 'PProvost/vim-ps1',                  ft = 'ps1' },
    { 'ekalinin/Dockerfile.vim',           ft = 'Dockerfile' },

    -- lsp
    { 'williamboman/mason.nvim',           cond = isNative,           config = get_setup('mason') },
    { 'williamboman/mason-lspconfig.nvim', cond = isNative,           config = get_setup('mason-lspconfig') },
    { 'neovim/nvim-lspconfig',             cond = isNative,           config = get_setup('lspconfig') },

    -- snippets
    { 'L3MON4D3/LuaSnip',                  cond = isNative },
    { 'rafamadriz/friendly-snippets',      cond = isNative },

    -- completion
    {
        'hrsh7th/nvim-cmp',
        cond = isNative,
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
