
local M = {}

function M.open()

    -- for debug purpose
    RELOAD("todo.adder")
    RELOAD("todo.previewer")
    RELOAD("todo.window")
    RELOAD("todo.utils")
    RELOAD("todo.config")
    if M.window == nil or M.window.adder == nil then
        M.setup()
        M.window = require("todo.window"):new()
        M.window:setup()
    end
end

function M.setup(opts)
    opts = opts or {}
    require("todo.config").setup(opts)
end

return M
