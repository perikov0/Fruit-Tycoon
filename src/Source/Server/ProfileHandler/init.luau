--!nocheck

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local ProfileHandler = {}
ProfileHandler.Connections = {}

local ProfileTemplate = require(ReplicatedStorage.Shared.Data.Template)
local ProfileService = require(script.ProfileService)
local DataManipulators = require(ReplicatedStorage.Shared.Data.Manipulator)

local DataKey = "TestData_02"

local ProfileStore = ProfileService.GetProfileStore(DataKey, ProfileTemplate)

local Profiles: {[Player]: {Data: typeof(ProfileTemplate)}} = {}

local function DeepCopyTable(t)
	local copy = {}
	for key, value in pairs(t) do
		if type(value) == "table" then
			copy[key] = DeepCopyTable(value)
		else
			copy[key] = value
		end
	end
	return copy
end

local initializedProfiles = {}
local function initProfile(player)
	if initializedProfiles[player] then return end
	initializedProfiles[player] = true

	local profile: typeof(Profiles[player]) = ProfileStore:LoadProfileAsync(tostring(player.UserId))
	if profile ~= nil then
		profile:AddUserId(player.UserId)
		profile:Reconcile()

		profile:ListenToRelease(function()
			Profiles[player] = nil
			initializedProfiles[player] = nil
			player:Kick()
		end)

		if player:IsDescendantOf(Players) == true then
			Profiles[player] = profile

			DataManipulators.Cache[player.UserId] = DeepCopyTable(profile.Data)

			local loginTimes = DataManipulators.GetData(player.UserId, "LogInTimes")
			DataManipulators.SetData(player.UserId, "LogInTimes", loginTimes+1, true)
			DataManipulators.SetData(player.UserId, "LastTimeJoined", tick(), true)

			player:SetAttribute("PROFILE_LOADED", true)

			DataManipulators:BindToDataUpdate(player.UserId, function(value, key, shouldSave)
				if not shouldSave then return end
				ProfileHandler.SaveToProfile(player, key, value)
			end)
		else
			profile:Release()
		end
	else
		player:Kick()
	end
end

function ProfileHandler.PlayerInit(player)
	initProfile(player)
end

function ProfileHandler.SaveToProfile(player: Player, key, value)
	local profile = Profiles[player]
	if not profile then return end

	profile.Data[key] = value
end

return ProfileHandler