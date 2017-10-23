
require 'busted.runner'()

local pb = require"pb"
local opt = require"protos.optional_boolean"

describe("An optional boolean member", function()

    it ("should be detected via HasField", function()

        msg = opt.TestOptionalBool()
        msg.bool_required = true
        assert.are.equal(false, msg:HasField("bool_optional"))
        
        binary,err = msg:Serialize()
        assert.is_true(not err)

        msg.bool_optional = true
        assert.are.equal(true, msg:HasField("bool_optional"))
        binary,err = msg:Serialize()
        assert.is_true(not err)


        msg.bool_optional = false
        assert.are.equal(true, msg:HasField("bool_optional"))
        binary,err = msg:Serialize()
        assert.is_true(not err)


        msg:Clear()
        msg.bool_required = true;
        assert.are.equal(false, msg:HasField("bool_optional"))
        binary,err = msg:Serialize()
        assert.is_true(not err)
    end)

end)


describe("A reqired boolean member", function()

    it ("should be able to be serialized as false", function()
        msg = opt.TestOptionalBool()
        msg.bool_required = false
        assert.are.equal(true, msg:HasField("bool_required"))
        binary,err = msg:Serialize()
        assert.is_true(not err)
        
    end)

    it ("should be able to be serialized as true", function()
        msg = opt.TestOptionalBool()
        msg.bool_required = true
        assert.are.equal(true, msg:HasField("bool_required"))
        binary,err = msg:Serialize()
        assert.is_true(not err)
        
    end)


end)

