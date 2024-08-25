local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataMap = require(ReplicatedStorage.Shared.Informations.DataMapUpgrader)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local ProxyTable = require(ReplicatedStorage.Shared.Packages.ProxyTable)

local FruitsProxy = ProxyTable.new("Fruits")

local Upgrader = {}
Upgrader.__index = Upgrader

function Upgrader.new(instance: Instance)
    return setmetatable({
        _instance = instance,
        _trove = Trove.new(),
        Attributes = DataMap[instance.Name],
    }, Upgrader)
end

function Upgrader:Connect()
    self._trove:Connect(self._instance.PrimaryPart.Touched, function(hit: Instance)
        if not hit:HasTag("FRUIT") then return end
        local fruitObj = FruitsProxy:Get(hit:GetAttribute("GUID"))
        fruitObj.DropperObject:GetAttribute("OnModify")(fruitObj)
        self.Attributes.OnModify(fruitObj)
        ReplicatedStorage.Remotes.UpgradeFruit:FireServer(self._instance.Name, fruitObj.GUID)
    end)
end

function Upgrader:Destroy()
    self._trove:Destroy()
end

return Upgrader