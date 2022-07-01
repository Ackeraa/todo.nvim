describe("previewer", function()
    local opts = require("todo.config").opts
    local filename = "lua/tests/todo.txt"
    opts.file_path = filename
    local previewer = require("todo.previewer"):new(opts)
    before_each(function()
        local file = io.open(filename, "w")
        if file then
            local lines = {
                "do something",
                "do something else",
                "do something else else",
                "do something else else else",
                "do something else else else else",
                "@2016-01-01 done something",
                "@2016-01-01 done something else",
                "@2016-01-01 done something else else",
            }
            for _, line in ipairs(lines) do
                file:write(line .. "\n")
            end
            file:close()
        end
    end)

    describe("file method", function()
        it("can load the todo file", function()
            previewer:load_file()
            assert.is.equal(8, #previewer.lines)
        end)

        it("can write the todo file", function()
            previewer = require("todo.previewer"):new(opts)
            previewer:load_file()
            previewer:save_file()
            assert.is.equal(8, #previewer.lines)
        end)
    end)

    describe("preview method", function()
        it("should add task right", function()
            previewer = require("todo.previewer"):new(opts)
            previewer:load_file()
            previewer:preview("add", 1, "task1")
            previewer:preview("add", 3, "task3")
            previewer:preview("add", 5, "task5")
            assert.is.equal("task1", previewer.lines[1])
            assert.is.equal("task3", previewer.lines[3])
            assert.is.equal("task5", previewer.lines[5])
            assert.is.equal("do something else else else else", previewer.lines[8])
            assert.is.equal(11, #previewer.lines)

        end)

        it("should delete task right", function()
            previewer = require("todo.previewer"):new(opts)
            previewer:load_file()
            previewer:preview("delete", 1)
            previewer:preview("delete", 2)
            previewer:preview("delete", 3)
            assert.is.equal("do something else", previewer.lines[1])
            assert.is.equal("do something else else else", previewer.lines[2])
            assert.is.equal(5, #previewer.lines)
        end)

        it("should done task right", function()
            previewer = require("todo.previewer"):new(opts)
            previewer:load_file()
            previewer:preview("done", 1)
            previewer:preview("done", 1)
            previewer:preview("done", 1)
            assert.is.equal("do something else else else", previewer.lines[1])
            assert.is.equal("do something else else else else", previewer.lines[2])
            assert.is.equal("@"..os.date("%Y-%m-%d").." do something else else", previewer.lines[3])
            assert.is.equal("@2016-01-01 done something", previewer.lines[6])
            assert.is.equal(8, #previewer.lines)
        end)

        it("should edit task right", function()
            previewer = require("todo.previewer"):new(opts)
            previewer:load_file()
            previewer:preview("edit", 1, "task1")
            previewer:preview("edit", 2, "task2")
            assert.is.equal("task1", previewer.lines[1])
            assert.is.equal("task2", previewer.lines[2])

            previewer:preview("edit", 1, "2")
            previewer:preview("edit", 2, "3")
            assert.is.equal("task2", previewer.lines[1])
            assert.is.equal("task1", previewer.lines[3])
            assert.is.equal(8, #previewer.lines)
        end)

        it("should all right", function()
            previewer = require("todo.previewer"):new(opts)
            previewer:load_file()

            previewer:preview("delete", 5)
            previewer:preview("delete", 3)
            previewer:preview("delete", 1)
            previewer:preview("delete", 2)
            assert.is.equal(4, #previewer.lines)
            assert.is.equal("do something else", previewer.lines[1])
            assert.is.equal("@2016-01-01 done something", previewer.lines[2])

            previewer:preview("delete", 1)
            previewer:preview("add", 1, "task1")
            previewer:preview("add", 2, "task2")
            previewer:preview("add", 3, "task5")
            previewer:preview("add", 3, "task3")
            previewer:preview("add", 4, "task4")
            assert.is.equal(8, #previewer.lines)
            for i = 1, 5 do
                assert.is.equal("task"..i, previewer.lines[i])
            end

            previewer:preview("edit", 1, 2)
            previewer:preview("edit", 2, 3)
            previewer:preview("edit", 3, 4)
            previewer:preview("edit", 4, 5)
            previewer:preview("edit", 5, 1)
            for i = 1, 5 do
                assert.is.equal("task"..i, previewer.lines[i])
            end

            previewer:preview("done", 3)
            previewer:preview("done", 1)
            previewer:preview("done", 3)
            previewer:preview("done", 1)
            previewer:preview("done", 1)

            assert.is.equal("@"..os.date("%Y-%m-%d").." task4", previewer.lines[1])
        end)
    end)

end)

