-- Services
local RS = game:GetService("ReplicatedStorage")
-- Instantiation
local Hud = {}
Hud.__index = Hud
-- Misc
local heartGradients = RS.misc.heartGradients
-- Variables
local NUM_HEARTS, NUM_HUNGER_BARS, NUM_THIRST_BARS = 10, 10, 10
local MAX_HEALTH, MAX_HUNGER, MAX_THIRST = 40, 40, 40
local HEALTH_COLOR = Color3.fromRGB(116, 0, 0)
local HUNGER_COLOR = Color3.fromRGB(111, 78, 55)
local THIRST_COLOR = Color3.fromRGB(31, 81, 255)
local EMPTY_COLOR = Color3.fromRGB(65, 65, 65)

function Hud.new(player)
    local newHud = setmetatable({}, Hud)

    newHud.playerInstance = player

    return newHud
end

function Hud:updateHealthRender(health)
    local hotbar = self.playerInstance.PlayerGui:WaitForChild("mainGui").hotbar

    for _, heart in pairs(hotbar.health:GetChildren()) do
        local gradients = { heart:FindFirstChild("quarter"), heart:FindFirstChild("half"), heart:FindFirstChild("threeFourths") }
        for _, gradient in pairs(gradients) do
            if gradient ~= nil then
                gradient:Destroy()
            end
        end
    end

    local heartsToFill = math.floor(health / (MAX_HEALTH / NUM_HEARTS))
    local partialHeartsToFill = health / (MAX_HEALTH / NUM_HEARTS) - heartsToFill
    local firstHeartToEmpty = math.ceil(heartsToFill + partialHeartsToFill)
    for i = 1, heartsToFill do
        hotbar.health["heart" .. i].BackgroundColor3 = HEALTH_COLOR
    end

    print(partialHeartsToFill)
    if partialHeartsToFill == 0.25 then
        heartGradients.quarter:Clone().Parent = hotbar.health["heart" .. heartsToFill + 1]
        -- uiGradient.Parent = hotbar.health["heart" .. heartsToFill + 1]
    elseif partialHeartsToFill == 0.5 then
        heartGradients.half:Clone().Parent = hotbar.health["heart" .. heartsToFill + 1]
    elseif partialHeartsToFill == 0.75 then
        heartGradients.threeFourths:Clone().Parent = hotbar.health["heart" .. heartsToFill + 1]
    end

    for i = firstHeartToEmpty, NUM_HEARTS do
        if i > 0 then
            hotbar.health["heart" .. i].BackgroundColor3 = EMPTY_COLOR
        end
    end
end

return Hud

        -- local uiGradient = Instance.new("UIGradient")
        -- uiGradient.Color = ColorSequence.new({
        --     ColorSequenceKeypoint.new(0, HEALTH_COLOR),
        --     ColorSequenceKeypoint.new(partialHeartsToFill, HEALTH_COLOR),
        --     ColorSequenceKeypoint.new(partialHeartsToFill + 0.001, EMPTY_COLOR),
        --     ColorSequenceKeypoint.new(1, EMPTY_COLOR)
        -- })