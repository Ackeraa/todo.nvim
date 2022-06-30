if vim.fn.has("nvim-0.7.0") == 0 then
  vim.api.nvim_err_writeln("todo requires at least nvim-0.7.0.1")
  return
end

-- make sure this file is loaded only once
if vim.g.loaded_todo == 1 then
  return
end
vim.g.loaded_todo = 1

local todo = require("todo")

vim.api.nvim_create_user_command(
  "Todo",
  todo.open,
{})
