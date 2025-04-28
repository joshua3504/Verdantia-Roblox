-- Instantiation
local BlockRegistry = {}

BlockRegistry.blocks = {	
	dirt = {
		breakSpeed = 0.5,
		color = "59320e",
		name = "dirt"
	},
	
	grass = {
		breakSpeed = 0.6,
		color = "0b430d",
		name = "grass"
	},
	
	spawnpoint = {
		breakSpeed = math.huge,
		canCollide = false,
		color = "000000",
		name = "spawnpoint",
		partClass = "SpawnLocation",
		transparency = 1,
		unbreakable = true
	},
	
	stone = {
		breakSpeed = 1.0,
		color = "818589",
		name = "stone",
		needsTool = true
	},
	
	voidstone = {
		breakSpeed = math.huge,
		color = "020202",
		name = "voidstone",
		unbreakable = true
	}
}

BlockRegistry.defaultSettings = {
	blockPlacement = "Center",
	canCollide = true,
	partClass = "Part",
	needsTool = false,
	transparency = 0,
	unbreakable = false
}

function BlockRegistry.getBlockInfo(blockName)
	local info = BlockRegistry.blocks[blockName]
	
	if not info then
		error("Block " .. blockName " not found in the block registry.")
	end
	
	return info
end

return BlockRegistry