require 'busted.runner'()

local pb = require"pb"
local utils = require"utils"
local integer64 = require"protos.int64"

local function round_trip_unsigned_serder(value)
    local input = integer64.UnsignedVarint64()

    input.uint64_ = value
    input.fixed64_ = value

    binary,errmsg = input:Serialize()
    assert.is_true(errmsg == nil)

    decoded,offset = integer64.UnsignedVarint64():Parse(binary)
    assert.is_true(decoded:IsInitialized())
    assert.are.equal(value, decoded.uint64_)
    assert.are.equal(value, decoded.fixed64_)
end

local function round_trip_signed_serder(value)
    local input = integer64.SignedVarint64()
    input.int64_ = value
    input.sfixed64_ = value
    input.sint64_  = value

    binary,errmsg = input:Serialize()
    assert.is_true(errmsg == nil)

    decoded,offset = integer64.SignedVarint64():Parse(binary)
    assert.is_true(decoded:IsInitialized(), "Failed: Message should be initialized after parsing")
    assert.are.equal(value, decoded.int64_)
    assert.are.equal(value, decoded.sfixed64_)
    assert.are.equal(value, decoded.sint64_)
end

describe("Unsigned 64 bit integers", function()
    it ("should encode/decode 0x0", function()
        round_trip_unsigned_serder(0x0)
    end)

    it ("should encode/decode 0x1", function()
        round_trip_unsigned_serder(0x1)
    end)

    it ("should decode 0x7FFFFFFF (bit 32 not set)", function()
        round_trip_unsigned_serder(0x7FFFFFFF)
    end)

    it ("should decode 0xFFFFFFFF (lower 32 bits set)", function()
        round_trip_unsigned_serder(0xFFFFFFFF)
    end)

    it ("should decode 0xDEADFFFFFFFF (lower 32 bits set)", function()
        round_trip_unsigned_serder(0xDEADFFFFFFFF)
    end)

    it ("Should decode 0x0010000000000000 (max lua int)", function()
        round_trip_unsigned_serder(0x0010000000000000)
    end)
end)

describe("Signed 64 bit integers", function()

    it ("should encode/decode 0x0", function()
        round_trip_signed_serder(0x0)
    end)

    it ("should encode/decode 0x1", function()
        round_trip_signed_serder(0x1)
    end)

   -- it ("should encode/decode -0x1", function()
   --    round_trip_signed_serder(-0x1)
   -- end)

    it ("should decode 0x7FFFFFFF (bit 32 not set)", function()
        round_trip_signed_serder(0x7FFFFFFF)
    end)

    it ("should decode 0xFFFFFFFF (lower 32 bits set)", function()
        round_trip_signed_serder(0xFFFFFFFF)
    end)

    it ("should decode 0xDEADFFFFFFFF (lower 32 bits set)", function()
        round_trip_signed_serder(0xDEADFFFFFFFF)
    end)

   -- it ("Should decode -9223372036854775809 (max #negative lua int)", function()
   --     round_trip_signed_serder(-9223372036854775808)
   -- end)

    it ("Should decode 0x0010000000000000 (max lua int)", function()
        round_trip_signed_serder(0x0010000000000000)
    end)

    it ("Should decode a UTC timestamp encoded as a int64", function()
        round_trip_signed_serder(0x15FB424FC40);
    end)
end)

