-- Загрузка Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Dead Rails GUI by Grok", "Synapse")  -- Название окна

-- Основной таб
local MainTab = Window:NewTab("Main Functions")
local MainSection = MainTab:NewSection("Core Cheats")

-- Переменные для состояний
local npcLockEnabled = false
local espEnabled = false
local aimbotEnabled = false

-- Функция NPC Lock (взята и адаптирована из скрипта)
local function toggleNPCLock(enable)
    npcLockEnabled = enable
    if enable then
        -- Код для NPC Lock (aim на ближайшего NPC)
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
                    -- Простой aim: поворот камеры на NPC
                    camera.CFrame = CFrame.new(camera.CFrame.Position, closestNPC.HumanoidRootPart.Position)
                end
            end
        end)
    end
end

-- Функция ESP (визуальное выделение NPC)
local highlights = {}
local function toggleESP(enable)
    espEnabled = enable
    if enable then
        for _, object in ipairs(workspace:GetDescendants()) do
            if object:IsA("Model") and object:FindFirstChild("Humanoid") and object:FindFirstChild("HumanoidRootPart") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESPHighlight"
                highlight.FillColor = Color3.new(1, 0, 0)  -- Красный цвет
                highlight.OutlineColor = Color3.new(1, 1, 0)
                highlight.FillTransparency = 0.5
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

-- Функция Aimbot (простой, на ближайшего врага)
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

-- Кнопки в GUI
MainSection:NewToggle("NPC Lock", "Автоматический лок на NPC", function(state)
    toggleNPCLock(state)
end)

MainSection:NewToggle("ESP (Wallhack)", "Выделение NPC через стены", function(state)
    toggleESP(state)
end)

MainSection:NewToggle("Aimbot", "Автоприцел на врагов", function(state)
    toggleAimbot(state)
end)

-- Дополнительный таб для информации
local InfoTab = Window:NewTab("Info")
local InfoSection = InfoTab:NewSection("Details")
InfoSection:NewLabel("GUI для Dead Rails с функциями из скрипта")
InfoSection:NewLabel("Автор: Grok (на основе твоего запроса)")
InfoSection:NewLabel("Используй на свой риск!")

-- Уведомление при запуске
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "GUI Loaded",
    Text = "Dead Rails Cheats GUI by Grok",
    Duration = 5
})