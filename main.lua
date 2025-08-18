-- Загрузка Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Dead Rails Ultimate GUI by Grok", "BloodTheme")  -- Красивая тема BloodTheme

-- Переменные для состояний
local npcLockEnabled = false
local espEnabled = false
local aimbotEnabled = false
local godmodeEnabled = false
local speedHackEnabled = false
local speedValue = 50
local infiniteBondsEnabled = false
local autoFarmBondsEnabled = false
local noClipEnabled = false

-- Основной таб: Main Functions
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Core Cheats")

-- Таб для Combat
local CombatTab = Window:NewTab("Combat")
local CombatSection = CombatTab:NewSection("Battle Features")

-- Таб для Farming
local FarmingTab = Window:NewTab("Farming")
local FarmingSection = FarmingTab:NewSection("Resource Cheats")

-- Таб для Movement
local MovementTab = Window:NewTab("Movement")
local MovementSection = MovementTab:NewSection("Mobility Hacks")

-- Функция NPC Lock (из оригинального скрипта, адаптировано)
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

-- Функция ESP (с кастомным цветом)
local highlights = {}
local function toggleESP(enable)
    espEnabled = enable
    if enable then
        for _, object in ipairs(workspace:GetDescendants()) do
            if object:IsA("Model") and object:FindFirstChild("Humanoid") and object:FindFirstChild("HumanoidRootPart") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESPHighlight"
                highlight.FillColor = Color3.new(1, 0, 0)  -- Красный для стиля
                highlight.OutlineColor = Color3.new(0, 1, 0)  -- Зелёный контур
                highlight.FillTransparency = 0.3  -- Меньше прозрачности для яркости
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

-- Новая функция: Godmode (бессмертие)
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

-- Новая функция: Speed Hack (с слайдером)
local function toggleSpeedHack(enable)
    speedHackEnabled = enable
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        if enable then
            player.Character.Humanoid.WalkSpeed = speedValue
        else
            player.Character.Humanoid.WalkSpeed = 16  -- Стандартная скорость
        end
    end
end

-- Новая функция: Infinite Bonds (бесконечные бонды)
local function setInfiniteBonds()
    local player = game.Players.LocalPlayer
    if player:FindFirstChild("Data") and player.Data:FindFirstChild("Bonds") then  -- Предполагаемый путь; измени если нужно
        player.Data.Bonds.Value = 999999
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Error", Text = "Bonds not found!", Duration = 3})
    end
end

-- Новая функция: Auto Farm Bonds (автосбор; placeholder, адаптируй под игру)
local function toggleAutoFarmBonds(enable)
    autoFarmBondsEnabled = enable
    if enable then
        local runService = game:GetService("RunService")
        runService.Heartbeat:Connect(function()
            if autoFarmBondsEnabled then
                -- Placeholder: Автосбор бондов (ищи и телепортируйся к ним)
                for _, bond in ipairs(workspace:GetDescendants()) do
                    if bond.Name == "Bond" and bond:IsA("Part") then  -- Предполагаемое имя
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = bond.CFrame
                        wait(0.5)  -- Задержка
                    end
                end
            end
        end)
    end
end

-- Новая функция: NoClip (прохождение через стены)
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

-- Новая функция: TP to End (телепорт к концу; placeholder координаты)
local function tpToEnd()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(1000, 100, 1000)  -- Замени на реальные координаты конца карты
    end
end

-- Элементы GUI
MainSection:NewToggle("NPC Lock", "Автолок на NPC", function(state)
    toggleNPCLock(state)
end)

MainSection:NewToggle("ESP (Wallhack)", "Выделение через стены", function(state)
    toggleESP(state)
end)

CombatSection:NewToggle("Aimbot", "Автоприцел", function(state)
    toggleAimbot(state)
end)

CombatSection:NewToggle("Godmode", "Бессмертие", function(state)
    toggleGodmode(state)
end)

FarmingSection:NewButton("Infinite Bonds", "Бесконечные бонды", function()
    setInfiniteBonds()
end)

FarmingSection:NewToggle("Auto Farm Bonds", "Автосбор бондов", function(state)
    toggleAutoFarmBonds(state)
end)

MovementSection:NewToggle("Speed Hack", "Увеличение скорости", function(state)
    toggleSpeedHack(state)
end)

MovementSection:NewSlider("Speed Value", "Значение скорости", 100, 16, function(value)
    speedValue = value
    if speedHackEnabled then
        toggleSpeedHack(true)  -- Обновить
    end
end)

MovementSection:NewToggle("NoClip", "Прохождение через стены", function(state)
    toggleNoClip(state)
end)

MovementSection:NewButton("TP to End", "Телепорт к концу", function()
    tpToEnd()
end)

-- Таб для Info
local InfoTab = Window:NewTab("Info")
local InfoSection = InfoTab:NewSection("Details")
InfoSection:NewLabel("Расширенный GUI для Dead Rails с новыми функциями")
InfoSection:NewLabel("Тема: BloodTheme для стиля")
InfoSection:NewLabel("Используй на свой риск!")

-- Уведомление
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "GUI Updated",
    Text = "Dead Rails Cheats с новыми функциями и красивым видом!",
    Duration = 5
})
