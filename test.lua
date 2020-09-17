local sproto = require "sproto"
local core = require "sproto.core"
local print_r = require "print_r"

local sp = sproto.parse [[
.Person {
	name 0 : string
	id 1 : integer
	email 2 : string
	real 3: double


	.PhoneNumber {
		number 99 : string
		type  1000: integer
	}

	phone 4 : *PhoneNumber
	phonemap 5 : *PhoneNumber()
}

.AddressBook {
	person 0: *Person(id)
	others 1: *Person
}
]]

-- core.dumpproto only for debug use
core.dumpproto(sp.__cobj)

for _, f in ipairs {"Person", "AddressBook"} do
	local def = sp:default(f)
	print("default table for " .. f)
	print_r(def)
	print("--------------")
end


local person = {
	[10000] = {
		name = "Alice",
		id = 10000,
		phone = {
			{ number = "123456789" , type = 1 },
			{ number = "87654321" , type = 2 },
		},
		phonemap = {
			["123456789"] = 1,
			["87654321"] = 2,
		}
	},
	[20000] = {
		name = "Bob",
		id = 20000,
		phone = {
			{ number = "01234567890" , type = 3 },
		},
		phonemap = {
			["0123456789"] = 3
		}
	}
}

local ab = {
	person = setmetatable({}, { __index = person, __pairs = function() return next, person, nil end }),
	others = {
		{
			name = "Carol",
			id = 30000,
			phone = {
				{ number = "9876543210" },
			},
			real = 1234.56789,
		},
		{
			name = "Bob",
			id = 30001,
			phonemap = {
				["9876543210"] = 1,
			}
		}
	}
}

collectgarbage "stop"

local code = sp:encode("AddressBook", ab)
local addr = sp:decode("AddressBook", code)
print_r(addr)
