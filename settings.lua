-- Вспомогательная GUI для настроек (settings.lua)
-- Этот скрипт предполагает, что основной GUI уже загружен и textLabels доступны глобально или через shared.
-- Если textLabels не глобальны, адаптируйте соответственно.

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Предполагаем, что textLabels доступны. Если нет, добавьте логику для поиска всех TextLabel в основном GUI.
-- Например:
local textLabels = {}  -- Если нужно, соберите их здесь, найдя в PlayerGui.DeadRailsGUI

local DeadRailsGUI = LocalPlayer.PlayerGui:WaitForChild("DeadRailsGUI", 10)
if not DeadRailsGUI then
    warn("Основной GUI не найден. Инжектите main.lua сначала.")
    return
end

local MainFrame = DeadRailsGUI:FindFirstChild("MainFrame")
if not MainFrame then
    warn("MainFrame не найден в DeadRailsGUI.")
    return
end

local ContentFrame = MainFrame:FindFirstChild("ContentFrame")
if not ContentFrame then
    warn("ContentFrame не найден. Убедитесь, что в main.lua добавлено ContentFrame.Name = 'ContentFrame'")
    return
end

local TabContainer = MainFrame:FindFirstChild("TabContainer")
if not TabContainer then
    warn("TabContainer не найден. Убедитесь, что в main.lua добавлено TabContainer.Name = 'TabContainer'")
    return
end

local UIPaddingContent = ContentFrame:FindFirstChildOfClass("UIPadding")
if not UIPaddingContent then
    warn("UIPadding не найден в ContentFrame.")
    return
end

-- Отключить клиппинг, чтобы контент мог выходить за пределы без укорачивания
ContentFrame.ClipsDescendants = false
TabContainer.ClipsDescendants = false

-- Собрать tabButtons
local tabButtons = {}
for _, child in ipairs(TabContainer:GetChildren()) do
    if child:IsA("TextButton") then
        table.insert(tabButtons, child)
    end
end

for _, gui in ipairs(DeadRailsGUI:GetDescendants()) do
    if gui:IsA("TextLabel") or gui:IsA("TextButton") then  -- Собираем все текстовые элементы
        table.insert(textLabels, gui)
    end
end

local SettingsGui = Instance.new("ScreenGui")
SettingsGui.Name = "SettingsGUI"
SettingsGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
SettingsGui.ResetOnSpawn = false
SettingsGui.IgnoreGuiInset = true

local SettingsFrame = Instance.new("Frame")
SettingsFrame.Size = UDim2.new(0, 200, 0, 250)
SettingsFrame.Position = UDim2.new(0, 10, 0, 10)  -- Позиция в верхнем левом углу
SettingsFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SettingsFrame.BorderSizePixel = 0
SettingsFrame.Parent = SettingsGui
SettingsFrame.Visible = true

local SettingsCorner = Instance.new("UICorner")
SettingsCorner.CornerRadius = UDim.new(0, 8)
SettingsCorner.Parent = SettingsFrame

-- Перетаскивание для SettingsFrame
local settingsDragging, settingsDragInput, settingsDragStart, settingsStartPos
local function settingsUpdate(input)
    local delta = input.Position - settingsDragStart
    SettingsFrame.Position = UDim2.new(settingsStartPos.X.Scale, settingsStartPos.X.Offset + delta.X, settingsStartPos.Y.Scale, settingsStartPos.Y.Offset + delta.Y)
end
SettingsFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        settingsDragging = true
        settingsDragStart = input.Position
        settingsStartPos = SettingsFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                settingsDragging = false
            end
        end)
    end
end)
SettingsFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        settingsDragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if settingsDragging and input == settingsDragInput then
        settingsUpdate(input)
    end
end)

-- Закрыть кнопку для настроек
local SettingsCloseButton = Instance.new("TextButton")
SettingsCloseButton.Size = UDim2.new(0, 20, 0, 20)
SettingsCloseButton.Position = UDim2.new(1, -25, 0, 5)
SettingsCloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
SettingsCloseButton.BorderSizePixel = 0
SettingsCloseButton.Text = "X"
SettingsCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsCloseButton.TextSize = 14
SettingsCloseButton.Parent = SettingsFrame
SettingsCloseButton.MouseButton1Click:Connect(function()
    SettingsFrame.Visible = false
end)

-- Настройка размера текста
local textSize = 10  -- Начальный размер
local TextSizeLabel = Instance.new("TextLabel")
TextSizeLabel.Size = UDim2.new(1, -50, 0, 30)
TextSizeLabel.Position = UDim2.new(0, 10, 0, 10)
TextSizeLabel.BackgroundTransparency = 1
TextSizeLabel.Text = "Размер текста: " .. textSize
TextSizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextSizeLabel.TextSize = 12
TextSizeLabel.Parent = SettingsFrame

local function updateTextSize()
    for _, label in ipairs(textLabels) do
        label.TextSize = textSize
    end
    TextSizeLabel.Text = "Размер текста: " .. textSize
end

local UpButton = Instance.new("TextButton")
UpButton.Size = UDim2.new(0, 20, 0, 20)
UpButton.Position = UDim2.new(1, -40, 0, 15)
UpButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
UpButton.Text = "↑"
UpButton.TextColor3 = Color3.fromRGB(0, 0, 0)
UpButton.Parent = SettingsFrame
UpButton.MouseButton1Click:Connect(function()
    textSize = math.min(textSize + 1, 30)  -- Макс 30
    updateTextSize()
end)

local DownButton = Instance.new("TextButton")
DownButton.Size = UDim2.new(0, 20, 0, 20)
DownButton.Position = UDim2.new(1, -40, 0, 40)
DownButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
DownButton.Text = "↓"
DownButton.TextColor3 = Color3.fromRGB(0, 0, 0)
DownButton.Parent = SettingsFrame
DownButton.MouseButton1Click:Connect(function()
    textSize = math.max(textSize - 1, 5)  -- Мин 5
    updateTextSize()
end)

-- Настройка перемещения Content (функций внутри ContentFrame с помощью UIPadding)
local ContentMoveLabel = Instance.new("TextLabel")
ContentMoveLabel.Size = UDim2.new(1, 0, 0, 30)
ContentMoveLabel.Position = UDim2.new(0, 10, 0, 70)
ContentMoveLabel.BackgroundTransparency = 1
ContentMoveLabel.Text = "Перемещение Content:"
ContentMoveLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ContentMoveLabel.TextSize = 12
ContentMoveLabel.Parent = SettingsFrame

local moveStep = 5

local ContentLeftButton = Instance.new("TextButton")
ContentLeftButton.Size = UDim2.new(0, 30, 0, 30)
ContentLeftButton.Position = UDim2.new(0, 10, 0, 100)
ContentLeftButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ContentLeftButton.Text = "←"
ContentLeftButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ContentLeftButton.Parent = SettingsFrame
ContentLeftButton.MouseButton1Click:Connect(function()
    -- Сдвиг влево: уменьшить PaddingLeft
    local currentLeft = UIPaddingContent.PaddingLeft.Offset
    UIPaddingContent.PaddingLeft = UDim.new(0, math.max(currentLeft - moveStep, -50))  -- Мин -50 для безопасности
end)

local ContentUpButton = Instance.new("TextButton")
ContentUpButton.Size = UDim2.new(0, 30, 0, 30)
ContentUpButton.Position = UDim2.new(0, 50, 0, 100)
ContentUpButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ContentUpButton.Text = "↑"
ContentUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ContentUpButton.Parent = SettingsFrame
ContentUpButton.MouseButton1Click:Connect(function()
    -- Сдвиг вверх: уменьшить PaddingTop
    local currentTop = UIPaddingContent.PaddingTop.Offset
    UIPaddingContent.PaddingTop = UDim.new(0, math.max(currentTop - moveStep, -50))
end)

local ContentDownButton = Instance.new("TextButton")
ContentDownButton.Size = UDim2.new(0, 30, 0, 30)
ContentDownButton.Position = UDim2.new(0, 90, 0, 100)
ContentDownButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ContentDownButton.Text = "↓"
ContentDownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ContentDownButton.Parent = SettingsFrame
ContentDownButton.MouseButton1Click:Connect(function()
    -- Сдвиг вниз: увеличить PaddingTop
    local currentTop = UIPaddingContent.PaddingTop.Offset
    UIPaddingContent.PaddingTop = UDim.new(0, currentTop + moveStep)
end)

local ContentRightButton = Instance.new("TextButton")
ContentRightButton.Size = UDim2.new(0, 30, 0, 30)
ContentRightButton.Position = UDim2.new(0, 130, 0, 100)
ContentRightButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ContentRightButton.Text = "→"
ContentRightButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ContentRightButton.Parent = SettingsFrame
ContentRightButton.MouseButton1Click:Connect(function()
    -- Сдвиг вправо: увеличить PaddingLeft
    local currentLeft = UIPaddingContent.PaddingLeft.Offset
    UIPaddingContent.PaddingLeft = UDim.new(0, currentLeft + moveStep)
end)

-- Настройка перемещения Tab (вкладок внутри TabContainer)
local TabMoveLabel = Instance.new("TextLabel")
TabMoveLabel.Size = UDim2.new(1, 0, 0, 30)
TabMoveLabel.Position = UDim2.new(0, 10, 0, 140)
TabMoveLabel.BackgroundTransparency = 1
TabMoveLabel.Text = "Перемещение Tab:"
TabMoveLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TabMoveLabel.TextSize = 12
TabMoveLabel.Parent = SettingsFrame

local TabUpButton = Instance.new("TextButton")
TabUpButton.Size = UDim2.new(0, 30, 0, 30)
TabUpButton.Position = UDim2.new(0, 10, 0, 170)
TabUpButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
TabUpButton.Text = "↑"
TabUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TabUpButton.Parent = SettingsFrame
TabUpButton.MouseButton1Click:Connect(function()
    for _, button in ipairs(tabButtons) do
        button.Position = UDim2.new(button.Position.X.Scale, button.Position.X.Offset, button.Position.Y.Scale, button.Position.Y.Offset - moveStep)
    end
end)

local TabDownButton = Instance.new("TextButton")
TabDownButton.Size = UDim2.new(0, 30, 0, 30)
TabDownButton.Position = UDim2.new(0, 50, 0, 170)
TabDownButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
TabDownButton.Text = "↓"
TabDownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TabDownButton.Parent = SettingsFrame
TabDownButton.MouseButton1Click:Connect(function()
    for _, button in ipairs(tabButtons) do
        button.Position = UDim2.new(button.Position.X.Scale, button.Position.X.Offset, button.Position.Y.Scale, button.Position.Y.Offset + moveStep)
    end
end)

-- Добавьте больше настроек по необходимости
