-- Services
local SSS = game:GetService("ServerScriptService").Server
-- JSON files
local worldGenSettings = require(SSS.worldGen.settings)
-- Helper methods table
local helperMethods = {}

function helperMethods.getHeight(x, z, biomeSettings)
	local noiseHeight = math.noise(x / biomeSettings.resolution * biomeSettings.frequency, z / biomeSettings.resolution * biomeSettings.frequency)
	noiseHeight = math.clamp(noiseHeight, -0.5, 0.5) + 0.5
	noiseHeight = math.floor(noiseHeight * biomeSettings.amplitude * worldGenSettings.blockSize)
	
	noiseHeight += 55

	return noiseHeight
end

function helperMethods.addEntryToChunkTable(chunkTable, newBlock, chunkX, chunkZ, worldX, worldY, worldZ)
	local blockId = "block_x" .. worldX .. "y" .. worldY .. "z" .. worldZ
	chunkTable.blocks[blockId] = newBlock
	--chunkTable.blocks[blockId] = {
	--	position = {
	--		x = worldX,
	--		y = worldY,
	--		z = worldZ
	--	}
	--}
	
	return chunkTable
end

return helperMethods