-- Server configs come from nvim-lspconfig's `lsp/` directory; mason-lspconfig
-- enables every Mason-installed server via vim.lsp.enable().
-- Per-server overrides: vim.lsp.config('<name>', { ... }) or a file at lsp/<name>.lua.
--
-- Built-in LSP mappings (no setup needed):
--   K hover · grn rename · gra code action · grr references · gri implementation
--   grt type definition · gO document symbols · <C-s> (insert) signature help
--   gq / <Leader>r format via LSP (formatexpr) · omnifunc (<C-x><C-o>)

-- letters, digits and _ trigger completion on every keypress
local keyword_chars = {}
for c in ('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_'):gmatch('.') do
    table.insert(keyword_chars, c)
end

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspAttach', { clear = true }),
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

        -- native LSP completion (see completion.lua for mappings)
        if client:supports_method('textDocument/completion') then
            local provider = client.server_capabilities.completionProvider
            provider.triggerCharacters = vim.list.unique(
                vim.list_extend(vim.deepcopy(provider.triggerCharacters or {}), keyword_chars)
            )
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
            -- the server drives the menu here, so turn off buffer-word autocomplete
            vim.bo[ev.buf].autocomplete = false
        end

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
