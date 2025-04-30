-- Services
local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService").Server
-- Classes
local classes = SSS.classes
local Inventory = require(classes.Inventory)
-- Instantiation
local Player = {}
Player.__index = Player
-- Variables
local playersCache = {}

function Player.new(playerInstance)
    local newPlayer = setmetatable({}, Player)

    newPlayer.playerInstance = playerInstance
    newPlayer.inventory = Inventory.new(playerInstance)
    newPlayer.health = 40
    newPlayer.hunger = 40
    newPlayer.thirst = 40

    playersCache["player_" .. playerInstance.UserId] = newPlayer

    return newPlayer
end

function Player:kill()
    -- still needs to be scripted
end

function Player:damageHealth(damageAmount)
    self.health = math.max(self.health - damageAmount, 0)
    if self.health <= 0 then
        self:kill()
    end
end

function Player:updateHudRender(health, hunger, thirst)
    if health == true then health = self.health else health = nil end
    if hunger == true then hunger = self.hunger else hunger = nil end
    if thirst == true then thirst = self.thirst else thirst = nil end
    RS.remotes.updateHudRender:FireClient(self.playerInstance, health, hunger, thirst)
end

function Player.getPlayersCache()
    return playersCache
end

function Player.getPlayerInCache(player)
    print(playersCache["player_" .. player.UserId])
    return playersCache["player_" .. player.UserId]
end

function Player.removePlayerFromCache(player)
    playersCache["player_" .. player.UserId] = nil
end

return Player