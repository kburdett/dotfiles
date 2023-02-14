-- =========
--  Plugins
-- =========
vim.call('plug#begin', '$XDG_CACHE_HOME/nvim/plugged')

local Plug = vim.fn['plug#']
Plug('nvim-lualine/lualine.nvim')
Plug('nvim-tree/nvim-web-devicons')
Plug('nvim-tree/nvim-tree.lua')
Plug('romgrk/barbar.nvim')
Plug('ekalinin/Dockerfile.vim') 
Plug('tpope/vim-commentary')
Plug('tpope/vim-fugitive')
Plug('elzr/vim-json')
Plug('kburdett/vim-nuuid')
Plug('PProvost/vim-ps1')
Plug('tpope/vim-repeat')
Plug('tpope/vim-speeddating')
Plug('tpope/vim-surround')
Plug('tpope/vim-unimpaired')
Plug('stephpy/vim-yaml')
Plug('vim-scripts/nginx.vim')
Plug('w0rp/ale')
Plug('chrisbra/csv.vim') 
Plug('joshdick/onedark.vim')

-- Status line icons
Plug('kyazdani42/nvim-web-devicons')

vim.call('plug#end')

require('lualine').setup{
    extensions = {'nvim-tree', 'fugitive'}
}

-- empty setup using defaults
require("nvim-tree").setup()

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

-- barbar commands
-- Goto buffer in position...
vim.keymap.set('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
vim.keymap.set('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
vim.keymap.set('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
vim.keymap.set('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
vim.keymap.set('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
vim.keymap.set('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
vim.keymap.set('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
vim.keymap.set('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
vim.keymap.set('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
vim.keymap.set('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
-- Pin/unpin buffer
vim.keymap.set('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
-- Close buffer
vim.keymap.set('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)



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

