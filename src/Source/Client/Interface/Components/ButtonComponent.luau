local ButtonComponent = {}
ButtonComponent.__index = ButtonComponent
ButtonComponent.Name = "ButtonBase"

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local Client = ReplicatedStorage.Source.Client
local Interface = Client.Interface
local CompFunctions = Interface.Components.Functions

local Fusion = require(Client.ClientPackages.Fusion)
local Value = Fusion.Value
local Hydrate = Fusion.Hydrate
local Tween = Fusion.Tween

local ComponentsType = require(Client.Interface.Components.ComponentTypes)
local FrameFunctions = require(CompFunctions.Frame)

function ButtonComponent.new(buttonObject: GuiButton, callbacks)
    return setmetatable({
        obj = buttonObject,
        callbacks = callbacks
    }, ButtonComponent)
end

function ButtonComponent:Init()
    local Component: ComponentsType.ButtonComponent = self
    
    Component.IconRotation = Value(Component.obj.Main.Icon.Rotation)
    Component.SizeFactor = Value(Component.obj.UIScale.Scale)
    Component.ButtonColor = Value(Color3.fromRGB(255,255,255))
    Component.IsCooldown = Value(false)
    Component.RegularSize = Component.obj.Size
    
    Component.obj.MouseEnter:Connect(function()
        Component:_ListenToHoverEnter(Component.callbacks.HoverEnter)
    end)

    Component.obj.MouseLeave:Connect(function()
        Component:_ListenToHoverLeave(Component.callbacks.HoverLeave)
    end)

    Component.obj.MouseButton1Click:Connect(function()
        Component:_ListenToClick(Component.callbacks.ClickFn)
    end)
    
    Hydrate(Component.obj.Main.Icon) {
        Rotation = Tween(Component.IconRotation, TweenInfo.new(0.12, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
    }

    Hydrate(Component.obj.UIScale) {
        Scale = Tween(Component.SizeFactor, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
    }

    Hydrate(Component.obj) {
        BackgroundColor3 = Tween(Component.ButtonColor, TweenInfo.new(0.06, Enum.EasingStyle.Sine, Enum.EasingDirection.Out))
    }
end

function ButtonComponent:_ListenToHoverEnter(callbackFn: () -> ()?)
    local Component: ComponentsType.ButtonComponent = self
    if callbackFn then task.spawn(callbackFn) end
    Component.SizeFactor:set(0.98)
    Component.IconRotation:set(6)
    Component.ButtonColor:set(Color3.fromRGB(180,180,180))
    SoundService.Game["Button Hover Sound"]:Play()
end

function ButtonComponent:_ListenToHoverLeave(callbackFn: () -> ())
    local Component: ComponentsType.ButtonComponent = self
    if callbackFn then task.spawn(callbackFn) end
    Component.SizeFactor:set(1)
    Component.IconRotation:set(0)
    Component.ButtonColor:set(Color3.fromRGB(255,255,255))
end

function ButtonComponent:_ListenToClick(callbackFn: (ComponentsType.ButtonComponent) -> ())
    local Component: ComponentsType.ButtonComponent = self
    if callbackFn then task.spawn(callbackFn, self) end
    Component.SizeFactor:set(0.85)
    Component.IconRotation:set(0)
    Component.ButtonColor:set(Color3.fromRGB(150, 150, 150))
    task.wait(0.1)
    Component.SizeFactor:set(1)
    Component.ButtonColor:set(Color3.fromRGB(255, 255, 255))
end

function ButtonComponent:LinkFrame(frame: Frame, UIscale: UIScale)
    local Component: ComponentsType.ButtonComponent = self
    Component.Link = frame

    Component.FrameValues = {
        FrameVisible = Value(false), --> If frame is visible / invisible
        FrameEnabled = Value(false), --> If it's turned off / on
        FrameSize = Value(1),
        FrameAnchor = Value(frame.AnchorPoint),
        ScaleTweenTime = 0.26,
    }

    Hydrate(frame) {
        Visible = Component.FrameValues.FrameVisible,
        AnchorPoint = Tween(Component.FrameValues.FrameAnchor, TweenInfo.new(Component.FrameValues.ScaleTweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut))
    }

    Hydrate(UIscale) {
        Scale = Tween(Component.FrameValues.FrameSize, TweenInfo.new(Component.FrameValues.ScaleTweenTime, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))
    }

end

return ButtonComponent