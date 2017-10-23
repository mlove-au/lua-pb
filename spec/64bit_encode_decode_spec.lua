
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


--[[
local function test_with_bit_32_set()
    round_trip_serder(0x00000000FFFFFFFF)
end

local function test_with_additional_high_bits_set()
    round_trip_serder(0x000D0001FFFFFFFF)
end

local function test_with_high_bits_set_without_bit32()
    round_trip_serder(0x0BCD0000EFFFFFFF)
end

local function test_with_real_timestamp()
    -- GMT: Monday, November 13, 2017 6:50:43.648 AM
    local ts_with_bit_32_set = 0x15FB424FC40
    round_trip_serder(ts_with_bit_32_set)
end

local function test_with_negative_signed_64_bits()
    round_trip_signed_serder(-1);
    local x=  -100000000000000
    local x=  -9000000000000000
    print(tonumber(x))
    round_trip_signed_serder(x);
 --   round_trip_signed_serder(-9223372036854775808)
end



test_with_real_timestamp()
test_with_high_bits_set_without_bit32()
test_with_additional_high_bits_set()
test_with_bit_32_set()
test_with_negative_signed_64_bits()

--]]
