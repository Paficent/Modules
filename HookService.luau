--!strict
--!native
--!optimize 2
--// Paficent \\-

--// Types
type AmbigiousFunction = (...any) -> any
type SignalConnection = { Disconnect: () -> () }

--// Imports
local Signal = (function() -- This library only really works for elevated permissions, so the lack of typechecking here shouldnt be a problem, you can always bundle with Wax if this is an issue
    if loadstring and pcall(loadstring("return 0")) then
        return loadstring("https://raw.githubusercontent.com/Paficent/Modules/main/Signal.luau")()
    end
    error("Failed to load Signal Library")
end)()

--// Module Declaration
local HookService = {}
HookService.__index = HookService

function HookService.new()
    return setmetatable({
        OnMessage = Signal.new(),
    }, HookService)
end

--// Locals
local hooks: {AmbigiousFunction: any} = {}

local clone_func = function(func)
    return clonefunction and clonefunction(func) or clonefunc and clonefunc(func) or func
end
local hook_func = function(func, hook)
    hooks[func] = clone_func(func)

    hookfunction(func, hook)
end
local restore_func = function(hookedFunction)
    if restorefunction then
        restorefunction(hookedFunction)
    else
        error("Your executor doesn't support 'restorefunction'")
    end

    hooks[hookedFunction] = nil
end

-- Hooks a function with another function
function HookService:Hook(originalFunction: AmbigiousFunction, hookFunction: AmbigiousFunction)
    hook_func(originalFunction, hookFunction)
    self.OnMessage:Fire(`Hooked {originalFunction}`)
end

-- Restores a previously hooked function to the original
function HookService:Restore(originalFunction: AmbigiousFunction)
    restore_func(originalFunction)
    self.OnMessage:Fire(`Hooked {originalFunction}`)
end

-- Spoofs the __index metamethod to return a custom value for a specific property
function HookService:HookIndex(object: Instance, property: string, value: any)
    local originalIndex: (self: any, key: any, ...any) -> any
    originalIndex = hookmetamethod(object, "__index", function(self, key, ...)
        if key == property then
            return value
        end
        return originalIndex(self, key, ...)
    end)
    self.OnMessage:Fire(`Hooked {object.Name}'s {property} to {value}`)
end

-- Spoofs the __namecall metamethod to block specific method calls
function HookService:HookNamecall(object: Instance, method: string)
    local originalNamecall: (self: any, ...any) -> any
    originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        if not checkcaller() and self == object and getnamecallmethod() == method then
            return
        end
        return originalNamecall(self, ...)
    end)
    self.OnMessage:Fire(`Blocked {object.Name}.{method}`)
end

-- Hooks a RemoteEvent or RemoteFunction with a custom function
function HookService:HookRemote(remote: RemoteEvent | RemoteFunction, hookFunction: AmbigiousFunction)
    local originalNamecall: (self: any, ...any) -> any
    originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        if not checkcaller() and self == remote then
            if getnamecallmethod() == "FireServer" or getnamecallmethod() == "InvokeServer" then
                return hookFunction(self, ...)
            end
        end
        return originalNamecall(self, ...)
    end)
    self.OnMessage:Fire(`Hooked remote {remote}`)
end

-- Disables all connections of a given signal
function HookService:DisableConnection(signal: RBXScriptSignal<...any>)
    for _, connection in ipairs(getconnections(signal)) do
        connection:Disable()
    end
    self.OnMessage:Fire(`Connections disabled for signal {signal}`)
end

-- Enables all connections of a given signal
function HookService:EnableConnections(signal: RBXScriptSignal<...any>)
    for _, connection in ipairs(getconnections(signal)) do
        connection:Enable()
    end
    self.OnMessage:Fire(`Connections enabled for signal '{signal}'`)
end

return HookService
