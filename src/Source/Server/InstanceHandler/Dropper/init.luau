local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataMap = require(script.DataMap)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)

local Dropper = {}
Dropper.__index = Dropper

function Dropper.new(owner: Player, instance: Instance)
    return setmetatable({
        _instance = instance,
        _trove = Trove.new(),
        _owner = owner,
        Attributes = DataMap[instance.Name],
    }, Dropper)
end

function Dropper:Connect()
    while task.wait(self.Attributes.Frequency) do
        local fruitObj = self.Attributes.Drop(self)
        fruitObj:SetAttribute("Owner", self._owner.Name)
        fruitObj:Setup()
    end
end

function Dropper:Destroy()
    self._trove:Destroy()
end -- Call when player leaves or something happens and we don't need this bad boy no more

return Dropper

