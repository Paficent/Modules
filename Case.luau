--!strict
--!native
--// Paficent \\--

local Case = {}
Case.__index = Case

type CaseData = {
    Statement: boolean,
    CallbackFunction: ((...any) -> any)?,
    Args: {any}?
}

type CaseObject = {
    cases: {CaseData},
    runAll: boolean,
    add: (self: CaseObject, statement: boolean, callbackFunction: ((...any) -> any)?, args: {any}?) -> (),
    addMultiple: (self: CaseObject, ...CaseData) -> (),
    test: (self: CaseObject) -> {number},
    check: (self: CaseObject) -> {any}
}

function Case.new(runAll: boolean): CaseObject
    local self: CaseObject = setmetatable({
        cases = {},
        runAll = runAll or false
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

function Case:addMultiple(...: CaseData): ()
    for _, caseData in ipairs({...}) do
        table.insert(self.cases, caseData)
    end
end

function Case:test(): {number}
    local result: {number} = {}
    for index, caseData in ipairs(self.cases) do
        if caseData.Statement then
            result[#result + 1] = index
        end
    end
    return result
end

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

setmetatable(Case, {
    __call = function(self, statement: boolean, callbackFunction: ((...any) -> any)?, args: {any}?)
        return self:add(statement, callbackFunction, args)
    end
})

return Case
