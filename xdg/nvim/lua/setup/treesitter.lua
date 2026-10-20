-- Tree-sitter highlighting
--
-- Highlighting itself is built into Neovim; nvim-treesitter only downloads and
-- compiles parsers (plus the query files that say how to highlight them).
-- Neovim already bundles parsers for c, lua, markdown, vim, vimdoc and query.
--
-- Building parsers needs, on each machine:
--   tree-sitter CLI 0.26.1+, a C compiler, tar and curl
-- Without the CLI nothing breaks: these filetypes keep regex highlighting.
-- :checkhealth nvim-treesitter shows what's missing; :TSUpdate rebuilds parsers.

-- parsers to install (bundled ones aren't needed here)
local languages = {
    'bash',
    'dockerfile',
    'javascript',
    'jsdoc', -- highlights /** ... */ comments in JavaScript
    'json',
    'powershell',
    'xml',
    'yaml',
}

if vim.fn.executable('tree-sitter') == 1 then
    -- async; does nothing for parsers that are already installed
    require('nvim-treesitter').install(languages)
end

-- start Tree-sitter highlighting for any filetype that has a parser and highlight queries
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('UserTreesitter', { clear = true }),
    callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match)
        if lang and vim.treesitter.language.add(lang) and vim.treesitter.query.get(lang, 'highlights') then
            vim.treesitter.start(ev.buf, lang)
        end
    end,
})

return { languages = languages }
