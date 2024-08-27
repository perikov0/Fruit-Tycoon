local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProxyTable = require(ReplicatedStorage.Shared.Packages.ProxyTable)

local GlobalProxy = ProxyTable.new("Global")

local PurchaseCallbacks = {}

PurchaseCallbacks["DIAMOND UPGRADER EXTENDER"] = function(buttonObj)
	GlobalProxy:Set("DIAMOND UPGRADER EXTENDER", true)

	local DiamondUpgrader = buttonObj.ButtonInstance.UpgradeToExtend.Value
	DiamondUpgrader:WaitForChild("DisplayPart"):WaitForChild("ValueDisplay"):WaitForChild("Value").Text = "1.8x"
end

return PurchaseCallbacks