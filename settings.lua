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

local UIListLayout = ContentFrame:FindFirstChildOfClass("UIListLayout")
if not UIListLayout then
    warn("UIListLayout не найден в ContentFrame.")
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
SettingsFrame.Size = UDim2.new(0, 200, 0, 300)  -- Уменьшил высоту до 300 для компактности
SettingsFrame.Position = UDim2.new(0, 10, 0, 10)  -- Позиция в верхнем левом углу
SettingsFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SettingsFrame.BorderSizePixel = 0
SettingsFrame.Parent = SettingsGui
SettingsFrame.Visible = true

local SettingsCorner = Instance.new("UICorner")
SettingsCorner.CornerRadius = UDim.new(0, 8)
SettingsCorner.Parent = SettingsFrame

-- Создать ScrollingFrame внутри SettingsFrame для прокрутки содержимого
local SettingsScrolling = Instance.new("ScrollingFrame")
SettingsScrolling.Size = UDim2.new(1, 0, 1, 0)
SettingsScrolling.Position = UDim2.new(0, 0, 0, 0)
SettingsScrolling.BackgroundTransparency = 1
SettingsScrolling.BorderSizePixel = 0
SettingsScrolling.Parent = SettingsFrame
SettingsScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
SettingsScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
SettingsScrolling.ScrollBarThickness = 10
SettingsScrolling.ScrollingDirection = Enum.ScrollingDirection.Y

-- Перетаскивание для SettingsFrame (работает на всём фрейме)
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
TextSizeLabel.Parent = SettingsScrolling

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
UpButton.Parent = SettingsScrolling
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
DownButton.Parent = SettingsScrolling
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
ContentMoveLabel.Parent = SettingsScrolling

local moveStep = 5

local ContentLeftButton = Instance.new("TextButton")
ContentLeftButton.Size = UDim2.new(0, 30, 0, 30)
ContentLeftButton.Position = UDim2.new(0, 10, 0, 100)
ContentLeftButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ContentLeftButton.Text = "←"
ContentLeftButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ContentLeftButton.Parent = SettingsScrolling
ContentLeftButton.MouseButton1Click:Connect(function()
    local currentLeft = UIPaddingContent.PaddingLeft.Offset
    local currentRight = UIPaddingContent.PaddingRight.Offset
    UIPaddingContent.PaddingLeft = UDim.new(0, currentLeft - moveStep)
    UIPaddingContent.PaddingRight = UDim.new(0, currentRight + moveStep)
end)

local ContentUpButton = Instance.new("TextButton")
ContentUpButton.Size = UDim2.new(0, 30, 0, 30)
ContentUpButton.Position = UDim2.new(0, 50, 0, 100)
ContentUpButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ContentUpButton.Text = "↑"
ContentUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ContentUpButton.Parent = SettingsScrolling
ContentUpButton.MouseButton1Click:Connect(function()
    local currentTop = UIPaddingContent.PaddingTop.Offset
    UIPaddingContent.PaddingTop = UDim.new(0, math.max(currentTop - moveStep, -50))
end)

local ContentDownButton = Instance.new("TextButton")
ContentDownButton.Size = UDim2.new(0, 30, 0, 30)
ContentDownButton.Position = UDim2.new(0, 90, 0, 100)
ContentDownButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ContentDownButton.Text = "↓"
ContentDownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ContentDownButton.Parent = SettingsScrolling
ContentDownButton.MouseButton1Click:Connect(function()
    local currentTop = UIPaddingContent.PaddingTop.Offset
    UIPaddingContent.PaddingTop = UDim.new(0, currentTop + moveStep)
end)

local ContentRightButton = Instance.new("TextButton")
ContentRightButton.Size = UDim2.new(0, 30, 0, 30)
ContentRightButton.Position = UDim2.new(0, 130, 0, 100)
ContentRightButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ContentRightButton.Text = "→"
ContentRightButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ContentRightButton.Parent = SettingsScrolling
ContentRightButton.MouseButton1Click:Connect(function()
    local currentLeft = UIPaddingContent.PaddingLeft.Offset
    local currentRight = UIPaddingContent.PaddingRight.Offset
    UIPaddingContent.PaddingLeft = UDim.new(0, currentLeft + moveStep)
    UIPaddingContent.PaddingRight = UDim.new(0, currentRight - moveStep)
end)

-- Настройка перемещения Tab (вкладок внутри TabContainer)
local TabMoveLabel = Instance.new("TextLabel")
TabMoveLabel.Size = UDim2.new(1, 0, 0, 30)
TabMoveLabel.Position = UDim2.new(0, 10, 0, 140)
TabMoveLabel.BackgroundTransparency = 1
TabMoveLabel.Text = "Перемещение Tab:"
TabMoveLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TabMoveLabel.TextSize = 12
TabMoveLabel.Parent = SettingsScrolling

local TabUpButton = Instance.new("TextButton")
TabUpButton.Size = UDim2.new(0, 30, 0, 30)
TabUpButton.Position = UDim2.new(0, 10, 0, 170)
TabUpButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
TabUpButton.Text = "↑"
TabUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TabUpButton.Parent = SettingsScrolling
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
TabDownButton.Parent = SettingsScrolling
TabDownButton.MouseButton1Click:Connect(function()
    for _, button in ipairs(tabButtons) do
        button.Position = UDim2.new(button.Position.X.Scale, button.Position.X.Offset, button.Position.Y.Scale, button.Position.Y.Offset + moveStep)
    end
end)

-- Настройка расширения GUI
local ResizeLabel = Instance.new("TextLabel")
ResizeLabel.Size = UDim2.new(1, 0, 0, 30)
ResizeLabel.Position = UDim2.new(0, 10, 0, 210)
ResizeLabel.BackgroundTransparency = 1
ResizeLabel.Text = "Расширение GUI:"
ResizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ResizeLabel.TextSize = 12
ResizeLabel.Parent = SettingsScrolling

local resizeStep = 5

-- Расширение TabContainer (фиолетовая область)
local TabResizeLabel = Instance.new("TextLabel")
TabResizeLabel.Size = UDim2.new(1, 0, 0, 20)
TabResizeLabel.Position = UDim2.new(0, 10, 0, 240)
TabResizeLabel.BackgroundTransparency = 1
TabResizeLabel.Text = "Tab (ширина):"
TabResizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TabResizeLabel.TextSize = 12
TabResizeLabel.Parent = SettingsScrolling

local TabWidthPlus = Instance.new("TextButton")
TabWidthPlus.Size = UDim2.new(0, 30, 0, 30)
TabWidthPlus.Position = UDim2.new(0, 10, 0, 260)
TabWidthPlus.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
TabWidthPlus.Text = "+"
TabWidthPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
TabWidthPlus.Parent = SettingsScrolling
TabWidthPlus.MouseButton1Click:Connect(function()
    local newTabWidth = TabContainer.Size.X.Offset + resizeStep
    TabContainer.Size = UDim2.new(0, newTabWidth, 1, 0)
    ContentFrame.Position = UDim2.new(0, newTabWidth, 0, 0)
    MainFrame.Size = UDim2.new(0, newTabWidth + ContentFrame.Size.X.Offset, 0, MainFrame.Size.Y.Offset)
end)

local TabWidthMinus = Instance.new("TextButton")
TabWidthMinus.Size = UDim2.new(0, 30, 0, 30)
TabWidthMinus.Position = UDim2.new(0, 50, 0, 260)
TabWidthMinus.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
TabWidthMinus.Text = "-"
TabWidthMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
TabWidthMinus.Parent = SettingsScrolling
TabWidthMinus.MouseButton1Click:Connect(function()
    local newTabWidth = math.max(TabContainer.Size.X.Offset - resizeStep, 50)  -- Мин ширина 50
    TabContainer.Size = UDim2.new(0, newTabWidth, 1, 0)
    ContentFrame.Position = UDim2.new(0, newTabWidth, 0, 0)
    MainFrame.Size = UDim2.new(0, newTabWidth + ContentFrame.Size.X.Offset, 0, MainFrame.Size.Y.Offset)
end)

-- Расширение ContentFrame (серая область)
local ContentResizeLabel = Instance.new("TextLabel")
ContentResizeLabel.Size = UDim2.new(1, 0, 0, 20)
ContentResizeLabel.Position = UDim2.new(0, 10, 0, 290)
ContentResizeLabel.BackgroundTransparency = 1
ContentResizeLabel.Text = "Content (ширина):"
ContentResizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ContentResizeLabel.TextSize = 12
ContentResizeLabel.Parent = SettingsScrolling

local ContentWidthPlus = Instance.new("TextButton")
ContentWidthPlus.Size = UDim2.new(0, 30, 0, 30)
ContentWidthPlus.Position = UDim2.new(0, 10, 0, 310)
ContentWidthPlus.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ContentWidthPlus.Text = "+"
ContentWidthPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
ContentWidthPlus.Parent = SettingsScrolling
ContentWidthPlus.MouseButton1Click:Connect(function()
    local newContentWidth = ContentFrame.Size.X.Offset + resizeStep
    ContentFrame.Size = UDim2.new(0, newContentWidth, 1, 0)
    MainFrame.Size = UDim2.new(0, TabContainer.Size.X.Offset + newContentWidth, 0, MainFrame.Size.Y.Offset)
end)

local ContentWidthMinus = Instance.new("TextButton")
ContentWidthMinus.Size = UDim2.new(0, 30, 0, 30)
ContentWidthMinus.Position = UDim2.new(0, 50, 0, 310)
ContentWidthMinus.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ContentWidthMinus.Text = "-"
ContentWidthMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
ContentWidthMinus.Parent = SettingsScrolling
ContentWidthMinus.MouseButton1Click:Connect(function()
    local newContentWidth = math.max(ContentFrame.Size.X.Offset - resizeStep, 100)  -- Мин ширина 100
    ContentFrame.Size = UDim2.new(0, newContentWidth, 1, 0)
    MainFrame.Size = UDim2.new(0, TabContainer.Size.X.Offset + newContentWidth, 0, MainFrame.Size.Y.Offset)
end)

-- Расширение высоты MainFrame (общей высоты)
local HeightResizeLabel = Instance.new("TextLabel")
HeightResizeLabel.Size = UDim2.new(1, 0, 0, 20)
HeightResizeLabel.Position = UDim2.new(0, 10, 0, 340)
HeightResizeLabel.BackgroundTransparency = 1
HeightResizeLabel.Text = "Высота GUI:"
HeightResizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HeightResizeLabel.TextSize = 12
HeightResizeLabel.Parent = SettingsScrolling

local HeightPlus = Instance.new("TextButton")
HeightPlus.Size = UDim2.new(0, 30, 0, 30)
HeightPlus.Position = UDim2.new(0, 10, 0, 360)
HeightPlus.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
HeightPlus.Text = "+"
HeightPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
HeightPlus.Parent = SettingsScrolling
HeightPlus.MouseButton1Click:Connect(function()
    local newHeight = MainFrame.Size.Y.Offset + resizeStep
    MainFrame.Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, newHeight)
end)

local HeightMinus = Instance.new("TextButton")
HeightMinus.Size = UDim2.new(0, 30, 0, 30)
HeightMinus.Position = UDim2.new(0, 50, 0, 360)
HeightMinus.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
HeightMinus.Text = "-"
HeightMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
HeightMinus.Parent = SettingsScrolling
HeightMinus.MouseButton1Click:Connect(function()
    local newHeight = math.max(MainFrame.Size.Y.Offset - resizeStep, 150)  -- Мин высота 150
    MainFrame.Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, newHeight)
end)

-- Настройка отступа между функциями
local PaddingLabel = Instance.new("TextLabel")
PaddingLabel.Size = UDim2.new(1, 0, 0, 20)
PaddingLabel.Position = UDim2.new(0, 10, 0, 400)
PaddingLabel.BackgroundTransparency = 1
PaddingLabel.Text = "Отступ функций: " .. UIListLayout.Padding.Offset
PaddingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PaddingLabel.TextSize = 12
PaddingLabel.Parent = SettingsScrolling

local PaddingPlus = Instance.new("TextButton")
PaddingPlus.Size = UDim2.new(0, 30, 0, 30)
PaddingPlus.Position = UDim2.new(0, 10, 0, 420)
PaddingPlus.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
PaddingPlus.Text = "+"
PaddingPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
PaddingPlus.Parent = SettingsScrolling
PaddingPlus.MouseButton1Click:Connect(function()
    local newPadding = UIListLayout.Padding.Offset + 1
    UIListLayout.Padding = UDim.new(0, newPadding)
    PaddingLabel.Text = "Отступ функций: " .. newPadding
end)

local PaddingMinus = Instance.new("TextButton")
PaddingMinus.Size = UDim2.new(0, 30, 0, 30)
PaddingMinus.Position = UDim2.new(0, 50, 0, 420)
PaddingMinus.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
PaddingMinus.Text = "-"
PaddingMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
PaddingMinus.Parent = SettingsScrolling
PaddingMinus.MouseButton1Click:Connect(function()
    local newPadding = math.max(UIListLayout.Padding.Offset - 1, 0)  -- Мин 0
    UIListLayout.Padding = UDim.new(0, newPadding)
    PaddingLabel.Text = "Отступ функций: " .. newPadding
end)

-- Новое: Текстовое окно для редактирования кода и кнопка "Применить изменения"
-- Уменьшил высоту CodeTextBox для компактности

local CodeEditorLabel = Instance.new("TextLabel")
CodeEditorLabel.Size = UDim2.new(1, 0, 0, 20)
CodeEditorLabel.Position = UDim2.new(0, 10, 0, 460)
CodeEditorLabel.BackgroundTransparency = 1
CodeEditorLabel.Text = "Редактор кода:"
CodeEditorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CodeEditorLabel.TextSize = 12
CodeEditorLabel.Parent = SettingsScrolling

local CodeTextBox = Instance.new("TextBox")
CodeTextBox.Size = UDim2.new(1, -20, 0, 60)  -- Уменьшил высоту до 60
CodeTextBox.Position = UDim2.new(0, 10, 0, 480)
CodeTextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CodeTextBox.BorderSizePixel = 0
CodeTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
CodeTextBox.TextSize = 12
CodeTextBox.MultiLine = true
CodeTextBox.ClearTextOnFocus = false
CodeTextBox.TextWrapped = true
CodeTextBox.Text = "-- Вставьте ваш Lua-код здесь\nlocal example = 1\nprint(example)"  -- Начальный код (placeholder)
CodeTextBox.Parent = SettingsScrolling

local ApplyButton = Instance.new("TextButton")
ApplyButton.Size = UDim2.new(0, 100, 0, 30)
ApplyButton.Position = UDim2.new(0, 10, 0, 550)  -- Скорректировал позицию
ApplyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
ApplyButton.Text = "Применить изменения"
ApplyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyButton.TextSize = 12
ApplyButton.Parent = SettingsScrolling
ApplyButton.MouseButton1Click:Connect(function()
    local editedCode = CodeTextBox.Text
    -- Симулируем применение: добавляем комментарий
    editedCode = editedCode .. "\n-- Изменения применены"
    CodeTextBox.Text = editedCode
end)

-- Добавьте больше настроек по необходимости
