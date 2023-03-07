
require('mason-lspconfig').setup({

    ensure_installed = {
        'bashls', -- bash
        'dockerls', -- dockerfile
        'docker_compose_language_service', -- docker compose
        'json-lsp', -- json
        'lemminx', -- xml
        'lua_ls', -- lua
        'marksman', -- markdown
        'powershell_es', -- powershell
        'tsserver', -- javascript
        'yamlls', -- yaml
    },

})

