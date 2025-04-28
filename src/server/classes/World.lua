-- Instantiation
local World = {}
World.__index = {}
-- Fields
World.lengthOfDay = 1440
World.timeOfDay = 370
World.daylightCycle = nil
World.spawnpointPosition = {}

function World.setSpawnPosition(x, y, z)
	World.spawnpointPosition = {
		x = x,
		y = y,
		z = z
	}
end

function World.startDaylightCycle()
	if not World.daylightCycle then
		World.daylightCycle = coroutine.create(function()
			while true do
				task.wait(1)
				World.timeOfDay += 1
				game:GetService("Lighting"):SetMinutesAfterMidnight(World.timeOfDay)
			end
		end)
		coroutine.resume(World.daylightCycle)
	end
end

function World.stopDaylightCycle()
	if World.daylightCycle then
		coroutine.close(World.daylightCycle)
	end
end

return World