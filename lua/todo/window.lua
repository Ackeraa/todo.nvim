local Adder = require("todo.adder")
local Previewer = require("todo.previewer")

local Window = {}

function Window:new()
    local previewer = Previewer:new()
    local adder = Adder:new()

    local window = {
        adder = adder,
        previewer = previewer,
    }
    self.__index = self
    return setmetatable(window, self)
end

function Window:map_keys()
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap

    -- adder mappings
    keymap(self.adder.buf, "c", "q", "<cmd>lua require'todo'.window:close()<CR>", opts)

    -- previewer mappings
end

function Window:close()
    self.adder:close()
    self.previewer:close()
end

return Window
