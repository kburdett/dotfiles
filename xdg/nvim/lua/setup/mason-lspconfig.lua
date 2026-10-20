-- PowerShell Editor Services runs inside PowerShell. Prefer PowerShell 7 (pwsh), fall back to
-- Windows PowerShell (powershell.exe), and skip the server on machines that have neither
-- (otherwise opening a .ps1 file throws an error).
local powershell = (vim.fn.executable('pwsh') == 1 and 'pwsh')
    or (vim.fn.executable('powershell') == 1 and 'powershell')
    or nil
if powershell then
    vim.lsp.config('powershell_es', { shell = powershell })
end

-- Servers Mason installs with npm; they also need node to run. Without both, skip them
-- instead of failing every install on startup (`:checkhealth mason` shows what's missing).
-- On WSL, ignore Windows' npm/node leaking in through the Windows PATH (/mnt/c/...).
local npm_servers = {
    bashls = true,
    docker_compose_language_service = true,
    dockerls = true,
    eslint = true,
    jsonls = true,
    yamlls = true,
}

local function has(cmd)
    local path = vim.fn.exepath(cmd)
    return path ~= '' and not (vim.fn.has('wsl') == 1 and vim.startswith(path, '/mnt/'))
end
local has_npm = has('npm') and has('node')

local servers = {
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
}

local ensure_installed, exclude = {}, {}
for _, server in ipairs(servers) do
    if (npm_servers[server] and not has_npm) or (server == 'powershell_es' and not powershell) then
        table.insert(exclude, server)
    else
        table.insert(ensure_installed, server)
    end
end

require('mason-lspconfig').setup({
    ensure_installed = ensure_installed,
    automatic_enable = { exclude = exclude },
})

return { servers = ensure_installed }
