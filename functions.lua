-- functions.lua: Loader с базовым GUI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Dead Rails Ultimate GUI by Grok", "BloodTheme")

-- Базовые табы (чтобы GUI появился сразу)
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Core Cheats")
local CombatTab = Window:NewTab("Combat")
local CombatSection = CombatTab:NewSection("Battle Features")
local FarmingTab = Window:NewTab("Farming")
local FarmingSection = FarmingTab:NewSection("Resource Cheats")
local MovementTab = Window:NewTab("Movement")
local MovementSection = MovementTab:NewSection("Mobility Hacks")
local InfoTab = Window:NewTab("Info")
local InfoSection = InfoTab:NewSection("Details")
InfoSection:NewLabel("Загружаю функции...")

-- Подгрузка частей
loadstring(game:HttpGet("https://raw.githubusercontent.com/kimpler1/script/main/functions_part1.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/kimpler1/script/main/functions_part2.lua"))()

-- Уведомление
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "GUI Loaded",
    Text = "Все функции доступны!",
    Duration = 5
})
