local log = require("todo.log")
local utils = require("todo.utils")

local Previewer = {}

function Previewer:new(opts)
    self.__index = self
    self.opts = opts
    local border = { "├", "─", "┤", "│", "╯", "─", "╰", "│" }
    local buf, win_id = utils.create_bufwin(
            opts.width, opts.previewer_height,
            opts.row + 2, opts.col, border, 1
        )

    vim.api.nvim_win_set_option(win_id, "cursorline", true)

    vim.api.nvim_win_set_option(win_id, "winhighlight", "NormalFloat:Normal,FloatBorder:TodoBorder")

    local previewer = {
        buf = buf,
        win_id = win_id,
        lines = {},
        todos = 0,
    }
    return setmetatable(previewer, self)
end

function Previewer:add_highlight()
    vim.fn.matchadd("TodoPriority", "^\\d\\+\\.")
    vim.fn.matchadd("TodoDone", "^"..self.opts.done_caret)
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

    -- shift
    for i = #self.lines, priority, -1 do
        self.lines[i + 1] = self.lines[i]
    end

    -- add new task
    self.lines[priority] = task
    self.todos = self.todos + 1
end

function Previewer:_delete(priority)
    if priority > self.todos then
        log.error("Task does not exist")
        return
    end

    -- shift
    for i = priority, #self.lines - 1 do
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

    local task = self.lines[priority]

    -- shift
    for i = priority, self.todos - 1 do
        self.lines[i] = self.lines[i + 1]
    end

    -- done the task
    self.lines[self.todos] = "@"..os.date("%Y-%m-%d").. " "..task
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

        local task = self.lines[priority]
        self:_delete(priority)
        self:_add(num, task)
    else
        self.lines[priority] = task_or_priority
    end
end

function Previewer:load_file()
  if vim.fn.filereadable(self.opts.file) == 0 then
    vim.fn.writefile({}, self.opts.file)
  end

  local file = io.open(self.opts.file_path, "r")
  if file then
    for line in file:lines() do
      if line:sub(1, 1) ~= "@"  then
        self.todos = self.todos + 1
      end
      table.insert(self.lines, line)
    end
    file:close()
    self:_update()
  end
end

function Previewer:save_file()
  local file = io.open(self.opts.file_path, "w")
  if file then
    for _, line in ipairs(self.lines) do
      file:write(line .. "\n")
    end
    file:close()
  else
    log.error("Failed to open file: ", self.opts.file_path)
  end
end

function Previewer:_repr()
  local lines = {}
  for i, line in ipairs(self.lines) do
    if line:sub(1, 1) ~= "@" then
      table.insert(lines, i .. ". " .. line)
    else
      table.insert(lines, self.opts.done_caret..line)
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
  if self.opts.upload_to_reminder then
    local reminder = require("todo.extensions.reminder")
    reminder.write_to_reminder(self.opts.file_path)
  end
end

return Previewer
