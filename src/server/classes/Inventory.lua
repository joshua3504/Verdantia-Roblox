-- Instantiation
local Inventory = {}
Inventory.__index = Inventory
-- Variables
local inventoriesCache = {}

function Inventory.new(owner)
    local newInventory = setmetatable({}, Inventory)

    newInventory.ownerName = owner.Name
    newInventory.ownerUserId = owner.UserId
    newInventory.inventory = {
        hotbar = {
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

    inventoriesCache["player_" .. owner.UserId] = newInventory

    print(newInventory)

    return newInventory
end

function Inventory.getInventoriesCache()
    return inventoriesCache
end

function Inventory.removeInventoryFromCache(player)
    inventoriesCache["player_" .. player.UserId] = nil
end

return Inventory