local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Manipulator = require(ReplicatedStorage.Shared.Data.Manipulator)

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
	local upgraderDict = {}
	for _, upgradeName in properties.UpgradesAvailable do
		upgraderDict[upgradeName] = false
	end -- Convert array to dict
	
	return setmetatable({
		_value = properties.BaseValue,
		DropperObject = properties.DropperObject,
		GUID = properties.GUID,
		Upgraders = upgraderDict,
		Active = true,
		Metadata = properties.Metadata,
	}, FruitClass)
end

function FruitClass:Process()
	if not self.Active then return end
	local owner: Player = self.DropperObject._owner
	if not owner then return end
	if self.Metadata.IsGem == true then
		local originalValue = Manipulator.GetData(owner.UserId, "Gems")
		Manipulator.SetData(owner.UserId, "Gems", originalValue + self._value, true)
	else
		local originalValue = Manipulator.GetData(owner.UserId, "Cash")
		Manipulator.SetData(owner.UserId, "Cash", originalValue + self._value, true)
	end
	self:Destroy()
end

function FruitClass:Modify(upgradeName)
	if self.Upgraders[upgradeName] == true then return false end -- `self.Upgraders[upgradeName]` has 3 states, treat true seperately 
	self.Upgraders[upgradeName] = true
	return self.Upgraders[upgradeName]
end

function FruitClass:Destroy()
	self._value = 0
	self.Active = false
end

return FruitClass