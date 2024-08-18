local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Manipulator = {Cache = {}}

local ServerModules = {}; task.defer(function()
	if RunService:IsClient() then return end
	ServerModules.Handler = require(ReplicatedStorage.Source.Server.ProfileHandler)
	ServerModules.TycoonClaimHandler = require(ReplicatedStorage.Source.Server.TycoonClaimHandler)
end)--// Can ignore LSP errors. It doesn't break when required on another thread.

local RequestRemoteFn = ReplicatedStorage.Remotes.RequestRemoteFn

function Manipulator.GetData(playerId, key)
	if RunService:IsClient() then 
		return RequestRemoteFn:InvokeServer(playerId, key)
	end

	if not Manipulator.Cache[playerId] then return end
	return Manipulator.Cache[playerId][key]
end

function Manipulator.SetData(playerId, key, value, shouldSave)
	local data = Manipulator.Cache[playerId]
	if not data then return end
	data[key] = value
	
	if table.find({"Cash", "Rebirths", "Gems"}, key) and RunService:IsServer() then
		ServerModules.TycoonClaimHandler.UpdateStats(Players:GetPlayerByUserId(playerId))
	end

	local player = Players:GetPlayerByUserId(playerId)

	if shouldSave and RunService:IsServer() then
		ServerModules.Handler.SaveToProfile(player, key, value)
	end

	return data[key]
end

if RunService:IsServer() then
	RequestRemoteFn.OnServerInvoke = function(_, userId: Player, key)
		return Manipulator.GetData(userId, key)
	end
end

return Manipulator