local sproto = require "sproto"

local print_r = require "print_r"

local wt = sproto.parse [[
.foo {
    s 0: string
    i 1: integer
    b 2: boolean
}
]]

local t

t = {s = "abc"}
print_r(wt:decode("foo", wt:encode("foo", t)))

t = {s = 123}
print_r(wt:decode("foo", wt:encode("foo", t)))

t = {s = setmetatable({}, {__tostring = function() return "hello" end})}
print_r(wt:decode("foo", wt:encode("foo", t)))

t = {i = 100}
print_r(wt:decode("foo", wt:encode("foo", t)))

t = {i = 100.1}
print_r(wt:decode("foo", wt:encode("foo", t)))

t = {b = true}
print_r(wt:decode("foo", wt:encode("foo", t)))

t = {b = {}}
print_r(wt:decode("foo", wt:encode("foo", t)))

