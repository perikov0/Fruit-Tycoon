local ComponentHandler = {}
ComponentHandler.Components = {}

function ComponentHandler.PlayerInit()
	for _, componentModule in script.Parent.Components:GetChildren() do
		if not componentModule:IsA("ModuleScript") then continue end
		local module = require(componentModule)
		if module.Ignore == true then continue end
		ComponentHandler.Components[module.Name] = module
	end
end

function ComponentHandler.AddComponent(componentName, ...)
	return ComponentHandler.Components[componentName].new(...)
end

return ComponentHandler