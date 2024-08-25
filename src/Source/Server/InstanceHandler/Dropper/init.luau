local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataMap = require(script.DataMap)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local ProxyTable = require(ReplicatedStorage.Shared.Packages.ProxyTable)

local FruitsProxy = ProxyTable.new("Fruits")

local Dropper = {}
Dropper.__index = Dropper

function Dropper.new(owner: Player, instance: Instance)
    return setmetatable({
        _instance = instance,
        _trove = Trove.new(),
        _owner = owner,
        Attributes = DataMap[instance.Name],
        Objects = {},
        UpgradesRanThru = {},
        Active = true,
    }, Dropper)
end

function Dropper:Connect()
    repeat
        local fruitObj = self.Attributes.Drop(self)
        fruitObj.DropperInstance = self._instance
        self.Objects[fruitObj.GUID] = fruitObj
        FruitsProxy:Set(fruitObj.GUID, fruitObj)
        ReplicatedStorage.Remotes.DropFruit:FireClient(self._owner, fruitObj.DropperInstance.Name, fruitObj.GUID)
        task.wait(self.Attributes.Frequency)
    until not self.Active
end

function Dropper:GetAttribute(name)
    return self.Attributes[name]
end

function Dropper:Destroy()
    self._trove:Destroy()
    self.Active = false
end

return Dropper