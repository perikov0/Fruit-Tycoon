local ReplicatedStorage = game:GetService("ReplicatedStorage")

local InstanceHandler = {}
InstanceHandler.Constructors = {
    Dropper = require(script.Dropper),
    Upgrader = require(script.Upgrader),
}
InstanceHandler.Cache = {Dropper = {},  Upgrader = {}}

function InstanceHandler.CreateInstance(buttonInstance: Model & {Unlock: ObjectValue})
    local instance = buttonInstance.Unlock.Value
    local instanceType: "Dropper" | "Upgrader" = instance:GetAttribute("InstanceType")
    local constructor = InstanceHandler.Constructors[instanceType]
    if not constructor then return end
    local instanceObject = constructor.new(instance)
    if instanceObject.Connect and typeof(instanceObject.Connect) == "function" then
        instanceObject:Connect()
    end
    InstanceHandler.Cache[instanceType][instance.Name] = instanceObject
end

ReplicatedStorage.Remotes.DropFruit.OnClientEvent:Connect(function(instanceName, GUID)
    local instanceObject = InstanceHandler.Cache.Dropper[instanceName]
    instanceObject:DropFruit(GUID)
end)

return InstanceHandler