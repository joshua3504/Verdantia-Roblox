-- Services
local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UIS = game:GetService("UserInputService")
-- Misc
local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()
local remotes = RS.remotes
-- Module scripts
local modules = RS.Shared.modules
local config = require(modules.config)
local Hud = require(modules.Hud)
local Translation = require(modules.Translation)
local util = require(modules.util)
-- GUIs
local mainGui = localPlayer.PlayerGui:WaitForChild("mainGui")
local inventoryFrame = mainGui.inventory
local infoScreen = mainGui.infoScreen
-- Variables
local inventoryOpen = false
-- Setting up the default settings
UIS.MouseIconEnabled = false
localPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
local playerHud = Hud.new(localPlayer)

-- Handles the inventory being opened and closed
UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        inventoryOpen = not inventoryOpen
        UIS.MouseIconEnabled = inventoryOpen

        if inventoryOpen then
            inventoryFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            localPlayer.CameraMode = Enum.CameraMode.Classic
            UIS.MouseBehavior = Enum.MouseBehavior.Default
        else
            inventoryFrame.Position = UDim2.new(0.5, 0, -0.75, 0)
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

-- Handles the block the player is hovering over being highlighted
local currentHoveredBlock

RunService.PreRender:Connect(function()
    if mouse.Target then
        if mouse.Target ~= currentHoveredBlock then
            if currentHoveredBlock then
                currentHoveredBlock:FindFirstChildOfClass("Highlight"):Destroy()
                currentHoveredBlock = nil
            end

            if mouse.Target.Parent == workspace.blocks and mouse.Target.Transparency < 1 then    
                if (mouse.Target.Position - localPlayer.Character.PrimaryPart.Position).magnitude < config.reachDistance * config.blockSize then    
                    local highlight = RS.misc.blockHighlight:Clone()
                    highlight.Parent = mouse.Target
                    currentHoveredBlock = mouse.Target
                end
            end
        end
    end
end)

-- Handles block breaking
local blockBeingBroken = nil
mouse.Button1Down:Connect(function()
    if currentHoveredBlock ~= nil and blockBeingBroken == nil then
        if currentHoveredBlock:GetAttribute("unbreakable") ~= true then
            blockBeingBroken = currentHoveredBlock

            local steps = 20
            local stepTime = currentHoveredBlock:GetAttribute("breakSpeed") / steps
            
            for i = 1, steps do
                if blockBeingBroken ~= nil then
                    currentHoveredBlock.Transparency = util.ceil(i / steps, 2)
                    task.wait(stepTime)
                else
                    return
                end
            end

            if blockBeingBroken then blockBeingBroken:SetAttribute("isBroken", true) end
            remotes.breakBlock:FireServer(blockBeingBroken)
            blockBeingBroken = nil
        end
    end
end)

mouse.Button1Up:Connect(function()
    if blockBeingBroken ~= nil then
        if blockBeingBroken:GetAttribute("isBroken") ~= true then
            blockBeingBroken.Transparency = 0
            blockBeingBroken = nil
        end
    end
end)

-- Handles updating the blocks in the inventory
remotes.updateInventoryRender.OnClientEvent:Connect(function(inventory)
    for i, slot in pairs(inventory.hotbar.slots) do
        RS.items[slot]:Clone().Parent = mainGui.hotbar.hotbar[i].ViewportFrame
        RS.items[slot]:Clone().Parent = inventoryFrame.container.hotbar[i].ViewportFrame
    end
end)

-- Handles updating the HUD
remotes.updateHudRender.OnClientEvent:Connect(function(health, hunger, thirst)
    if health ~= nil then
        playerHud:updateHealthRender(health)
    end
end)

-- Handles the translations
local translator = LocalizationService:GetTranslatorForPlayer(localPlayer)
Translation.translate(localPlayer, translator.LocaleId)
translator:GetPropertyChangedSignal("LocaleId"):Connect(function()
	Translation.translate(localPlayer, translator.LocaleId)
end)