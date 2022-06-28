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
                "-- done something @2016-01-01",
                "-- done something else @2016-01-01",
                "-- done something else else @2016-01-01",
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

            line = previewer:_parse("-- 123 hello @2016-01-01")
            assert.is.not_nil(line)
            assert.is.equal(nil, line.priority)
            assert.is.equal("123 hello", line.task)
            assert.is.equal("2016-01-01", line.date)
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

        it("should delete task right", function()
            previewer = require("todo.previewer"):new()
            previewer:load_file(filename)
            previewer:preview("delete", 1)
            previewer:preview("delete", 2)
            previewer:preview("delete", 3)
            assert.is.equal("do something else", previewer.lines[1].task)
            assert.is.equal(1, previewer.lines[1].priority)
            assert.is.equal("do something else else else", previewer.lines[2].task)
            assert.is.equal(2, previewer.lines[2].priority)
            assert.is_nil(previewer.lines[3].priority)
            assert.is.equal(5, #previewer.lines)
        end)

        it("should done task right", function()
            previewer = require("todo.previewer"):new()
            previewer:load_file(filename)
            previewer:preview("done", 1)
            previewer:preview("done", 1)
            previewer:preview("done", 1)
            assert.is.equal("do something else else else", previewer.lines[1].task)
            assert.is.equal(1, previewer.lines[1].priority)
            assert.is.equal("do something else else else else", previewer.lines[2].task)
            assert.is.equal(2, previewer.lines[2].priority)
            assert.is.equal("do something else else", previewer.lines[3].task)
            assert.is.equal("2022-06-28", previewer.lines[3].date)
            assert.is.equal("do something else", previewer.lines[4].task)
            assert.is.equal(8, #previewer.lines)
        end)

        it("should edit task right", function()
            previewer = require("todo.previewer"):new()
            previewer:load_file(filename)
            previewer:preview("edit", 1, "task1")
            previewer:preview("edit", 2, "task2")
            assert.is.equal("task1", previewer.lines[1].task)
            assert.is.equal(1, previewer.lines[1].priority)
            assert.is.equal("task2", previewer.lines[2].task)
            assert.is.equal(2, previewer.lines[2].priority)

            previewer:preview("edit", 1, "2")
            previewer:preview("edit", 2, "3")
            assert.is.equal("task2", previewer.lines[1].task)
            assert.is.equal(1, previewer.lines[1].priority)
            assert.is.equal("task1", previewer.lines[3].task)
            assert.is.equal(3, previewer.lines[3].priority)
            assert.is.equal(8, #previewer.lines)

        end)

    end)

end)

