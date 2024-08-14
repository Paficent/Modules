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

--// Local Functions
local function createCaseData(statement: boolean, callbackFunction: ((...any) -> any)?, args: {any}?): CaseData
    return {
        Statement = statement,
        CallbackFunction = callbackFunction,
        Args = args
    }
end
local function getCallbackResult(callbackFunction: ((...any) -> any)?, args: {any}?): any
    if not callbackFunction then
        return nil
    end

    if args then
        return callbackFunction(table.unpack(args))
    else
        return callbackFunction()
    end
end
local function shouldAddResult(result: any, runAll: boolean): boolean
    return runAll or result
end

--// Methods
-- Adds a new case with a statement, callback function, and optional arguments
function Case:add(statement: boolean, callbackFunction: ((...any) -> any)?, args: {any}?): ()
    local caseData = createCaseData(statement, callbackFunction, args)
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
            table.insert(result, index)
        end
    end
    return result
end

-- Checks all cases and returns results of callback functions for true statements
function Case:check(): {any}
    local results: {any} = {}
    for _, caseData in ipairs(self.cases) do
        if caseData.Statement then
            local result = getCallbackResult(caseData.CallbackFunction, caseData.Args)
            if shouldAddResult(result, self.runAll) then
                table.insert(results, result)
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
