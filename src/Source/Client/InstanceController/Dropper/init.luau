local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataMap = require(ReplicatedStorage.Shared.Informations.DataMapDropper)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)

local Dropper = {}
Dropper.__index = Dropper

function Dropper.new(instance: Instance)
    return setmetatable({
        _instance = instance,
        _trove = Trove.new(),
        Attributes = DataMap[instance.Name].Client,
    }, Dropper)
end

function Dropper:DropFruit(GUID)
    local fruitObj = self.Attributes.Drop(GUID, self)
    fruitObj:Spawn()
    return fruitObj
end

function Dropper:GetInstance()
    return self._instance
end

function Dropper:GetAttribute(name)
    return self.Attributes[name]
end

function Dropper:Destroy()
    self._trove:Destroy()
end

return Dropper

