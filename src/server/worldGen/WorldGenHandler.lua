-- Services
local SSS = game:GetService("ServerScriptService").Server
-- Classes
local classes = SSS.classes
local Block = require(classes.Block)
local World = require(classes.World)
-- JSON files
local helperMethods = require(SSS.worldGen.helperMethods)
local worldGenSettings = require(SSS.worldGen.settings)
-- Instantiation
local WorldGenHandler = {}

function WorldGenHandler.createChunk(seed, chunkX, chunkZ)
	-- Setting the seed
	math.randomseed(seed)
	
	-- Setting up the chunk table
	local chunkId = "chunk_" .. "x" .. chunkX .. "z" .. chunkZ
	local chunkTable = {
		chunkId = chunkId,
		blocks = {}
	}
	
	-- Generate the voidstone
	for x = 0, worldGenSettings.chunkSize do
		for layer = 0, worldGenSettings.voidstoneGen.numLayers - 1 do
			for z = 0, worldGenSettings.chunkSize do
				coroutine.resume(coroutine.create(function()
					local newBlock
				
					if math.random() < worldGenSettings.voidstoneGen["layer" .. layer] then
						newBlock = Block.new("voidstone", x + (chunkX * worldGenSettings.chunkSize), layer, z + (chunkZ * worldGenSettings.chunkSize))
					else
						newBlock = Block.new("stone", x + (chunkX * worldGenSettings.chunkSize), layer, z + (chunkZ * worldGenSettings.chunkSize))
					end
					
					helperMethods.addEntryToChunkTable(chunkTable, newBlock, chunkX, chunkZ, x, layer, z)
				end))
			end
		end
	end
	
	-- Generate the stone, dirt, and grass
	for x = 0, worldGenSettings.chunkSize do
		for layer = worldGenSettings.voidstoneGen.numLayers, worldGenSettings.biomes.plains.groundLayers do
			for z = 0, worldGenSettings.chunkSize do
				coroutine.resume(coroutine.create(function()
					local height = helperMethods.getHeight(x + (chunkX * worldGenSettings.chunkSize), z + (chunkZ * worldGenSettings.chunkSize), worldGenSettings.biomes.plains)
					if layer <= height then
						local newBlock
						
						if height - layer == 0 then
							newBlock = Block.new("grass", x + (chunkX * worldGenSettings.chunkSize), layer, z + (chunkZ * worldGenSettings.chunkSize))
						elseif height - layer <= 4 then
							newBlock = Block.new("dirt", x + (chunkX * worldGenSettings.chunkSize), layer, z + (chunkZ * worldGenSettings.chunkSize))
						else
							newBlock = Block.new("stone", x + (chunkX * worldGenSettings.chunkSize), layer, z + (chunkZ * worldGenSettings.chunkSize))
						end
						
						helperMethods.addEntryToChunkTable(chunkTable, newBlock, chunkX, chunkZ, x, layer, z)
						
						if chunkX == 0 and chunkZ == 0 and x == 0 and z == 0 then
							World.setSpawnPosition(0, layer + 1, 0)
						end
					end
				end))
			end
		end
	end
	
	return chunkTable
end

function WorldGenHandler.loadChunk(chunkTable)
	for _, block in pairs(chunkTable.blocks) do
		if block:shouldRender(chunkTable.blocks) then
			block:createPart()
			block:spawnPart()
		end
	end
end

return WorldGenHandler