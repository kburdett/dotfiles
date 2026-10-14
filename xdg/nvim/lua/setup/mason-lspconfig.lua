-- PowerShell Editor Services runs inside PowerShell. Prefer PowerShell 7 (pwsh), fall back to
-- Windows PowerShell (powershell.exe), and skip the server on machines that have neither
-- (otherwise opening a .ps1 file throws an error).
local powershell = (vim.fn.executable('pwsh') == 1 and 'pwsh')
    or (vim.fn.executable('powershell') == 1 and 'powershell')
    or nil
if powershell then
    vim.lsp.config('powershell_es', { shell = powershell })
end

require('mason-lspconfig').setup({
    ensure_installed = {
        'bashls',                          -- bash
        'docker_compose_language_service', -- docker compose
        'dockerls',                        -- dockerfile
        'eslint',                          -- javascript
        'jsonls',                          -- json
        'lemminx',                         -- xml
        'lua_ls',                          -- lua
        'marksman',                        -- markdown
        'powershell_es',                   -- powershell
        'yamlls',                          -- yaml
    },
    automatic_enable = {
        exclude = powershell and {} or { 'powershell_es' },
    },
})
