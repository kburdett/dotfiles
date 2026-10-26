-- set this first to avoid mapping issues
vim.g.mapleader = ' '

-- Profile gate. Plugins, language servers and parsers load only where the profile file says
-- "full": bootstrap.sh / bootstrap.ps1 write it on workstations, and the infra repo's shell role
-- writes it on servers. A missing file, or anything else in it, means minimal: no plugins and
-- nothing downloaded, so a server stays safe even if the file is lost.
--   <config dir>/dotfiles/profile, next to this nvim folder (~/.config/dotfiles/profile)
local profile_file = vim.fs.dirname(vim.fn.stdpath('config')) .. '/dotfiles/profile'
local profile = vim.fn.filereadable(profile_file) == 1 and vim.fn.readfile(profile_file, '', 1)[1] or ''
vim.g.dotfiles_profile = vim.trim(profile) == 'full' and 'full' or 'minimal'
local full = vim.g.dotfiles_profile == 'full'

-- disable unused built-in plugins (netrw stays on in minimal: there's no nvim-tree to replace it)
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_zipPlugin = 1
if full then
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
end

-- options, mappings and commands need no plugins (and also run on Debian's older Neovim)
require('options')
if full then
    require('plugins')
    if not vim.g.vscode then
        require('completion')
    end
end
require('mappings')
require('commands')
