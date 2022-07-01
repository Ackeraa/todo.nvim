local utils = require("todo.utils")

local Adder = {}

function Adder:new(opts)
    self.__index = self
    self.opts = opts
    local title_win_id = self:_create_title_window()
    local prefix_win_id = self:_create_prefix_window()
    local main_win_id = self:_create_main_window()
    local buf, win_id = self:_create_input_window()

    local adder = {
        buf = buf,
        win_id = win_id,
        title_win_id = title_win_id,
        main_win_id = main_win_id,
        prefix_win_id = prefix_win_id,
    }

    return setmetatable(adder, self)
end

function Adder:add_highlight()
    -- TODO: add some other user defined highlightings
    local ops = { "add", "delete", "done", "edit" }
    local hls = { "TodoAdd", "TodoDelete", "TodoDone", "TodoEdit" }
    local pre_len = { 1, 2, 2, 1 } -- to avoid ambiguity
    for i, op in ipairs(ops) do
        for _, prefix in ipairs(utils.generate_prefixs(op, pre_len[i])) do
            vim.fn.matchadd(hls[i], "^"..prefix)
        end
    end
end

function Adder:_create_main_window()
    local border = { "╭", "─", "╮", "│", "┤", "─", "├", "│" }

    local _, win_id = utils.create_bufwin(
            self.opts.width, self.opts.adder_height,
            self.opts.row, self.opts.col, border, 1
        )

    vim.api.nvim_win_set_option(win_id, "winhighlight", "NormalFloat:Normal,FloatBorder:Constant")

    return win_id
end

function Adder:_create_input_window()
    local buf, win_id = utils.create_bufwin(
            self.opts.width - #self.opts.prompt_prefix, self.opts.adder_height,
            self.opts.row + 1, self.opts.col + #self.opts.prompt_prefix, "none", 2
        )

    vim.api.nvim_win_set_option(win_id, "winhighlight", "NormalFloat:Normal")

    return buf, win_id
end

function Adder:_create_title_window()
    local buf, win_id = utils.create_bufwin(
            #self.opts.title, 1, self.opts.row,
            self.opts.col + math.ceil((self.opts.width - #self.opts.title) / 2),
            "none", 2
        )

    vim.api.nvim_buf_set_lines(buf, 0, -1, true, { self.opts.title })
    vim.api.nvim_buf_add_highlight(buf, -1, "TodoTitle", 0, 0, -1)
    vim.api.nvim_win_set_config(win_id, { focusable = false })
    vim.api.nvim_win_set_option(win_id, "winhighlight", "NormalFloat:Normal")

    return win_id
end

function Adder:_create_prefix_window()
    local buf, win_id = utils.create_bufwin(
            #self.opts.prompt_prefix, 1, self.opts.row + 1,
            self.opts.col + 1, "none", 2
        )

    vim.api.nvim_buf_set_lines(buf, 0, -1, true, { self.opts.prompt_prefix })
    vim.api.nvim_buf_add_highlight(buf, -1, "TodoPrompt", 0, 0, -1)
    vim.api.nvim_win_set_config(win_id, { focusable = false })
    vim.api.nvim_win_set_option(win_id, "winhighlight", "NormalFloat:Normal")

    return win_id
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
    elseif #uop > 1 and string.match("delete", puop) then 
        op = "delete"
        arg1 = tonumber(line:match("(%d+)%s*$"))
    elseif #uop > 1 and string.match("done", puop) then
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
    vim.api.nvim_win_close(self.prefix_win_id, true)
    vim.api.nvim_win_close(self.main_win_id, true)
end

return Adder


