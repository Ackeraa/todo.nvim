local log = require("todo.log")
local utils = require("todo.utils")
local config = require("todo.config")

local Previewer = {}

function Previewer:new()
    local border = { "├", "─", "┤", "│", "╯", "─", "╰", "│" }
    local buf, win_id = utils.create_bufwin(
            config.width, config.previewer_height,
            config.row + 2, config.col, border, 1
        )

    vim.api.nvim_win_set_option(win_id, "cursorline", true)

    vim.api.nvim_win_set_option(win_id, "winhighlight", "NormalFloat:Normal,FloatBorder:TodoBorder")

    local previewer = {
        buf = buf,
        win_id = win_id,
        lines = {},
        todos = 0,
    }
    self.__index = self

    return setmetatable(previewer, self)
end

function Previewer:add_highlight()
    vim.fn.matchadd("TodoPriority", "^\\d\\+\\.")
    vim.fn.matchadd("TodoDone", "^"..config.done_caret)
    vim.fn.matchadd("TodoDate", "@\\d\\+-\\d\\+-\\d\\+")
end

function Previewer:preview(op, arg1, arg2)
    if arg1 == nil then
        log.error("Task does not exist")
        return nil
    end

    if op == "add" then
        self:_add(arg1, arg2)
    elseif op == "delete" then
        self:_delete(arg1)
    elseif op == "done" then
        self:_done(arg1)
    elseif op == "edit" then
        self:_edit(arg1, arg2)
    else
        log.error("Unknown command: ", op)
    end

    self:_update()

    return ""
end

function Previewer:_add(priority, task)
    if priority > self.todos + 1 then
        log.error("Task priority is too high")
        return
    end
    -- shift dones
    for i = #self.lines, self.todos + 1, -1 do
        self.lines[i + 1] = self.lines[i]
    end

    -- shift todos after priority
    for i = self.todos, priority, -1 do
        self.lines[i + 1] = {
            priority = self.lines[i].priority + 1,
            task = self.lines[i].task
        }
    end

    -- add new task
    self.lines[priority] = {
        priority = priority,
        task = task
    }
    self.todos = self.todos + 1
end

function Previewer:_delete(priority)
    if priority > self.todos then
        log.error("Task does not exist")
        return
    end

    -- shift todos
    for i = priority, self.todos - 1 do
        self.lines[i].task = self.lines[i + 1].task
    end

    -- shift dones
    for i = self.todos, #self.lines - 1 do
        self.lines[i] = self.lines[i + 1]
    end

    -- delete the last empty line
    self.lines[#self.lines] = nil
    self.todos = self.todos - 1
end

function Previewer:_done(priority)
    if priority > self.todos then
        log.error("Task does not exist")
        return
    end

    local done = self.lines[priority].task

    -- shift todos
    for i = priority, self.todos - 1 do
        self.lines[i].task = self.lines[i + 1].task
    end

    -- done the task
    self.lines[self.todos] = {
        date = os.date("%Y-%m-%d"),
        task = done,
    }
    self.todos = self.todos - 1
end

function Previewer:_edit(priority, task_or_priority)
    if priority > self.todos then
        log.error("Task does not exist")
        return
    end

    local num = tonumber(task_or_priority)
    if num then
        if num > self.todos + 1 then
            log.error("Task priority is too high")
        end

        local task = self.lines[priority].task
        self:_delete(priority)
        self:_add(num, task)
    else
        self.lines[priority].task = task_or_priority
    end
end

function Previewer:load_file()
    local file = io.open(config.file_path, "r")
    if file then
        for line in file:lines() do
            line = self:_parse(line)
            if line.priority  then
                self.todos = self.todos + 1
            end
            table.insert(self.lines, line)
        end
        file:close()
        self:_update()
    end
end

function Previewer:save_file()
    local file = io.open(config.file_path, "w")
    if file then
        local lines = self:_repr()
        for _, line in ipairs(lines) do
            file:write(line .. "\n")
        end
        file:close()
    else
        log.error("Failed to open file: ", config.file_path)
    end
end

function Previewer:_parse(line)
    local priority = line:match("^(%d+)")
    if priority then
        return {
            priority = tonumber(priority),
            task = line:sub(#priority + 3)
        }
    else
        local date = line:match("@(%d+-%d+-%d+)")
        local task = line:match("@%d+-%d+-%d+%s+(.+)$")
        return {
            date = date,
            task = task
        }
    end
end

function Previewer:_repr()
    local lines = {}
    for _, line in ipairs(self.lines) do
        if line.priority then
            table.insert(lines, line.priority .. ". " .. line.task)
        else
            table.insert(lines, config.done_caret.." @"..line.date.." "..line.task)
        end
    end
    return lines
end

function Previewer:_update()
    local lines = self:_repr()
    vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, lines)
end

function Previewer:close()
    vim.api.nvim_win_close(self.win_id, true)
end

return Previewer
