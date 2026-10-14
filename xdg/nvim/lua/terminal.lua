-- A single toggleable terminal in a 15-line split along the bottom (replaces toggleterm).
-- The shell keeps running while hidden; exiting it (exit / Ctrl-D) closes the buffer.
local M = {}

local term_buf = nil
local height = 15

local function term_win()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_buf(win) == term_buf then
            return win
        end
    end
end

function M.toggle()
    local valid = term_buf and vim.api.nvim_buf_is_valid(term_buf)
    local win = valid and term_win()
    if win then
        vim.api.nvim_win_hide(win)
        return
    end

    vim.cmd('botright ' .. height .. 'split')
    if valid then
        vim.api.nvim_win_set_buf(0, term_buf)
    else
        vim.cmd.terminal()
        term_buf = vim.api.nvim_get_current_buf()
        vim.bo[term_buf].buflisted = false -- keep it out of the buffer tabline
    end
    vim.wo.winfixheight = true
    vim.cmd.startinsert()
end

return M
