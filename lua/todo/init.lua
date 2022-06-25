
local M = {}

function M.open()

    RELOAD("todo.parser")
    RELOAD("todo.adder")
    RELOAD("todo.previewer")
    RELOAD("todo.window")
    local Window = require("todo.window")
    local window = Window:new()
    M.window = window
    window:map_keys()

    return window
end

return M
