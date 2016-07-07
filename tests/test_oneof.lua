local pb = require"pb"

-- load .proto file.
local oneof = require"protos.oneof"

local Test1 = oneof.Test1
local Test2 = oneof.Test2

local data = {
	id = 11111,
  bar = "bar",
  baz = 99999,
  foo = 99999,
}

-- create with values for all fields and serialize
local msg_no_oneof = Test1(data)
local bin = msg_no_oneof:Serialize()
-- deserialize into a Test2 message
local msg_oneof = Test2():Parse(bin)

assert(msg_oneof.id == msg_no_oneof.id)
-- only the last field of the oneof set should be non-nil
assert(msg_oneof.foo == nil)
assert(msg_oneof.bar == nil)
assert(msg_oneof.baz ~= nil)
-- oneof accessor return a non-nil value
assert(msg_oneof.type == msg_oneof.baz)
-- trying to set the oneof value is not supported and should yield an error
assert(not pcall(function() msg_oneof.type = "Test" end))