local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CompletedModules = {}

for _, module in ReplicatedStorage.Source.Server:GetChildren() do
	if module:IsA("ModuleScript") then
		CompletedModules[module.Name] = require(module)
	end
end

local function Iterate(functionName, ...)
	for _, module in CompletedModules do
		if module[functionName] and typeof(module[functionName]) == "function" then
			task.spawn(module[functionName], ...)
		end
	end
end

Iterate("ServerInit")

local function PlayerInit(player: Player)
	Iterate("PlayerInit", player)

	if player.Character then
		Iterate("CharacterInit", player.Character)
	end

	player.CharacterAdded:Connect(function(Character)
		Iterate("CharacterInit", Character)
	end)
end

task.spawn(function()
	for _, player in Players:GetPlayers() do
		PlayerInit(player)
	end
end)

Players.PlayerAdded:Connect(PlayerInit)