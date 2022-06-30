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

                                                              *todo-extension*

|                    commands                    |               Action                |                          Parameters                           |
| :--------------------------------------------: | :---------------------------------: | :----------------------------------------------------------: |
|            `add {priority} {to-do}`            |           Add a new to-do           | {priority}: Priority of the new to-do, defaults to 0<br>{to-do}:  Contents of the new to-do |
|              `delete {priority}`               |           Delete a to-do            | {priority}: Priority of the to-do to be deleted       |
|               `done {priority}`                |        Mark a to-do as done         | {priority}: Priority of the to-do that has been done     |
| `edit {priority} {new-to-do}|/|{new-priority}` | Edit a to-do's priority or contents | {priority}: Priority of the to-do to be edited<br/>{new-to-do}: The new contents of the to-do <br/>{new-priority}: The new priority of the to-do |


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

