vim.cmd('filetype plugin indent on')

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
vim.opt.termguicolors = true
vim.opt.splitbelow = true
vim.opt.splitright = true

-- indentation
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- searching
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.infercase = true
vim.opt.smartcase = true
vim.opt.smartindent = true

-- swap and backup
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- error bells
vim.opt.errorbells = false
vim.opt.visualbell = true

-- misc
vim.opt.ruler = true
vim.opt.hidden = true
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 100

-- Neovim version dependent
if vim.fn.has('nvim-0.9') == 1 then
    vim.opt.shortmess:append('WcC') -- Reduce command line messages
    vim.opt.splitkeep = 'screen'    -- Reduce scroll during window split
else
    vim.opt.shortmess:append('Wc')  -- Reduce command line messages
end
