
local M = {}

function M.open()

    RELOAD("todo.adder")
    RELOAD("todo.previewer")
    RELOAD("todo.window")
    RELOAD("todo.utils")
    RELOAD("todo.config")
    local Window = require("todo.window")
    local window = Window:new()
    M.window = window
    window:setup()

    return window
end

return M
