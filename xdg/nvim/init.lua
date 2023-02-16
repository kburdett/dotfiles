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
    'dense-analysis/ale',
    'chrisbra/csv.vim',
    'joshdick/onedark.vim',
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

