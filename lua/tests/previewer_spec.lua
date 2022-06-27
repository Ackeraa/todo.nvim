describe("previewer", function()
    local previewer = require("todo.previewer"):new()

    describe("file method", function()
        it("can load the todo file", function()
            previewer:load_file("lua/tests/todo.txt")
            assert.is.equal(#previewer.lines, 8)
        end)

        it("can write the todo file", function()
            previewer = require("todo.previewer"):new()
            previewer:load_file("lua/tests/todo.txt")
            previewer:save_file("lua/tests/todo.txt")
            assert.is.equal(#previewer.lines, 8)
        end)
    end)
end)

