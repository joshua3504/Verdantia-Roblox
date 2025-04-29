-- Services
local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService").Server
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

function DroppedBlock:listenForPickUp()
    if self.part then
        self.touchedConnection = self.part.Touched:Connect(function(hit)
            print(hit)
        end)
    end
end

function DroppedBlock:createPart()
    local part = RS.droppedBlocks[self.name]:Clone()
    part.Position = Vector3.new(self.position.x * worldGenSettings.blockSize,
	    self.position.y * worldGenSettings.blockSize, self.position.z * worldGenSettings.blockSize)
    self.part = part
end

function DroppedBlock:spawnPart()
    self.part.Parent = workspace.droppedBlocks
    self:listenForPickUp()
end

return DroppedBlock