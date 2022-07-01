
local M = {}

function M.open()

    -- for debug purpose
    --[[ RELOAD("todo.adder")
    RELOAD("todo.previewer")
    RELOAD("todo.window")
    RELOAD("todo.utils")
    RELOAD("todo.config") ]]
    if M.opts and (M.window == nil or M.window.adder == nil) then
        M.window = require("todo.window"):new(M.opts)
        M.window:setup()
    end
end

function M.setup(custom_config)
    local config = require("todo.config").setup(custom_config)
    if config == nil then
        return
    end
    M.opts = config.opts
end

return M
