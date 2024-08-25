local DataMapUpgrader = {}

DataMapUpgrader["UPGRADE 1"] = {
	OnModify = function(fruitObj)
		fruitObj *= 1.2
		fruitObj += 2
	end
}

DataMapUpgrader["UPGRADE 2"] = {
	OnModify = function(fruitObj)
		fruitObj *= 1.2
		fruitObj += 2
	end
}

return DataMapUpgrader