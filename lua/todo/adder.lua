local utils = require("todo.utils")
local config = require("todo.config")

local Adder = {}

function Adder:new()
    self.__index = self
    local buf, win_id = self:create_main()
    --local _, title_win_id = self:create_title()

    local adder = {
        buf = buf,
        win_id = win_id,
       -- title_win_id = title_win_id,
    }

    return setmetatable(adder, self)
end

function Adder:create_main()
    local border = { "╭", "─", "╮", "│", "┤", "─", "├", "│" }

    local buf, win_id = utils.create_bufwin(
            config.width, config.adder_height,
            config.row, config.col, border
        )

    vim.highlight.create("Border", { guifg = "#19e6e6" }, false)
    vim.api.nvim_win_set_option(win_id, "winhighlight", "NormalFloat:Normal,FloatBorder:Border")

    return buf, win_id
end

function Adder:create_title()
    local buf, win_id = utils.create_bufwin(4, 1, config.row - 1, config.col, "single")
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, { "TODO" })

    return buf, win_id
end

function Adder:create_prompt()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "filetype", "todo")
    vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, {"Enter your task:"})
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

function Adder:clear()
    vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, {})
end

function Adder:close()
    vim.api.nvim_win_close(self.win_id, true)
    --vim.api.nvim_win_close(self.title_win_id, true)
end

return Adder


