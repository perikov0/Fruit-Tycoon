local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local Manipulators = require(ReplicatedStorage.Shared.Data.Manipulator)

local ValueDisplayer = {}

function ValueDisplayer.PlayerInit()
    local playerUI = LocalPlayer:WaitForChild("PlayerGui")
	local statDisplayed = playerUI:WaitForChild("StatDisplayed")
    task.wait(2)

	local function upd()
		local fetchedData = Manipulators.GetData(LocalPlayer.UserId)
		statDisplayed.Cash.Text = "Cash: "..math.round(fetchedData.Cash)
		statDisplayed.Gems.Text = "Gems: "..math.round(fetchedData.Gems)
		statDisplayed.Rebirths.Text = "Rebirths: "..math.round(fetchedData.Rebirths)
	end

	upd()
	ReplicatedStorage.Remotes.UpdateDisplayValues.OnClientEvent:Connect(upd)
end

return ValueDisplayer