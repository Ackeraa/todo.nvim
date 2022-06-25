local Parser = {}

function Parser:new()
    local parser = {
        lines = {},
        line_count = 0,
    }
    self.__index = self
    return setmetatable(parser, self)
end

function Parser:parse(buf)
    local line = vim.api.nvim_buf_get_lines(buf, 0, -1, false)[1]

    local op = nil
    local arg1 = nil
    local arg2 = nil

    if string.sub(line, 1, 1) == "a" then
        -- TODO: priority(arg2) maybe greater than 9, but I don't think it's necessary
        op = "add"
        arg1 = string.sub(line, 5, 5)
        arg2 = string.sub(line, 7)
    elseif string.sub(line, 1, 2) == "de" then
        op = "delete"
        arg1 = tonumber(string.sub(line, 8, 8))
    elseif string.sub(line, 1, 2) == "do" then
        op = "done"
        arg1 = tonumber(string.sub(line, 6, 6))
    elseif string.sub(line, 1, 1) == "e" then
        op = "edit"
        arg1 = tonumber(string.sub(line, 6, 6))
    end

    return op, arg1, arg2
end

return Parser
