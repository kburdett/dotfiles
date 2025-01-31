local isNative = not vim.g.vscode

require('mini.comment').setup() -- adds gc/gcc
require('mini.surround').setup({
    mappings = {
        -- default bindings overload `s`, which I find annoying -_-
        add = '<leader>sa',            -- Add surrounding in Normal and Visual modes
        delete = '<leader>sd',          -- Delete surrounding
        find = '<leader>sf',           -- Find surrounding (to the right)
        find_left = '<leader>sF',      -- Find surrounding (to the left)
        highlight = '<leader>sh',      -- Highlight surrounding
        replace = '<leader>sc',         -- Replace surrounding
        update_n_lines = '<leader>sn', -- Update `n_lines`
    }
})
require('mini.pairs').setup()       -- automatically adds closing pairs (), [], {}, '', "", etc
require('mini.bracketed').setup()   -- adds forward/backword navigation bindings on []
require('mini.splitjoin').setup()   -- adds gS for toggling joined/split line args
require('mini.move').setup()        -- adds <M-h/l/j/k> binds to move lines around

if (isNative) then
    require('mini.indentscope').setup() -- adds indent scope, including visualization
    require('mini.trailspace').setup()  -- highlights trailing spaces
end
