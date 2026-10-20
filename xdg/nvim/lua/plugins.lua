-- Plugins are managed by the built-in vim.pack (Neovim 0.12+).
--   :PackUpdate  fetch updates and review them (:w to apply, :q to discard)
--   :PackClean   delete plugins on disk that are no longer listed here
-- Installed revisions are pinned in nvim-pack-lock.json (keep it in version control).

local gh = function(repo)
    return 'https://github.com/' .. repo
end

-- core (also loaded inside vscode-neovim)
vim.pack.add({
    gh('nvim-mini/mini.nvim'),
    gh('johmsalas/text-case.nvim'),
})

require('setup/mini')
require('setup/text-case')

-- If running inside vscode-neovim, we don't want to load any other plugins
if vim.g.vscode then
    return
end

-- rebuild Tree-sitter parsers whenever nvim-treesitter is updated (they must match its queries)
-- registered before vim.pack.add() so it also sees the plugin's first install
vim.api.nvim_create_autocmd('PackChanged', {
    group = vim.api.nvim_create_augroup('UserPackHooks', { clear = true }),
    callback = function(ev)
        -- (install.lua rebuilds them itself, and waits, when the bootstrap syncs plugins)
        if ev.data.spec.name == 'nvim-treesitter' and ev.data.kind == 'update' and not vim.g.pack_sync then
            if not ev.data.active then
                vim.cmd.packadd('nvim-treesitter')
            end
            vim.cmd('TSUpdate')
        end
    end,
})

vim.pack.add({
    -- colorscheme
    gh('navarasu/onedark.nvim'),

    -- ui
    gh('lewis6991/gitsigns.nvim'),
    gh('nvim-tree/nvim-web-devicons'),
    gh('nvim-lualine/lualine.nvim'),
    gh('nvim-tree/nvim-tree.lua'),
    gh('folke/trouble.nvim'),

    -- filetypes
    gh('chrisbra/csv.vim'),
    { src = gh('nvim-treesitter/nvim-treesitter'), version = 'main' },

    -- lsp
    gh('neovim/nvim-lspconfig'),
    gh('mason-org/mason.nvim'),
    gh('mason-org/mason-lspconfig.nvim'),
})

require('setup/onedark') -- colorscheme first
require('setup/gitsigns')
require('setup/lualine')
require('setup/tree')
require('setup/trouble')
require('setup/treesitter')
require('setup/lsp')
require('setup/mason')
require('setup/mason-lspconfig') -- must come after mason

vim.api.nvim_create_user_command('PackUpdate', function()
    vim.pack.update()
end, { desc = 'Update plugins' })

vim.api.nvim_create_user_command('PackClean', function()
    local unused = vim.iter(vim.pack.get(nil, { info = false }))
        :filter(function(p) return not p.active end)
        :map(function(p) return p.spec.name end)
        :totable()
    if #unused == 0 then
        vim.notify('No unused plugins')
        return
    end
    vim.pack.del(unused)
end, { desc = 'Delete plugins no longer in the config' })
