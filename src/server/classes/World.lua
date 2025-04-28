-- Instantiation
local World = {}
World.__index = {}
-- Fields
World.spawnpointPosition = {}

function World.setSpawnPosition(x, y, z)
	World.spawnpointPosition = {
		x = x,
		y = y,
		z = z
	}
end

return World