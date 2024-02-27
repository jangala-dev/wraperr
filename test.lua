package.path = "wraperr/?.lua;" .. package.path

local wraperr = require "wraperr"

-- Function to test new error creation
local function test_new_error_creation()
    local error_message = "Test error"
    local error_obj = wraperr.new(error_message)
    assert(tostring(error_obj) == error_message, "Error object should correctly represent its message")
end

-- Function to test error wrapping functionality
local function test_error_wrapping_and_unwrapping()
    local base_error = wraperr.new("Base error")
    local wrapped_error = wraperr.new("Wrapped error"):wrap(base_error)
    assert(wrapped_error:unwrap() == base_error, "Wrapped error should unwrap to the base error")
end

-- Function to test error comparison (is)
local function test_error_comparison()
    local error1 = wraperr.new("Error 1")
    local error2 = wraperr.new("Error 2"):wrap(error1)
    local error3 = wraperr.new("Error 3")

    assert(error2:is(error1), "Error 2 should be considered as wrapping Error 1")
    assert(not error1:is(error2), "Error 1 should not be considered as wrapping Error 2")
    assert(not error2:is(error3), "Error 2 and Error 3 should not be considered the same")
end

-- Function to test error type checking (as)
local function test_error_type_checking()
    local custom_to_string = function(self)
        return "Custom: " .. tostring(self.content)
    end
    local custom_error = wraperr.custom(custom_to_string)
    local error_obj = custom_error.new({content = "Custom Error"})

    local success, result = error_obj:as(error_obj)
    assert(success and result == error_obj, "Error object should match its custom type")
end

-- Function to test custom errors
local function test_custom_errors()
    local http_to_string = function(self)
        return string.format("HTTP Error %d: %s", self.status_code, self.err and tostring(self.err) or "nil")
    end
    local http_error = wraperr.custom(http_to_string)
    local not_found_error = http_error.new({status_code = 404, err = wraperr.new("Not Found")})
    local server_error = http_error.new({status_code = 500, err = wraperr.new("Internal Server Error")})

    assert(tostring(not_found_error) == "HTTP Error 404: Not Found", "Not found error message should match")
    assert(tostring(server_error) == "HTTP Error 500: Internal Server Error", "Server error message should match")

    -- Ensure custom errors can use wraperr methods
    local wrapped_http_error = wraperr.new("Wrapper error"):wrap(not_found_error)
    assert(wrapped_http_error:is(not_found_error), "wrapped_http_error should contain not_found_error")
    assert(not server_error:is(not_found_error), "server_error is not not_found_error")

    -- Test custom error with standard error chain
    local chained_error = not_found_error:wrap(wraperr.new("Database Error"))
    assert(tostring(chained_error:unwrap()) == "Database Error", "Chained error should unwrap to the correct error")
end

-- Running the tests
test_new_error_creation()
test_error_wrapping_and_unwrapping()
test_error_comparison()
test_error_type_checking()
test_custom_errors()

print("All tests passed!")
