if vim.fn.has("nvim-0.7.0") == 0 then
  vim.api.nvim_err_writeln("todo requires at least nvim-0.7.0.1")
  return
end

-- make sure this file is loaded only once
if vim.g.loaded_todo == 1 then
  return
end
vim.g.loaded_todo = 1

-- create any global command that does not depend on user setup
-- usually it is better to define most commands/mappings in the setup function
-- Be careful to not overuse this file!
local todo = require("todo")

local highlights = {
    TodoTitle = { default = true, link = "Identifier" },
    TodoPrompt = { default = true, link = "Statement" },
    TodoBorder = { default = true, link = "Constant" },
}

for k, v in pairs(highlights) do
  vim.api.nvim_set_hl(0, k, v)
end

vim.api.nvim_create_user_command(
  "Todo",
  todo.open,
{})
