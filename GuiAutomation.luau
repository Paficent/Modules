--!strict
--!native
--!optimize 2
--// Paficent \\-

--// Types
type Button = TextButton | ImageButton

--// Module Declaration
local Automation = {}
Automation.__index = Automation

--// Locals
local function HandleButtonClick(Button: Button, MouseButton: string)
    local connectionTypes = {"Activated", "Down", "Up", "Click"}
    local connections = {Activated = getconnections(Button.Activated)}

    for _, connectionType in ipairs(connectionTypes) do
        local connection = connections[connectionType] or getconnections(Button[MouseButton .. connectionType])
        if #connections[connectionType] >= 1 then
            local success, msg = pcall(function() connections[connectionType][1]:Fire() end)
            if not success then error(msg) end
        end
    end
end

--// Methods
function Automation.FillTextBox(TextBox: TextBox, Text: string)
    TextBox.Text = tostring(Text)
end

-- Types out text into a TextBox with an optional delay between each character
function Automation.TypeTextBox(TextBox: TextBox, Text: string, Delay: number?, RemoveOldText: boolean?)
    Delay = Delay or 0.05

    if RemoveOldText == nil and true or RemoveOldText then
        TextBox.Text = ""
    end

    for i = 1, #Text do
        task.wait(Delay)
        TextBox.Text = TextBox.Text .. string.sub(Text, i, i)
    end
end

-- Simulates a left-click on a Button
function Automation.LeftClickButton(Button: Button)
    HandleButtonClick(Button, "MouseButton1")
end

-- Simulates a right-click on a Button
function Automation.RightClickButton(Button: Button)
    HandleButtonClick(Button, "MouseButton2")
end

return Automation
