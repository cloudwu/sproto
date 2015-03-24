local parser = require "sprotoparser"
local core = require "sproto.core"
local print_r = require "print_r"

local format = string.format
local strbyte = string.byte

local sp = parser.parse [[
.person {
	name 0 : string 
}
]]

sp = core.newproto(sp)

local ab = {
	name = 1000,
}

local st = core.querytype(sp, "person")

local binary = core.encode(st, ab) 
local target = core.decode(st, binary)

print( type(ab.name) )    --> number
print( type(target.name) )  --> string

print( string.gsub(binary, ".", function(x) 
		return format("0x%02X ", strbyte(x) ) 
	end ) 
)
--> 0x01 0x00 0x00 0x00 0x04 0x00 0x00 0x00 0x31 0x30 0x30 0x30     12

core.deleteproto(sp)
