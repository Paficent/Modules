--!strict
local Case = {}

function checkStatement(Statement: boolean): boolean
	if Statement == true then -- If the boolean is true return true
		return true
	end
	
	return false -- Otherwise return false
end

-- Returns the index of the first case that is true
function Case.Test(Cases: {boolean}): number -- Cases is treated as an array where boolean's is the only type allowed, this is because anything in a if statement will get interpreted to be true or false
	for index, Statement in next, Cases do -- Loops through all the cases in the table
		if checkStatement(Statement) then -- If the boolean statement is true, then return the index
			return index
		end
	end
	return -1
end


-- Finds the first instance of case which is true and calls the CallbackFunction with the "Args" that are present, returning whatever the function returns
function Case.Check(Cases: {[number]: {Statement: boolean, CallbackFunction: any, Args: {any} | nil}}): any
	for index, Data in next, Cases do -- Loops through all the Cases in the table
		if checkStatement(Data["Statement"]) then -- If the boolean statement is true, check to see if it has a callbackfunction, if it does, it will call and return it
			local CallbackFunction = Data["CallbackFunction"]
			local Args = Data["Args"]
			if typeof(CallbackFunction) == "function" then
				if Args then
					return CallbackFunction(table.unpack(Args))
				end
				return CallbackFunction()
			else
				return nil
			end
		end
	end
	return nil
end

return Case
