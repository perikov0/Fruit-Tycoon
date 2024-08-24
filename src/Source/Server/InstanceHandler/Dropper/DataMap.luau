local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Fruits = ReplicatedStorage.Assets.Fruits
local Manipulator = require(ReplicatedStorage.Shared.Data.Manipulator)

local DataMap = {}

local FruitClass = {}
FruitClass.__index = FruitClass

do
    function FruitClass.new(fruitName)
        return setmetatable({
            _valueDisplay = ReplicatedStorage.Assets.ValueDisplay:Clone(),
            fruit = Fruits[fruitName]:Clone(),
        }, FruitClass)
    end

    function FruitClass:UpdateBillboard()
        self._valueDisplay.Holder.Cash.Text = "$"..self.fruit:GetAttribute("Value")
    end 

    function FruitClass:SetAttribute(propertyName, propertyValue)
        self.fruit:SetAttribute(propertyName, propertyValue)
        self:UpdateBillboard()
    end -- Acts as a setter

    function FruitClass:Process()
        local owner: Player = Players:FindFirstChild(self.fruit:GetAttribute("Owner"))
        if not owner then return end

        local originalCash = Manipulator.GetData(owner.UserId, "Cash")
        Manipulator.SetData(owner.UserId, "Cash", originalCash+self.fruit:GetAttribute("Value"), true)
    end -- Calls when ore is processed in furnace.
end

DataMap["APPLE DROPPER 1"] = {
    Drop = function()
        local fruitObj = FruitClass.new("Apple")
        fruitObj:SetAttribute("Value", 10)
        
        return fruitObj
    end,
    OnModify = function()

    end,
    Frequency = 4,
}

return table.freeze(DataMap)