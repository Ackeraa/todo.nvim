local Adder = require("todo.adder")

--local window = Window:new()
local M = {}

function M.open()
    local adder = Adder:new()

    return adder
end

return M
