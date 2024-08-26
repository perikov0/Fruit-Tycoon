local TweenService = game:GetService("TweenService")
local info = TweenInfo.new(0.084, Enum.EasingStyle.Circular, Enum.EasingDirection.In, 3, true)

local rad = math.rad
local rand = math.random

local function GenerateRandom()
	return CFrame.Angles(rad(rand(4,9)), rad(rand(4,9)), rad(rand(4,9)))
end

return {
	OnDrop = function(dropperObject)
		local dropperInstance = dropperObject:GetInstance()
		if not dropperInstance then return end
		if not dropperInstance:FindFirstChild("LeaveObjects") then
			warn(dropperInstance.Name,"Dropper does not contain leaves folder.")
			return
		end

		for _, leaf in dropperInstance:GetChildren() do
			TweenService:Create(leaf, info, {
				CFrame = leaf.CFrame * GenerateRandom()
			}):Play()
		end
	end
}