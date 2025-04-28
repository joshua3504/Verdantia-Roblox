local lang = game:GetService("ReplicatedStorage").Shared.lang
local langFiles = {
    en_us = require(lang.en_us),
    es_es = require(lang.es_es)
}
local Translation = {}

function Translation.translate(player, langCode)
    local mainGui = player.PlayerGui:WaitForChild("mainGui")
    local langFile = langFiles[langCode] or langFiles.en_us

    mainGui.infoScreen.coordinates:SetAttribute("coordinates", langFile.infoScreen.coordinates)
    mainGui.infoScreen.facing:SetAttribute("facing", langFile.infoScreen.facing)
    mainGui.infoScreen.facing:SetAttribute("east", langFile.infoScreen.directions.east)
    mainGui.infoScreen.facing:SetAttribute("north", langFile.infoScreen.directions.north)
    mainGui.infoScreen.facing:SetAttribute("south", langFile.infoScreen.directions.south)
    mainGui.infoScreen.facing:SetAttribute("west", langFile.infoScreen.directions.west)
end

return Translation