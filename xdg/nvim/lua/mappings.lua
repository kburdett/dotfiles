local opts = { silent = true }
vim.keymap.set('n', '<Leader>/', '<Cmd>nohlsearch<CR>', opts)

-- quick line endings
vim.keymap.set('n', '<Leader>,', 'mqA,<Esc>`q', opts)
vim.keymap.set('n', '<Leader>;', 'mqA;<Esc>`q', opts)

-- add empty lines before and after cursor line
vim.keymap.set('n', '<Leader>O', "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>", opts)
vim.keymap.set('n', '<Leader>o', "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>", opts)

-- kill the command ex mode key
vim.keymap.set('n', 'Q', '<Nop>', opts)

-- switch between window splits
vim.keymap.set('n', '<C-K>', '<Cmd>wincmd k<CR>', opts)
vim.keymap.set('n', '<C-J>', '<Cmd>wincmd j<CR>', opts)
vim.keymap.set('n', '<C-H>', '<Cmd>wincmd h<CR>', opts)
vim.keymap.set('n', '<C-L>', '<Cmd>wincmd l<CR>', opts)

-- diagnostics: [d / ]d (prev/next) and <C-w>d (float) are built in
vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist, opts)

-- terminal mappings (apply to every terminal buffer)
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts)
vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)

-- reformat whole buffer (uses the LSP formatter when one is attached)
vim.keymap.set('n', '<Leader>r', 'ggVGgq', opts)

-- "entire buffer" text object, e.g. yae, dae, =ae, vae
vim.keymap.set('x', 'ae', '<Esc>ggVG', { silent = true, desc = 'Entire buffer' })
vim.keymap.set('o', 'ae', ':<C-u>normal! ggVG<CR>', { silent = true, desc = 'Entire buffer' })

-- toggle a terminal in a split along the bottom (replaces toggleterm)
if not vim.g.vscode then
    vim.keymap.set('n', '<Leader>t', function() require('terminal').toggle() end, { desc = 'Toggle terminal' })
end
