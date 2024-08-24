local InstanceHandler = {}
InstanceHandler.Constructors = {
    Dropper = require(script.Dropper),
    Upgrader = require(script.Upgrader),
}

function InstanceHandler.CreateInstance(owner: Player, buttonInstance: Model & {Unlock: ObjectValue})
    local instance = buttonInstance.Unlock.Value
    local instanceType: "Dropper" | "Upgrader" = instance:GetAttribute("InstanceType")
    local constructor = InstanceHandler.Constructors[instanceType]
    if not constructor then return end
    local instanceObject = constructor.new(owner, instance)
    instanceObject:Connect()
end

return InstanceHandler