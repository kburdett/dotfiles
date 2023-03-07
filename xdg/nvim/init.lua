-- =========
--  Plugins
-- =========

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
    'nvim-lualine/lualine.nvim',
    'nvim-tree/nvim-web-devicons',
    'nvim-tree/nvim-tree.lua',
    'kdheepak/tabline.nvim',
    'ekalinin/Dockerfile.vim',
    'terrortylor/nvim-comment',
    'lewis6991/gitsigns.nvim',
    'elzr/vim-json',
    'kburdett/vim-nuuid',
    'PProvost/vim-ps1',
    'kylechui/nvim-surround',
    'stephpy/vim-yaml',
    'vim-scripts/nginx.vim',
    'chrisbra/csv.vim',
    'joshdick/onedark.vim',

    -- LSP
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
})

require('lualine').setup({
    extensions = {'nvim-tree', 'fugitive'}
})
require('tabline').setup()
require('nvim-tree').setup()
require('nvim_comment').setup()
require('nvim-surround').setup()
require('gitsigns').setup()

-- matchit!  
vim.cmd.runtime('macros/matchit.vim');


-- ===========
--  LSP Setup
-- ===========
require('mason').setup()
require('mason-lspconfig').setup()

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end


local cmp = require('cmp')
cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
    }, {
        { name = 'buffer' },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- Register language servers
local lsp_setup = {
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
}
local lspconfig = require('lspconfig')
lspconfig['bashls'].setup(lsp_setup)
lspconfig['docker_compose_language_service'].setup(lsp_setup)
lspconfig['dockerls'].setup(lsp_setup)
lspconfig['eslint'].setup(lsp_setup)
lspconfig['html'].setup(lsp_setup)
lspconfig['jsonls'].setup(lsp_setup)
lspconfig['lua_ls'].setup(lsp_setup)
lspconfig['marksman'].setup(lsp_setup)
lspconfig['powershell_es'].setup(lsp_setup)
lspconfig['sqlls'].setup(lsp_setup)
lspconfig['yamlls'].setup(lsp_setup)


-- =========
--  Options
-- =========

-- editing
vim.opt.clipboard:append('unnamedplus') -- yank to system clipboard by default
vim.opt.fileformats:remove('mac')
vim.opt.mouse = 'a'

-- display
vim.opt.showmatch = true
vim.opt.number = true
vim.opt.showcmd = true
vim.opt.scrolloff = 2
vim.opt.sidescrolloff = 5

-- indentation
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- swap and backup
vim.opt.swapfile = false

-- error bells
vim.opt.errorbells = false
vim.opt.visualbell = true

-- misc
vim.opt.ruler = true
vim.opt.hidden = true
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 100



-- ==============
--  Key Bindings
-- ==============
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<Leader>/', ':nohlsearch<CR>', opts)

-- quick line endings
vim.keymap.set('n', '<Leader>,', 'mqA,<Esc>`q', opts)
vim.keymap.set('n', '<Leader>;', 'mqA;<Esc>`q', opts)

-- map entire file text objects
vim.keymap.set('v', 'ae', ':<C-U>silent! normal! ggVG<CR>', opts)
vim.keymap.set('o', 'ae', ':<C-U>normal! ggVG<CR>', opts)

-- kill the command ex mode key
vim.keymap.set('n', 'Q', '<Nop>', opts);

-- switch between window splits
vim.keymap.set('n', '<C-K>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-J>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-H>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-L>', ':wincmd l<CR>', opts)


-- =================
--  Custom Commands
-- =================
vim.api.nvim_create_user_command('Vimrc', "edit $MYVIMRC", {bang = true})
vim.api.nvim_create_user_command('PrettyXml', "% !xmllint %", {bang = true})
vim.api.nvim_create_user_command('PrettyJson', "% !jq '.'", {bang = true})
vim.api.nvim_create_user_command('MinJson', "% !jq '.' -c", {bang = true})

vim.api.nvim_create_user_command(
  'PJ',
  function()
    vim.cmd ([[
        put
        set ft=json
        %!jq '.'
    ]])
  end,
  {bang = true, desc = 'Paste and format JSON'}
)

-- auto source .vimrc on save
local au_reload_vimrc = vim.api.nvim_create_augroup("AutoReloadVimRC", {clear = true})
vim.api.nvim_create_autocmd("BufWritePost", {pattern = '$MYVIMRC', command = 'so $MYVIMRC', group = au_reload_vimrc})
vim.api.nvim_create_autocmd("BufWritePost", {pattern = '$MYGVIMRC', command = 'so $MYGVIMRC', group = au_reload_vimrc})



-- =============
--  Colorscheme
-- =============
vim.opt.termguicolors = true
vim.cmd.colorscheme('onedark')

