local Previewer = {}


function Previewer:new()
    local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    --vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, {">"})

    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")
    local win_height = math.ceil(height * 0.3)
    local win_width = math.ceil(width * 0.5)
    local row = math.ceil((height - win_height) / 2) + 1
    local col = math.ceil((width - win_width) / 2)
    local border = { "├", "─", "┤", "│", "╯", "─", "╰", "│" }

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

    vim.highlight.create("Border", { guifg = "#19e6e6" }, false)
    vim.api.nvim_win_set_option(win_id, "winhighlight", "NormalFloat:Normal,FloatBorder:Border")
    -- local new_pos = vim.api.nvim_win_get_cursor(win_id)[1]

    local previewer = {
        buf = buf,
        win_id = win_id,
    }
    self.__index = self

    return setmetatable(previewer, self)
end

function Previewer:close()
    vim.api.nvim_win_close(self.win_id, true)
end

return Previewer
