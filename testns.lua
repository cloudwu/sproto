local sproto = require "sproto"
local print_r = require "print_r"
local core = require "sproto.core"

local schemas = {
    ["addressBook"] = [[
namespace addressbook

.AddressBook {
	person 0 : *Person(id)
	others 1 : *Person(id)
}

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
    ]],

    ["telephone"] = [[
namespace telephone

.Phone {
    is_mobile 0 : boolean
    number 1 : Person.PhoneNumber@addressbook
}

call 1 {
    request {
        who 0 : Person@addressbook
        what 1 : Phone
    }
    response {
        ok 0 : boolean
    }
}
    ]],
}

local sp = sproto.parse(schemas)
-- core.dumpproto only for debug use
core.dumpproto(sp.__cobj)

local def = sp:default "Person@addressbook"
print("default table for Person")
print_r(def)
print("--------------")

local person = {
	[10000] = {
		name = "Alice",
		id = 10000,
		phone = {
			{ number = "123456789" , type = 1 },
			{ number = "87654321" , type = 2 },
		}
	},
	[20000] = {
		name = "Bob",
		id = 20000,
		phone = {
			{ number = "01234567890" , type = 3 },
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
			}
		},
	}
}

collectgarbage "stop"

local code = sp:encode("AddressBook@addressbook", ab)
local addr = sp:decode("AddressBook@addressbook", code)
print_r(addr)

print("#### test rpc request")
local req = sp:request_encode("call@telephone", {who = {name="deadbeaf",id=3},what={number={number="1234545"}, is_mobile=true}})
print_r(sp:request_decode("call@telephone",req))

print("#### test rpc response")
local resp =sp:response_encode("call@telephone",{ok=true}) 
print_r(sp:response_decode("call@telephone",resp))
