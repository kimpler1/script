-- Загрузка Linoria UI Library (высоко кастомизируемая, для уникальности)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()

-- Кастомная тема для выделения (можно менять цвета, добавить градиенты и т.д.)
Library.Themes["CustomTheme"] = {
    AccentColor = Color3.fromRGB(255, 50, 50),  -- Красный акцент
    Background = Color3.fromRGB(20, 20, 20),  -- Тёмный фон
    GroupBackground = Color3.fromRGB(30, 30, 30),
    NavBackground = Color3.fromRGB(40, 40, 40),
    TabBackground = Color3.fromRGB(35, 35, 35),
    TextColor = Color3.fromRGB(255, 255, 255),
    DisabledTextColor = Color3.fromRGB(150, 150, 150),
    -- Добавь градиенты или анимации здесь (используй TweenService для кастома)
}
Library:LoadTheme("CustomTheme")  -- Применяем кастомную тему

-- Создание окна (меньше в 1.5 раза, кастом размер)
local Window = Library:CreateWindow({Title = "Dead Rails Ultimate GUI by Grok", Size = UDim2.fromOffset(400, 300)})  -- Уменьшено от стандартного 600x450

-- Переменные для состояний (остались те же)
local npcLockEnabled = false
local espEnabled = false
local aimbotEnabled = false
local godmodeEnabled = false
local speedHackEnabled = false
local speedValue = 50
local autoFarmBondsEnabled = false
local noClipEnabled = false

-- Табы и группы
local MainTab = Window:AddTab("Main")
local MainGroup = MainTab:AddLeftGroupbox("Core Cheats")

local CombatTab = Window:AddTab("Combat")
local CombatGroup = CombatTab:AddLeftGroupbox("Battle Features")

local FarmingTab = Window:AddTab("Farming")
local FarmingGroup = FarmingTab:AddLeftGroupbox("Resource Cheats")

local MovementTab = Window:AddTab("Movement")
local MovementGroup = MovementTab:AddLeftGroupbox("Mobility Hacks")

local InfoTab = Window:AddTab("Info")
local InfoGroup = InfoTab:AddLeftGroupbox("Details")

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
        Library:Notify("Error: leaderstats or Bonds not found! Use Auto Farm instead.", 3)
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

-- Элементы GUI (адаптировано под Linoria)
MainGroup:AddToggle("NPCLock", {Text = "NPC Lock", Callback = function(Value)
    toggleNPCLock(Value)
end})

MainGroup:AddToggle("ESP", {Text = "ESP (Wallhack)", Callback = function(Value)
    toggleESP(Value)
end})

CombatGroup:AddToggle("Aimbot", {Text = "Aimbot", Callback = function(Value)
    toggleAimbot(Value)
end})

CombatGroup:AddToggle("Godmode", {Text = "Godmode", Callback = function(Value)
    toggleGodmode(Value)
end})

FarmingGroup:AddButton("Infinite Bonds", function()
    setInfiniteBonds()
end)

FarmingGroup:AddToggle("AutoFarmBonds", {Text = "Auto Farm Bonds", Callback = function(Value)
    toggleAutoFarmBonds(Value)
end})

MovementGroup:AddToggle("SpeedHack", {Text = "Speed Hack", Callback = function(Value)
    toggleSpeedHack(Value)
end})

MovementGroup:AddSlider("SpeedValue", {Text = "Speed Value", Min = 16, Max = 100, Default = 50, Callback = function(Value)
    speedValue = Value
    if speedHackEnabled then
        toggleSpeedHack(true)
    end
end})

MovementGroup:AddToggle("NoClip", {Text = "NoClip", Callback = function(Value)
    toggleNoClip(Value)
end})

MovementGroup:AddButton("TP to End", function()
    tpToEnd()
end)

InfoGroup:AddLabel("Расширенный GUI для Dead Rails")
InfoGroup:AddLabel("На Linoria Lib с кастом темой — выделяйся!")
InfoGroup:AddLabel("Используй на свой риск!")

-- Уведомление при запуске
Library:Notify("GUI Loaded", "Linoria Lib с кастомизацией — теперь уникальный дизайн!", 5)
