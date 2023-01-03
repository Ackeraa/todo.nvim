local reminder = {}

reminder.script_path = function()
  local str = debug.getinfo(2, "S").source:sub(2)
  return str:match("(.*/)")
end

-- do not use this, because it's pretty slow.
reminder.read_from_reminder = function(file_path)
  local script = reminder.script_path.."read_from_reminder.scpt "
  io.popen("osascript "..script..file_path)
end

reminder.write_to_reminder = function(file_path)
  local script = reminder.script_path().."write_to_reminder.scpt "
  io.popen("osascript "..script..file_path)
end

return reminder

