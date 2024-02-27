## wraperr: Enhanced Error Handling for Lua

`wraperr` is a Lua module designed to extend error handling capabilities by introducing a system for wrapping error as values. Drawing inspiration from Go, `wraperr` allows developers to create, wrap, and manage errors with greater flexibility and detail. It uses Lua's metatables to provide advanced functionality such as custom error types, error wrapping for additional context, and precise error comparison and unwrapping.

**Key Features:**

- **Error Wrapping:** Wrap errors within other errors to maintain original error information while adding new context.
- **Custom Error Types:** Define custom error types with unique string representations for clearer and more informative error messages (as well as custom handling using codes, etc).
- **Precise Error Handling:** Perform checks to see if an error matches or contains another error, and unwrap errors to reveal underlying issues.

### Quick Start

```lua
local wraperr = require("wraperr")

-- Creating a simple error
local base_error = wraperr.new("Base error")

-- Wrapping the error with additional context
local context_error = wraperr.new("Context added"):wrap(base_error)

-- Demonstrating error comparison and unwrapping
if context_error:is(base_error) then
    print("Context error includes the base error")
end

-- Defining and using custom error types
local function custom_error_message(self)
    return "Custom Error: " .. self.message
end

local custom_error = wraperr.custom(custom_error_message)
local my_error = custom_error.new({message = "An unexpected error occurred"})

print(my_error)  -- Outputs: Custom Error: An unexpected error occurred
```

### Installation

To use `wraperr` in your project, place the `wraperr.lua` file in an appropriate directory within your project structure. Include it in your Lua scripts as needed:

```lua
local wraperr = require("wraperr")
```

### Usage

**Creating New Errors:**

- Use `wraperr.new(content)` to generate new error objects.
- Apply `error:wrap(another_error)` to encapsulate one error within another, and so adding additional context.

**Defining Custom Error Types:**

- Create a constructor for a custom error type with `wraperr.custom(to_string_function)`, which allows for a custom string representation of the error.

**Handling Errors:**

- Use `error:is(other_error)` to ascertain if the current error object matches or contains the specified error.
- Use `error:as(custom_error_type)` to ascertain if the current error object contains an error of the specific type and return that error.
- Access a wrapped error directly through `error:unwrap()`, facilitating deeper error investigation.

### Contributing

Contributions to `wraperr` are welcome. Feel free to fork the repository, make your changes, and submit pull requests. If you encounter any issues or have suggestions for improvements, please open an issue on the project repository.

### License

`wraperr` is open-sourced software licensed under the MIT license.