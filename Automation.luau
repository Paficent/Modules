--!strict
--!native
--!optimize 2
--// Paficent \\-

--// Types
type Button = TextButton | ImageButton

--// Module Declaration
local GUI = {}
GUI.__index = GUI

-- Fills a TextBox with the provided text
function GUI.FillTextBox(TextBox: TextBox, Text: string)
    TextBox.Text = tostring(Text)
end

-- Types out text into a TextBox with an optional delay between each character
function GUI.TypeTextBox(TextBox: TextBox, Text: string, Delay: number?, RemoveOldText: boolean?)
    Delay = Delay or 0.05
    RemoveOldText = RemoveOldText == nil and true or RemoveOldText

    if RemoveOldText then
        TextBox.Text = ""
    end

    for i = 1, #Text do
        task.wait(Delay)
        TextBox.Text = TextBox.Text .. string.sub(Text, i, i)
    end
end

-- Simulates a left-click on a Button by firing the appropriate events
function GUI.LeftClickButton(Button: Button)
    local _Activated = getconnections(Button.Activated)
    local _MB1Down = getconnections(Button.MouseButton1Down)
    local _MB1Up = getconnections(Button.MouseButton1Up)
    local _MB1Click = getconnections(Button.MouseButton1Click)

    if #_Activated >= 1 then
        local success, msg = pcall(function()
            _Activated[1]:Fire()
        end)
        assert(success, msg)
    elseif #_MB1Down >= 1 then
        local success, msg = pcall(function()
            _MB1Down[1]:Fire()
        end)
        assert(success, msg)
    elseif #_MB1Up >= 1 then
        local success, msg = pcall(function()
            _MB1Up[1]:Fire()
        end)
        assert(success, msg)
    elseif #_MB1Click >= 1 then
        local success, msg = pcall(function()
            _MB1Click[1]:Fire()
        end)
        assert(success, msg)
    end
end

-- Simulates a right-click on a Button by firing the appropriate events
function GUI.RightClickButton(Button: Button)
    local _Activated = getconnections(Button.Activated)
    local _MB2Down = getconnections(Button.MouseButton2Down)
    local _MB2Up = getconnections(Button.MouseButton2Up)
    local _MB2Click = getconnections(Button.MouseButton2Click)

    if #_Activated >= 1 then
        local success, msg = pcall(function()
            _Activated[1]:Fire()
        end)
        assert(success, msg)
    elseif #_MB2Down >= 1 then
        local success, msg = pcall(function()
            _MB2Down[1]:Fire()
        end)
        assert(success, msg)
    elseif #_MB2Up >= 1 then
        local success, msg = pcall(function()
            _MB2Up[1]:Fire()
        end)
        assert(success, msg)
    elseif #_MB2Click >= 1 then
        local success, msg = pcall(function()
            _MB2Click[1]:Fire()
        end)
        assert(success, msg)
    end
end

return GUI
