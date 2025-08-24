local Camera = workspace.CurrentCamera
local espMobsEnabled = false
local espPlayersEnabled = false
local ESPMobsObjects = {}
local ESPPlayersObjects = {}
local function isMob(model)
    return model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") and model:FindFirstChild("Head") and not Players:GetPlayerFromCharacter(model)
end
local function isPlayer(model)
    return model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") and model:FindFirstChild("Head") and Players:GetPlayerFromCharacter(model)
end
local function CreateESPForMob(model)
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.Adornee = model
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = false
    highlight.Parent = model

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPText"
    billboard.Adornee = model.Head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = false
    billboard.Parent = model.Head

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextSize = 10
    textLabel.Text = ""
    textLabel.Parent = billboard

    ESPMobsObjects[model] = {Highlight = highlight, Billboard = billboard, TextLabel = textLabel}

    model.AncestryChanged:Connect(function()
        if not model:IsDescendantOf(workspace) then
            if ESPMobsObjects[model] then
                if ESPMobsObjects[model].Billboard then
                    ESPMobsObjects[model].Billboard:Destroy()
                end
                if ESPMobsObjects[model].Highlight then
                    ESPMobsObjects[model].Highlight:Destroy()
                end
                ESPMobsObjects[model] = nil
            end
        end
    end)
end
local function CreateESPForPlayer(model)
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.Adornee = model
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color3.fromRGB(0, 255, 0)  -- Green for players
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = false
    highlight.Parent = model

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPText"
    billboard.Adornee = model.Head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = false
    billboard.Parent = model.Head

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextSize = 10
    textLabel.Text = ""
    textLabel.Parent = billboard

    ESPPlayersObjects[model] = {Highlight = highlight, Billboard = billboard, TextLabel = textLabel}

    model.AncestryChanged:Connect(function()
        if not model:IsDescendantOf(workspace) then
            if ESPPlayersObjects[model] then
                if ESPPlayersObjects[model].Billboard then
                    ESPPlayersObjects[model].Billboard:Destroy()
                end
                if ESPPlayersObjects[model].Highlight then
                    ESPPlayersObjects[model].Highlight:Destroy()
                end
                ESPPlayersObjects[model] = nil
            end
        end
    end)
end
local function toggleESPMobs()
    espMobsEnabled = not espMobsEnabled
    if not espMobsEnabled then
        for _, espObject in pairs(ESPMobsObjects) do
            espObject.Highlight.Enabled = false
            espObject.Billboard.Enabled = false
        end
    end
end
local function toggleESPPlayers()
    espPlayersEnabled = not espPlayersEnabled
    if not espPlayersEnabled then
        for _, espObject in pairs(ESPPlayersObjects) do
            espObject.Highlight.Enabled = false
            espObject.Billboard.Enabled = false
        end
    end
end
-- Заглушки для других функций (замени на реальный код)
local function toggleAimbot()
    print("Aimbot toggled - implement me")
end
local function toggleGodmode()
    print("Godmode toggled - implement me")
end
local function setInfiniteBonds()
    print("Infinite Bonds set - implement me")
end
local function toggleAutoFarmBonds()
    print("Auto Farm Bonds toggled - implement me")
end
local function toggleSpeedHack()
    print("Speed Hack toggled - implement me")
end
local function toggleNoClip()
    print("NoClip toggled - implement me")
end
local function tpToEnd()
    print("TP to End - implement me")
end
-- Scan for existing mobs and players
for _, model in ipairs(workspace:GetDescendants()) do
    if isMob(model) then
        CreateESPForMob(model)
    elseif isPlayer(model) then
        CreateESPForPlayer(model)
    end
end
-- Listen for new models
workspace.DescendantAdded:Connect(function(desc)
    if isMob(desc) then
        CreateESPForMob(desc)
    elseif isPlayer(desc) then
        CreateESPForPlayer(desc)
    end
end)
-- Update ESP on each frame
RunService.RenderStepped:Connect(function()
    -- Update Mobs ESP
    if espMobsEnabled then
        for model, espObject in pairs(ESPMobsObjects) do
            local humanoid = model:FindFirstChild("Humanoid")
            local root = model:FindFirstChild("HumanoidRootPart")
            local head = model:FindFirstChild("Head")
            if humanoid and root and head and humanoid.Health > 0 then
                local _, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local dist = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude) or math.huge
                    if dist <= 5000 then
                        espObject.Highlight.Enabled = true
                        espObject.Billboard.Enabled = true
                        espObject.TextLabel.Text = model.Name .. " [" .. math.floor(dist) .. "]"
                    else
                        espObject.Highlight.Enabled = false
                        espObject.Billboard.Enabled = false
                    end
                else
                    espObject.Highlight.Enabled = false
                    espObject.Billboard.Enabled = false
                end
            else
                espObject.Highlight.Enabled = false
                espObject.Billboard.Enabled = false
            end
        end
    end

    -- Update Players ESP
    if espPlayersEnabled then
        for model, espObject in pairs(ESPPlayersObjects) do
            local humanoid = model:FindFirstChild("Humanoid")
            local root = model:FindFirstChild("HumanoidRootPart")
            local head = model:FindFirstChild("Head")
            if humanoid and root and head and humanoid.Health > 0 then
                local _, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local dist = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude) or math.huge
                    if dist <= 5000 then
                        espObject.Highlight.Enabled = true
                        espObject.Billboard.Enabled = true
                        espObject.TextLabel.Text = model.Name .. " [" .. math.floor(dist) .. "]"
                    else
                        espObject.Highlight.Enabled = false
                        espObject.Billboard.Enabled = false
                    end
                else
                    espObject.Highlight.Enabled = false
                    espObject.Billboard.Enabled = false
                end
            else
                espObject.Highlight.Enabled = false
                espObject.Billboard.Enabled = false
            end
        end
    end
end)

-- Экспорт функций
return {
    toggleESPMobs = toggleESPMobs,
    toggleESPPlayers = toggleESPPlayers,
    toggleAimbot = toggleAimbot,
    toggleGodmode = toggleGodmode,
    setInfiniteBonds = setInfiniteBonds,
    toggleAutoFarmBonds = toggleAutoFarmBonds,
    toggleSpeedHack = toggleSpeedHack,
    toggleNoClip = toggleNoClip,
    tpToEnd = tpToEnd
}
