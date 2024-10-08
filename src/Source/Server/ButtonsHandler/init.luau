local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local DataManipulator = require(ReplicatedStorage.Shared.Data.Manipulator)
local InstanceHandler = require(ReplicatedStorage.Source.Server.InstanceHandler)
local PurchaseCallbacks = require(script.PurchaseCallbacks)

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

local TWEEN_TIME = 0.3

function ButtonClass:Purchase()
    local cash = DataManipulator.GetData(self.Owner.UserId, "Cash")
    if cash < self.ButtonInstance:GetAttribute("Cost") then return end
    self.Purchased = true
    self:Appear()

    DataManipulator.SetData(self.Owner.UserId, "Cash", cash-self.ButtonInstance:GetAttribute("Cost"), true)
    task.spawn(InstanceHandler.CreateInstance, self.Owner, self.ButtonInstance)

    local elapsed = 1
    local conn; conn = RunService.Heartbeat:Connect(function(dt)
        elapsed -= dt/TWEEN_TIME
        self.ButtonInstance:ScaleTo(TweenService:GetValue(math.max(elapsed, 0.01), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
    end)

    task.delay(TWEEN_TIME, function()
        conn:Disconnect()
        self.ButtonInstance.Parent = ReplicatedStorage.ButtonStorage
    end)
    
    if PurchaseCallbacks[self.ButtonInstance:GetAttribute("Name")] then
        PurchaseCallbacks[self.ButtonInstance:GetAttribute("Name")](self)
    end
end

function ButtonClass:Appear()
    local unlock = self.ButtonInstance.Unlock.Value
    unlock.Parent = self.TycoonInstance.Unlockables
    ReplicatedStorage.Remotes.AppearAnimation:FireClient(self.Owner)
end

function ButtonsHandler.PlayerInit(player: Player)
    repeat task.wait() until player:GetAttribute("TYCOON_SLOT")
    ButtonsHandler.Buttons[player] = {}
    local sortedButtons = {}

    for _, button in workspace.Tycoons[player:GetAttribute("TYCOON_SLOT")].Buttons:GetChildren() do
        local order = button:GetAttribute("Order")
        sortedButtons[order] = sortedButtons[order] or {}
        table.insert(sortedButtons[order], button)
    end

    for _, buttonGroup in sortedButtons do
        for _, button in buttonGroup do
            ButtonsHandler.Buttons[player][button:GetAttribute("Name")] = ButtonClass.new(button, player)
            button.Unlock.Value.Parent = ReplicatedStorage.TycoonStorage[player.Name]
        end
    end

end

function ButtonsHandler.PlayerLeave(player: Player)
    ButtonsHandler.Buttons[player] = nil
end

ReplicatedStorage.Remotes.PurchaseButton.OnServerEvent:Connect(function(player: Player, buttonPurchased)
    print(buttonPurchased)
    ButtonsHandler.Buttons[player][buttonPurchased]:Purchase()
end)

return ButtonsHandler