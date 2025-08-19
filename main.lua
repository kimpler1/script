-- Загрузка Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Dead Rails Ultimate GUI by Grok", "BloodTheme")  -- Красивая тема BloodTheme

-- Переменные для состояний
local npcLockEnabled = false
local espEnabled = false
local aimbotEnabled = false
local godmodeEnabled = false
local speedHackEnabled = false
local speedValue = 50
local autoFarmBondsEnabled = false
local noClipEnabled = false
local autoWinEnabled = false  -- Новая для auto win (farm bonds через победы)

-- Основной таб: Main Functions
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Core Cheats")

-- Таб для Combat
local CombatTab = Window:NewTab("Combat")
local CombatSection = CombatTab:NewSection("Battle Features")

-- Таб для Farming
local FarmingTab = Window:NewTab("Farming")
local FarmingSection = FarmingTab:NewSection("Resource Cheats")

-- Таб для Movement
local MovementTab = Window:NewTab("Movement")
local MovementSection = MovementTab:NewSection("Mobility Hacks")

-- Элементы GUI (тут подключаем функции из Части 2)
MainSection:NewToggle("NPC Lock", "Автолок на NPC", function(state)
    toggleNPCLock(state)
end)

MainSection:NewToggle("ESP (Wallhack)", "Выделение через стены", function(state)
    toggleESP(state)
end)

CombatSection:NewToggle("Aimbot", "Автоприцел", function(state)
    toggleAimbot(state)
end)

CombatSection:NewToggle("Godmode", "Бессмертие", function(state)
    toggleGodmode(state)
end)

FarmingSection:NewButton("Infinite Bonds", "Бесконечные бонды", function()
    setInfiniteBonds()
end)

FarmingSection:NewToggle("Auto Farm Bonds", "Автосбор бондов", function(state)
    toggleAutoFarmBonds(state)
end)

FarmingSection:NewToggle("Auto Win (Farm Bonds)", "Авто победа для бондов", function(state)
    toggleAutoWin(state)
end)

MovementSection:NewToggle("Speed Hack", "Увеличение скорости", function(state)
    toggleSpeedHack(state)
end)

MovementSection:NewSlider("Speed Value", "Значение скорости", 100, 16, function(value)
    speedValue = value
    if speedHackEnabled then
        toggleSpeedHack(true)  -- Обновить
    end
end)

MovementSection:NewToggle("NoClip", "Прохождение через стены", function(state)
    toggleNoClip(state)
end)

MovementSection:NewButton("TP to End", "Телепорт к концу", function()
    tpToEnd()
end)

-- Таб для Info
local InfoTab = Window:NewTab("Info")
local InfoSection = InfoTab:NewSection("Details")
InfoSection:NewLabel("Расширенный GUI для Dead Rails с исправлениями")
InfoSection:NewLabel("Bonds теперь в leaderstats; Auto Farm ищет 'Bond/Treasury'")
InfoSection:NewLabel("Используй на свой риск!")

-- Уведомление
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "GUI Updated",
    Text = "Infinite Bonds и Auto Farm исправлены!",
    Duration = 5
})
