-- editing
vim.opt.clipboard:append('unnamedplus') -- yank to system clipboard by default
vim.opt.mouse = 'a'                     -- default is 'nvi'; 'a' adds command-line mode

-- display
vim.opt.showmatch = true
vim.opt.number = true
vim.opt.scrolloff = 2
vim.opt.sidescrolloff = 5
vim.opt.termguicolors = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = 'screen' -- reduce scroll during window split

-- show trailing whitespace as · and non-breaking spaces as ␣
-- tabs stay invisible; :%s/\s\+$//e strips trailing whitespace
vim.opt.list = true
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }
-- like mini.trailspace, hide it while typing so fresh indentation isn't flagged
local trail_group = vim.api.nvim_create_augroup('UserTrailingSpace', { clear = true })
vim.api.nvim_create_autocmd('InsertEnter', {
    group = trail_group,
    callback = function() vim.opt_local.listchars:remove('trail') end,
})
vim.api.nvim_create_autocmd('InsertLeave', {
    group = trail_group,
    callback = function() vim.opt_local.listchars:append({ trail = '·' }) end,
})

-- indentation
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

-- searching
vim.opt.ignorecase = true
vim.opt.infercase = true
vim.opt.smartcase = true

-- swap and backup
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- misc
vim.opt.visualbell = true
vim.opt.ttimeoutlen = 100
vim.opt.shortmess:append('WcC') -- reduce command line messages

-- diagnostics (virtual text has been off by default since 0.11)
vim.diagnostic.config({ virtual_text = true })
