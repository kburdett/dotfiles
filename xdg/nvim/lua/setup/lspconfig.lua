
local lsp_setup = {
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
}

local lspconfig = require('lspconfig')
lspconfig['bashls'].setup(lsp_setup)
lspconfig['docker_compose_language_service'].setup(lsp_setup)
lspconfig['dockerls'].setup(lsp_setup)
lspconfig['eslint'].setup(lsp_setup)
lspconfig['html'].setup(lsp_setup)
lspconfig['jsonls'].setup(lsp_setup)
lspconfig['lua_ls'].setup(lsp_setup)
lspconfig['marksman'].setup(lsp_setup)
lspconfig['powershell_es'].setup(lsp_setup)
lspconfig['sqlls'].setup(lsp_setup)
lspconfig['yamlls'].setup(lsp_setup)

