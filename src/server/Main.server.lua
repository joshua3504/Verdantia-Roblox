-- Services
local SSS = game:GetService("ServerScriptService").Server
-- Handlers
local WorldGenHandler = require(SSS.worldGen.WorldGenHandler)
-- Classes
local classes = SSS.classes
local Block = require(classes.Block)
local World = require(classes.World)
-- JSON files
local config = require(SSS.misc.config)
-- Variables
local chunks = {}

-- Create the chunks
for x = 0, 1 do
	for z = 0, 1 do
		wait(0.1)
		local newChunk = WorldGenHandler.createChunk(18, x, z)
		chunks["chunk_x" .. x .. "z" .. z] = newChunk
	end
end

for _, chunk in pairs(chunks) do
	WorldGenHandler.loadChunk(chunk)
end

-- Create the spawn point
local spawnpoint = Block.new("spawnpoint", 0, World.spawnpointPosition.y, 0)
--chunks["chunk_x0z0"].blocks.["block_x0z0"]
spawnpoint:createPart()
spawnpoint:spawnPart()

-- Teleport all players to the spawn
for i, plr in pairs(game:GetService("Players"):GetPlayers()) do
	plr:Move(workspace.blocks:FindFirstChild(config.namespace .. ":spawnpoint").Position)
end

workspace.SpawnLocation:Destroy()

print(chunks)