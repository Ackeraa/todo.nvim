local log = require("todo.log")

local config = {}

local width = vim.api.nvim_get_option("columns")
local height = vim.api.nvim_get_option("lines")

config.title = " TODO "
config.prompt_prefix = " "
config.done_caret = " "
config.file_path = "lua/todo/todo.txt"
config.adder_height = 1
config.previewer_height = math.ceil(height * 0.3)
config.width = math.ceil(width * 0.5)
config.row = math.ceil((height - config.adder_height - config.previewer_height) / 2) - 1
config.col = math.ceil((width - config.width) / 2)

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

config.setup = function(opts)
    --[[ if opts.file_path == nil then
        log.error("Todo file path is not specified")
        return nil
    end ]]
    config = vim.tbl_deep_extend("force", config, opts)

    for k, v in pairs(config.highlights) do
      vim.api.nvim_set_hl(0, k, v)
    end
end

return config
