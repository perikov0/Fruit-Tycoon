local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local DataManipulator = require(ReplicatedStorage.Shared.Data.Manipulator)

local TycoonClaimHandler = {}
TycoonClaimHandler.Callbacks = {}
TycoonClaimHandler.Tycoons = {} :: {
    {
        Owned: Player,
        TimeLastOwned: number,
    }
}

local function FindFirstOpenTycoon()
    local firstOpenIndex = nil
    for index, tycoon in TycoonClaimHandler.Tycoons do
        if tycoon.Owned then continue end
        firstOpenIndex = index
    end
    return firstOpenIndex
end

local function CharacterInit(character)
    if not character then return end

    local player = Players:GetPlayerFromCharacter(character)
    local tycoon = workspace.Tycoons[player:GetAttribute("TYCOON_SLOT")]
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = tycoon.Spawn.SpawnLocation.CFrame*CFrame.new(0,5,0)
end

function TycoonClaimHandler.UpdateStats(player)
    local tycoonSlot = player:GetAttribute("TYCOON_SLOT")
    local tycoonStats = workspace.Tycoons[tostring(tycoonSlot)].TycoonStats
    local surfaceUI = tycoonStats.Owned
    surfaceUI.Frame.Headshot.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    surfaceUI.Frame.RebirthsDisplay.Text = "Rebirths: "..DataManipulator.GetData(player.UserId, "Rebirths")
    surfaceUI.Frame.CashDisplay.Text = "Cash: "..DataManipulator.GetData(player.UserId, "Cash")
    surfaceUI.Frame.GemsDisplay.Text = "Gems: "..DataManipulator.GetData(player.UserId, "Gems")
    surfaceUI.TycoonName.Text = player.Name.."'s Fruit Tycoon"
    tycoonStats.Owned.Enabled = true
    tycoonStats.NotOwned.Enabled = false
end

function TycoonClaimHandler.PlayerInit(player: Player)
    repeat task.wait() until player:GetAttribute("PROFILE_LOADED") == true

    local tycoonSlot = FindFirstOpenTycoon()
    TycoonClaimHandler.Tycoons[tycoonSlot].Owned = player
    TycoonClaimHandler.Tycoons[tycoonSlot].TimeLastOwned = workspace:GetServerTimeNow()
    
    player:SetAttribute("TYCOON_SLOT", tycoonSlot)
    local tycoonStats = workspace.Tycoons[tostring(tycoonSlot)].TycoonStats
    TycoonClaimHandler.UpdateStats(player)

    CharacterInit(player.Character)

    TycoonClaimHandler.Callbacks[player] = function()
        TycoonClaimHandler.Tycoons[tycoonSlot].Owned = nil
        tycoonStats.Owned.Enabled = false
        tycoonStats.NotOwned.Enabled = true
    end -- Cleanup callback
end

function TycoonClaimHandler.CharacterInit(character)
    local player = Players:GetPlayerFromCharacter(character)
    if not player:GetAttribute("PROFILE_LOADED") then return end

    CharacterInit(character)
end

function TycoonClaimHandler.ServerInit()
    for _, spawnLocation: SpawnLocation in CollectionService:GetTagged("SPAWN_LOCATION") do
        spawnLocation.Enabled = false
    end

    for _ = 1, #workspace.Tycoons:GetChildren() do
        table.insert(TycoonClaimHandler.Tycoons, {})
    end
end

function TycoonClaimHandler.PlayerLeave(player)
    TycoonClaimHandler.Callbacks[player]()
end

return TycoonClaimHandler