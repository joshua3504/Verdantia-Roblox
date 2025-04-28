-- Services
local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
-- Misc
local localPlayer = Players.LocalPlayer
-- Module scripts
local modules = RS.Shared.modules
local Translation = require(modules.Translation)
local util = require(modules.util)
-- GUIs
local mainGui = localPlayer.PlayerGui:WaitForChild("mainGui")
local inventoryFrame = mainGui.inventory
local infoScreen = mainGui.infoScreen
-- Setting up the default settings
UIS.MouseIconEnabled = false
localPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
UIS.MouseBehavior = Enum.MouseBehavior.LockCenter

-- Handles the inventory being opened and closed
UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        inventoryFrame.Visible = not inventoryFrame.Visible
        UIS.MouseIconEnabled = inventoryFrame.Visible

        if inventoryFrame.Visible then
            localPlayer.CameraMode = Enum.CameraMode.Classic
            UIS.MouseBehavior = Enum.MouseBehavior.Default
        else
            localPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
            UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
        end
    end
end)

-- Handles the info screen
coroutine.resume(coroutine.create(function()
    while true do
        task.wait(0.01)
        local hrp = localPlayer.Character.HumanoidRootPart

        if not hrp then
            infoScreen.coordinates.Text = infoScreen.coordinates:GetAttribute("coordinates") .. ":"
            infoScreen.facing.Text = infoScreen.facing:GetAttribute("facing") .. ":"
        else
            -- Handles the coordinates
            local x = util.formatDouble(util.round(hrp.Position.X / 3, 3), 3)
            local y = util.formatDouble(util.round(hrp.Position.Y / 3 - 0.5, 3), 3)
            local z = util.formatDouble(util.round(hrp.Position.Z / 3, 3), 3)
    
            infoScreen.coordinates.Text = infoScreen.coordinates:GetAttribute("coordinates") .. ": " .. x .. ", " .. y .. ", " .. z
            
            -- Handles the direction the player is facing
            local lookVector = hrp.CFrame.LookVector
            local facingDirection
            
            if math.abs(lookVector.X) < math.abs(lookVector.Z) then
                if lookVector.Z < 0 then
                    facingDirection = "north"
                else
                    facingDirection = "south"
                end
            else
                if lookVector.X < 0 then
                    facingDirection = "west"
                else
                    facingDirection = "east"
                end
            end

            infoScreen.facing.Text = infoScreen.facing:GetAttribute("facing") .. ": " .. infoScreen.facing:GetAttribute(facingDirection)
        end

        -- Handles the time of day
        infoScreen.timeOfDay.Text = infoScreen.timeOfDay:GetAttribute("timeOfDay") .. ": " ..
            util.formatTime(game:GetService("Lighting"):GetMinutesAfterMidnight(), false)
    end
end))

-- Handles the translations
local translator = LocalizationService:GetTranslatorForPlayer(localPlayer)
Translation.translate(localPlayer, translator.LocaleId)
translator:GetPropertyChangedSignal("LocaleId"):Connect(function()
	Translation.translate(localPlayer, translator.LocaleId)
end)