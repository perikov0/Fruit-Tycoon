--// Perikov 8/24/24

local ProxyTable = {}
ProxyTable.__index = ProxyTable

local Cache = {}

function ProxyTable.new(name)
	if not Cache[name] then
		Cache[name] = setmetatable({
			_table = {},
			_name = name
		}, ProxyTable)
	end
	return Cache[name]
end

function ProxyTable:Get(k)
	return if k then self._table[k] else self._table
end

function ProxyTable:Set(k, v)
	self._table[k] = v
end

function ProxyTable:Destroy()
	Cache[self._name] = nil
	self = nil
end

return table.freeze({
	new = ProxyTable.new,
})