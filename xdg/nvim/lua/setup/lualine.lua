require('lualine').setup({
    options = {
        theme = 'onedark',
    },
    -- buffers on the left, tabs on the right
    tabline = {
        lualine_a = { 'buffers' },
        lualine_z = { 'tabs' },
    },
    extensions = { 'nvim-tree', 'trouble', 'toggleterm' },
})
