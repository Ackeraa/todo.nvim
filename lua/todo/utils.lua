local utils = {}

utils.create_bufwin = function(width, height, row, col, border, zindex)

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "filetype", "todo")

    local opts = {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        border = border,
        zindex = zindex,
    }

    local win_id = vim.api.nvim_open_win(buf, false, opts)

    return buf, win_id
end

utils.generate_prefixs = function(str, start)
    local prefix = {}
    for i = start, #str do
        table.insert(prefix, str:sub(1, i))
    end

    return prefix
end

return utils
