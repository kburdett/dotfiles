vim.api.nvim_create_user_command('Vimrc', "edit $MYVIMRC", { bang = true })
vim.api.nvim_create_user_command('PrettyXml', "% !xmllint %", { bang = true })
vim.api.nvim_create_user_command('PrettyJson', "% !jq '.'", { bang = true })
vim.api.nvim_create_user_command('MinJson', "% !jq '.' -c", { bang = true })

vim.api.nvim_create_user_command(
    'PJ',
    function()
        vim.cmd([[
        put
        set ft=json
        %!jq '.'
    ]])
    end,
    { bang = true, desc = 'Paste and format JSON' }
)

-- auto source .vimrc on save
local au_reload_vimrc = vim.api.nvim_create_augroup("AutoReloadVimRC", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", { pattern = '$MYVIMRC', command = 'so $MYVIMRC', group = au_reload_vimrc })
vim.api.nvim_create_autocmd("BufWritePost", { pattern = '$MYGVIMRC', command = 'so $MYGVIMRC', group = au_reload_vimrc })
