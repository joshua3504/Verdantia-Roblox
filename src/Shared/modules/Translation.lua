local lang = game:GetService("ReplicatedStorage").Shared.lang
local langFiles = {
    en_us = require(lang.en_us),
    es_es = require(lang.es_es)
}
local Translation = {}

function Translation.translate(player, langCode)
    langCode = langCode:gsub("-", "_"):lower()
    local infoScreen = player.PlayerGui:WaitForChild("mainGui").infoScreen
    local langFile = langFiles[langCode] or langFiles.en_us

    infoScreen.coordinates:SetAttribute("coordinates", langFile.infoScreen.coordinates)
    infoScreen.facing:SetAttribute("facing", langFile.infoScreen.facing)
    infoScreen.facing:SetAttribute("east", langFile.infoScreen.directions.east)
    infoScreen.facing:SetAttribute("north", langFile.infoScreen.directions.north)
    infoScreen.facing:SetAttribute("south", langFile.infoScreen.directions.south)
    infoScreen.facing:SetAttribute("west", langFile.infoScreen.directions.west)
end

return Translation