-- Import the Case module
local Case = require(script.Case)

-- Create a new Case object, specifying whether to run all callbacks
local myCase = Case.new(true) -- `true` to run all callbacks

-- Add individual cases using the __call metamethod
myCase(true, function() return "Case 1 executed" end)
myCase(false, function() return "Case 2 executed" end) -- This will not be executed since the statement is false
myCase(true, function() return "Case 3 executed" end)

-- Add multiple cases using the addMultiple method
myCase:addMultiple(
    { Statement = true, CallbackFunction = function() return "Case 4 executed" end },
    { Statement = true, CallbackFunction = function(arg) return "Case 5 executed with arg: " .. arg end, Args = {"Hello"} }
)

-- Retrieve the indices of all cases that have a true statement
local indices = myCase:test()
print("Indices of cases with true statements:", table.concat(indices, ", "))
-- Output: Indices of cases with true statements: 1, 3, 4, 5

-- Retrieve the results of all callbacks
local results = myCase:check()
print("Results of all callbacks:")
for _, result in ipairs(results) do
    print(result)
end
-- Output:
-- Results of all callbacks:
-- Case 1 executed
-- Case 3 executed
-- Case 4 executed
-- Case 5 executed with arg: Hello

-- Create another Case object to demonstrate the `runAll` parameter
local anotherCase = Case.new(false) -- `false` to run only callbacks that return true

-- Add cases
anotherCase(true, function() return true end) -- This will be included in results because it returns true
anotherCase(true, function() return false end) -- This will be excluded from results because it returns false
anotherCase(true, function() return "Only True" end)

-- Retrieve the indices of all cases that have a true statement
local anotherIndices = anotherCase:test()
print("Indices of cases with true statements in anotherCase:", table.concat(anotherIndices, ", "))
-- Output: Indices of cases with true statements in anotherCase: 1, 2, 3

-- Retrieve the results of all callbacks
local anotherResults = anotherCase:check()
print("Results of all callbacks in anotherCase:")
for _, result in ipairs(anotherResults) do
    print(result)
end
-- Output:
-- Results of all callbacks in anotherCase:
-- Only True
