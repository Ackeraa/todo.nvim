describe("adder parse", function()

    it("can parse add command", function()
        local adder = require("todo.adder")
        local op, arg1, arg2 = adder:_parse("add 1 hello")
        assert.is.not_nil(op, arg1, arg2)
        assert.is.equal("add", op)
        assert.is.equal(1, arg1)
        assert.is.equal("hello", arg2)

        op, arg1, arg2 = adder:_parse("ad 1123 1232 hello world")
        assert.is.not_nil(op, arg1, arg2)
        assert.is.equal("add", op)
        assert.is.equal(1123, arg1)
        assert.is.equal("1232 hello world", arg2)

    end)

    it("can parse delete command", function()
        local adder = require("todo.adder")
        local op, arg1, arg2 = adder:_parse("delete 1")
        assert.is.not_nil(op, arg1, arg2)
        assert.is.equal("delete", op)
        assert.is.equal(1, arg1)
        assert.is.equal(nil, arg2)

        op, arg1, arg2 = adder:_parse("d 112")
        assert.is.not_nil(op, arg1, arg2)
        assert.is.equal("delete", op)
        assert.is.equal(112, arg1)
        assert.is.equal(nil, arg2)

    end)

    it("can parse done command", function()
        local adder = require("todo.adder")
        local op, arg1, arg2 = adder:_parse("done 1")
        assert.is.not_nil(op, arg1, arg2)
        assert.is.equal("done", op)
        assert.is.equal(1, arg1)
        assert.is.equal(nil, arg2)

        op, arg1, arg2 = adder:_parse("do 1")
        assert.is.not_nil(op, arg1, arg2)
        assert.is.equal("done", op)
        assert.is.equal(1, arg1)
        assert.is.equal(nil, arg2)

    end)

    it("can parse edit command", function()
        local adder = require("todo.adder")
        local op, arg1, arg2 = adder:_parse("edit 1 hello")
        assert.is.not_nil(op, arg1, arg2)
        assert.is.equal("edit", op)
        assert.is.equal(1, arg1)
        assert.is.equal("hello", arg2)

        op, arg1, arg2 = adder:_parse("ed 1123 1232 hello world")
        assert.is.not_nil(op, arg1, arg2)
        assert.is.equal("edit", op)
        assert.is.equal(1123, arg1)
        assert.is.equal("1232 hello world", arg2)

    end)

end)
