require('mini.comment').setup() -- adds gc/gcc
require('mini.surround').setup({
    mappings = {
        -- default bindings overload `s`, which I find annoying -_-
        add = 'msa',            -- Add surrounding in Normal and Visual modes
        delete = 'ds',          -- Delete surrounding
        find = 'msf',           -- Find surrounding (to the right)
        find_left = 'msF',      -- Find surrounding (to the left)
        highlight = 'msh',      -- Highlight surrounding
        replace = 'cs',         -- Replace surrounding
        update_n_lines = 'msn', -- Update `n_lines`
    }
})
require('mini.pairs').setup()       -- automatically adds closing pairs (), [], {}, '', "", etc
require('mini.trailspace').setup()  -- highlights trailing spaces
require('mini.bracketed').setup()   -- adds forward/backword navigation bindings on []
require('mini.splitjoin').setup()   -- adds gS for toggling joined/split line args
require('mini.indentscope').setup() -- adds indent scope, including visualization
require('mini.move').setup()        -- adds <M-h/l/j/k> binds to move lines around
