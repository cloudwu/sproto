-- generate wire protocol example
local sproto = require "sproto"

local sp = sproto.parse [[
.Person {
    name 0 : string
    age 1 : integer
    marital 2 : boolean
    children 3 : *Person
}

.Data {
	numbers 0 : *integer
	bools 1 : *boolean
	number 2 : integer
	bignumber 3 : integer
    double 4 : double
    doubles 5 : *double
    fpn 6 : integer(2)
}
]]

local function run_example(typename, data)
    local chunk = sp:encode(typename, data)
    local t = {}
    for i=1, #chunk do
        t[#t+1] = string.format("%02x", string.byte(chunk, i))
    end
    print(table.concat(t, " "))
end

-- Example 1
print("Example 1:")
run_example("Person", {
    name = "Alice",
    age = 13,
    marital = false
})

-- Example 2
print("Example 2:")
run_example("Person", {
    name = "Bob",
    age = 40,
    children = {
        { name = "Alice" ,  age = 13 },
        { name = "Carol" ,  age = 5 },
    }
})

-- Example 3
print("Example 3:")
run_example("Data", {
    numbers = { 1,2,3,4,5 }
})

-- Example 4
print("Example 4:")
run_example("Data", {
    numbers = {
        (1<<32)+1,
        (1<<32)+2,
        (1<<32)+3,
    }
})

-- Example 5
print("Example 5:")
run_example("Data", {
    bools = { false, true, false }
})

-- Example 6
print("Example 6:")
run_example("Data", {
    number = 100000,
    bignumber = -10000000000,
})

-- Example 7
print("Example 7:")
run_example("Data", {
    double = 0.01171875,
    doubles = {0.01171875, 23, 4}
})

-- Example 8
print("Example 8:")
run_example("Data", {
    fpn = 1.82,
})

