local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Class = require(script.Class)

local Buttons = {}

function Buttons.PlayerInit()
    repeat task.wait() until LocalPlayer:GetAttribute("TYCOON_SLOT")
    task.wait(0.5)
    local sortedButtons = {}

    for _, button in workspace.Tycoons[LocalPlayer:GetAttribute("TYCOON_SLOT")].Buttons:GetChildren() do
        local order = button:GetAttribute("Order")
        sortedButtons[order] = sortedButtons[order] or {}
        table.insert(sortedButtons[order], button)
    end

    for _, buttonGroup in sortedButtons do
        for _, button in buttonGroup do
            local buttonObj = Class.new(button)
            buttonObj:UpdateAppearance()
        end
    end
end

return Buttons
