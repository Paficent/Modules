--!strict
--!native
--// Paficent \\--

--[[
Example Usage:


local Case = require(script.Case)
local myCase = Case.new()

myCase:add(false, function() return "Case 1 executed" end)
myCase:addMultiple({
    { Statement = true, CallbackFunction = function() return "Case 2 executed" end },
    { Statement = true, CallbackFunction = function(arg) return "Case 3 executed with arg: " .. arg end, Args = {"Hello"} }
})

local index = myCase:test()
print(index) -- Output: 2

local result = myCase:check()
print(result) -- Output: "Case 2 executed"
]]--

local Case = {}
Case.__index = Case

type CaseData = {
    Statement: boolean,
    CallbackFunction: ((...any) -> any)?,
    Args: {any}?
}

type CaseObject = {
    cases: {CaseData},
    add: (self: CaseObject, statement: boolean, callbackFunction: ((...any) -> any)?, args: {any}?) -> (),
    addMultiple: (self: CaseObject, cases: {CaseData}) -> (),
    test: (self: CaseObject) -> number,
    check: (self: CaseObject) -> any?
}

function Case.new(): CaseObject
    local self: CaseObject = setmetatable({
        cases = {}
    }, Case)
    return self
end

function Case:add(statement: boolean, callbackFunction: ((...any) -> any)?, args: {any}?): ()
    local caseData: CaseData = {
        Statement = statement,
        CallbackFunction = callbackFunction,
        Args = args
    }
    table.insert(self.cases, caseData)
end

function Case:addMultiple(cases: {CaseData}): ()
    for _, caseData in ipairs(cases) do
        table.insert(self.cases, caseData)
    end
end

function Case:test(): number
    for index, data in ipairs(self.cases) do
        if data.Statement then
            return index
        end
    end
    return -1
end

function Case:check(): any?
    for _, data in ipairs(self.cases) do
        if data.Statement then
            local callbackFunction = data.CallbackFunction
            if callbackFunction then
                if data.Args then
                    return callbackFunction(table.unpack(data.Args))
                else
                    return callbackFunction()
                end
            end
        end
    end
    return nil
end

return Case
