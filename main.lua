local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

if not LocalPlayer then
    warn("Скрипт не может найти локального игрока. Попробуйте перезапустить игру.")
    return
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeadRailsGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)  -- Уменьшен для миниатюрности
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Visible = true
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local dragging, dragInput, dragStart, startPos
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

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 100, 1, 0)
TabContainer.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame
local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 10)
TabCorner.Parent = TabContainer

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(0, 200, 1, 0)  -- Уменьшен для миниатюрности
ContentFrame.Position = UDim2.new(0, 100, 0, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame
local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = ContentFrame

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -70, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "▲"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 0)
MinimizeButton.TextScaled = true
MinimizeButton.Parent = MainFrame
local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 5)
MinimizeCorner.Parent = MinimizeButton

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 0)
CloseButton.TextScaled = true
CloseButton.Parent = MainFrame
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseButton

local MinimizedFrame = Instance.new("Frame")
MinimizedFrame.Size = UDim2.new(0, 65, 0, 30)
MinimizedFrame.Position = UDim2.new(1, -75, 0, 5)
MinimizedFrame.BackgroundTransparency = 1
MinimizedFrame.Parent = ScreenGui
MinimizedFrame.Visible = false

local MaximizeButton = Instance.new("TextButton")
MaximizeButton.Size = UDim2.new(0, 30, 0, 30)
MaximizeButton.Position = UDim2.new(0, 0, 0, 0)
MaximizeButton.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
MaximizeButton.BorderSizePixel = 0
MaximizeButton.Text = "▼"
MaximizeButton.TextColor3 = Color3.fromRGB(255, 255, 0)
MaximizeButton.TextScaled = true
MaximizeButton.Parent = MinimizedFrame
local MaximizeCorner = Instance.new("UICorner")
MaximizeCorner.CornerRadius = UDim.new(0, 5)
MaximizeCorner.Parent = MaximizeButton

local CloseButtonMinimized = Instance.new("TextButton")
CloseButtonMinimized.Size = UDim2.new(0, 30, 0, 30)
CloseButtonMinimized.Position = UDim2.new(0, 35, 0, 0)
CloseButtonMinimized.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButtonMinimized.BorderSizePixel = 0
CloseButtonMinimized.Text = "X"
CloseButtonMinimized.TextColor3 = Color3.fromRGB(255, 255, 0)
CloseButtonMinimized.TextScaled = true
CloseButtonMinimized.Parent = MinimizedFrame
local CloseMinimizedCorner = Instance.new("UICorner")
CloseMinimizedCorner.CornerRadius = UDim.new(0, 5)
CloseMinimizedCorner.Parent = CloseButtonMinimized

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedFrame.Visible = true
    MinimizeButton.Text = "▼"
    MaximizeButton.Text = "▼"
end)

MaximizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MinimizedFrame.Visible = false
    MinimizeButton.Text = "▲"
    MaximizeButton.Text = "▲"
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

CloseButtonMinimized.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Функции
local npcLockEnabled = false
local function toggleNPCLock()
    npcLockEnabled = not npcLockEnabled
    if npcLockEnabled then
        local runService = game:GetService("RunService")
        local camera = workspace.CurrentCamera
        runService.RenderStepped:Connect(function()
            if npcLockEnabled then
                local closestNPC = nil
                local closestDistance = math.huge
                for _, object in ipairs(workspace:GetDescendants()) do
                    if object:IsA("Model") and object:FindFirstChild("Humanoid") and object:FindFirstChild("HumanoidRootPart") and object.Name ~= LocalPlayer.Name then
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
local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
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

local aimbotEnabled = false
local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        local runService = game:GetService("RunService")
        local mouse = LocalPlayer:GetMouse()
        runService.RenderStepped:Connect(function()
            if aimbotEnabled then
                local closest = nil
                local closestDist = math.huge
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
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

local godmodeEnabled = false
local function toggleGodmode()
    godmodeEnabled = not godmodeEnabled
    if godmodeEnabled then
        local runService = game:GetService("RunService")
        runService.Heartbeat:Connect(function()
            if godmodeEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
            end
        end)
    end
end

local speedHackEnabled = false
local speedValue = 50
local function toggleSpeedHack()
    speedHackEnabled = not speedHackEnabled
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if speedHackEnabled then
            LocalPlayer.Character.Humanoid.WalkSpeed = speedValue
        else
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end

local function setInfiniteBonds()
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats and leaderstats:FindFirstChild("Bonds") then
        leaderstats.Bonds.Value = 999999
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Error", Text = "Bonds not found!", Duration = 3})
    end
end

local autoFarmBondsEnabled = false
local function toggleAutoFarmBonds()
    autoFarmBondsEnabled = not autoFarmBondsEnabled
    if autoFarmBondsEnabled then
        local runService = game:GetService("RunService")
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        runService.Heartbeat:Connect(function()
            if autoFarmBondsEnabled then
                for _, bond in ipairs(workspace:GetDescendants()) do
                    if string.find(bond.Name:lower(), "bond") and (bond:IsA("Part") or bond:IsA("Model")) then
                        bond.CFrame = hrp.CFrame * CFrame.new(0, 0, -2)
                        wait(0.3)
                    end
                end
            end
        end)
    end
end

local noClipEnabled = false
local function toggleNoClip()
    noClipEnabled = not noClipEnabled
    if noClipEnabled then
        local runService = game:GetService("RunService")
        runService.Stepped:Connect(function()
            if noClipEnabled and LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

local function tpToEnd()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1000, 100, 1000)  -- Замени на реальные координаты конца карты
    end
end

local tabs = {"Main", "Combat", "Farming", "Movement", "Info"}
local tabButtons = {}
local currentTab = nil
local sliders = {}

for i, tabName in ipairs(tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, -10, 0, 35)
    TabButton.Position = UDim2.new(0, 5, 0, (i-1)*40)
    TabButton.BackgroundColor3 = Color3.fromRGB(60, 20, 100)
    TabButton.BorderSizePixel = 0
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 0)
    TabButton.TextSize = 12
    TabButton.TextWrapped = true
    TabButton.Parent = TabContainer
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 5)
    ButtonCorner.Parent = TabButton

    table.insert(tabButtons, TabButton)

    TabButton.MouseButton1Click:Connect(function()
        if currentTab then
            currentTab.BackgroundColor3 = Color3.fromRGB(60, 20, 100)
        end
        TabButton.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
        currentTab = TabButton

        for _, slider in pairs(sliders) do
            slider.Visible = false
        end

        if tabName == "Main" then
            sliders.NPCLockSlider.Visible = true
            sliders.ESPSlider.Visible = true
        elseif tabName == "Combat" then
            sliders.AimbotSlider.Visible = true
            sliders.GodmodeSlider.Visible = true
        elseif tabName == "Farming" then
            sliders.InfiniteBondsSlider.Visible = true
            sliders.AutoFarmBondsSlider.Visible = true
        elseif tabName == "Movement" then
            sliders.SpeedHackSlider.Visible = true
            sliders.NoClipSlider.Visible = true
            sliders.TPToEndSlider.Visible = true
        elseif tabName == "Info" then
            sliders.InfoLabel.Visible = true
        end
    end)

    if tabName == "Main" then
        sliders.NPCLockSlider = createSlider(ContentFrame, "NPC Lock", 10, toggleNPCLock, npcLockEnabled, false)
        sliders.ESPSlider = createSlider(ContentFrame, "ESP", 60, toggleESP, espEnabled, false)
        sliders.NPCLockSlider.Visible = false
        sliders.ESPSlider.Visible = false
    elseif tabName == "Combat" then
        sliders.AimbotSlider = createSlider(ContentFrame, "Aimbot", 10, toggleAimbot, aimbotEnabled, false)
        sliders.GodmodeSlider = createSlider(ContentFrame, "Godmode", 60, toggleGodmode, godmodeEnabled, false)
        sliders.AimbotSlider.Visible = false
        sliders.GodmodeSlider.Visible = false
    elseif tabName == "Farming" then
        sliders.InfiniteBondsSlider = createSlider(ContentFrame, "Infinite Bonds", 10, setInfiniteBonds, false, false)
        sliders.AutoFarmBondsSlider = createSlider(ContentFrame, "Auto Farm Bonds", 60, toggleAutoFarmBonds, autoFarmBondsEnabled, false)
        sliders.InfiniteBondsSlider.Visible = false
        sliders.AutoFarmBondsSlider.Visible = false
    elseif tabName == "Movement" then
        sliders.SpeedHackSlider = createSlider(ContentFrame, "Speed Hack", 10, toggleSpeedHack, speedHackEnabled, true)
        sliders.NoClipSlider = createSlider(ContentFrame, "NoClip", 80, toggleNoClip, noClipEnabled, false)
        sliders.TPToEndSlider = createSlider(ContentFrame, "TP to End", 130, tpToEnd, false, false)
        sliders.SpeedHackSlider.Visible = false
        sliders.NoClipSlider.Visible = false
        sliders.TPToEndSlider.Visible = false
    elseif tabName == "Info" then
        sliders.InfoLabel = createSlider(ContentFrame, "Расширенный GUI для Dead Rails", 10, function() end, false, false)
        sliders.InfoLabel.Visible = false
    end
end

if #tabButtons > 0 then
    tabButtons[1].MouseButton1Click:Connect(function()
        tabButtons[1].MouseButton1Click()
    end)()
end

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Скрипт Dead Rails загружен",
    Text = "GUI с новыми функциями для Dead Rails",
    Duration = 5
})
