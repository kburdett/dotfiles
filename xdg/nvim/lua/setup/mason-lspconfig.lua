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
})
