local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
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
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 340, 0, 255)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -128)
MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Visible = true
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 9)
MainCorner.Parent = MainFrame
local dragging = false
local dragInput, dragStart, startPos
local isDraggingAnySlider = false
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
local function startDrag(input, frame)
    if isDraggingAnySlider then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        ContextActionService:BindAction("FreezeCamera", function() return Enum.ContextActionResult.Sink end, false, Enum.UserInputType.MouseMovement, Enum.UserInputType.Touch)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                ContextActionService:UnbindAction("FreezeCamera")
            end
        end)
    end
end
local function handleInputChanged(input, frame)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end
MainFrame.InputBegan:Connect(function(input) startDrag(input, MainFrame) end)
MainFrame.InputChanged:Connect(function(input) handleInputChanged(input, MainFrame) end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(0, 85, 1, 0)
TabContainer.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame
TabContainer.InputBegan:Connect(function(input) startDrag(input, TabContainer) end)
TabContainer.InputChanged:Connect(function(input) handleInputChanged(input, TabContainer) end)
local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 9)
TabCorner.Parent = TabContainer
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(0, 255, 1, 0)
ContentFrame.Position = UDim2.new(0, 85, 0, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.ScrollBarThickness = 9
ContentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ContentFrame.InputBegan:Connect(function(input) startDrag(input, ContentFrame) end)
ContentFrame.InputChanged:Connect(function(input) handleInputChanged(input, ContentFrame) end)
local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 9)
ContentCorner.Parent = ContentFrame
local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 34) -- Опустить первые функции на 34 пикселя, чтобы не накладываться на кнопки
UIPadding.Parent = ContentFrame
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.Parent = ContentFrame
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 26, 0, 26)
MinimizeButton.Position = UDim2.new(1, -60, 0, 4)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "▲"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 0)
MinimizeButton.TextScaled = true
MinimizeButton.Parent = MainFrame
local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 4)
MinimizeCorner.Parent = MinimizeButton
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 26, 0, 26)
CloseButton.Position = UDim2.new(1, -30, 0, 4)
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
MinimizedFrame.Size = UDim2.new(0, 55, 0, 26)
MinimizedFrame.Position = UDim2.new(1, -64, 0, 4)
MinimizedFrame.BackgroundTransparency = 1
MinimizedFrame.Parent = ScreenGui
MinimizedFrame.Visible = false
local MaximizeButton = Instance.new("TextButton")
MaximizeButton.Size = UDim2.new(0, 26, 0, 26)
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
CloseButtonMinimized.Size = UDim2.new(0, 26, 0, 26)
CloseButtonMinimized.Position = UDim2.new(0, 30, 0, 0)
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
local espEnabled = false
local espGuis = {}
local function createESP(player)
    if player == LocalPlayer then return end
    local character = player.Character or player.CharacterAdded:Wait()
    local head = character:WaitForChild("Head")
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255, 0, 0)
    text.Text = player.Name
    text.TextSize = 14
    text.Parent = billboard
    billboard.Parent = LocalPlayer.PlayerGui
    espGuis[player] = billboard
    -- For health
    local humanoid = character:WaitForChild("Humanoid")
    local function updateHealth()
        text.Text = player.Name .. " | Health: " .. math.floor(humanoid.Health)
    end
    updateHealth()
    humanoid.HealthChanged:Connect(updateHealth)
end
local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                createESP(player)
            end
            player.CharacterAdded:Connect(function()
                createESP(player)
            end)
        end
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                createESP(player)
            end)
        end)
    else
        for _, gui in pairs(espGuis) do
            gui:Destroy()
        end
        espGuis = {}
    end
end
local function createSlider(parent, labelText, toggleFunction, enabledFlag, hasSpeedSlider)
    local containerHeight = hasSpeedSlider and 51 or 34
    local SliderContainer = Instance.new("Frame")
    SliderContainer.Size = UDim2.new(1, -17, 0, containerHeight)
    SliderContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    SliderContainer.BackgroundTransparency = 0.5
    SliderContainer.BorderSizePixel = 0
    SliderContainer.Parent = parent
    local SliderContainerCorner = Instance.new("UICorner")
    SliderContainerCorner.CornerRadius = UDim.new(0, 4)
    SliderContainerCorner.Parent = SliderContainer
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 119, 0, 17)
    Label.Position = hasSpeedSlider and UDim2.new(0, 9, 0, 4) or UDim2.new(0, 9, 0, 9)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 10
    Label.TextWrapped = true
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderContainer
    local SliderBackground = Instance.new("Frame")
    SliderBackground.Size = UDim2.new(0, 37, 0, 14)
    SliderBackground.Position = hasSpeedSlider and UDim2.new(1, -51, 0, 4) or UDim2.new(1, -51, 0, 10)
    SliderBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SliderBackground.BorderSizePixel = 0
    SliderBackground.Parent = SliderContainer
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 9)
    SliderCorner.Parent = SliderBackground
    local SliderKnob = Instance.new("TextButton")
    SliderKnob.Size = UDim2.new(0, 22, 0, 22)
    SliderKnob.Position = UDim2.new(0, 0, 0, -4)
    SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderKnob.BorderSizePixel = 0
    SliderKnob.Text = ""
    SliderKnob.Parent = SliderBackground
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(0, 13)
    KnobCorner.Parent = SliderKnob
    local isEnabled = enabledFlag
    SliderKnob.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        local newPos = isEnabled and UDim2.new(1, -22, 0, -4) or UDim2.new(0, 0, 0, -4)
        local newColor = isEnabled and Color3.fromRGB(75, 0, 130) or Color3.fromRGB(50, 50, 50)
        local knobColor = isEnabled and Color3.fromRGB(150, 150, 150) or Color3.fromRGB(255, 255, 255)
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        TweenService:Create(SliderKnob, tweenInfo, {Position = newPos, BackgroundColor3 = knobColor}):Play()
        TweenService:Create(SliderBackground, tweenInfo, {BackgroundColor3 = newColor}):Play()
        toggleFunction()
    end)
    if hasSpeedSlider then
        local speedValue = 50 -- Начальное значение скорости (0-100)
        local SpeedSliderBackground = Instance.new("Frame")
        SpeedSliderBackground.Size = UDim2.new(1, -20, 0, 9) -- Относительная ширина
        SpeedSliderBackground.Position = UDim2.new(0, 10, 0, 34)
        SpeedSliderBackground.BackgroundColor3 = Color3.fromRGB(80, 80, 80) -- Изменено на более светлый серый для выделения
        SpeedSliderBackground.BackgroundTransparency = 0.5
        SpeedSliderBackground.BorderSizePixel = 0
        SpeedSliderBackground.Parent = SliderContainer
        local SpeedSliderCorner = Instance.new("UICorner")
        SpeedSliderCorner.CornerRadius = UDim.new(0, 4)
        SpeedSliderCorner.Parent = SpeedSliderBackground
        local SpeedSliderKnob = Instance.new("TextButton")
        SpeedSliderKnob.Size = UDim2.new(0, 22, 0, 22)
        SpeedSliderKnob.Position = UDim2.new(0, (speedValue / 100) * (SpeedSliderBackground.Size.X.Offset - 22), 0, -7)
        SpeedSliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SpeedSliderKnob.BorderSizePixel = 0
        SpeedSliderKnob.Text = ""
        SpeedSliderKnob.Parent = SpeedSliderBackground
        local SpeedKnobCorner = Instance.new("UICorner")
        SpeedKnobCorner.CornerRadius = UDim.new(0, 13)
        SpeedKnobCorner.Parent = SpeedSliderKnob
        local draggingSpeed = false
        local dragConnection
        local function startDrag(input)
            isDraggingAnySlider = true
            local sliderPosX = SpeedSliderBackground.AbsolutePosition.X
            local sliderWidth = SpeedSliderBackground.AbsoluteSize.X
            local knobWidth = SpeedSliderKnob.AbsoluteSize.X
            local mouseX = input.Position.X
            local relativeX = mouseX - sliderPosX
            local normalizedPos = math.clamp(relativeX / sliderWidth, 0, 1)
            local newPosX = normalizedPos * (sliderWidth - knobWidth)
            local newPos = UDim2.new(0, newPosX, 0, -7)
            local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear)
            TweenService:Create(SpeedSliderKnob, tweenInfo, {Position = newPos}):Play()
            speedValue = math.floor(normalizedPos * 100)
            if speedHackEnabled then
                toggleSpeedHack()
            end
            draggingSpeed = true
            if dragConnection then dragConnection:Disconnect() end
            dragConnection = RunService.RenderStepped:Connect(function()
                if not draggingSpeed then return end
                local mousePos = UserInputService:GetMouseLocation()
                local relativeX = mousePos.X - sliderPosX
                local normalizedPos = math.clamp(relativeX / sliderWidth, 0, 1)
                local newPosX = normalizedPos * (sliderWidth - knobWidth)
                SpeedSliderKnob.Position = UDim2.new(0, newPosX, 0, -7)
                speedValue = math.floor(normalizedPos * 100)
                if speedHackEnabled then
                    toggleSpeedHack()
                end
            end)
        end
        SpeedSliderKnob.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                startDrag(input)
            end
        end)
        SpeedSliderBackground.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                startDrag(input)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and draggingSpeed then
                draggingSpeed = false
                isDraggingAnySlider = false
                if dragConnection then
                    dragConnection:Disconnect()
                    dragConnection = nil
                end
            end
        end)
        -- Обновление позиции при изменении размера (для динамической ширины)
        SliderContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            local sliderWidth = SpeedSliderBackground.AbsoluteSize.X
            local knobWidth = SpeedSliderKnob.AbsoluteSize.X
            SpeedSliderKnob.Position = UDim2.new(0, (speedValue / 100) * (sliderWidth - knobWidth), 0, -7)
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
    TabButton.Size = UDim2.new(1, -9, 0, 30)
    TabButton.Position = UDim2.new(0, 4, 0, (i-1)*34)
    TabButton.BackgroundColor3 = Color3.fromRGB(60, 20, 100)
    TabButton.BorderSizePixel = 0
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 0)
    TabButton.TextSize = 10
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
        sliders.ESPSlider = createSlider(ContentFrame, "ESP (Wallhack)", toggleESP, false, false)
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
-- Автоматически открыть первую вкладку без симуляции клика
if #tabButtons > 0 then
    currentTab = tabButtons[1]
    tabButtons[1].BackgroundColor3 = Color3.fromRGB(75, 0, 130)
    sliders.ESPSlider.Visible = true
end
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Скрипт Dead Rails загружен",
    Text = "GUI с функциями от Grok",
    Duration = 5
})

-- Фиксированные настройки для main.lua

-- Размер текста
local textSize = 11
for _, gui in ipairs(ScreenGui:GetDescendants()) do
    if gui:IsA("TextLabel") or gui:IsA("TextButton") then
        gui.TextSize = textSize
    end
end

-- Позиционирование Content (UIPadding)
UIPadding.PaddingLeft = UDim.new(0, 5)
UIPadding.PaddingRight = UDim.new(0, -5)
UIPadding.PaddingTop = UDim.new(0, 39)

-- Позиционирование вкладок (TabButtons)
for i, button in ipairs(tabButtons) do
    button.Position = UDim2.new(button.Position.X.Scale, 4, button.Position.Y.Scale, button.Position.Y.Offset + 5)
end

-- Размеры фреймов
MainFrame.Size = UDim2.new(0, 350, 0, 220)
TabContainer.Size = UDim2.new(0, 95, 1, 0)
ContentFrame.Position = UDim2.new(0, 95, 0, 0)
ContentFrame.Size = UDim2.new(0, 255, 1, 0)

-- Отступ функций (UIListLayout.Padding)
UIListLayout.Padding = UDim.new(0, 7)
