# Has not been used yet.
on run argv
    set file_path to item 1 of argv
    set todoFile to open for access file_path with write permission
    set todoList to "Todo"

    tell application "Reminders"
        set tasks to reminders of list todoList
        repeat with task in tasks
            write (name of task as string) & "\n" to todoFile
        end repeat
    end tell

    close access todoFile
end run
