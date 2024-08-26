local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local Class = if RunService:IsClient() then require(script.ClientClass) else require(script.ServerClass)

local DataMap = {}

local function Construct(...)
	return Class.new(...)
end

local function fetchConstructParams(...)
	local params = {...}

	if RunService:IsClient() then
		return {
			FruitName = params[1],
			Scale = params[2],
			GUID = params[3],
			DropperObject = params[4],
			BaseValue = params[5],
		}
	end

	return {
		FruitName = params[1],
		GUID = params[2],
		DropperObject = params[3],
		BaseValue = params[4]
	}
end

local function newguid()
	return HttpService:GenerateGUID()
end

do
	local BaseValue = 1
	local Frequency = 4
	local FruitName = "Apple"
	DataMap["APPLE DROPPER 1"] = {
		Client = {
			Drop = function(GUID, dropperObject)
				local params = fetchConstructParams(FruitName,1,GUID,dropperObject,BaseValue)
				return Construct(params)
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
				local params = fetchConstructParams(FruitName,newguid(),dropperObject,BaseValue)
				return Construct(params)
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
	local FruitName = "Apple"
	DataMap["APPLE DROPPER 2"] = {
		Client = {
			Drop = function(GUID, dropperObject)
				local params = fetchConstructParams(FruitName,1.2,GUID,dropperObject,BaseValue)
				return Construct(params)
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
				local params = fetchConstructParams(FruitName,newguid(),dropperObject,BaseValue)
				return Construct(params)
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
	local FruitName = "Apple"
	DataMap["APPLE DROPPER 3"] = {
		Client = {
			Drop = function(GUID, dropperObject)
				local params = fetchConstructParams(FruitName,1.3,GUID,dropperObject,BaseValue)
				return Construct(params)
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
				local params = fetchConstructParams(FruitName,newguid(),dropperObject,BaseValue)
				return Construct(params)
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
	local BaseValue = 1
	local Frequency = 4
	local FruitName = "DiamondApple"
	DataMap["DIAMOND APPLE DROPPER 1"] = {
		Client = {
			Drop = function(GUID, dropperObject)
				local params = fetchConstructParams(FruitName,1,GUID,dropperObject,BaseValue)
				return Construct(params)
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
				local params = fetchConstructParams(FruitName,newguid(),dropperObject,BaseValue)
				return Construct(params)
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
	local FruitName = "DiamondApple"
	DataMap["DIAMOND APPLE DROPPER 2"] = {
		Client = {
			Drop = function(GUID, dropperObject)
				local params = fetchConstructParams(FruitName,1.2,GUID,dropperObject,BaseValue)
				return Construct(params)
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
				local params = fetchConstructParams(FruitName,newguid(),dropperObject,BaseValue)
				return Construct(params)
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
	local FruitName = "DiamondApple"
	DataMap["DIAMOND APPLE DROPPER 3"] = {
		Client = {
			Drop = function(GUID, dropperObject)
				local params = fetchConstructParams(FruitName,1.3,GUID,dropperObject,BaseValue)
				return Construct(params)
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
				local params = fetchConstructParams(FruitName,newguid(),dropperObject,BaseValue)
				return Construct(params)
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