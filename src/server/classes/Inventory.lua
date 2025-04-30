-- Services
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
-- Instantiation
local Inventory = {}
Inventory.__index = Inventory

function Inventory.new(owner)
    local newInventory = setmetatable({}, Inventory)

    newInventory.ownerName = owner.Name
    newInventory.ownerUserId = owner.UserId
    newInventory.inventory = {
        hotbar = {
            slots = {},
            selectedSlot = 1
        },
        inventory = {},
        armor = {
            hat = nil,
            shirt = nil,
            pants = nil,
            shoes = nil,
            offhand = nil
        }
    }

    -- print(newInventory)

    return newInventory
end

-- function Inventory:addItemToHotbar(item, slot)
--     local oldItem = self.hotbar["slot" .. slot]
--     self.hotbar["slot" .. slot] = item
--     return oldItem
-- end

-- function Inventory:removeItemFromHotbar(slot)
--     local removedItem = self.hotbar["slot" .. slot]
--     self.hotbar["slot" .. slot] = nil
--     return removedItem
-- end

-- Adds the item to the first available slot and returns the slot it was added to
function Inventory:addItemToFirstAvailableSlot(itemName)
    for i = 1, 9 do
        if self.inventory.hotbar.slots["slot" .. i] == nil then
            self.inventory.hotbar.slots["slot" .. i] = itemName
            self:updateRender()
            return i
        end
    end

    for i = 1, 27 do
        if self.inventory.inventory["slot" .. i] == nil then
            self.inventory.inventory["slot" .. i] = itemName
            self:updateRender()
            return i + 9
        end
    end

    return nil
end

function Inventory:updateRender()
    RS.remotes.updateInventoryRender:FireClient(Players[self.ownerName], self.inventory)
end

return Inventory