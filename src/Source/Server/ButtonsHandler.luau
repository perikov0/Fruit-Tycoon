local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local DataManipulator = require(ReplicatedStorage.Shared.Data.Manipulator)

local ButtonsHandler = {}
ButtonsHandler.Buttons = {}

local ButtonClass = {}
ButtonClass.__index = ButtonClass

function ButtonClass.new(buttonInstance, player)
    return setmetatable({
        ButtonInstance = buttonInstance,
        Purchased = false,
        Owner = player,
        TycoonInstance = workspace.Tycoons[tostring(player:GetAttribute("TYCOON_SLOT"))],
    }, ButtonClass)
end

function ButtonClass:Purchase()
    local cash = DataManipulator.GetData(self.Owner.UserId, "Cash")
    if cash < self.ButtonInstance:GetAttribute("Cost") then return end
    self.Purchased = true
    DataManipulator.SetData(self.Owner.UserId, "Cash", cash-self.ButtonInstance:GetAttribute("Cost"), true)
    self:Appear()
end

function ButtonClass:Appear()
    local unlock = self.ButtonInstance.Unlock.Value
    unlock.Parent = self.TycoonInstance.Unlockables
end

function ButtonsHandler.PlayerInit(player: Player)
    repeat task.wait() until player:GetAttribute("TYCOON_SLOT")
    ButtonsHandler.Buttons[player] = {}

    for _, button in CollectionService:GetTagged("BUTTON") do
        ButtonsHandler.Buttons[player][button:GetAttribute("Name")] = ButtonClass.new(button, player)
        button.Unlock.Value.Parent = ReplicatedStorage.TycoonStorage[player.Name]
    end
end

function ButtonsHandler.PlayerLeave(player: Player)
    ButtonsHandler.Buttons[player] = nil
end

ReplicatedStorage.Remotes.PurchaseButton.OnServerEvent:Connect(function(player: Player, buttonPurchased)
    ButtonsHandler.Buttons[player][buttonPurchased]:Purchase()
end)

return ButtonsHandler