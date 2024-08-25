local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PhysicsService = game:GetService("PhysicsService")
local ProxyTable = require(ReplicatedStorage.Shared.Packages.ProxyTable)
local FruitsProxy = ProxyTable.new("Fruits")

PhysicsService:RegisterCollisionGroup("Fruit")
PhysicsService:CollisionGroupSetCollidable("Fruit", "Fruit", false)

local processedFruits = {}

local InstanceHandler = {}
InstanceHandler.Constructors = {
    Dropper = require(script.Dropper),
    Upgrader = require(script.Upgrader),
}
InstanceHandler.Cache = {}
type typePossibilities = "Dropper" | "Upgrader"

function InstanceHandler.PlayerInit(player)
    processedFruits[player.UserId] = {}
    InstanceHandler.Cache[player.Name] = {Dropper = {}, Upgrader = {}}
end

function InstanceHandler.PlayerLeave(player)
    processedFruits[player.UserId] = nil
    InstanceHandler.Cache[player.Name] = nil
end

function InstanceHandler.CreateInstance(owner: Player, buttonInstance: Model & {Unlock: ObjectValue})
    local instance = buttonInstance.Unlock.Value
    local instanceType: typePossibilities = instance:GetAttribute("InstanceType")
    local constructor = InstanceHandler.Constructors[instanceType]
    if not constructor then return end
    local instanceObject = constructor.new(owner, instance)
    if instanceObject.Connect and typeof(instanceObject.Connect) == "function" then
        instanceObject:Connect()
    end
    InstanceHandler.Cache[owner.Name][instanceType][instance.Name] = instanceObject
end

ReplicatedStorage.Remotes.UpgradeFruit.OnServerEvent:Connect(function(player, upgraderName, GUID)
    local upgraderObject = InstanceHandler.Cache[player.Name].Upgrader[upgraderName]
    local fruitObj = FruitsProxy:Get(GUID)
    local canModify = fruitObj.DropperObject:GetAttribute("CanModify")(fruitObj, upgraderName)
    if not canModify then return end
    upgraderObject.Attributes.OnModify(fruitObj)
end)

ReplicatedStorage.Remotes.ProcessFruit.OnServerEvent:Connect(function(player, GUID)
    if processedFruits[player.UserId][GUID] then return end

    processedFruits[player.UserId][GUID] = true

    local fruitObj = FruitsProxy:Get(GUID)
    if not fruitObj then
        warn("Fruit object does not exist. This user is exploiting.")
        return
    end
    fruitObj.DropperObject:GetAttribute("OnProcess")(fruitObj)
end)

return InstanceHandler