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
local worldGenSettings = require(SSS.worldGen.settings)
-- Variables
local chunks = {}

-- Create the chunks
for x = 0, 1 do
	for z = 0, 1 do
		task.wait(0.1)
		coroutine.resume(coroutine.create(function()
			local newChunk = WorldGenHandler.createChunk(18, x, z)
			chunks["chunk_x" .. x .. "z" .. z] = newChunk
		end))
	end
end

for _, chunk in pairs(chunks) do
	task.wait(0.1)
	coroutine.resume(coroutine.create(function()
		WorldGenHandler.loadChunk(chunk)
	end))
end

local spawnpoint = Block.new("spawnpoint", 0, World.spawnpointPosition.y, 0)
--chunks["chunk_x0z0"].blocks.["block_x0z0"]
spawnpoint:createPart()
spawnpoint:spawnPart()

-- Teleport all players to the spawn
for _, player in pairs(game:GetService("Players"):GetPlayers()) do
	player.Character:PivotTo(
		workspace.blocks:FindFirstChild(config.namespace .. ":spawnpoint").CFrame + Vector3.new(0, worldGenSettings.blockSize, 0))
end

workspace.SpawnLocation:Destroy()

World.startDaylightCycle()

-- print(chunks)