-- Простой GUI для Dead Rails без внешних библиотек
-- Создан на чистом Roblox Lua для стабильности и кастомизации
-- Draggable на mobile (поддержка touch), с кастомными цветами для выделения
-- Размер компактный, цвета: тёмный фон с красными акцентами

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "DeadRailsGUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)  -- Компактный размер (меньше в 1.5 раза от стандартного)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)  -- Тёмный фон
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Dead Rails Ultimate GUI by Grok"
TitleLabel.TextColor3 = Color3.fromRGB(255, 50, 50)  -- Красный текст
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.Parent = MainFrame

-- Draggable для PC и mobile (touch)
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)

-- Переменные состояний
local npcLockEnabled = false
local espEnabled = false
local aimbotEnabled = false
local godmodeEnabled = false
local speedHackEnabled = false
local speedValue = 50
local autoFarmBondsEnabled = false
local noClipEnabled = false

-- Функции (те же)
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
        player.Character.HumanoidRootPart.CFrame = CFrame.new(1000, 100, 1000)  -- Замени на реальные
    end
end

local function closeGUI()
    ScreenGui:Destroy()
    -- Очистка состояний
    npcLockEnabled = false
    espEnabled = false
    aimbotEnabled = false
    godmodeEnabled = false
    speedHackEnabled = false
    autoFarmBondsEnabled = false
    noClipEnabled = false
end

-- Простые табы как кнопки (переключают visible контейнеров)
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(1, 0, 1, -30)
TabContainer.Position = UDim2.new(0, 0, 0, 30)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0
TabContainer.Parent = MainFrame

-- Контейнеры для секций (скрыты по умолчанию)
local MainSection = Instance.new("Frame")
MainSection.Size = UDim2.new(1, 0, 1, 0)
MainSection.BackgroundTransparency = 1
MainSection.Parent = TabContainer
MainSection.Visible = true  -- По умолчанию Main видим

local CombatSection = Instance.new("Frame")
CombatSection.Size = UDim2.new(1, 0, 1, 0)
CombatSection.BackgroundTransparency = 1
CombatSection.Parent = TabContainer
CombatSection.Visible = false

local FarmingSection = Instance.new("Frame")
FarmingSection.Size = UDim2.new(1, 0, 1, 0)
FarmingSection.BackgroundTransparency = 1
FarmingSection.Parent = TabContainer
FarmingSection.Visible = false

local MovementSection = Instance.new("Frame")
MovementSection.Size = UDim2.new(1, 0, 1, 0)
MovementSection.BackgroundTransparency = 1
MovementSection.Parent = TabContainer
MovementSection.Visible = false

local InfoSection = Instance.new("Frame")
InfoSection.Size = UDim2.new(1, 0, 1, 0)
InfoSection.BackgroundTransparency = 1
InfoSection.Parent = TabContainer
InfoSection.Visible = false

-- Кнопки табов вверху
local TabButtonsFrame = Instance.new("Frame")
TabButtonsFrame.Size = UDim2.new(1, 0, 0, 30)
TabButtonsFrame.Position = UDim2.new(0, 0, 0, 30)
TabButtonsFrame.BackgroundTransparency = 1
TabButtonsFrame.Parent = MainFrame

local function createTabButton(name, section, pos)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.2, 0, 1, 0)
    button.Position = UDim2.new(pos, 0, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = TabButtonsFrame

    local corner = Instance.new("UICorner")
    corner.Parent = button

    button.MouseButton1Click:Connect(function()
        MainSection.Visible = false
        CombatSection.Visible = false
        FarmingSection.Visible = false
        MovementSection.Visible = false
        InfoSection.Visible = false
        section.Visible = true
    end)
end

createTabButton("Main", MainSection, 0)
createTabButton("Combat", CombatSection, 0.2)
createTabButton("Farming", FarmingSection, 0.4)
createTabButton("Movement", MovementSection, 0.6)
createTabButton("Info", InfoSection, 0.8)

-- Функция создания toggle-кнопки
local function createToggle(parent, name, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.Text = name .. ": OFF"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.Parent = button

    local state = false
    button.MouseButton1Click:Connect(function()
        state = not state
        button.Text = name .. ": " .. (state and "ON" or "OFF")
        button.BackgroundColor3 = state and Color3.fromRGB(100, 0, 0) or Color3.fromRGB(40, 40, 40)
        callback(state)
    end)
end

-- Функция создания кнопки
local function createButton(parent, name, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.Parent = button

    button.MouseButton1Click:Connect(callback)
end

-- Функция создания лейбла
local function createLabel(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.Parent = parent
end

-- Добавление элементов в секции
local yOffset = 0

-- Main Section
yOffset = 0
createToggle(MainSection, "NPC Lock", toggleNPCLock)
MainSection["NPC Lock"].Position = UDim2.new(0, 10, 0, yOffset)
yOffset = yOffset + 35
createToggle(MainSection, "ESP (Wallhack)", toggleESP)
MainSection["ESP (Wallhack)"].Position = UDim2.new(0, 10, 0, yOffset)

-- Combat Section
yOffset = 0
createToggle(CombatSection, "Aimbot", toggleAimbot)
CombatSection["Aimbot"].Position = UDim2.new(0, 10, 0, yOffset)
yOffset = yOffset + 35
createToggle(CombatSection, "Godmode", toggleGodmode)
CombatSection["Godmode"].Position = UDim2.new(0, 10, 0, yOffset)

-- Farming Section
yOffset = 0
createButton(FarmingSection, "Infinite Bonds", setInfiniteBonds)
FarmingSection["Infinite Bonds"].Position = UDim2.new(0, 10, 0, yOffset)
yOffset = yOffset + 35
createToggle(FarmingSection, "Auto Farm Bonds", toggleAutoFarmBonds)
FarmingSection["Auto Farm Bonds"].Position = UDim2.new(0, 10, 0, yOffset)

-- Movement Section
yOffset = 0
createToggle(MovementSection, "Speed Hack", toggleSpeedHack)
MovementSection["Speed Hack"].Position = UDim2.new(0, 10, 0, yOffset)
yOffset = yOffset + 35

-- Простой "слайдер" для скорости: кнопки +10/-10 и лейбл
local speedLabel = createLabel(MovementSection, "Speed: 50")
speedLabel.Position = UDim2.new(0, 10, 0, yOffset)
yOffset = yOffset + 25
createButton(MovementSection, "+10 Speed", function()
    speedValue = math.min(speedValue + 10, 100)
    speedLabel.Text = "Speed: " .. speedValue
    if speedHackEnabled then toggleSpeedHack(true) end
end)
MovementSection["+10 Speed"].Size = UDim2.new(0.5, -5, 0, 30)
MovementSection["+10 Speed"].Position = UDim2.new(0, 10, 0, yOffset)

createButton(MovementSection, "-10 Speed", function()
    speedValue = math.max(speedValue - 10, 16)
    speedLabel.Text = "Speed: " .. speedValue
    if speedHackEnabled then toggleSpeedHack(true) end
end)
MovementSection["-10 Speed"].Size = UDim2.new(0.5, -5, 0, 30)
MovementSection["-10 Speed"].Position = UDim2.new(0.5, 0, 0, yOffset)
yOffset = yOffset + 35

createToggle(MovementSection, "NoClip", toggleNoClip)
MovementSection["NoClip"].Position = UDim2.new(0, 10, 0, yOffset)
yOffset = yOffset + 35
createButton(MovementSection, "TP to End", tpToEnd)
MovementSection["TP to End"].Position = UDim2.new(0, 10, 0, yOffset)

-- Info Section
yOffset = 0
createLabel(InfoSection, "Расширенный GUI для Dead Rails")
InfoSection[1].Position = UDim2.new(0, 10, 0, yOffset)
yOffset = yOffset + 25
createLabel(InfoSection, "Без библиотек — стабильный и кастомный!")
InfoSection[2].Position = UDim2.new(0, 10, 0, yOffset)
yOffset = yOffset + 25
createLabel(InfoSection, "Используй на свой риск!")
InfoSection[3].Position = UDim2.new(0, 10, 0, yOffset)
yOffset = yOffset + 35
createButton(InfoSection, "Close GUI", closeGUI)
InfoSection["Close GUI"].Position = UDim2.new(0, 10, 0, yOffset)
InfoSection["Close GUI"].BackgroundColor3 = Color3.fromRGB(100, 0, 0)  -- Тёмно-красный для выделения

-- Уведомление при запуске
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "GUI Loaded",
    Text = "Простой GUI без библиотек — draggable на mobile!",
    Duration = 5
})
