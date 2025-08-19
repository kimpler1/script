-- Загрузка Rayfield UI Library (mobile-friendly, с drag на touch)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Dead Rails Ultimate GUI by Grok",
    LoadingTitle = "Загрузка...",
    LoadingSubtitle = "by Grok",
    ConfigurationSaving = {Enabled = false}
})

-- Переменные для состояний
local npcLockEnabled = false
local espEnabled = false
local aimbotEnabled = false
local godmodeEnabled = false
local speedHackEnabled = false
local speedValue = 50
local autoFarmBondsEnabled = false
local noClipEnabled = false

-- Основной таб: Main
local MainTab = Window:CreateTab("Main", nil) -- Иконка опционально
local MainSection = MainTab:CreateSection("Core Cheats")

-- Таб для Combat
local CombatTab = Window:CreateTab("Combat", nil)
local CombatSection = CombatTab:CreateSection("Battle Features")

-- Таб для Farming
local FarmingTab = Window:CreateTab("Farming", nil)
local FarmingSection = FarmingTab:CreateSection("Resource Cheats")

-- Таб для Movement
local MovementTab = Window:CreateTab("Movement", nil)
local MovementSection = MovementTab:CreateSection("Mobility Hacks")

-- Таб для Info
local InfoTab = Window:CreateTab("Info", nil)
local InfoSection = InfoTab:CreateSection("Details")

-- Функции (остались те же)
local function toggleNPCLock(enable)
    npcLockEnabled = enable
    if enable then
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
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

local function toggleAimbot(enable)
    aimbotEnabled = enable
    if enable then
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local mouse = player:GetMouse()
        game:GetService("RunService").RenderStepped:Connect(function()
            if aimbotEnabled then
                local closest = nil
                local closestDist = math.huge
                for _, p in ipairs(Players:GetPlayers()) do
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

local function toggleGodmode(enable)
    godmodeEnabled = enable
    if enable then
        local player = game.Players.LocalPlayer
        local runService = game:GetService("RunService")
        runService.Heartbeat:Connect(function()
            if godmodeEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.Health = player.Character.Humanoid.MaxHealth
            end
        end)
    end
end

local function toggleSpeedHack(enable)
    speedHackEnabled = enable
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        if enable then
            player.Character.Humanoid.WalkSpeed = speedValue
        else
            player.Character.Humanoid.WalkSpeed = 16
        end
    end
end

local function setInfiniteBonds()
    local player = game.Players.LocalPlayer
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats and leaderstats:FindFirstChild("Bonds") then
        leaderstats.Bonds.Value = 999999
    else
        Rayfield:Notify({
            Title = "Error",
            Content = "leaderstats or Bonds not found! Use Auto Farm instead.",
            Duration = 3
        })
    end
end

local function toggleAutoFarmBonds(enable)
    autoFarmBondsEnabled = enable
    if enable then
        local runService = game:GetService("RunService")
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        runService.Heartbeat:Connect(function()
            if autoFarmBondsEnabled then
                for _, bond in ipairs(workspace:GetDescendants()) do
                    if string.find(bond.Name:lower(), "bond") and (bond:IsA("Part") or bond:IsA("Model")) then
                        bond.CFrame = hrp.CFrame * CFrame.new(0, 0, -2)
                        wait(0.2)
                    end
                end
            end
        end)
    end
end

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

local function tpToEnd()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(1000, 100, 1000)  -- Замени на реальные координаты
    end
end

-- Элементы GUI (адаптировано под Rayfield)
MainSection:CreateToggle({
    Name = "NPC Lock",
    CurrentValue = false,
    Callback = function(Value)
        toggleNPCLock(Value)
    end
})

MainSection:CreateToggle({
    Name = "ESP (Wallhack)",
    CurrentValue = false,
    Callback = function(Value)
        toggleESP(Value)
    end
})

CombatSection:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Callback = function(Value)
        toggleAimbot(Value)
    end
})

CombatSection:CreateToggle({
    Name = "Godmode",
    CurrentValue = false,
    Callback = function(Value)
        toggleGodmode(Value)
    end
})

FarmingSection:CreateButton({
    Name = "Infinite Bonds",
    Callback = function()
        setInfiniteBonds()
    end
})

FarmingSection:CreateToggle({
    Name = "Auto Farm Bonds",
    CurrentValue = false,
    Callback = function(Value)
        toggleAutoFarmBonds(Value)
    end
})

MovementSection:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Callback = function(Value)
        toggleSpeedHack(Value)
    end
})

MovementSection:CreateSlider({
    Name = "Speed Value",
    Range = {16, 100},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 50,
    Callback = function(Value)
        speedValue = Value
        if speedHackEnabled then
            toggleSpeedHack(true)
        end
    end
})

MovementSection:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Callback = function(Value)
        toggleNoClip(Value)
    end
})

MovementSection:CreateButton({
    Name = "TP to End",
    Callback = function()
        tpToEnd()
    end
})

InfoSection:CreateLabel("Расширенный GUI для Dead Rails")
InfoSection:CreateLabel("На Rayfield UI — draggable на mobile!")
InfoSection:CreateLabel("Используй на свой риск!")

-- Уведомление при запуске
Rayfield:Notify({
    Title = "GUI Loaded",
    Content = "Теперь с drag на телефоне и уменьшенным размером!",
    Duration = 5
})
