-- Загрузка DrRay UI Library (кастомизируемая, актуальная в 2025)
local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()

-- Кастомизация для выделения (меняй цвета, добавь градиенты или анимации)
DrRayLibrary.options = {  -- Пример кастом тем
    mainColor = Color3.fromRGB(255, 50, 50),  -- Красный основной цвет
    backgroundColor = Color3.fromRGB(20, 20, 20),  -- Тёмный фон
    accentColor = Color3.fromRGB(255, 100, 100),  -- Акцент
    textColor = Color3.fromRGB(255, 255, 255),  -- Текст белый
    -- Добавь градиенты: используй UIStroke или Tween для кнопок в функциях
}

local window = DrRayLibrary:Load("Dead Rails Ultimate GUI by Grok", "Default")  -- Окно, можно кастомизировать размер

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
local MainTab = DrRayLibrary.newTab("Main", "rbxassetid://4483345998")  -- Иконка опционально

-- Таб для Combat
local CombatTab = DrRayLibrary.newTab("Combat", "rbxassetid://4483345998")

-- Таб для Farming
local FarmingTab = DrRayLibrary.newTab("Farming", "rbxassetid://4483345998")

-- Таб для Movement
local MovementTab = DrRayLibrary.newTab("Movement", "rbxassetid://4483345998")

-- Таб для Info
local InfoTab = DrRayLibrary.newTab("Info", "rbxassetid://4483345998")

-- Функции (остались те же, но с кастом анимациями если нужно)
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
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Error", Text = "leaderstats or Bonds not found! Use Auto Farm instead.", Duration = 3})
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

-- Элементы GUI на DrRay (адаптировано, с кастом)
MainTab.newToggle("NPC Lock", "Автолок на NPC", false, function(state)
    toggleNPCLock(state)
end)

MainTab.newToggle("ESP (Wallhack)", "Выделение через стены", false, function(state)
    toggleESP(state)
end)

CombatTab.newToggle("Aimbot", "Автоприцел", false, function(state)
    toggleAimbot(state)
end)

CombatTab.newToggle("Godmode", "Бессмертие", false, function(state)
    toggleGodmode(state)
end)

FarmingTab.newButton("Infinite Bonds", "Бесконечные бонды", function()
    setInfiniteBonds()
end)

FarmingTab.newToggle("Auto Farm Bonds", "Автосбор бондов", false, function(state)
    toggleAutoFarmBonds(state)
end)

MovementTab.newToggle("Speed Hack", "Увеличение скорости", false, function(state)
    toggleSpeedHack(state)
end)

MovementTab.newSlider("Speed Value", "Значение скорости", 16, 100, 50, false, "Speed", function(value)
    speedValue = value
    if speedHackEnabled then
        toggleSpeedHack(true)
    end
end)

MovementTab.newToggle("NoClip", "Прохождение через стены", false, function(state)
    toggleNoClip(state)
end)

MovementTab.newButton("TP to End", "Телепорт к концу", function()
    tpToEnd()
end)

InfoTab.newLabel("Расширенный GUI для Dead Rails с кастом на DrRay")
InfoTab.newLabel("Выделяйся: меняй цвета в options выше!")
InfoTab.newLabel("Используй на свой риск!")

-- Уведомление при запуске
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "GUI Loaded",
    Text = "DrRay UI с кастомизацией — теперь уникальный!",
    Duration = 5
})
