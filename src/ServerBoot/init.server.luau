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

	local function CharacterInit(character)
		Iterate("CharacterInit", player.Character)
		character.Destroying:Once(function()
			Iterate("CharacterDestroyed", player.Character)
		end)
	end

	if player.Character then
		CharacterInit(player.Character)
	end

	player.CharacterAdded:Connect(function(Character)
		CharacterInit(Character)
	end)
end

local function PlayerLeave(player)
	Iterate("PlayerLeave", player)
end

task.spawn(function()
	for _, player in Players:GetPlayers() do
		PlayerInit(player)
	end
end)

Players.PlayerAdded:Connect(PlayerInit)
Players.PlayerRemoving:Connect(PlayerLeave)