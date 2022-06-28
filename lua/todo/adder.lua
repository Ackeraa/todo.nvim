local Adder = {}

function Adder:new()
    local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "filetype", "todo")
    vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, {"  "})

    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")
    local win_height = 1
    local win_width = math.ceil(width * 0.5)
    local row = math.ceil((height - win_height - height * 0.3) / 2) - 1
    local col = math.ceil((width - win_width) / 2)
    local border = { "╭", "─", "╮", "│", "┤", "─", "├", "│" }

    local opts = {
        style = "minimal",
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        border = border,
    }

    -- do not allow to change the content of the buffer
    local win_id = vim.api.nvim_open_win(buf, true, opts)

    vim.highlight.create("Border", { guifg = "#19e6e6" }, false)
    vim.api.nvim_win_set_option(win_id, "winhighlight", "NormalFloat:Normal,FloatBorder:Border")
    --vim.api.nvim_win_set_cursor(win_id, {1, 2})
    -- local new_pos = vim.api.nvim_win_get_cursor(win_id)[1]
    -- vim.api.nvim_win_set_cursor(win_id, {1, 4})

    local adder = {
        buf = buf,
        win_id = win_id,
    }
    self.__index = self

    return setmetatable(adder, self)
end

function Adder:adde()
    local line = vim.api.nvim_buf_get_lines(self.buf, 0, -1, false)[1]
    return self:_parse(line)
end

function Adder:_parse(line)
    local op = nil
    local arg1 = nil
    local arg2 = nil

    local uop = line:match("^(%w+)")
    local puop = "^"..uop
    if string.match("add", puop) then
        op = "add"
        arg1, arg2 = line:match("%w+%s+(%d+)%s+(.+)")
        if arg1 == nil then
            arg1 = 1
            arg2 = line:match("%w+%s+(.+)")
        else
            arg1 = tonumber(arg1)
        end
    elseif string.match("delete", puop) then   -- d -> delete
        op = "delete"
        arg1 = tonumber(line:match("(%d+)%s*$"))
    elseif string.match("done", puop) then
        op = "done"
        arg1 = tonumber(line:match("(%d+)%s*$"))
        arg1 = tonumber(arg1)
    elseif string.match("edit", puop) then
        op = "edit"
        arg1, arg2 = line:match("%w+%s+(%d+)%s+(.+)")
        arg1 = tonumber(arg1)
    end

    return op, arg1, arg2
end

-- switch to insert mode and set the cursor to the end of the line
function Adder:_set_cursor()
    vim.api.nvim_command("normal! i")
    vim.api.nvim_win_set_cursor(self.win_id, {1, #vim.api.nvim_buf_get_lines(self.buf, 0, -1, false)[1]})
end

function Adder:close()
    vim.api.nvim_win_close(self.win_id, true)
end

return Adder


