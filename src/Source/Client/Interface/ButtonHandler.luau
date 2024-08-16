local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local ButtonHandler = {}

local Components = require(script.Parent.Components)
local ComponentTypes = require(script.Parent.Components.ComponentTypes)

local FrameFunctions = require(script.Parent.Components.Functions.Frame)

local function CreateButtonObject(...): ComponentTypes.ButtonComponent
    local object = Components.AddComponent("ButtonBase", ...)
    object:Init()
    return object
end

function ButtonHandler.CharacterInit(character)
    ButtonHandler.Character = character
end

function ButtonHandler.PlayerInit()
    local playerUI = LocalPlayer:WaitForChild("PlayerGui")
    local screenUI = playerUI:WaitForChild("ScreenGui")
    local buttons = screenUI:WaitForChild("LeftUI_test"):WaitForChild("Buttons")
    task.wait()

    CreateButtonObject(buttons:WaitForChild("Summon"), {
        ClickFn = function(self: ComponentTypes.ButtonComponent)
            if not ButtonHandler.Character then return end
            ButtonHandler.Character.PrimaryPart.CFrame = workspace:WaitForChild("SummonTeleportingPart").CFrame
        end
    })

    local Inventory = CreateButtonObject(buttons:WaitForChild("Inventory"), {
        ClickFn = function(self: ComponentTypes.ButtonComponent)
            if self.IsCooldown:get() == true then return end

            if self.FrameValues.FrameEnabled:get() == false then
                FrameFunctions.Open(self)
            else
                FrameFunctions.Close(self)
            end
        end
    })
    Inventory:LinkFrame(screenUI:WaitForChild("Items").Frame, screenUI:WaitForChild("Items").UIScale)

    CreateButtonObject(buttons:WaitForChild("Items"), {
        ClickFn = function(self: ComponentTypes.ButtonComponent)
            print("Items")
        end
    })

    CreateButtonObject(buttons:WaitForChild("Store"), {
        ClickFn = function(self: ComponentTypes.ButtonComponent)
            print("Store")
        end
    })

    CreateButtonObject(buttons:WaitForChild("Quests"), {
        ClickFn = function(self: ComponentTypes.ButtonComponent)
            print("Quests")
        end
    })

    CreateButtonObject(buttons:WaitForChild("Trade"), {
        ClickFn = function(self: ComponentTypes.ButtonComponent)
            print("Trade")
        end
    })
end

return ButtonHandler