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

