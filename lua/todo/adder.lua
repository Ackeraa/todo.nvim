local utils = require("todo.utils")
local config = require("todo.config")

local Adder = {}

function Adder:new()
    self.__index = self
    local _, title_win_id = self:create_title_window()
    local _, prompt_win_id = self:create_prompt_window()
    local _, main_win_id = self:create_main_window()
    local buf, win_id = self:create_input_window()

    local adder = {
        buf = buf,
        win_id = win_id,
        title_win_id = title_win_id,
        main_win_id = main_win_id,
        prompt_win_id = prompt_win_id,
    }

    return setmetatable(adder, self)
end

-- TODO; rename to private
function Adder:create_main_window()
    local border = { "╭", "─", "╮", "│", "┤", "─", "├", "│" }

    local buf, win_id = utils.create_bufwin(
            config.width, config.adder_height,
            config.row, config.col, border, 1
        )

    vim.highlight.create("Border", { guifg = "#19e6e6" }, false)
    vim.api.nvim_win_set_option(win_id, "winhighlight", "NormalFloat:Normal,FloatBorder:Border")

    return buf, win_id
end

function Adder:create_input_window()
    local buf, win_id = utils.create_bufwin(
            config.width - 1, config.adder_height,
            config.row + 1, config.col+2, "none", 2
        )
    vim.api.nvim_win_set_option(win_id, "winhighlight", "NormalFloat:Normal")

    return buf, win_id
end

function Adder:create_title_window()
    local buf, win_id = utils.create_bufwin(
            #config.title, 1, config.row,
            config.col + math.ceil((config.width - #config.title) / 2),
            "none", 2
        )

    vim.api.nvim_buf_set_lines(buf, 0, -1, true, { config.title })
    vim.api.nvim_win_set_config(win_id, { focusable = false })
    vim.api.nvim_win_set_option(win_id, "winhighlight", "NormalFloat:Normal")

    return buf, win_id
end

function Adder:create_prompt_window()
    local buf, win_id = utils.create_bufwin(
            1, 1, config.row + 1,
            config.col + 1, "none", 2
        )

    vim.api.nvim_buf_set_lines(buf, 0, -1, true, { config.prompt })
    vim.api.nvim_win_set_config(win_id, { focusable = false })

    return buf, win_id
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
    vim.api.nvim_win_close(self.title_win_id, true)
    vim.api.nvim_win_close(self.prompt_win_id, true)
    vim.api.nvim_win_close(self.main_win_id, true)
end

return Adder


