local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<Leader>/', ':nohlsearch<CR>', opts)

-- quick line endings
vim.keymap.set('n', '<Leader>,', 'mqA,<Esc>`q', opts)
vim.keymap.set('n', '<Leader>;', 'mqA;<Esc>`q', opts)

-- add empty lines before and after cursor line
vim.keymap.set('n', '<Leader>O', "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>", opts)
vim.keymap.set('n', '<Leader>o', "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>", opts)

-- kill the command ex mode key
vim.keymap.set('n', 'Q', '<Nop>', opts);

-- switch between window splits
vim.keymap.set('n', '<C-K>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-J>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-H>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-L>', ':wincmd l<CR>', opts)

-- see `:help vim.diagnostic.*` for more details
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- terminal mappings
local topts = { noremap = true, silent = true, buffer = 0 }
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], topts)
vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], topts)
vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], topts)
vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], topts)
vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], topts)

-- reformat code
vim.keymap.set('n', '<Leader>r', 'ggVGgq', opts);
