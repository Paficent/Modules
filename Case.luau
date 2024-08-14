--!strict
--!native
--!optimize 2
--// Paficent \\-

--// Types
type CaseData = {
    Statement: boolean,
    CallbackFunction: ((...any) -> any)?,
    Args: {any}?
}

--// Module Declaration
local Case = {}
Case.__index = Case

--// Constructor
function Case.new(runAll: boolean)
    return setmetatable({
        cases = {} :: {CaseData},
        runAll = runAll or false
    }, Case)
end

-- Adds a new case with a statement, callback function, and optional arguments
function Case:add(statement: boolean, callbackFunction: ((...any) -> any)?, args: {any}?): ()
    local caseData: CaseData = {
        Statement = statement,
        CallbackFunction = callbackFunction,
        Args = args
    }
    table.insert(self.cases, caseData)
end

-- Adds multiple cases in one call
function Case:addMultiple(...: CaseData): ()
    for _, caseData in ipairs({...}) do
        table.insert(self.cases, caseData)
    end
end

-- Tests all cases and returns indices of cases with a true statement
function Case:test(): {number}
    local result: {number} = {}
    for index, caseData in ipairs(self.cases) do
        if caseData.Statement then
            result[#result + 1] = index
        end
    end
    return result
end

-- Checks all cases and returns results of callback functions for true statements
function Case:check(): {any}
    local results: {any} = {}
    local runAll = self.runAll
    for _, caseData in ipairs(self.cases) do
        if caseData.Statement then
            local callbackFunction = caseData.CallbackFunction
            if callbackFunction then
                local result
                if caseData.Args then
                    result = callbackFunction(table.unpack(caseData.Args))
                else
                    result = callbackFunction()
                end
                if runAll or result then
                    results[#results + 1] = result
                end
            end
        end
    end
    return results
end

-- Allows calling the module as a function to add a case
setmetatable(Case, {
    __call = function(self, statement: boolean, callbackFunction: ((...any) -> any)?, args: {any}?)
        self:add(statement, callbackFunction, args)
    end
})

return Case
