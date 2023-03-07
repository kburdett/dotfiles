
function get_setup(name)
  return function()
    require("setup." .. name)
  end
end

return {

    -- core
    {'nvim-lualine/lualine.nvim', config = get_setup('lualine')},
    'nvim-tree/nvim-web-devicons',
    {'nvim-tree/nvim-tree.lua', config = get_setup('tree')},
    {'kdheepak/tabline.nvim', config = get_setup('tabline')},
    {'terrortylor/nvim-comment', config = get_setup('comment')},
    {'lewis6991/gitsigns.nvim', config = get_setup('gitsigns')},
    'kburdett/vim-nuuid',
    {'kylechui/nvim-surround', config = get_setup('surround')},
    {'mhartington/formatter.nvim', config = get_setup('formatter')},

    -- filetypes
    'chrisbra/csv.vim',
    'stephpy/vim-yaml',
    'PProvost/vim-ps1',
    'ekalinin/Dockerfile.vim',
    'vim-scripts/nginx.vim',

    -- colorschemes
    'joshdick/onedark.vim',

    -- lsp
    {'williamboman/mason.nvim', config = get_setup('mason')},
    {'williamboman/mason-lspconfig.nvim', config = get_setup('mason-lspconfig')},
    {'neovim/nvim-lspconfig', config = get_setup('lspconfig')},

    -- snippets
    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',

    -- completion
    {
        'hrsh7th/nvim-cmp',
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

