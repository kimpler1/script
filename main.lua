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
MainFrame.Size = UDim2.new(0, 300, 0, 225)  -- Уменьшено на 25% от 400x300
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -112)
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
TabContainer.Size = UDim2.new(0, 75, 1, 0)  -- Уменьшено на 25% от 100
TabContainer.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame
local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 10)
TabCorner.Parent = TabContainer

local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(0, 225, 1, 0)  -- Уменьшено на 25% от 300
ContentFrame.Position = UDim2.new(0, 75, 0, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.ScrollBarThickness = 8  -- Уменьшено на 25% от 10
ContentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = ContentFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)  -- Уменьшено на 25% от 5
UIListLayout.Parent = ContentFrame

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 23, 0, 23)  -- Уменьшено на 25% от 30
MinimizeButton.Position = UDim2.new(1, -52, 0, 4)  -- Адаптировано
MinimizeButton.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "▲"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 0)
MinimizeButton.TextScaled = true
MinimizeButton.Parent = MainFrame
local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 4)  -- Уменьшено
MinimizeCorner.Parent = MinimizeButton

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 23, 0, 23)
CloseButton.Position = UDim2.new(1, -26, 0, 4)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 0)
CloseButton.TextScaled = true
CloseButton.Parent = MainFrame
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseButton

local MinimizedFrame = Instance.new("Frame")
MinimizedFrame.Size = UDim2.new(0, 49, 0, 23)  -- Уменьшено от 65x30
MinimizedFrame.Position = UDim2.new(1, -56, 0, 4)
MinimizedFrame.BackgroundTransparency = 1
MinimizedFrame.Parent = ScreenGui
MinimizedFrame.Visible = false

local MaximizeButton = Instance.new("TextButton")
MaximizeButton.Size = UDim2.new(0, 23, 0, 23)
MaximizeButton.Position = UDim2.new(0, 0, 0, 0)
MaximizeButton.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
MaximizeButton.BorderSizePixel = 0
MaximizeButton.Text = "▼"
MaximizeButton.TextColor3 = Color3.fromRGB(255, 255, 0)
MaximizeButton.TextScaled = true
MaximizeButton.Parent = MinimizedFrame
local MaximizeCorner = Instance.new("UICorner")
MaximizeCorner.CornerRadius = UDim.new(0, 4)
MaximizeCorner.Parent = MaximizeButton

local CloseButtonMinimized = Instance.new("TextButton")
CloseButtonMinimized.Size = UDim2.new(0, 23, 0, 23)
CloseButtonMinimized.Position = UDim2.new(0, 26, 0, 0)
CloseButtonMinimized.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButtonMinimized.BorderSizePixel = 0
CloseButtonMinimized.Text = "X"
CloseButtonMinimized.TextColor3 = Color3.fromRGB(255, 255, 0)
CloseButtonMinimized.TextScaled = true
CloseButtonMinimized.Parent = MinimizedFrame
local CloseMinimizedCorner = Instance.new("UICorner")
CloseMinimizedCorner.CornerRadius = UDim.new(0, 4)
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

local function createSlider(parent, labelText, toggleFunction, enabledFlag, hasSpeedSlider)
    local containerHeight = hasSpeedSlider and 45 or 30  -- Уменьшено на 25% от 60/40
    local SliderContainer = Instance.new("Frame")
    SliderContainer.Size = UDim2.new(1, -15, 0, containerHeight)  -- Уменьшено от 280 to 210, but since relative, adjust
    SliderContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    SliderContainer.BackgroundTransparency = 0.5
    SliderContainer.BorderSizePixel = 0
    SliderContainer.Parent = parent
    local SliderContainerCorner = Instance.new("UICorner")
    SliderContainerCorner.CornerRadius = UDim.new(0, 4)  -- Уменьшено
    SliderContainerCorner.Parent = SliderContainer

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 105, 0, 15)  -- Уменьшено от 140x20
    Label.Position = hasSpeedSlider and UDim2.new(0, 8, 0, 4) or UDim2.new(0, 8, 0, 8)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 9  -- Уменьшено от 12
    Label.TextWrapped = true
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderContainer

    local SliderBackground = Instance.new("Frame")
    SliderBackground.Size = UDim2.new(0, 32, 0, 13)  -- Уменьшено от 43x17
    SliderBackground.Position = hasSpeedSlider and UDim2.new(1, -45, 0, 4) or UDim2.new(1, -45, 0, 9)
    SliderBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SliderBackground.BorderSizePixel = 0
    SliderBackground.Parent = SliderContainer
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)  -- Уменьшено
    SliderCorner.Parent = SliderBackground

    local SliderKnob = Instance.new("TextButton")
    SliderKnob.Size = UDim2.new(0, 20, 0, 20)  -- Уменьшено от 26
    SliderKnob.Position = UDim2.new(0, 0, 0, -4)
    SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderKnob.BorderSizePixel = 0
    SliderKnob.Text = ""
    SliderKnob.Parent = SliderBackground
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(0, 11)  -- Уменьшено
    KnobCorner.Parent = SliderKnob

    local isEnabled = enabledFlag
    SliderKnob.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        local newPos = isEnabled and UDim2.new(1, -20, 0, -4) or UDim2.new(0, 0, 0, -4)
        local newColor = isEnabled and Color3.fromRGB(75, 0, 130) or Color3.fromRGB(50, 50, 50)
        local knobColor = isEnabled and Color3.fromRGB(150, 150, 150) or Color3.fromRGB(255, 255, 255)
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        TweenService:Create(SliderKnob, tweenInfo, {Position = newPos, BackgroundColor3 = knobColor}):Play()
        TweenService:Create(SliderBackground, tweenInfo, {BackgroundColor3 = newColor}):Play()
        toggleFunction()
    end)

    if hasSpeedSlider then
        local SpeedSliderBackground = Instance.new("Frame")
        SpeedSliderBackground.Size = UDim2.new(0, 195, 0, 8)  -- Уменьшено от 260x10
        SpeedSliderBackground.Position = UDim2.new(0, 8, 0, 30)  -- Уменьшено от 10,40
        SpeedSliderBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        SpeedSliderBackground.BackgroundTransparency = 0.5
        SpeedSliderBackground.BorderSizePixel = 0
        SpeedSliderBackground.Parent = SliderContainer
        local SpeedSliderCorner = Instance.new("UICorner")
        SpeedSliderCorner.CornerRadius = UDim.new(0, 4)
        SpeedSliderCorner.Parent = SpeedSliderBackground

        local SpeedSliderKnob = Instance.new("TextButton")
        SpeedSliderKnob.Size = UDim2.new(0, 20, 0, 20)
        SpeedSliderKnob.Position = UDim2.new(0, (speedValue / 100) * (195 - 20), 0, -6)  -- Уменьшено от -8
        SpeedSliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SpeedSliderKnob.BorderSizePixel = 0
        SpeedSliderKnob.Text = ""
        SpeedSliderKnob.Parent = SpeedSliderBackground
        local SpeedKnobCorner = Instance.new("UICorner")
        SpeedKnobCorner.CornerRadius = UDim.new(0, 11)
        SpeedKnobCorner.Parent = SpeedSliderKnob

        local draggingSpeed = false
        SpeedSliderKnob.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingSpeed = true
            end
        end)

        SpeedSliderKnob.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingSpeed = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if draggingSpeed and input.UserInputType == Enum.UserInputType.Touch then
                local sliderPosX = SpeedSliderBackground.AbsolutePosition.X
                local sliderWidth = SpeedSliderBackground.AbsoluteSize.X
                local knobWidth = SpeedSliderKnob.AbsoluteSize.X
                local mouseX = input.Position.X
                local relativeX = mouseX - sliderPosX
                local normalizedPos = math.clamp(relativeX / sliderWidth, 0, 1)
                local newPosX = normalizedPos * (sliderWidth - knobWidth)
                SpeedSliderKnob.Position = UDim2.new(0, newPosX, 0, -6)
                speedValue = math.floor(normalizedPos * 100)
                if speedHackEnabled then
                    toggleSpeedHack()
                end
            end
        end)
    end

    return SliderContainer
end

local tabs = {"Main", "Combat", "Farming", "Movement", "Info"}
local tabButtons = {}
local currentTab = nil
local sliders = {}

for i, tabName in ipairs(tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, -8, 0, 34)  -- Уменьшено от 45 to 34 (approx 25%)
    TabButton.Position = UDim2.new(0, 4, 0, (i-1)*38)  -- Уменьшено от 50 to 38
    TabButton.BackgroundColor3 = Color3.fromRGB(60, 20, 100)
    TabButton.BorderSizePixel = 0
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 0)
    TabButton.TextSize = 10  -- Уменьшено от 14
    TabButton.TextWrapped = true
    TabButton.Parent = TabContainer
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 4)
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

        -- Обновить CanvasSize
        local totalHeight = 0
        for _, slider in pairs(sliders) do
            if slider.Visible then
                totalHeight = totalHeight + slider.AbsoluteSize.Y + UIListLayout.Padding.Offset
            end
        end
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    end)

    if tabName == "Main" then
        sliders.NPCLockSlider = createSlider(ContentFrame, "NPC Lock", toggleNPCLock, npcLockEnabled, false)
        sliders.ESPSlider = createSlider(ContentFrame, "ESP (Wallhack)", toggleESP, espEnabled, false)
        sliders.NPCLockSlider.Visible = false
        sliders.ESPSlider.Visible = false
    elseif tabName == "Combat" then
        sliders.AimbotSlider = createSlider(ContentFrame, "Aimbot", toggleAimbot, aimbotEnabled, false)
        sliders.GodmodeSlider = createSlider(ContentFrame, "Godmode", toggleGodmode, godmodeEnabled, false)
        sliders.AimbotSlider.Visible = false
        sliders.GodmodeSlider.Visible = false
    elseif tabName == "Farming" then
        sliders.InfiniteBondsSlider = createSlider(ContentFrame, "Infinite Bonds", setInfiniteBonds, false, false)
        sliders.AutoFarmBondsSlider = createSlider(ContentFrame, "Auto Farm Bonds", toggleAutoFarmBonds, autoFarmBondsEnabled, false)
        sliders.InfiniteBondsSlider.Visible = false
        sliders.AutoFarmBondsSlider.Visible = false
    elseif tabName == "Movement" then
        sliders.SpeedHackSlider = createSlider(ContentFrame, "Speed Hack", toggleSpeedHack, speedHackEnabled, true)
        sliders.NoClipSlider = createSlider(ContentFrame, "NoClip", toggleNoClip, noClipEnabled, false)
        sliders.TPToEndSlider = createSlider(ContentFrame, "TP to End", tpToEnd, false, false)
        sliders.SpeedHackSlider.Visible = false
        sliders.NoClipSlider.Visible = false
        sliders.TPToEndSlider.Visible = false
    elseif tabName == "Info" then
        sliders.InfoLabel = createSlider(ContentFrame, "Расширенный GUI для Dead Rails", function() end, false, false)
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
    Text = "GUI с функциями от Grok, уменьшено на 25%",
    Duration = 5
})
