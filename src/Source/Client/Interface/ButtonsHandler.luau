local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Buttons = {}

local Components = require(script.Parent.Components)
local ComponentTypes = require(script.Parent.Components.ComponentTypes)

local FrameFunctions = require(script.Parent.Components.Functions.Frame)

local function CreateButtonObject(...): ComponentTypes.ButtonComponent
    local object = Components.AddComponent("ButtonBase", ...)
    object:Init()
    return object
end

function Buttons.CharacterInit(character)
    Buttons.Character = character
end

function Buttons.PlayerInit()
    local playerUI = LocalPlayer:WaitForChild("PlayerGui")
    task.wait()
end

return Buttons