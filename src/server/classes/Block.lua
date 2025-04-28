-- Services
local SSS = game:GetService("ServerScriptService").Server
-- Registries
local BlockRegistry = require(SSS.registries.BlockRegistry)
-- JSON files
local config = require(SSS.misc.config)
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

function getPropertyOrDefault(blockInfo, property)
	if blockInfo[property] ~= nil then
		return blockInfo[property]
	else
		return BlockRegistry.defaultSettings[property]
	end
end

function Block.new(name, xPos, yPos, zPos)
	local blockInfo = BlockRegistry.getBlockInfo(name)
	local newBlock = setmetatable({}, Block)
	
	newBlock.name = config.namespace .. ":" .. blockInfo.name
	newBlock.blockPlacement = getPropertyOrDefault(blockInfo, "blockPlacement")
	newBlock.breakSpeed = blockInfo.breakSpeed
	newBlock.canCollide = getPropertyOrDefault(blockInfo, "canCollide")
	newBlock.color = blockInfo.color
	newBlock.needsTool = getPropertyOrDefault(blockInfo, "needsTool")
	newBlock.partClass = getPropertyOrDefault(blockInfo, "partClass")
	newBlock.position = {
		x = xPos,
		y = yPos,
		z = zPos
	}
	newBlock.size = Block.size
	newBlock.transparency = getPropertyOrDefault(blockInfo, "transparency")
	newBlock.unbreakable = getPropertyOrDefault(blockInfo, "unbreakable")
	
	return newBlock
end

function Block:createPart()
	local part = Instance.new(self.partClass)
	
	part.Anchored = true
	part.CanCollide = self.canCollide
	part.Color = Color3.fromHex(self.color)
	part.Material = Enum.Material.SmoothPlastic
	part.Name = self.name
	part.Position = Vector3.new(self.position.x * worldGenSettings.blockSize,
		self.position.y * worldGenSettings.blockSize, self.position.z * worldGenSettings.blockSize)
	part.Size = Vector3.new(self.size.x, self.size.y, self.size.z)
	part.Transparency = self.transparency
	
	self.part = part
end

function Block:spawnPart()
	self.part.Parent = workspace.blocks
end

return Block