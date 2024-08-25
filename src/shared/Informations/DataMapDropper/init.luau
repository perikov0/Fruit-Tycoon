local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local Class = if RunService:IsClient() then require(script.ClientClass) else require(script.ServerClass)

local DataMap = {}

local function Construct(...)
	return Class.new(...)
end

do
	local BaseValue = 1
	local Frequency = 4
	DataMap["APPLE DROPPER 1"] = {
		Client = {
			Drop = function(GUID, dropperObject)
				return Construct {
					FruitName = "Apple",
					Scale = 1,
					GUID = GUID,
					DropperObject = dropperObject,
					BaseValue = BaseValue
				}
			end,
			OnModify = function()
		
			end,
			OnProcess = function(fruitObj)
				fruitObj:Process()
			end,
			Frequency = Frequency
		},
		Server = {
			Drop = function(dropperObject)
				return Construct {
					FruitName = "Apple",
					GUID = HttpService:GenerateGUID(),
					DropperObject = dropperObject,
					BaseValue = BaseValue
				}
			end,
			CanModify = function(fruitObj, upgradeName)
				return fruitObj:Modify(upgradeName)
			end,
			OnProcess = function(fruitObj)
				fruitObj:Process()
			end,
			Frequency = Frequency
		},
	}
end

do
	local BaseValue = 2
	local Frequency = 4
	DataMap["APPLE DROPPER 2"] = {
		Client = {
			Drop = function(GUID, dropperObject)
				return Construct {
					FruitName = "Apple",
					Scale = 1.1,
					GUID = GUID,
					DropperObject = dropperObject,
					BaseValue = BaseValue
				}
			end,
			OnModify = function()
		
			end,
			OnProcess = function(fruitObj)
				fruitObj:Process()
			end,
			Frequency = Frequency
		},
		Server = {
			Drop = function(dropperObject)
				return Construct {
					FruitName = "Apple",
					GUID = HttpService:GenerateGUID(),
					DropperObject = dropperObject,
					BaseValue = BaseValue
				}
			end,
			CanModify = function(fruitObj, upgradeName)
				return fruitObj:Modify(upgradeName)
			end,
			OnProcess = function(fruitObj)
				fruitObj:Process()
			end,
			Frequency = Frequency
		},
	}
end

do
	local BaseValue = 5
	local Frequency = 4
	DataMap["APPLE DROPPER 3"] = {
		Client = {
			Drop = function(GUID, dropperObject)
				return Construct {
					FruitName = "Apple",
					Scale = 1.5,
					GUID = GUID,
					DropperObject = dropperObject,
					BaseValue = BaseValue
				}
			end,
			OnModify = function()
		
			end,
			OnProcess = function(fruitObj)
				fruitObj:Process()
			end,
			Frequency = Frequency
		},
		Server = {
			Drop = function(dropperObject)
				return Construct {
					FruitName = "Apple",
					GUID = HttpService:GenerateGUID(),
					DropperObject = dropperObject,
					BaseValue = BaseValue
				}
			end,
			CanModify = function(fruitObj, upgradeName)
				return fruitObj:Modify(upgradeName)
			end,
			OnProcess = function(fruitObj)
				fruitObj:Process()
			end,
			Frequency = Frequency
		},
	}
end

return table.freeze(DataMap)