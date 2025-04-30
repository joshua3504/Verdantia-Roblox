-- Services
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService").Server
local TweenService = game:GetService("TweenService")
-- Classes
local classes = SSS.classes
local Inventory = require(classes.Inventory)
local Player = require(classes.Player)
-- JSON files
local worldGenSettings = require(SSS.worldGen.settings)
-- Instantiation
local DroppedBlock = {}
DroppedBlock.__index = DroppedBlock

function DroppedBlock.new(name, position)
    local newDroppedItem = setmetatable({}, DroppedBlock)

    newDroppedItem.name = name
    newDroppedItem.position = position

    return newDroppedItem
end

function DroppedBlock:animate()
    local pos = self.part.Position

    -- Vertical tween
    TweenService:Create(
        self.part,
        TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true),
        { Position = Vector3.new(pos.X, pos.Y - (worldGenSettings.blockSize / 4), pos.Z) }
    ):Play()

    -- Horizontal tween
    TweenService:Create(
        self.part,
        TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false),
        { Orientation = Vector3.new(0, 360, 0) }
    ):Play()
end

function DroppedBlock:listenForPickUp()
    if self.part then
        self.touchedConnection = self.part.Touched:Connect(function(hit)
            local player = Players:GetPlayerFromCharacter(hit.Parent)

            if player then
                Player.getPlayerInCache(player).inventory:addItemToFirstAvailableSlot(self.name)
                self.part:Destroy()
                self = nil
            end
        end)
    end
end

function DroppedBlock:createPart()
    local part = RS.droppedBlocks[self.name]:Clone()
    part.Position = Vector3.new(self.position.x * worldGenSettings.blockSize,
	    (self.position.y * worldGenSettings.blockSize) + (worldGenSettings.blockSize / 8), self.position.z * worldGenSettings.blockSize)
    self.part = part
end

function DroppedBlock:spawnPart()
    self.part.Parent = workspace.droppedBlocks
    self:listenForPickUp()
    self:animate()
end

return DroppedBlock