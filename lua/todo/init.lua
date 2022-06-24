
--local window = Window:new()
local M = {}

function M.open()

    RELOAD("todo.adder")
    RELOAD("todo.previewer")
    local Adder = require("todo.adder")
    local Previewer = require("todo.previewer")
    local adder = Adder:new()
    local previewer = Previewer:new()

    return adder, previewer
end

return M
