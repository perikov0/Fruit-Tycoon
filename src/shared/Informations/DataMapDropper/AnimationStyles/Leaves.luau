local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local info = TweenInfo.new(0.1, Enum.EasingStyle.Circular, Enum.EasingDirection.In, 1, true)

local rad = math.rad
local rand = math.random

local function Emit(Particle: BasePart)
	for _, ParticleEmitter in Particle:GetDescendants() do
		if ParticleEmitter:IsA("ParticleEmitter") then
			ParticleEmitter:Emit(ParticleEmitter:GetAttribute("EmitCount"))
		end
	end
end

local function GenerateRandom()
	return CFrame.Angles(rad(rand(-4,4)), rad(rand(-4,4)), rad(rand(-4,4)))
end

return {
	OnDrop = function(dropperObject)
		local dropperInstance = dropperObject:GetInstance()
		if not dropperInstance then return end
		if not dropperInstance:FindFirstChild("Leaves") then
			warn(dropperInstance.Name,"Dropper does not contain leaves folder.")
			return
		end
		local shakeEffect = ReplicatedStorage.Assets.ShakeEffect:Clone()
		shakeEffect.Position = dropperInstance.Trunk:GetPivot().Position+Vector3.new(0,4,0)
		shakeEffect.Parent = workspace.Effects
		Debris:AddItem(shakeEffect, 6)

		local originalCFS = {}
		for _, leaf in dropperInstance:FindFirstChild("Leaves"):GetChildren() do
			originalCFS[leaf] = leaf.CFrame
			task.spawn(function()
				for i = 1, 1 do
					local tween = TweenService:Create(leaf, info, {
						CFrame = leaf.CFrame * GenerateRandom()
					})
					Emit(shakeEffect)
					tween:Play()
					tween.Completed:Wait()
				end
			end)
		end
	end,
	Yield = 0.6,
}