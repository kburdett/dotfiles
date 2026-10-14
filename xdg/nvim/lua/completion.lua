-- Native completion (Neovim 0.12+), replacing nvim-cmp.
--   Insert mode: the menu appears as you type. In LSP buffers the items come from
--   the language server (see setup/lsp.lua); elsewhere they are words from open buffers.
--   Command line: the menu appears as you type after :, / or ?.
--
--   <Tab>/<S-Tab>  next/previous item (or jump through snippet placeholders)
--   <CR>           accept the selected item (a plain newline if nothing is selected)
--   <C-y>          accept the selected item
--   <C-e>          close the menu
--   <C-Space>      open the menu manually

-- insert mode
vim.o.autocomplete = true
vim.opt.complete = { '.', 'w', 'b', 'u' } -- current buffer, other windows, loaded & unloaded buffers
vim.opt.completeopt = { 'menuone', 'noselect', 'popup', 'fuzzy' }
vim.o.pumheight = 15

-- command line
vim.opt.wildmode = { 'noselect:lastused', 'full' }
vim.api.nvim_create_autocmd('CmdlineChanged', {
    group = vim.api.nvim_create_augroup('UserCmdlineComplete', { clear = true }),
    pattern = { ':', '/', '?' },
    callback = function()
        vim.fn.wildtrigger()
    end,
})
-- keep <Up>/<Down> for command-line history while the menu is open
vim.keymap.set('c', '<Up>', function()
    return vim.fn.wildmenumode() == 1 and '<C-e><Up>' or '<Up>'
end, { expr = true })
vim.keymap.set('c', '<Down>', function()
    return vim.fn.wildmenumode() == 1 and '<C-e><Down>' or '<Down>'
end, { expr = true })

-- insert-mode mappings
local pumvisible = function()
    return vim.fn.pumvisible() == 1
end

vim.keymap.set({ 'i', 's' }, '<Tab>', function()
    if pumvisible() then
        return '<C-n>'
    elseif vim.snippet.active({ direction = 1 }) then
        return '<Cmd>lua vim.snippet.jump(1)<CR>'
    end
    return '<Tab>'
end, { expr = true, silent = true })

vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
    if pumvisible() then
        return '<C-p>'
    elseif vim.snippet.active({ direction = -1 }) then
        return '<Cmd>lua vim.snippet.jump(-1)<CR>'
    end
    return '<S-Tab>'
end, { expr = true, silent = true })

vim.keymap.set('i', '<CR>', function()
    if pumvisible() and vim.fn.complete_info({ 'selected' }).selected ~= -1 then
        return '<C-y>'
    end
    -- keep mini.pairs' smart newline between brackets
    return _G.MiniPairs and _G.MiniPairs.cr() or '<CR>'
end, { expr = true, silent = true })

vim.keymap.set('i', '<C-Space>', function()
    if next(vim.lsp.get_clients({ bufnr = 0, method = 'textDocument/completion' })) then
        vim.lsp.completion.get()
    else
        vim.api.nvim_feedkeys(vim.keycode('<C-n>'), 'n', false)
    end
end, { silent = true })
