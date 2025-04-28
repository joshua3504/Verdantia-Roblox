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
	-- if worldX < 10 then 
	-- 	worldX = "0" .. worldX
	-- elseif worldX < 99
	-- end
	-- if worldY < 10 then worldY = "0" .. worldY end
	-- if worldZ < 10 then worldZ = "0" .. worldZ end

	local blockId = "block_x" .. worldX .. "y" .. worldY .. "z" .. worldZ
	chunkTable.blocks[blockId] = newBlock
	
	return chunkTable
end

return helperMethods