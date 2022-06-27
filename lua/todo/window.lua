local Adder = require("todo.adder")
local Previewer = require("todo.previewer")

local Window = {}

function Window:new()
    -- TODO: check if window is already open

    local previewer = Previewer:new()
    local adder = Adder:new()

    local window = {
        adder = adder,
        previewer = previewer,
    }
    self.__index = self
    return setmetatable(window, self)
end

function Window:setup()
    self:map_keys()
    self.previewer:load_file("lua/todo/todo.txt")
    vim.api.nvim_command("call feedkeys('i', 'n')")
    -- set focus window to the adder window
end

function Window:switch_window(which)
    if which == "adder" then
        vim.api.nvim_set_current_win(self.adder.win_id)
        vim.api.nvim_command("call feedkeys('i', 'n')")
    elseif which == "previewer" then
        vim.api.nvim_set_current_win(self.previewer.win_id)
    end
end

function Window:doit()
    op, arg1, arg2 = self.adder:adde()
    rst = self.previewer:preview(op, arg1, arg2)
    return ""
end

function Window:map_keys()
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap

    -- TODO: Unmap <C-w>w and <C-w>w<CR>

    -- adder mappings
    keymap(self.adder.buf, "n", "<leader>q", "<cmd>lua require'todo'.window:close()<CR>", opts)
    keymap(self.adder.buf, "n", "j", "<cmd>lua require'todo'.window:switch_window('previewer')<CR>", opts)
    keymap(self.adder.buf, "i", "<CR>","<cmd>lua require'todo'.window:doit()<CR>", opts)

    -- previewer mappings
    keymap(self.previewer.buf, "n", "<leader>q", "<cmd>lua require'todo'.window:close()<CR>", opts)
    keymap(self.previewer.buf, "n", "i", "<cmd>lua require'todo'.window:switch_window('adder')<CR>", opts)
end


function Window:close()
    self.adder:close()
    self.previewer:close()
end

return Window
