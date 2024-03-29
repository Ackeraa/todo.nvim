local Adder = require("todo.adder")
local Previewer = require("todo.previewer")

local Window = {}

function Window:new(opts)
  local previewer = Previewer:new(opts)
  local adder = Adder:new(opts)

  local window = {
    adder = adder,
    previewer = previewer,
  }
  self.__index = self
  return setmetatable(window, self)
end

function Window:setup()
  -- TODO: ugly implementation, need to be improved
  self:switch_window("previewer")
  self.previewer:add_highlight()
  self:switch_window("adder")
  self.adder.add_highlight()

  self:map_keys()
  self.previewer:load_file()
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
  self.previewer:preview(op, arg1, arg2)
  self.previewer:save_file()
  self.adder:clear()
end

function Window:map_keys()
  local opts = { noremap = true, silent = true }
  local keymap = vim.api.nvim_buf_set_keymap

  -- TODO: Unmap <C-w>w and <C-w>w<CR>

  -- adder mappings
  keymap(self.adder.buf, "n", "<Esc>", "<cmd>lua require'todo'.window:close()<CR>", opts)
  keymap(self.adder.buf, "n", "j", "<cmd>lua require'todo'.window:switch_window('previewer')<CR>", opts)
  keymap(self.adder.buf, "i", "<CR>","<cmd>lua require'todo'.window:doit()<CR>", opts)

  -- previewer mappings
  keymap(self.previewer.buf, "n", "<Esc>", "<cmd>lua require'todo'.window:close()<CR>", opts)
  keymap(self.previewer.buf, "n", "i", "<cmd>lua require'todo'.window:switch_window('adder')<CR>", opts)
end


function Window:close()
  self.adder:close()
  self.previewer:close()
  self.adder = nil
  self.previewer = nil
end

return Window
