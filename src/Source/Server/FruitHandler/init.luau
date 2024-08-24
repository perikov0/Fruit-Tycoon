local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local FruitHandler = {}

function FruitHandler.ServerInit()
    CollectionService:GetInstanceAddedSignal("FRUIT_TAG"):Connect(function(fruit)
        local owner = Players:FindFirstChild(fruit:GetAttribute("Owner"))
        if not owner then return end

        
    end)
end

return FruitHandler