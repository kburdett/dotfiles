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
