local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FusionTypes = require(ReplicatedStorage.Source.Client.ClientPackages.Fusion)

type callback = (any) -> ()

export type ButtonComponent = {
    obj: GuiButton & {UIScale: UIScale, Main: Frame & {Icon: ImageLabel}},
    callbacks: {[string]: callback},
    Link: GuiBase,

    IsCooldown: FusionTypes.Value<boolean>,
    IconRotation: FusionTypes.Value<number>,
    SizeFactor: FusionTypes.Value<number>,
    ButtonColor: FusionTypes.Value<Color3>,
    
    RegularSize: UDim2,
    
    FrameValues: {
        FrameVisible: FusionTypes.Value<boolean>,
        FrameEnabled: FusionTypes.Value<boolean>,
        FrameSize: FusionTypes.Value<number>,
        FrameAnchor: FusionTypes.Value<Vector2>,
        ScaleTweenTime: number,
    },

    new: (GuiButton) -> ButtonComponent,
    Init: (ButtonComponent) -> (),
    
    LinkFrame: (ButtonComponent, GuiObject) -> (),

    _ListenToHoverEnter: (ButtonComponent, callback) -> (),
    _ListenToHoverLeave: (ButtonComponent, callback) -> (),
    _ListenToClick: (ButtonComponent, callback) -> (),
}

return setmetatable({Ignore = true}, {__index = function()
    error("Cannot index Types module.")
end})