local sproto = require "sproto"
local print_r = require "print_r"

sp = sproto.parse [[
.package {
	type 0 : integer
	session 1 : integer
}

foobar 1 {
	request {
		what 0 : string
	}
	response {
		ok 0 : boolean
	}
}
]]

-- The type package must has two field : type and session
local server = sp:rpc "package"
local client = sp:rpc "package"

print("client request foobar")
local req = client:request("foobar", { what = "foo" }, 1)
print("request package size =", #req)
local type, name, request, response = server:dispatch(req)
assert(type == "REQUEST" and name == "foobar")
print_r(request)
print("server response")
local resp = response { ok = true }
print("response package size =", #resp)
print("client dispatch")
local type, session, response = client:dispatch(resp)
assert(type == "RESPONSE" and session == 1)
print_r(response)
