--!strict
--!native
--!optimize 2
--// Paficent \\-

--// Imports
local cloneReference = function(obj): Instance
    if cloneref then
        return cloneref(obj)
    end
    
	return obj
end

--// Module Declaration
local Services = {}
Services.__index = Services

-- Retrieves and returns multiple services by name
function Services:Get(...: string): {any}
    local toReturn: {any} = {}
    
    for _, serviceName in ipairs({...}) do
        table.insert(toReturn, self[serviceName])
    end

    return table.unpack(toReturn)
end

-- Metamethod for dynamically creating or retrieving services
setmetatable(Services, {
    __index = function(self, name: string)
        local service
        if name == "VirtualInputManager" or name == "VirtualUser" then
            service = cloneReference(Instance.new(name))
        else
            service = cloneReference(game:GetService(name))
        end

        rawset(self, name, service)
        return service
    end,
})

return Services
