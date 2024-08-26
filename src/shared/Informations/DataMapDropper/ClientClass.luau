local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Fruits = ReplicatedStorage.Assets.Fruits

local Manipulator = require(ReplicatedStorage.Shared.Data.Manipulator)
local ProxyTable = require(ReplicatedStorage.Shared.Packages.ProxyTable)

local FruitsProxy = ProxyTable.new("Fruits")

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

function FruitClass.new(properties)
	local fruit = Fruits[properties.FruitName]:Clone()
	fruit.Parent = Instance.new("Model")
	fruit.Parent:ScaleTo(math.max(properties.Scale or 1, 0.01))
	fruit.Parent = nil
	fruit.CollisionGroup = "Fruit"

	return setmetatable({
		_value = properties.BaseValue,
		ValueDisplay = ReplicatedStorage.Assets.ValueDisplay:Clone(),
		DropperObject = properties.DropperObject,
		GUID = properties.GUID,
		Fruit = fruit,
		Active = true,
	}, FruitClass)
end

function FruitClass:UpdateBillboard()
	self.ValueDisplay.Cash.Text = "$"..(self._value - self._value%0.01) -- Trunctate
end 

function FruitClass:SetAttribute(propertyName, propertyValue)
	self.Fruit:SetAttribute(propertyName, propertyValue)
	self:UpdateBillboard()
end

function FruitClass:Spawn()
	FruitsProxy:Set(self.GUID, self)
	local spawner = self.DropperObject._instance.PrimaryPart
	local offset = -(Vector3.yAxis*(spawner.Size.Y/2 + self.Fruit.Size.Y/2 + 1))
	self.Fruit.Parent = workspace.Fruits
	self.Fruit.CFrame = (spawner.CFrame * CFrame.Angles(math.pi/2, 0, math.pi/2))+offset
	self.Fruit:AddTag("FRUIT")
	self.Fruit:SetAttribute("GUID", self.GUID)
	self.ValueDisplay.Parent = self.Fruit
	self.ValueDisplay.Adornee = self.Fruit
	self:UpdateBillboard()
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

return FruitClass