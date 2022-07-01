local reminder = {}

reminder.script_path = "lua/todo/extensions/reminder/"

-- do not use this, because it's pretty slow.
reminder.read_from_reminder = function(file_path)
    local script = reminder.script_path.."read_from_reminder.scpt "
    io.popen("osascript "..script..file_path)
end

reminder.write_to_reminder = function(file_path)
    local script = reminder.script_path.."write_to_reminder.scpt "
    io.popen("osascript "..script..file_path)
end

return reminder

