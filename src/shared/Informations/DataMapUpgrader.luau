local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProxyTable = require(ReplicatedStorage.Shared.Packages.ProxyTable)

local GlobalProxy = ProxyTable.new("Global")

local DataMapUpgrader = {}

DataMapUpgrader["DIAMOND UPGRADER"] = {
	OnModify = function(fruitObj)
		print(GlobalProxy:Get())
		fruitObj *= if GlobalProxy:Get("DIAMOND UPGRADER EXTENDER") == true then 1.8 else 1.2
	end
}

return DataMapUpgrader