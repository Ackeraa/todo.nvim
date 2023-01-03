local log = require("todo.log")

local config = {}

local width = vim.api.nvim_get_option("columns")
local height = vim.api.nvim_get_option("lines")

config.opts = {
  title = " TODO ",
  prompt_prefix = " ",
  done_caret = " ",
  upload_to_reminder = false,
  adder_height = 1,
  previewer_height = math.ceil(height * 0.3),
  width = math.ceil(width * 0.5),
  row = math.ceil((height * 0.7 - 1) / 2) - 1,
  col = math.ceil((width * 0.5) / 2),
  file_path = "todo.txt",
}

config.highlights = {
  TodoTitle = { default = true, link = "Title" },
  TodoPrompt = { default = true, link = "Statement" },
  TodoBorder = { default = true, link = "Constant" },
  TodoAdd = { default = true, link = "MoreMsg" },
  TodoDelete = { default = true, link = "ErrorMsg" },
  TodoEdit = { default = true, link = "WarningMsg" },
  TodoDone = { default = true, link = "String" },
  TodoPriority = { default = true, link = "MoreMsg" },
  TodoDate = { default = true, link = "Comment" },
}

config.setup = function(custom_config)
  config = vim.tbl_deep_extend("force", config, custom_config)

  for k, v in pairs(config.highlights) do
    vim.api.nvim_set_hl(0, k, v)
  end

  return config
end

return config
