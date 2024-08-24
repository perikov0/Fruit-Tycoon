local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local DataManipulator = require(ReplicatedStorage.Shared.Data.Manipulator)
local InstanceHandler = require(ReplicatedStorage.Source.Server.InstanceHandler)

local ButtonsHandler = {}
ButtonsHandler.Buttons = {}

local ButtonClass = {}
ButtonClass.__index = ButtonClass

function ButtonClass.new(buttonInstance, player)
    return setmetatable({
        _buttonInstance = buttonInstance,
        Purchased = false,
        Owner = player,
        TycoonInstance = workspace.Tycoons[tostring(player:GetAttribute("TYCOON_SLOT"))],
    }, ButtonClass)
end

local TWEEN_TIME = 0.3

function ButtonClass:Purchase()
    local cash = DataManipulator.GetData(self.Owner.UserId, "Cash")
    if cash < self._buttonInstance:GetAttribute("Cost") then return end
    self.Purchased = true
    self:Appear()
    DataManipulator.SetData(self.Owner.UserId, "Cash", cash-self._buttonInstance:GetAttribute("Cost"), true)
    task.spawn(InstanceHandler.CreateInstance, self.Owner, self._buttonInstance)

    local elapsed = 1
    local conn; conn = RunService.Heartbeat:Connect(function(dt)
        elapsed -= dt/TWEEN_TIME
        self._buttonInstance:ScaleTo(TweenService:GetValue(math.max(elapsed, 0.01), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
    end)

    task.delay(TWEEN_TIME, function()
        conn:Disconnect()
        self._buttonInstance.Parent = ReplicatedStorage.ButtonStorage
    end)
end

function ButtonClass:Appear()
    local unlock = self._buttonInstance.Unlock.Value
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