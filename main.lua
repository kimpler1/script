-- Загрузка Orion Library (customizable UI для Roblox)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Dead Rails Ultimate GUI by Grok", HidePremium = false, SaveConfig = false, ConfigFolder = "DeadRailsConfig"})

-- Кастомная тема для выделения (можно менять цвета, стили)
OrionLib.Themes["Custom"] = {
    Main = Color3.fromRGB(30, 30, 30),  -- Тёмный фон
    Second = Color3.fromRGB(20, 20, 20),  -- Вторичный
    Stroke = Color3.fromRGB(255, 0, 0),  -- Красный контур
    Divider = Color3.fromRGB(50, 50, 50),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(200, 200, 200),
    TabText = Color3.fromRGB(255, 255, 255),
    TabTextDark = Color3.fromRGB(180, 180, 180),
    Tab = Color3.fromRGB(40, 40, 40),
    Background = Color3.fromRGB(25, 25, 25),
    BackgroundDark = Color3.fromRGB(15, 15, 15),
    TabDivider = Color3.fromRGB(255, 0, 0)  -- Красный разделитель
}
OrionLib:SelectTheme("Custom")  -- Применяем кастомную тему

-- Уменьшение размера окна в 1.5 раза (кастом для мобильного)
wait(0.1)
local coreGui = game:GetService("CoreGui")
local orionGui = coreGui:FindFirstChild("Orion")
if orionGui then
    orionGui.Main.Size = UDim2.new(0, 400, 0, 300)  -- Уменьшено от стандартного ~600x450
end

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
local MainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local MainSection = MainTab:AddSection({Name = "Core Cheats"})

-- Таб для Combat
local CombatTab = Window:MakeTab({Name = "Combat", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local CombatSection = CombatTab:AddSection({Name = "Battle Features"})

-- Таб для Farming
local FarmingTab = Window:MakeTab({Name = "Farming", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local FarmingSection = FarmingTab:AddSection({Name = "Resource Cheats"})

-- Таб для Movement
local MovementTab = Window:MakeTab({Name = "Movement", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local MovementSection = MovementTab:AddSection({Name = "Mobility Hacks"})

-- Таб для Info
local InfoTab = Window:MakeTab({Name = "Info", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local InfoSection = InfoTab:AddSection({Name = "Details"})

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
        OrionLib:MakeNotification({Name = "Error", Content = "leaderstats or Bonds not found! Use Auto Farm instead.", Image = "rbxassetid://4483345998", Time = 3})
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

-- Элементы GUI (адаптировано под Orion)
MainSection:AddToggle({Name = "NPC Lock", Default = false, Callback = function(Value)
    toggleNPCLock(Value)
end})

MainSection:AddToggle({Name = "ESP (Wallhack)", Default = false, Callback = function(Value)
    toggleESP(Value)
end})

CombatSection:AddToggle({Name = "Aimbot", Default = false, Callback = function(Value)
    toggleAimbot(Value)
end})

CombatSection:AddToggle({Name = "Godmode", Default = false, Callback = function(Value)
    toggleGodmode(Value)
end})

FarmingSection:AddButton({Name = "Infinite Bonds", Callback = function()
    setInfiniteBonds()
end})

FarmingSection:AddToggle({Name = "Auto Farm Bonds", Default = false, Callback = function(Value)
    toggleAutoFarmBonds(Value)
end})

MovementSection:AddToggle({Name = "Speed Hack", Default = false, Callback = function(Value)
    toggleSpeedHack(Value)
end})

MovementSection:AddSlider({Name = "Speed Value", Min = 16, Max = 100, Increment = 1, Default = 50, Callback = function(Value)
    speedValue = Value
    if speedHackEnabled then
        toggleSpeedHack(true)
    end
end})

MovementSection:AddToggle({Name = "NoClip", Default = false, Callback = function(Value)
    toggleNoClip(Value)
end})

MovementSection:AddButton({Name = "TP to End", Callback = function()
    tpToEnd()
end})

InfoSection:AddLabel("Расширенный GUI для Dead Rails")
InfoSection:AddLabel("На Orion Lib с кастом темой для уникальности!")
InfoSection:AddLabel("Используй на свой риск!")

-- Инициализация и уведомление
OrionLib:Init()
OrionLib:MakeNotification({
    Name = "GUI Loaded",
    Content = "Orion Lib с кастомизацией — теперь выделяешься!",
    Image = "rbxassetid://4483345998",
    Time = 5
})
