local Parser = {}

function Parser:new()
    local parser = {
        lines = {},
        line_count = 0,
    }
    self.__index = self
    return setmetatable(parser, self)
end

function Parser:parse(line)

    local op = nil
    local arg1 = nil
    local arg2 = nil

    print("ADA", line)
    if string.sub(line, 1, 1) == "a" then
        -- TODO: priority(arg2) maybe greater than 9, but I don't think it's necessary
        -- TODO: prefix should be used 
        op = "add"
        arg1 = tonumber(string.sub(line, 5, 5))
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
        arg2 = string.sub(line, 8)
    end

    return op, arg1, arg2
end

return Parser
