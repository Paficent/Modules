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
    addCase: (self: CaseObject, statement: boolean, callbackFunction: ((...any) -> any)?, args: {any}?) -> (),
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

function Case:addCase(statement: boolean, callbackFunction: ((...any) -> any)?, args: {any}?): ()
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
