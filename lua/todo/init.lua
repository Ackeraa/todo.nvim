
--local window = Window:new()
local M = {}

function M.open()

    RELOAD("todo.adder")
    local Adder = require("todo.adder")
    local adder = Adder:new()

    return adder
end

return M
