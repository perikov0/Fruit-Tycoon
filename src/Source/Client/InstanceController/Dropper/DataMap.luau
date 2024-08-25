local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Fruits = ReplicatedStorage.Assets.Fruits
local Manipulator = require(ReplicatedStorage.Shared.Data.Manipulator)

local DataMap = {}

local FruitClass = {
    __add = function(self, value)
        self._value += value
        self:UpdateBillboard()
        return self
    end,
    __mul = function(self, value)
        self._value *= value
        self:UpdateBillboard()
        return self
    end
}
FruitClass.__index = FruitClass

do
    function FruitClass.new(properties)
        return setmetatable({
            _value = properties.BaseValue,
            ValueDisplay = ReplicatedStorage.Assets.ValueDisplay:Clone(),
            Fruit = Fruits[properties.FruitName]:Clone(),
            DropperObject = properties.DropperObject,
            GUID = properties.GUID,
            Active = true,
        }, FruitClass)
    end

    function FruitClass:UpdateBillboard()
        self.ValueDisplay.Holder.Cash.Text = "$"..self._value
    end 

    function FruitClass:SetAttribute(propertyName, propertyValue)
        self.Fruit:SetAttribute(propertyName, propertyValue)
        self:UpdateBillboard()
    end

    function FruitClass:Spawn()
        local spawner = self.DropperObject._instance.PrimaryPart
        local offset = -(Vector3.yAxis*(spawner.Size.Y/2 + self.Fruit.Size.Y/2 + 1))
        self.Fruit.Parent = workspace.Fruits
        self.Fruit.CFrame = (spawner.CFrame * CFrame.Angles(math.pi/2, 0, math.pi/2))+offset
        self.Fruit:AddTag("FRUIT")
        self.Fruit:SetAttribute("GUID", self.GUID)
    end

    function FruitClass:Process()
        if not self.Active then return end
        
        local originalCash = Manipulator.GetData(LocalPlayer.UserId, "Cash")
        Manipulator.SetData(LocalPlayer.UserId, "Cash", originalCash + self._value, true)
        self:Destroy()
    end

    function FruitClass:Destroy()
        self.Active = false
        task.delay(1, function()
            self.Fruit:Destroy()
        end)
    end
end

DataMap["APPLE DROPPER 1"] = {
    Drop = function(GUID, dropperObject)
        return FruitClass.new({
            FruitName = "Apple",
            GUID = GUID,
            DropperObject = dropperObject,
            BaseValue = 10
        })
    end,
    OnModify = function()

    end,
    OnProcess = function(fruitObj)
        print("Processed ;w;")
        fruitObj:Process()
    end
}

return table.freeze(DataMap)