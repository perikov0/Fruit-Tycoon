local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local CompletedModules = {}

for _, module in ReplicatedStorage.Source.Client:GetChildren() do
	if module:IsA("ModuleScript") then
		CompletedModules[module.Name] = require(module)
	end
end

for _, module in ReplicatedStorage.Source.Client.Interface:GetChildren() do
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

local function CharacterInit(character)
	Iterate("CharacterInit", character)
end

Iterate("PlayerInit")
if LocalPlayer.Character then
	CharacterInit(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(CharacterInit)