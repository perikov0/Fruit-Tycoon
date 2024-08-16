local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Client = ReplicatedStorage.Source.Client

local ComponentsType = require(Client.Interface.Components.ComponentTypes)

local Frame = {}

local CurrentCamera = workspace.CurrentCamera
local CameraTween: Tween, BlurTween: Tween

local function cancelTweens()
	if CameraTween then
        CameraTween:Cancel()
    end

	if BlurTween then
        BlurTween:Cancel()
    end
end

local function playTweenAnims()
    BlurTween:Play()
    CameraTween:Play()
end

function Frame.Open(ButtonComponent: ComponentsType.ButtonComponent)
    print("Open", ButtonComponent.Link)
    cancelTweens()
    BlurTween = TweenService:Create(Lighting.UIBlur, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = 20})
    CameraTween = TweenService:Create(CurrentCamera, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {FieldOfView = 75})
    playTweenAnims()
    LocalPlayer:SetAttribute("OpenedFrame", ButtonComponent.Link.Name)

    ButtonComponent.FrameValues.FrameEnabled:set(true)
    ButtonComponent.FrameValues.FrameVisible:set(true)
    ButtonComponent.FrameValues.FrameSize:set(1)
    ButtonComponent.IsCooldown:set(true, true)
    ButtonComponent.FrameValues.FrameAnchor:set(Vector2.new(0, 1))

    task.wait(ButtonComponent.FrameValues.ScaleTweenTime)

    ButtonComponent.IsCooldown:set(false, true)
end

function Frame.Close(ButtonComponent: ComponentsType.ButtonComponent)
    print("Close", ButtonComponent.Link)
    cancelTweens()
	BlurTween = TweenService:Create(Lighting.UIBlur, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = 0})
	CameraTween = TweenService:Create(CurrentCamera, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {FieldOfView = 70})
    playTweenAnims()

    ButtonComponent.FrameValues.FrameSize:set(0.4)
    ButtonComponent.IsCooldown:set(true, true)
    ButtonComponent.FrameValues.FrameAnchor:set(Vector2.new(0, 0))

    task.wait(ButtonComponent.FrameValues.ScaleTweenTime)
    LocalPlayer:SetAttribute("OpenedFrame", nil)
    
    ButtonComponent.FrameValues.FrameEnabled:set(false)
    ButtonComponent.FrameValues.FrameVisible:set(false)
    ButtonComponent.IsCooldown:set(false, true)
end

return Frame
