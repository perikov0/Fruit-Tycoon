local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataMap = require(script.DataMap)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)

local Upgrader = {}
Upgrader.__index = Upgrader

function Upgrader.new(owner: Player, instance: Instance)
    return setmetatable({
        _instance = instance,
        _trove = Trove.new(),
        _owner = owner,
        Data = DataMap[instance.Name],
    }, Upgrader)
end

function Upgrader:Connect()
    print("Connected Upgrader")
    self._trove:Connect(self._instance.PrimaryPart.Touched, function(hit: Instance)
        if not hit:HasTag("FRUIT_TAG") then return end
        print(hit:GetFullName())
    end)
end

function Upgrader:Destroy()
    self._trove:Destroy()
end -- Call when player leaves or something happens and we don't need this bad boy no more

return Upgrader

