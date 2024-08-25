local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local DataManipulator = require(ReplicatedStorage.Shared.Data.Manipulator)
local InstanceController = require(ReplicatedStorage.Source.Client.InstanceController)
local PurchaseCallbacks = require(script.Parent.PurchaseCallbacks)

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
        ReqLinked = {},
        PurchaseCallback = function()
            --warn("No callback added to required objects")
        end,
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

    local reqButton = ButtonClass.Buttons[requirements]
    if reqButton then
        reqButton.ReqLinked[buttonInstance:GetAttribute("Name")] = object
        reqButton.PurchaseCallback = function()
            for _, targetObj in reqButton.ReqLinked do
                targetObj:UpdateAppearance()
            end
        end -- Calls when the required button is pressed.
    end

    ButtonClass.Buttons[buttonInstance:GetAttribute("Name")] = object
    return object
end

function ButtonClass:UpdateAppearance()
    local requirements = self.ButtonInstance:GetAttribute("Requirements")

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

function ButtonClass:Purchase()
    local cost = self.ButtonInstance:GetAttribute("Cost")
    local playerCash = DataManipulator.GetData(LocalPlayer.UserId, "Cash")
    if playerCash < cost then return end

    self.TouchConn:Disconnect()
    self.Purchased = true
    self.PurchaseCallback()
    self.ButtonInstance.PrimaryPart.Color = Color3.fromRGB(116, 232, 131)

    ReplicatedStorage.Remotes.PurchaseButton:FireServer(self.ButtonInstance:GetAttribute("Name"))

    InstanceController.CreateInstance(self.ButtonInstance)

    if PurchaseCallbacks[self.ButtonInstance:GetAttribute("Name")] then
        PurchaseCallbacks[self.ButtonInstance:GetAttribute("Name")](self)
    end
end

return ButtonClass