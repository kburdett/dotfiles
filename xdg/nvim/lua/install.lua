-- Install everything this config uses and wait for it to finish, for the bootstrap scripts:
--   nvim --headless "+lua require('install')" +qa
-- Missing plugins are already installed by the time this runs (vim.pack.add installs them
-- synchronously, at the lockfile revision, without asking when headless). This then syncs the
-- rest to nvim-pack-lock.json, and installs Tree-sitter parsers and Mason servers, which run in
-- the background, so wait for those here. Anything already up to date is skipped.

local timeout = 10 * 60 * 1000

-- start on a new line: headless Neovim leaves its own progress messages unterminated
local function log(msg)
    io.stdout:write('\n' .. msg)
end

-- the PackChanged hook in plugins.lua would start :TSUpdate without waiting; done below instead
vim.g.pack_sync = true

-- Plugins: check out the revisions in the lockfile (vim.pack.get() reports the lockfile's
-- revision, git the one on disk), and delete plugins that are no longer in the config
local outdated, unused = {}, {}
for _, p in ipairs(vim.pack.get(nil, { info = false })) do
    if not p.active then
        table.insert(unused, p.spec.name)
    elseif vim.trim(vim.fn.system({ 'git', '-C', p.path, 'rev-parse', 'HEAD' })) ~= p.rev then
        table.insert(outdated, p.spec.name)
    end
end
if #outdated > 0 then
    log('Syncing plugins to the lockfile: ' .. table.concat(outdated, ', '))
    vim.pack.update(outdated, { target = 'lockfile', force = true })
    -- reload nvim-treesitter's code if it changed, so parsers are built for the new version
    for name in pairs(package.loaded) do
        if vim.startswith(name, 'nvim-treesitter') then
            package.loaded[name] = nil
        end
    end
end
if #unused > 0 then
    log('Deleting plugins no longer in the config: ' .. table.concat(unused, ', '))
    vim.pack.del(unused)
end

-- Tree-sitter parsers (the CLI is needed to build them; see setup/treesitter.lua).
-- update() rebuilds parsers that don't match the installed nvim-treesitter.
if vim.fn.executable('tree-sitter') == 1 then
    log('Installing Tree-sitter parsers...')
    local ts = require('nvim-treesitter')
    ts.install(require('setup/treesitter').languages):wait(timeout)
    ts.update():wait(timeout)
else
    log('Skipping Tree-sitter parsers: no tree-sitter CLI')
end

-- Mason language servers
local registry = require('mason-registry')
local refreshed = false
registry.refresh(function() refreshed = true end)
vim.wait(timeout, function() return refreshed end, 100)

local to_package = require('mason-lspconfig').get_mappings().lspconfig_to_package
local pending, failed = 0, {}
for _, server in ipairs(require('setup/mason-lspconfig').servers) do
    local name = to_package[server]
    local ok, pkg = pcall(registry.get_package, name or server)
    if not ok then
        table.insert(failed, server)
    elseif not pkg:is_installed() and not pkg:is_installing() then
        log('Installing ' .. pkg.name .. '...')
        pending = pending + 1
        pkg:install({}, function(success)
            pending = pending - 1
            if not success then
                table.insert(failed, pkg.name)
            end
        end)
    end
end
vim.wait(timeout, function() return pending == 0 end, 200)

if #failed > 0 then
    log('Failed to install: ' .. table.concat(failed, ', ') .. ' (see :Mason)')
else
    log('Neovim plugins, parsers and language servers are installed')
end
io.stdout:write('\n')
