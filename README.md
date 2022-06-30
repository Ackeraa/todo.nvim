# todo.nvim
This plugin helps you manage your to-do list while working in neovim, purely written in lua.

## Installation
Using packer
```lua
use { 'ackeraa/todo.nvim' }
```
## Setup
This plugin must be explicitly enabled by using `require("todo").setup{}`
You must pass the `file_path` to specify the where do you want to save of the to-do list. 
```lua
require("todo").setup {
    file_path = "path/to/save/todo.txt"
}
```

## Usage
Use the command `:Todo` to start.

There are four types of commands can be used in the floating window:

| commands                                     | Action                              |
| :------------------------------------------- | :---------------------------------- |
| `add {priority} {to-do}`                     | Add a new to-do                     |
| `delete {priority}`                          | Delete a to-do                      |
| `done {priority}`                            | Mark a to-do as done                |
| `edit {priority} {new-to-do}/{new-priority}` | Edit a to-do's priority or contents |

Examples:
* `add do one thing`: Add the first to-do(`{priority}` defaults to 1)
* `add 2 do another thing`: Add the second to-do
* `edit 1 2`: Change the first to-do's priority to 2, now the second to-do's priority becomes 1
* `edit 2 do the new one thing`: Change second to-do's contents  
* `delete 2`: Delete the second to-do
* `done 1`: Mark the first to-do as done

See doc for details.

TODO:
* <leader>t -> floating window
* cmds: add, delete, done, edit
* mark the thing done
* keep history
* add date when marked done
* add priority: (1)(2)(3)
* upload to server or icloud
* example:
    * add 1 finish master-vim
    * delete 1 / delete text
    * done 1 / done text
    * edit 1 new text / edit 1 2

* saved file format: 
    * 1. do something
    * 2. do another something
    * -- something has been done @2022.6.27
* live grep
* doc
* call me
* highlight add, delete, done, edit
* Just finished the job, but the implementation is not elegant.
* checkhealth

