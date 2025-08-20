-- Вспомогательная GUI для настроек (settings.lua)
-- Этот скрипт предполагает, что основной GUI уже загружен и textLabels доступны глобально или через shared.
-- Если textLabels не глобальны, адаптируйте соответственно.

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Предполагаем, что textLabels доступны. Если нет, добавьте логику для поиска всех TextLabel в основном GUI.
-- Например:
local textLabels = {}  -- Если нужно, соберите их здесь, найдя в PlayerGui.DeadRailsGUI

for _, gui in ipairs(LocalPlayer.PlayerGui:WaitForChild("DeadRailsGUI"):GetDescendants()) do
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
SettingsFrame.Size = UDim2.new(0, 200, 0, 150)
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

-- Добавьте больше настроек по необходимости
