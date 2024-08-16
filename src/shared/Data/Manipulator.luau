local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Manipulator = {Cache = {}}

local Handler; task.defer(function()
	if RunService:IsClient() then return end
	Handler = require(ReplicatedStorage.Source.Server.ProfileHandler) --// Can ignore LSP error. It doesn't break when required on another thread.
end)

local RequestRemoteFn = Instance.new("RemoteFunction")

function Manipulator.GetData(playerId, key)
	if RunService:IsClient() then 
		return RequestRemoteFn:InvokeServer(playerId)
	end

	if not Manipulator.Cache[playerId] then return end
	return Manipulator.Cache[playerId][key]
end

function Manipulator.SetData(playerId, key, value, shouldSave)
	local data = Manipulator.Cache[playerId]
	if not data then return end
	data[key] = value

	local player = Players:GetPlayerByUserId(playerId)

	if shouldSave and RunService:IsServer() then
		Handler.SaveToProfile(player, key, value)
	end

	return data[key]
end

RequestRemoteFn.OnServerInvoke = function(_, player: Player, key)
	return Manipulator.GetData(player.UserId, key)
end

return Manipulator
