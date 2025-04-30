-- Services
local RS = game:GetService("ReplicatedStorage")
-- Instantiation
local Item = {}
Item.__index = Item

function Item.new(name)
	local newItem = setmetatable({}, Item)

    newItem.part = RS.items[name]:Clone()

	return newItem
end

function Item:getPart()
    return self.part
end

return Item