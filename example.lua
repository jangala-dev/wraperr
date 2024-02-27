package.path = "wraperr/?.lua;" .. package.path

local wraperr = require "wraperr"

local inner_error = wraperr.new("inner error")
local middle_error = wraperr.new("middle error"):wrap(inner_error)
local outer_error = wraperr.new("outer error"):wrap(middle_error)
print(outer_error)
assert(outer_error:is(middle_error))
assert(outer_error:is(inner_error))
assert(not middle_error:is(outer_error))

local function http_to_string(self)
    return string.format("HTTP Error %d: %s", self.status_code, self.err and tostring(self.err) or "nil")
end

local http_error = wraperr.custom(http_to_string)

-- Create specific HTTP errors
local not_found = http_error.new({status_code = 404, err = wraperr.new("Not Found")})
local server_error = http_error.new({status_code = 500, err = wraperr.new("Internal Server Error")})

-- Print the errors
print(not_found)
print(server_error)

-- Test wrapping functionality
local wrapped_error = wraperr.new("Wrapper error"):wrap(not_found)
print(wrapped_error)  -- Should show the wrapper error with the not_found error wrapped inside

-- Test is functionality
assert(wrapped_error:is(not_found), "wrapped_error should contain not_found")
assert(not server_error:is(not_found), "server_error is not not_found")
