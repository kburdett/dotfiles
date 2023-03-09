require("formatter").setup({
    logging = true,
    log_level = vim.log.levels.WARN,
    filetype = {
        -- opt in to all default formatters
        ["*"] = {
            require("formatter.filetypes.any").remove_trailing_whitespace,
        }
    }
})
