local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()
local venyx = library.new("Dead Rails Ultimate GUI by Grok")

-- Кастомизация размера: Делаем GUI миниатюрным (меньше по размеру)
wait(0.1)  -- Дождаться создания UI
local coreGui = game:GetService("CoreGui")
local venyxGui = coreGui:FindFirstChild("Venyx")  -- Имя ScreenGui Venyx
if venyxGui then
    venyxGui.Main.Size = UDim2.new(0, 300, 0, 200)  -- Миниатюрный размер (ширина 300, высота 200; измени по вкусу)
end

-- Кастомизация: Темы для выделения (изменяй цвета для уникальности)
local themes = {
    Background = Color3.fromRGB(20, 20, 20),
    Glow = Color3.fromRGB(0, 0, 0),
    Accent = Color3.fromRGB(255, 0, 0),
    LightContrast = Color3.fromRGB(30, 30, 30),
    DarkContrast = Color3.fromRGB(10, 10, 10),
    TextColor = Color3.fromRGB(255, 255, 255)
}
venyx.themes = themes

-- Добавляем поддержку перемещения на телефоне (touch drag)
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    venyxGui.Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

venyxGui.Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = venyxGui.Main.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

venyxGui.Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)

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
local MainPage = venyx:addPage("Main", 5012544693)
local MainSection = MainPage:addSection("Core Cheats")

-- Таб для Combat
local CombatPage = venyx:addPage("Combat", 5012544693)
local CombatSection = CombatPage:addSection("Battle Features")

-- Таб для Farming
local FarmingPage = venyx:addPage("Farming", 5012544693)
local FarmingSection = FarmingPage:addSection("Resource Cheats")

-- Таб для Movement
local MovementPage = venyx:addPage("Movement", 5012544693)
local MovementSection = MovementPage:addSection("Mobility Hacks")

-- Таб для Info
local InfoPage = venyx:addPage("Info", 5012544693)
local InfoSection = InfoPage:addSection("Details")

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
        venyx:Notify("Error", "leaderstats or Bonds not found! Use Auto Farm instead.")
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
        player.Character.HumanoidRootPart.CFrame = CFrame.new(1000, 100, 1000)
    end
end

local function closeGUI()
    venyx:toggle()
    wait(0.1)
    venyx = nil
    local coreGui = game:GetService("CoreGui")
    for _, gui in ipairs(coreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name == "Venyx" then
            gui:Destroy()
        end
    end
    npcLockEnabled = false
    espEnabled = false
    aimbotEnabled = false
    godmodeEnabled = false
    speedHackEnabled = false
    autoFarmBondsEnabled = false
    noClipEnabled = false
end

MainSection:addToggle("NPC Lock", false, function(value)
    toggleNPCLock(value)
end)

MainSection:addToggle("ESP (Wallhack)", false, function(value)
    toggleESP(value)
end)

CombatSection:addToggle("Aimbot", false, function(value)
    toggleAimbot(value)
end)

CombatSection:addToggle("Godmode", false, function(value)
    toggleGodmode(value)
end)

FarmingSection:addButton("Infinite Bonds", function()
    setInfiniteBonds()
end)

FarmingSection:addToggle("Auto Farm Bonds", false, function(value)
    toggleAutoFarmBonds(value)
end)

MovementSection:addToggle("Speed Hack", false, function(value)
    toggleSpeedHack(value)
end)

MovementSection:addSlider("Speed Value", 50, 16, 100, function(value)
    speedValue = value
    if speedHackEnabled then
        toggleSpeedHack(true)
    end
end)

MovementSection:addToggle("NoClip", false, function(value)
    toggleNoClip(value)
end)

MovementSection:addButton("TP to End", function()
    tpToEnd()
end)

InfoSection:addLabel("Расширенный GUI для Dead Rails на Venyx UI")
InfoSection:addLabel("Миниатюрный, кастомизируемый через themes")
InfoSection:addLabel("Используй на свой риск!")

InfoSection:addButton("Close GUI", function()
    closeGUI()
end)

venyx:Notify("GUI Loaded", "Venyx UI - миниатюрная и изменяемая, с кнопкой закрытия!")

venyx:SelectPage(venyx.pages[1], true)
