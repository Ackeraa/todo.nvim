local Adder = {}


function Adder:new()
    local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")
    local win_height = 1
    local win_width = 1
    local row = math.ceil((height - win_height) / 2 - 1)
    local col = math.ceil((width - win_width) / 2)
    local border = "double"

    local opts = {
        style = "minimal",
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        border = border,
    }

    local win_id = vim.api.nvim_open_win(buf, true, opts)

    vim.api.nvim_win_set_option(win_id, "cursorline", true)

    -- Move cursor
    local new_pos = math.max(2, vim.api.nvim_win_get_cursor(win_id)[1] - 1)
    vim.api.nvim_win_set_cursor(win_id, {new_pos, 0})

    local adder = {
        buf = buf,
        win_id = win_id,
    }
    self.__index = self

    return setmetatable(adder, self)
end

function Adder:close()
    vim.api.nvim_win_close(self.win, true)
end

return Adder
