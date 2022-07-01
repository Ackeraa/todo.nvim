on run argv
    set file_path to item 1 of argv
    set tasks to paragraphs of (read POSIX file file_path)
    set todoList to "Todo"

    tell application "Reminders"
        tell list todoList
            delete every reminder
        end tell
    end tell

    repeat with task in tasks
        tell application "Reminders"
            tell list todoList 
                if task starts with "@" then 
                    exit repeat
                else
                    make new reminder at end with properties {name:task}
                end if
            end tell
        end tell
    end repeat
end run
