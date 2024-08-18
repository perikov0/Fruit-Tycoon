local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

local SPEED = 10

local Conveyors = {}

function Conveyors.ServerInit()
    for _, conveyor in CollectionService:GetTagged("CONVEYOR") do
        RunService.PostSimulation:Connect(function()
            conveyor.Velocity = conveyor.CFrame.LookVector*SPEED
        end)
    end
end

return Conveyors
