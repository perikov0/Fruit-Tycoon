local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataMap = require(script.DataMap)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local ProxyTable = require(ReplicatedStorage.Shared.Packages.ProxyTable)

local Dropper = {}
Dropper.__index = Dropper

local FruitsProxy = ProxyTable.new("Fruits")

function Dropper.new(instance: Instance)
    return setmetatable({
        _instance = instance,
        _trove = Trove.new(),
        Attributes = DataMap[instance.Name],
    }, Dropper)
end

function Dropper:DropFruit(GUID)
    local fruitObj = self.Attributes.Drop(GUID, self)
    fruitObj:Spawn()
    FruitsProxy:Set(fruitObj.GUID, fruitObj)
    return fruitObj
end

function Dropper:GetAttribute(name)
    return self.Attributes[name]
end

function Dropper:Destroy()
    self._trove:Destroy()
end

return Dropper

