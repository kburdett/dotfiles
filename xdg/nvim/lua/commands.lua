vim.api.nvim_create_user_command('Vimrc', 'edit $MYVIMRC', { bang = true })
vim.api.nvim_create_user_command('PrettyXml', '% !xmllint %', { bang = true })
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
