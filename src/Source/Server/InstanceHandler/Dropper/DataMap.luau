local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local Manipulator = require(ReplicatedStorage.Shared.Data.Manipulator)

local DataMap = {}

local FruitClass = {
    __add = function(self, value)
        self._value += value
        return self
    end,
    __mul = function(self, value)
        self._value *= value
        return self
    end
}
FruitClass.__index = FruitClass

do
    function FruitClass.new(properties)
        return setmetatable({
            _value = properties.BaseValue,
            DropperObject = properties.DropperObject,
            GUID = properties.GUID,
            Active = true
        }, FruitClass)
    end

    function FruitClass:Process()
        if not self.Active then return end
        local owner: Player = self.DropperObject._owner
        if not owner then return end
        
        local originalCash = Manipulator.GetData(owner.UserId, "Cash")
        Manipulator.SetData(owner.UserId, "Cash", originalCash + self._value, true)
        self:Destroy()
    end

    function FruitClass:Destroy()
        self._value = 0
        self.Active = false
    end
end

DataMap["APPLE DROPPER 1"] = {
    Drop = function(dropperObject)
        return FruitClass.new({
            FruitName = "Apple",
            GUID = HttpService:GenerateGUID(),
            DropperObject = dropperObject,
            BaseValue = 10
        })
    end,
    OnModify = function()

    end,
    OnProcess = function(fruitObj)
        fruitObj:Process()
    end,
    Frequency = 4,
}

return table.freeze(DataMap)