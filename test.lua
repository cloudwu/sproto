local parser = require "sprotoparser"
local core = require "sproto.core"
local print_r = require "print_r"

local sp = parser.parse [[
.Person {
	name 0 : string
	id 1 : integer
	email 2 : string

	.PhoneNumber {
		number 0 : string
		type 1 : integer
	}

	phone 3 : *PhoneNumber
}

.AddressBook {
	person 0 : *Person(id)
}
]]

sp = core.newproto(sp)
core.dumpproto(sp)
local st = core.querytype(sp, "AddressBook")

local ab = {
	person = {
		{
			name = "Alice",
			id = 10000,
			phone = {
				{ number = "123456789" , type = 1 },
				{ number = "87654321" , type = 2 },
			}
		},
		{
			name = "Bob",
			id = 20000,
			phone = {
				{ number = "01234567890" , type = 3 },
			}
		}
	}
}

collectgarbage "stop"

local code = core.encode(st, ab)
local addr = core.decode(st, code)
print_r(addr)
