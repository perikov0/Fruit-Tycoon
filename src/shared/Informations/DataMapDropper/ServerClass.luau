local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Manipulator = require(ReplicatedStorage.Shared.Data.Manipulator)
local ProxyTable = require(ReplicatedStorage.Shared.Packages.ProxyTable)

local FruitsProxy = ProxyTable.new("Fruits")

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

function FruitClass.new(properties)
	return setmetatable({
		_value = properties.BaseValue,
		DropperObject = properties.DropperObject,
		GUID = properties.GUID,
		Upgraders = {},
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

function FruitClass:Modify(upgradeName)
	print(upgradeName)
	if self.Upgraders[upgradeName] then return false end
	self.Upgraders[upgradeName] = true
	return self.Upgraders[upgradeName]
end

function FruitClass:Destroy()
	self._value = 0
	self.Active = false
end

return FruitClass