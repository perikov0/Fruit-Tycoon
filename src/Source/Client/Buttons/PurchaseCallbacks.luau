local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ProxyTable = require(ReplicatedStorage.Shared.Packages.ProxyTable)
local FruitsProxy = ProxyTable.new("Fruits")

local PurchaseCallbacks = {}

PurchaseCallbacks["CONVEYOR 1"] = function(buttonObject)
	local unlock = buttonObject.ButtonInstance.Unlock.Value
	unlock.Sell.Touched:Connect(function(hit)
        if not hit:HasTag("FRUIT") then return end
		local GUID = hit:GetAttribute("GUID")
		local fruitObj = FruitsProxy:Get(GUID)
		fruitObj.DropperObject:GetAttribute("OnProcess")(fruitObj)
		ReplicatedStorage.Remotes.ProcessFruit:FireServer(GUID)
	end)
end

return PurchaseCallbacks