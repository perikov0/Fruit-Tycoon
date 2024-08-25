local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

local Conveyors = {}

local DEFAULT_SPEED = 10

function Conveyors.ServerInit()
    for _, conveyor in CollectionService:GetTagged("CONVEYOR") do
        RunService.PostSimulation:Connect(function()
            conveyor.Velocity = conveyor.CFrame.LookVector*(conveyor:GetAttribute("Speed") or DEFAULT_SPEED)
        end)
    end
end

return Conveyors
