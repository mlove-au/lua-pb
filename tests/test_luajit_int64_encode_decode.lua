
local pb = require"pb"
local utils = require"utils"
local integer64 = require"protos.int64"


local function round_trip_serder(value)
    local input = integer64.TestVariableInt64()
    input.standard_ = value
    input.unsigned_ = value
    input.signed_   = value

    binary,errmsg = input:Serialize()
    assert(errmsg == nil)

    decoded,offset = integer64.TestVariableInt64():Parse(binary)
    assert(decoded:IsInitialized(), "Failed: Message should be initialized after parsing")
    assert(decoded.standard_ == value, "Failed: " .. tostring(value) .. " != " ..  tostring(decoded.standard_))
    assert(decoded.unsigned_ == value, "Failed: " .. tostring(value) .. " != " ..  tostring(decoded.standard_))
    assert(decoded.signed_ == value, "Failed: " .. tostring(value) .. " != " ..  tostring(decoded.standard_))
end


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


test_with_real_timestamp()
test_with_high_bits_set_without_bit32()
test_with_additional_high_bits_set()
test_with_bit_32_set()

