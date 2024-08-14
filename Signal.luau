--!strict
--!native
--!optimize 2
--// Paficent \\-

--// Types
type SignalConnection = {
    Disconnect: () -> ()
}

--// Module Declaration
local Signal = {}
Signal.__index = Signal

--// Constructor
function Signal.new()
    return setmetatable({
        _connections = {} :: {(...any) -> ()},
    }, Signal)
end


-- Connects a callback function to the signal
function Signal:Connect(callback: (...any) -> ()): SignalConnection
    table.insert(self._connections, callback)

    local connection = {
        Disconnect = function()
            for i, conn in ipairs(self._connections) do
                if conn == callback then
                    table.remove(self._connections, i)
                    break
                end
            end
        end
    }

    return connection :: SignalConnection
end

-- Fires the signal, calling all connected callbacks with the provided arguments
function Signal:Fire(...: any)
    for _, callback in ipairs(self._connections) do
        callback(...)
    end
end

return Signal
