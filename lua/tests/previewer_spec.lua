describe("previewer", function()
    local previewer = require("todo.previewer"):new()
    local filename = "lua/tests/todo.txt"
    before_each(function()
        local file = io.open(filename, "w")
        if file then
            local lines = {
                "1. do something",
                "2. do something else",
                "3. do something else else",
                "4. do something else else else",
                "5. do something else else else else",
                "-- done something",
                "-- done something else",
                "-- done something else else",
            }
            for _, line in ipairs(lines) do
                file:write(line .. "\n")
            end
            file:close()
        end
    end)

    describe("parse", function()
        it("should parse right", function()
            local line = previewer:_parse("1. 123 hello")
            assert.is.not_nil(line)
            assert.is.equal(1, line.priority)
            assert.is.equal("123 hello", line.task)

            line = previewer:_parse("-- 123 hello")
            assert.is.not_nil(line)
            assert.is.equal(nil, line.priority)
            assert.is.equal("123 hello", line.task)
        end)
    end)

    describe("file method", function()
        it("can load the todo file", function()
            previewer:load_file(filename)
            assert.is.equal(8, #previewer.lines)
        end)

        it("can write the todo file", function()
            previewer = require("todo.previewer"):new()
            previewer:load_file(filename)
            previewer:save_file(filename)
            assert.is.equal(8, #previewer.lines)
        end)
    end)

    describe("preview method", function()
        it("should add task right", function()
            previewer = require("todo.previewer"):new()
            previewer:load_file(filename)
            previewer:preview("add", 1, "task1")
            previewer:preview("add", 3, "task3")
            previewer:preview("add", 5, "task5")
            assert.is.equal("task1", previewer.lines[1].task)
            assert.is.equal("task3", previewer.lines[3].task)
            assert.is.equal("task5", previewer.lines[5].task)
            assert.is.equal("do something else else else else", previewer.lines[8].task)
            assert.is.equal(11, #previewer.lines)
        end)

    end)
end)

