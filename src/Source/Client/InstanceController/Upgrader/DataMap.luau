local DataMap = {}

DataMap["UPGRADE 1"] = {
    OnModify = function(fruitObj)
        fruitObj *= 1.2
        fruitObj += 5
    end
}

DataMap["UPGRADE 2"] = {
    OnModify = function(fruitObj)
        fruitObj *= 1.2
        fruitObj += 5
    end
}

return table.freeze(DataMap)