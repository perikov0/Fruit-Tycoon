local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local DataManipulator = require(ReplicatedStorage.Shared.Data.Manipulator)

local LocalPlayer = Players.LocalPlayer

local ButtonClass = {}
ButtonClass.__index = ButtonClass
ButtonClass.Buttons = {}

function ButtonClass.new(buttonInstance: Model & {PrimaryPart: Part})
    local requirements = buttonInstance:GetAttribute("Requirements")
    local buttonUI = ReplicatedStorage.Assets.ButtonUI:Clone()
    buttonUI.Parent = buttonInstance
    buttonUI.Adornee = buttonInstance.PrimaryPart

    local object = setmetatable({
        ButtonInstance = buttonInstance,
        ButtonUI = buttonUI,
        Purchased = false,
        TouchConn = nil,
        PurchaseCallback = function()
            warn("No callback added to required objects")
        end
    }, ButtonClass)

    task.delay(1, function()
        local pressCooldown = false
        object.TouchConn = buttonInstance.PrimaryPart.Touched:Connect(function(hit)
            if hit.Parent ~= LocalPlayer.Character then return end
            if pressCooldown then return end
            pressCooldown = true
            object:Purchase()
            task.wait(0.3)
            pressCooldown = false
        end)
    end)

    if ButtonClass.Buttons[requirements] then
        ButtonClass.Buttons[requirements].PurchaseCallback = function()
            object:UpdateAppearance()
        end -- Calls when the required button is pressed.
    end

    ButtonClass.Buttons[buttonInstance:GetAttribute("Name")] = object
    return object
end

function ButtonClass:UpdateAppearance()
    local requirements = self.ButtonInstance:GetAttribute("Requirements")
    print(requirements)

    local requirementsButtonObject = ButtonClass.Buttons[requirements]
    if (requirementsButtonObject) and (not requirementsButtonObject.Purchased) then
        print("Cannot ever buy")
        self.ButtonInstance.Parent = ReplicatedStorage.ButtonStorage
        return
    end

    local tycoonSlot = LocalPlayer:GetAttribute("TYCOON_SLOT")
    local tycoonFolder = workspace.Tycoons[tostring(tycoonSlot)]

    self.ButtonInstance.Parent = tycoonFolder.Buttons
    self.ButtonUI.Frame.ButtonName.Text = self.ButtonInstance:GetAttribute("Name")
    self.ButtonUI.Frame.Cost.Text = "$"..self.ButtonInstance:GetAttribute("Cost")
end

local TWEEN_TIME = 0.3
function ButtonClass:Purchase()
    local cost = self.ButtonInstance:GetAttribute("Cost")
    local playerCash = DataManipulator.GetData(LocalPlayer.UserId, "Cash")
    if playerCash < cost then return end

    self.TouchConn:Disconnect()
    self.Purchased = true
    self.PurchaseCallback()
    self.ButtonInstance.PrimaryPart.Color = Color3.fromRGB(116, 232, 131)
    
    local elapsed = 1
    local conn; conn = RunService.Heartbeat:Connect(function(dt)
        elapsed -= dt/TWEEN_TIME
        if elapsed <= 0 then
            conn:Disconnect()
            return
        end
        self.ButtonInstance:ScaleTo(TweenService:GetValue(elapsed, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
    end)

    task.delay(TWEEN_TIME, function()
        self.ButtonInstance.Parent = ReplicatedStorage.ButtonStorage
    end)

    ReplicatedStorage.Remotes.PurchaseButton:FireServer(self.ButtonInstance:GetAttribute("Name"))
end

return ButtonClass