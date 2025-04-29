-- Services
local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService").Server
-- Classes
local DroppedBlock = require(SSS.classes.DroppedBlock)
-- JSON files
local worldGenSettings = require(SSS.worldGen.settings)
-- Instantiation
local Block = {}
Block.__index = Block
-- Fields
Block.size = {
	x = 3,
	y = 3,
	z = 3
}

function Block.new(name, chunkId, xPos, yPos, zPos)
	local newBlock = setmetatable({}, Block)

	newBlock.name = name
	newBlock.chunkId = chunkId
	newBlock.position = {
		x = xPos,
		y = yPos,
		z = zPos
	}

	return newBlock
end

function Block:getBlockId()
	return "block_x" .. self.position.x .. "y" .. self.position.y .. "z" .. self.position.z
end

function Block:createPart()
	local part = RS.blocks[self.name]:Clone()
	-- part.Name = "block_x" .. self.position.x .. "y" .. self.position.y .. "z" .. self.position.z
	part.Position = Vector3.new(self.position.x * worldGenSettings.blockSize,
		self.position.y * worldGenSettings.blockSize, self.position.z * worldGenSettings.blockSize)
	part:SetAttribute("chunkId", self.chunkId)
	part:SetAttribute("blockId", self:getBlockId())
	self.part = part
end

function Block:spawnPart()
	self.part.Parent = workspace.blocks
end

function Block:removeAndDrop(chunksTable)
	local droppedBlock = DroppedBlock.new(self.name, self.position)
	droppedBlock:createPart()
	droppedBlock:spawnPart()

	chunksTable[self.chunkId].blocks[self:getBlockId()] = nil
	self.part:Destroy()
end

function Block:shouldRender(chunkBlocks)
	local x = self.position.x
	local y = self.position.y
	local z = self.position.z

	-- if x - 1 < 0 or z - 1 < 0 or y - 1 < 0 then
	-- 	return true -- Returns true if it's on the outside of a chunk
	-- else
	local neighboringBlocks = {
		above = chunkBlocks["block_x" .. x .. "y" .. (y + 1) .. "z" .. z],
		below = chunkBlocks["block_x" .. x .. "y" .. (y - 1) .. "z" .. z],
		north = chunkBlocks["block_x" .. x .. "y" .. y .. "z" .. (z - 1)],
		south = chunkBlocks["block_x" .. x .. "y" .. y .. "z" .. (z + 1)],
		east = chunkBlocks["block_x" .. (x + 1) .. "y" .. y .. "z" .. z],
		west = chunkBlocks["block_x" .. (x - 1) .. "y" .. y .. "z" .. z],
	}

	for i = 1, 6 do
		if neighboringBlocks[i] == nil then
			return true
		end
	end

	return false
	-- if above and below and north and south and east and west then
	-- 	-- print("don't render")
	-- 	return false
	-- else
	-- 	-- print("render")
	-- 	return true
	-- end
	-- end
end

return Block