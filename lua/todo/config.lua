local config = {}

local width = vim.api.nvim_get_option("columns")
local height = vim.api.nvim_get_option("lines")

config.title = " TODO "
config.prompt_prefix = " "
config.done_caret = " "
config.adder_height = 1
config.previewer_height = math.ceil(height * 0.3)
config.width = math.ceil(width * 0.5)
config.row = math.ceil((height - config.adder_height - config.previewer_height) / 2) - 1
config.col = math.ceil((width - config.width) / 2)

return config
