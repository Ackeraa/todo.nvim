f = io.open("todo.txt", "r")
if f then
    for line in f:lines() do
        print(line)
    end
    f:close()
end
