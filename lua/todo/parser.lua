local Parser = {}

function Parser:new()
    local parser = {
        lines = {},
        line_count = 0,
    }
    self.__index = self
    return setmetatable(parser, self)
end

function Parser:parse(file)
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local line_count = vim.api.nvim_buf_line_count(0)
    local parser = {
        lines = lines,
        line_count = line_count,
    }
    self.__index = self
    return setmetatable(parser, self)
end

function Parser:get_line(line_number)
    return self.lines[line_number]
end

function Parser:get_line_count()
    return self.line_count
end

function Parser:get_line_number(line)
    for i, v in ipairs(self.lines) do
        if v == line then
            return i
        end
    end
    return nil
end

return Parser
