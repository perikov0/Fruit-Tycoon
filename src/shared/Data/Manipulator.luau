local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Manipulator = {Cache = {}}
Manipulator.Binds = {}

local RequestRemoteFn = ReplicatedStorage.Remotes.RequestRemoteFn

function Manipulator.GetData(playerId, key)
	if RunService:IsClient() then 
		return RequestRemoteFn:InvokeServer(playerId, key)
	end

	if not Manipulator.Cache[playerId] then return end
	return key and Manipulator.Cache[playerId][key] or Manipulator.Cache[playerId]
end

function Manipulator.SetData(playerId, key, value, ...)
	local data = Manipulator.Cache[playerId]
	if not data then return end
	data[key] = value
	
	for _, fn in (Manipulator.Binds[playerId] or {}) do
		fn(value, key, ...)
	end

	return data[key]
end

function Manipulator:BindToDataUpdate(playerId, fn)
	Manipulator.Binds[playerId] = Manipulator.Binds[playerId] or {}
	return table.insert(Manipulator.Binds[playerId], fn)
end

function Manipulator:UnbindFromDataUpdate(playerId, index)
	table.remove(Manipulator.Binds[playerId], index)
end

if RunService:IsServer() then
	RequestRemoteFn.OnServerInvoke = function(_, userId: Player, key)
		return Manipulator.GetData(userId, key)
	end
end

return Manipulator