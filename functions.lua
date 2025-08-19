-- Загрузка Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
local Window = Rayfield:CreateWindow({
    Name = "Dead Rails Ultimate GUI by Grok",
    LoadingTitle = "Загружаю...",
    LoadingSubtitle = "Подожди",
    ConfigurationSaving = {Enabled = false}
})

-- Табы
local MainTab = Window:CreateTab("Main")
local CombatTab = Window:CreateTab("Combat")
local FarmingTab = Window:CreateTab("Farming")
local MovementTab = Window:CreateTab("Movement")
local InfoTab = Window:CreateTab("Info")

-- Переменные
local npcLockEnabled = false
local espEnabled = false
local aimbotEnabled = false
local godmodeEnabled = false
local speedHackEnabled = false
local speedValue = 50
local autoFarmBondsEnabled = false
local noClipEnabled = false

-- Функция NPC Lock
local function toggleNPCLock(enable)
    npcLockEnabled = enable
    if enable then
        local player = game.Players.LocalPlayer
        local runService = game:GetService("RunService")
        local camera = workspace.CurrentCamera
        runService.RenderStepped:Connect(function()
            if npcLockEnabled then
                local closestNPC = nil
                local closestDistance = math.huge
                for _, object in ipairs(workspace:GetDescendants()) do
                    if object:IsA("Model") and object:FindFirstChild("Humanoid") and object:FindFirstChild("HumanoidRootPart") and object.Name ~= player.Name then
                        local hrp = object:FindFirstChild("HumanoidRootPart")
                        local distance = (camera.CFrame.Position - hrp.Position).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestNPC = object
                        end
                    end
                end
                if closestNPC then
                    camera.CFrame = CFrame.new(camera.CFrame.Position, closestNPC.HumanoidRootPart.Position)
                end
            end
        end)
    end
end

-- Функция ESP
local highlights = {}
local function toggleESP(enable)
    espEnabled = enable
    if enable then
        for _, object in ipairs(workspace:GetDescendants()) do
            if object:IsA("Model") and object:FindFirstChild("Humanoid") and object:FindFirstChild("HumanoidRootPart") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESPHighlight"
                highlight.FillColor = Color3.new(1, 0, 0)
                highlight.OutlineColor = Color3.new(0, 1, 0)
                highlight.FillTransparency = 0.3
                highlight.OutlineTransparency = 0
                highlight.Parent = object
                table.insert(highlights, highlight)
            end
        end
    else
        for _, hl in ipairs(highlights) do
            hl:Destroy()
        end
        highlights = {}
    end
end

-- Функция Aimbot
local function toggleAimbot(enable)
    aimbotEnabled = enable
    if enable then
        local player = game.Players.LocalPlayer
        local mouse = player:GetMouse()
        game:GetService("RunService").RenderStepped:Connect(function()
            if aimbotEnabled then
                local closest = nil
                local closestDist = math.huge
                for _, p in ipairs(game.Players:GetPlayers()) do
                    if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (mouse.Hit.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closest = p.Character.HumanoidRootPart
                        end
                    end
                end
                if closest then
                    mouse.TargetFilter = closest
                end
            end
        end)
    end
end

-- Функция Godmode
local function toggleGodmode(enable)
    godmodeEnabled = enable
    if enable then
        local player = game.Players.LocalPlayer
        game:GetService("RunService").Heartbeat:Connect(function()
            if godmodeEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.Health = player.Character.Humanoid.MaxHealth
            end
        end)
    end
end

-- Функция Speed Hack
local function toggleSpeedHack(enable)
    speedHackEnabled = enable
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = enable and speedValue or 16
    end
end

-- Функция Infinite Bonds
local function setInfiniteBonds()
    local player = game.Players.LocalPlayer
    local leaderstats = player:WaitForChild("leaderstats")
    local bonds = leaderstats:WaitForChild("Bonds")
    if bonds then
        bonds.Value = 999999
    else
        Rayfield:Notify({Title = "Error", Content = "Bonds not found!", Duration = 3})
    end
end

-- Функция Auto Farm Bonds
local function toggleAutoFarmBonds(enable)
    autoFarmBondsEnabled = enable
    if enable then
        local runService = game:GetService("RunService")
        local player = game.Players.LocalPlayer
        local hrp = player.Character:WaitForChild("HumanoidRootPart")
        runService.Heartbeat:Connect(function()
            if autoFarmBondsEnabled then
                for _, bond in ipairs(workspace:GetDescendants()) do
                    if string.find(bond.Name:lower(), "bond") and (bond:IsA("Part") or bond:IsA("Model")) then
                        hrp.CFrame = bond.CFrame * CFrame.new(0, 3, 0)
                        wait(0.3)
                    end
                end
            end
        end)
    end
end

-- Функция NoClip
local function toggleNoClip(enable)
    noClipEnabled = enable
    local player = game.Players.LocalPlayer
    local runService = game:GetService("RunService")
    if enable then
        runService.Stepped:Connect(function()
            if noClipEnabled and player.Character then
                for _, part in ipairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

-- Функция TP to End
local function tpToEnd()
    local player = game.Players.LocalPlayer
    if player.Character then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(1000, 100, 1000) -- Замени координаты
    end
end

-- Элементы GUI (коротко)
MainTab:CreateToggle({Name = "NPC Lock", CurrentValue = false, Callback = toggleNPCLock})
MainTab:CreateToggle({Name = "ESP", CurrentValue = false, Callback = toggleESP})

CombatTab:CreateToggle({Name = "Aimbot", CurrentValue = false, Callback = toggleAimbot})
CombatTab:CreateToggle({Name = "Godmode", CurrentValue = false, Callback = toggleGodmode})

FarmingTab:CreateButton({Name = "Infinite Bonds", Callback = setInfiniteBonds})
FarmingTab:CreateToggle({Name = "Auto Farm Bonds", CurrentValue = false, Callback = toggleAutoFarmBonds})

MovementTab:CreateToggle({Name = "Speed Hack", CurrentValue = false, Callback = toggleSpeedHack})
MovementTab:CreateSlider({Name = "Speed Value", Range = {16, 100}, Increment = 1, CurrentValue = 50, Callback = function(value) speedValue = value end})
MovementTab:CreateToggle({Name = "NoClip", CurrentValue = false, Callback = toggleNoClip})
MovementTab:CreateButton({Name = "TP to End", Callback = tpToEnd})

InfoTab:CreateParagraph({Title = "Info", Content = "GUI на Rayfield. Используй на риск!"})

-- Уведомление
Rayfield:Notify({Title = "Loaded", Content = "GUI готов", Duration = 5})
