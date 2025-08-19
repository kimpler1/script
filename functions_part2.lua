-- Исправленная функция: Infinite Bonds (теперь через leaderstats)
local function setInfiniteBonds()
    local player = game.Players.LocalPlayer
    local leaderstats = player:WaitForChild("leaderstats")
    local bonds = leaderstats:WaitForChild("Bonds")
    if bonds then
        bonds.Value = 999999
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Error", Text = "Bonds not found in leaderstats!", Duration = 3})
    end
end

-- Переделанная функция: Auto Farm Bonds (ищет 'Bond' или 'Treasury', TP к ним)
local function toggleAutoFarmBonds(enable)
    autoFarmBondsEnabled = enable
    if enable then
        local runService = game:GetService("RunService")
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        
        local foundBonds = false
        runService.Heartbeat:Connect(function()
            if autoFarmBondsEnabled then
                for _, bond in ipairs(workspace:GetDescendants()) do
                    if (string.find(bond.Name:lower(), "bond") or string.find(bond.Name:lower(), "treasury")) and (bond:IsA("Part") or bond:IsA("Model")) then
                        foundBonds = true
                        hrp.CFrame = bond.CFrame * CFrame.new(0, 3, 0)
                        wait(0.3)
                    end
                end
                if not foundBonds then
                    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Info", Text = "No bonds found! Try in bank vault.", Duration = 3})
                end
            end
        end)
    end
end

-- Новая функция: Auto Win (loop TP to end для farm bonds через победы)
local function toggleAutoWin(enable)
    autoWinEnabled = enable
    if enable then
        local runService = game:GetService("RunService")
        runService.Heartbeat:Connect(function()
            if autoWinEnabled then
                tpToEnd()
                wait(5)  -- Задержка для повторения (избегай спама, чтобы не бан)
            end
        end)
    end
end

-- Функция NoClip
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

-- Функция TP to End
local function tpToEnd()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(1000, 100, 1000)  -- Замени на реальные координаты конца (найди в игре)
    end
end

-- Элементы GUI (ссылаются на функции из part1 и part2)
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
