--!native
--!optimize 2
--// Paficent \\-

--// Imports
local cloneReference = function(obj: Instance): Instance
	if cloneref then
		return cloneref(obj)
	end

	return obj
end

--// Module Declaration
local Services = {}
Services.__index = Services
setmetatable(Services, {
	-- Handles dynamic service creation or retrieval
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

	-- Handles retrieval of multiple services
	__call = function(self, ...: string)
		local toReturn: { any } = {}

		for _, serviceName in ipairs({ ... }) do
			table.insert(toReturn, self[serviceName])
		end

		return table.unpack(toReturn)
	end,
})

-- Alternative Syntax, proxy for __call
function Services:Get(...: string)
	return self(...)
end

return Services
