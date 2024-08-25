local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataMap = require(ReplicatedStorage.Shared.Informations.DataMapUpgrader)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)

local Upgrader = {}
Upgrader.__index = Upgrader

function Upgrader.new(owner: Player, instance: Instance)
    return setmetatable({
        _instance = instance,
        _trove = Trove.new(),
        _owner = owner,
        Attributes = DataMap[instance.Name],
    }, Upgrader)
end

function Upgrader:Destroy()
    self._trove:Destroy()
end

return Upgrader

