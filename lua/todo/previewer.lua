local log = require("todo.log")

local Previewer = {}

function Previewer:new()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

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
        lines = {},
    }
    self.__index = self

    return setmetatable(previewer, self)
end

function Previewer:preview(op, arg1, arg2)
    if op == "add" then
        self:_add(arg1, arg2)
    elseif op == "delete" then
        self:_delete(arg1)
    elseif op == "done" then
        self:_done(arg1)
    elseif op == "edit" then
        self:_edit(arg1)
    else
        log.error("Unknown command: ", op)
    end

    return ""
end

function Previewer:load_file(filename)
    local file = io.open(filename, "r")
    if file then
        for line in file:lines() do
            table.insert(self.lines, line)
        end
        file:close()
        self:_update()
    end
end

function Previewer:save_file(filename)
    local file = io.open(filename, "w")
    if file then
        for _, line in ipairs(self.lines) do
            file:write(line .. "\n")
        end
        file:close()
    else
        log.error("Failed to open file: ", filename)
    end
end

function Previewer:_update()
    vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, self.lines)

    --[[ vim.api.nvim_buf_clear_namespace(self.buf, 0, -1, "todo")
    for _, line in ipairs(self.lines) do
        vim.api.nvim_buf_add_line(self.buf, -1, { line }, "todo")
    end ]]
end

function Previewer:_add(priority, text)

end

function Previewer:close()
    vim.api.nvim_win_close(self.win_id, true)
end

return Previewer
