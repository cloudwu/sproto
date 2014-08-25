local parser = require "sprotoparser"
local core = require "sproto.core"
local print_r = require "print_r"

local spbin = parser.parse [[
.foobar {
	.nest {
		a 1 : string
		b 3 : boolean
		c 5 : integer
	}
	a 0 : string
	b 1 : integer
	c 2 : boolean
	d 3 : nest

	e 4 : *string
	f 5 : *integer
	g 6 : *boolean
	h 7 : foobar
}

.simpleReponse {
    ack 0 : boolean
}

.protocol {
    id 0 : integer
    req 1 : boolean
    data 2 : string
}

.group {
   data 0 : *string
}

postfoobar 1 {
    request foobar
    response {
        ok 0 : boolean
    }
}

poststr 2 {
    request {
        a 0 : string
        b 1 : boolean
    }
    response simpleReponse
}
]]

-- create protocol req/rep obj
local req1_obj = {
	a = "hello",
	b = 1000000,
	c = true,
	d = {
		a = "world",
		-- skip b
		c = -1,
	},
	e = { "ABC", "def" },
	f = { -3, -2, -1, 0 , 1, 2},
	g = { true, false, true },
	h = { b = 100 },
--	h = {
--		{ b = 100 },
--		{},
--		{ b = -100, c= false },
--		{ b = 0, e = { "test" } },
--	},
}

local req2_obj = {
   a = "req2_string",
   b = true
}

local rep1_obj = {
   ok = false
}

local rep2_obj = {
   ack = true
}

-- test protocol

protocoltbl = {
   postfoobar = 1,
   poststr = 2
}

local pr ={}

function pr.init( prdata )
   pr.sp = core.newproto( prdata )
   core.dumpproto( pr.sp )
   pr.prst = core.querytype(pr.sp, "protocol")
   pr.gst = core.querytype(pr.sp, "group")
   pr.data = {}
end

function pr.fini()
   core.delproto(pr.sp)
   pr.sp = nil
end

function pr.newpkg()
   pr.data = {}
end

function pr.append( protoid, isreq, obj )
   local name, req_st, rep_st = core.protocol(pr.sp, protoid)
   local st = isreq and req_st or rep_st
   local pro = {
      id = protoid,
      req = isreq,
      data = core.encode(st, obj)
   }
   pr.data[#pr.data + 1] = core.encode(pr.prst, pro)
end

function pr.packall()
   return core.pack( core.encode(pr.gst, { data = pr.data }) )
end

function pr.unpack( data )
   local group = core.decode(pr.gst, core.unpack( data ))
   pr.udata = group.data
   pr.uidx = 0
   -- print_r( pr.udata )
end

function pr.popone()
   if pr.uidx < #pr.udata then
      pr.uidx = pr.uidx + 1
      local p = core.decode(pr.prst, pr.udata[pr.uidx])
      -- 
      local name, req_st, rep_st = core.protocol(pr.sp, p.id)
      local st = p.req and req_st or rep_st
      return core.decode(st, p.data)
   end
   return nil
end

pr.init( spbin )
pr.newpkg()
pr.append( protocoltbl.postfoobar, true, req1_obj )
pr.append( protocoltbl.postfoobar, false, rep1_obj )
pr.append( protocoltbl.poststr, true, req2_obj )
pr.append( protocoltbl.poststr, false, rep2_obj )
local pkg = pr.packall()
-- 
local function _seperator() print(string.rep("-", 24)) end
pr.unpack( pkg )
print_r( pr.popone() )
_seperator()
print_r( pr.popone() )
_seperator()
print_r( pr.popone() )
_seperator()
print_r( pr.popone() )
_seperator()
print(pr.popone())
pr.fini()
