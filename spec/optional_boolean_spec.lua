
require 'busted.runner'()

local pb = require"pb"
local utils = require"utils"
local opt = require"protos.optional_boolean"

describe("A boolean member", function()
    it ("should be detected via HasField", function()

        msg = opt.TestOptionalBool()
        assert.are.equal(false, msg:HasField("bool_"))

        msg.bool_ = true;
        assert.are.equal(true, msg:HasField("bool_"))

        msg.bool_ = false;
        assert.are.equal(true, msg:HasField("bool_"))

        msg:Clear()
        assert.are.equal(false, msg:HasField("bool_"))

    end)

end)
