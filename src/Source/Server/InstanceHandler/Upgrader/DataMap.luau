local DataMap = {}

DataMap["UPGRADE 1"] = {
    Modify = function(instance: Instance)
        local originalValue = instance:GetAttribute("Value") :: number
        instance:SetAttribute("Value", originalValue*1.3)
    end
}

DataMap["UPGRADE 2"] = {
    Modify = function(instance: Instance)
        local originalValue = instance:GetAttribute("Value") :: number
        instance:SetAttribute("Value", originalValue*1.4)
    end
}

return table.freeze(DataMap)