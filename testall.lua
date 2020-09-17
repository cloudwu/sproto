local sproto = require "sproto"
local print_r = require "print_r"

local sp = sproto.parse [[
.foobar {
	.nest {
		a 1 : string
		b 3 : boolean
		c 5 : integer
		d 6 : integer(3)
	}
	.map {
		a 1 : string
		b 2 : nest
	}
	a 0 : string
	b 1 : integer
	c 2 : boolean
	d 3 : *nest(a)

	e 4 : *string
	f 5 : *integer
	g 6 : *boolean
	h 7 : *foobar
	i 8 : *integer(2)
	j 9 : binary
	k 10: double
	l 11: *double
	m 12: *map()
}
]]

local obj = {
	a = "hello",
	b = 1000000,
	c = true,
	d = {
		{
			a = "one",
			-- skip b
			c = -1,
		},
		{
			a = "two",
			b = true,
		},
		{
			a = "",
			b = false,
			c = 1,
		},
		{
			a = "decimal",
			d = 1.235,
		}
	},
	e = { "ABC", "", "def" },
	f = { -3, -2, -1, 0 , 1, 2},
	g = { true, false, true },
	h = {
		{ b = 100 },
		{},
		{ b = -100, c= false },
		{ b = 0, e = { "test" } },
	},
	i = { 1,2.1,3.21,4.321 },
	j = "\0\1\2\3",
	k = 12.34567,
	l = {11.1, 22.2, 33.3, 44.4},
	m = {
		a = {a = 1, b = false, c = 5, d = 6},
		c = {a = 2, b = true, c = 6, d = 7},
	}
}

local code = sp:encode("foobar", obj)
obj = sp:decode("foobar", code)
print_r(obj)

-- core.dumpproto only for debug use
local core = require "sproto.core"
core.dumpproto(sp.__cobj)
