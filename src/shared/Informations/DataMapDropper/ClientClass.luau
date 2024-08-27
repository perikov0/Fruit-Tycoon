local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Fruits = ReplicatedStorage.Assets.Fruits

local Manipulator = require(ReplicatedStorage.Shared.Data.Manipulator)
local ProxyTable = require(ReplicatedStorage.Shared.Packages.ProxyTable)

local FruitsProxy = ProxyTable.new("Fruits")

local AnimationStyles = {}
for _, style in script.Parent.AnimationStyles:GetChildren() do
	AnimationStyles[style.Name] = require(style)
end

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

	local AnimationStyle = properties.DropperObject:GetInstance():GetAttribute("OnDropAnimationType")
	if AnimationStyle and AnimationStyles[AnimationStyle] then
		AnimationStyles[AnimationStyle].OnDrop(properties.DropperObject)
		task.wait(AnimationStyles[AnimationStyle].Yield)
	end
	
	return setmetatable({
		_value = properties.BaseValue,
		ValueDisplay = ReplicatedStorage.Assets.ValueDisplay:Clone(),
		DropperObject = properties.DropperObject,
		GUID = properties.GUID,
		Fruit = fruit,
		Active = true,
		Metadata = properties.Metadata,
	}, FruitClass)
end

function FruitClass:UpdateBillboard()
	local tValue = (self._value - self._value%0.01)
	if self.Metadata.IsGem == true then
		self.ValueDisplay.Cash.Text = "[G$] "..tValue -- Trunctate
		self.ValueDisplay.Cash.TextColor3 = Color3.fromRGB(166, 131, 255)
	else
		self.ValueDisplay.Cash.Text = "$"..tValue -- Trunctate
	end
end 

function FruitClass:SetAttribute(propertyName, propertyValue)
	self.Fruit:SetAttribute(propertyName, propertyValue)
	self:UpdateBillboard()
end

function FruitClass:Spawn()
	FruitsProxy:Set(self.GUID, self)
	local spawner = self.DropperObject:GetInstance().PrimaryPart
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