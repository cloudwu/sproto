local sproto = require "sproto"
local core = require "sproto.core"
local print_r = require "print_r"

local sp1 = sproto.parse [[
.map {
    a 0 : integer
    b 1 : string
}

.struct {
    m 0 : *map()
}
]]

local sp2 = sproto.parse [[
.map {
    a 0 : integer
    b 1 : string
}

.struct {
    m 0 : *map
}
]]

local r

local s1 = {m = {[2] = "3", [4] = "5"}}
r = sp2:decode("struct", sp1:encode("struct", s1))
print_r(r)

local s2 = {m = {{a = 2, b = "3"}, {a = 4, b = "5"}}}
r = sp1:decode("struct", sp2:encode("struct", s2))
print_r(r)
