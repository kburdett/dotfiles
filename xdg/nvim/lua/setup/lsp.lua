-- Server configs come from nvim-lspconfig's `lsp/` directory; mason-lspconfig
-- enables every Mason-installed server via vim.lsp.enable().
-- Per-server overrides: vim.lsp.config('<name>', { ... }) or a file at lsp/<name>.lua.
--
-- Built-in LSP mappings (no setup needed):
--   K hover · grn rename · gra code action · grr references · gri implementation
--   grt type definition · gO document symbols · <C-s> (insert) signature help
--   gq / <Leader>r format via LSP (formatexpr) · omnifunc (<C-x><C-o>)

vim.lsp.config('*', {
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspAttach', { clear = true }),
    callback = function(ev)
        local map = function(lhs, rhs, desc)
            vim.keymap.set('n', lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
        end
        map('gd', vim.lsp.buf.definition, 'Go to definition')
        map('gD', vim.lsp.buf.declaration, 'Go to declaration')
        map('<Leader>wa', vim.lsp.buf.add_workspace_folder, 'Add workspace folder')
        map('<Leader>wr', vim.lsp.buf.remove_workspace_folder, 'Remove workspace folder')
        map('<Leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, 'List workspace folders')
    end,
})
