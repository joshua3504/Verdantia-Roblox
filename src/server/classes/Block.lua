-- Services
local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService").Server
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

function Block.new(name, xPos, yPos, zPos)
	local newBlock = setmetatable({}, Block)

	newBlock.name = name
	newBlock.position = {
		x = xPos,
		y = yPos,
		z = zPos
	}

	return newBlock
end

function Block:createPart()
	local part = RS.blocks[self.name]:Clone()
	-- part.Name = "block_x" .. self.position.x .. "y" .. self.position.y .. "z" .. self.position.z
	part.Position = Vector3.new(self.position.x * worldGenSettings.blockSize,
		self.position.y * worldGenSettings.blockSize, self.position.z * worldGenSettings.blockSize)
	self.part = part
end

function Block:spawnPart()
	self.part.Parent = workspace.blocks
end

function Block:shouldRender(chunkBlocks)
	local x = self.position.x
	local y = self.position.y
	local z = self.position.z

	-- if x - 1 < 0 or z - 1 < 0 or y - 1 < 0 then
	-- 	return true -- Returns true if it's on the outside of a chunk
	-- else
	local above = chunkBlocks["block_x" .. x .. "y" .. (y + 1) .. "z" .. z]
	local below = chunkBlocks["block_x" .. x .. "y" .. (y - 1) .. "z" .. z]
	local north = chunkBlocks["block_x" .. x .. "y" .. y .. "z" .. (z - 1)]
	local south = chunkBlocks["block_x" .. x .. "y" .. y .. "z" .. (z + 1)]
	local east = chunkBlocks["block_x" .. (x + 1) .. "y" .. y .. "z" .. z]
	local west = chunkBlocks["block_x" .. (x - 1) .. "y" .. y .. "z" .. z]

	if above and below and north and south and east and west then
		-- print("don't render")
		return false
	else
		-- print("render")
		return true
	end
	-- end
end

return Block