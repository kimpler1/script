local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Dead Rails Alpha (BY SKNDUAWB)", "Synapse")
local Tab = Window:NewTab("DEAD RAILS")
local Section = Tab:NewSection("Hello everyone Thanks for use my script This Is full Version")
Section:NewLabel("Dead rails")
Section:NewButton("NPC LOCK", "idk", function()
    --dead rails wall hack aimbot.
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    player.CameraMode = Enum.CameraMode.Classic
    local runService = game:GetService("RunService")
    local StarterGui = game:GetService("StarterGui")
    local camera = workspace.CurrentCamera
    StarterGui:SetCore("SendNotification", {
        Title = "Code by GioBolqvi", -- dont skid 🙏💀
        Text = "on Roblox",
        Duration = 3
    })
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NPC_Lock_GUI"
    screenGui.Parent = game:GetService("CoreGui")
    local button = Instance.new("TextButton")
    button.Name = "NPC Lock: ON/OFF"
    button.Size = UDim2.new(0, 150, 0, 50)
    button.Position = UDim2.new(0.5, -75, 0.9, -25)
    button.BackgroundColor3 = Color3.new(0, 0, 0)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = "NPC Lock: OFF"
    button.Font = Enum.Font.Fantasy
    button.TextScaled = true
    button.TextSize = 20
    button.Parent = screenGui
    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 12)
    uicorner.Parent = button
    local dragging = false
    local dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = button.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            update(input)
        end
    end)
    local npcLock = false
    local lastTarget = nil
    local toggleLoop
    local function addPlayerHighlight()
        if player.Character then
            local highlight = player.Character:FindFirstChild("PlayerHighlightESP")
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "PlayerHighlightESP"
                highlight.FillColor = Color3.new(1, 1, 1)
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = player.Character
            end
        end
    end
    local function removePlayerHighlight()
        if player.Character and player.Character:FindFirstChild("PlayerHighlightESP") then
            player.Character.PlayerHighlightESP:Destroy()
        end
    end
    local function getClosestNPC()
        local closestNPC = nil
        local closestDistance = math.huge
        for _, object in ipairs(workspace:GetDescendants()) do
            if object:IsA("Model") then
                local humanoid = object:FindFirstChild("Humanoid") or object:FindFirstChildWhichIsA("Humanoid")
                local hrp = object:FindFirstChild("HumanoidRootPart") or object.PrimaryPart
                if humanoid and hrp and humanoid.Health > 0 and object.Name ~= "Horse" then
                    local distance = (camera.CFrame.Position - hrp.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestNPC = object
                    end
                end
            end
        end
        return closestNPC
    end
    local function addHighlight(target)
        if target then
            local highlight = target:FindFirstChild("NPCHighlightESP")
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "NPCHighlightESP"
                highlight.FillColor = Color3.new(1, 0, 0)
                highlight.OutlineColor = Color3.new(1, 0, 0)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = target
            end
        end
    end
    local function removeHighlight(target)
        if target and target:FindFirstChild("NPCHighlightESP") then
            target.NPCHighlightESP:Destroy()
        end
    end
    local function updateCamera()
        local target = getClosestNPC()
        if target then
            local hrp = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart
            if hrp then
                camera.CFrame = CFrame.new(camera.CFrame.Position, hrp.Position)
                if lastTarget and lastTarget ~= target then
                    removeHighlight(lastTarget)
                end
                addHighlight(target)
                lastTarget = target
            end
        else
            if lastTarget then
                removeHighlight(lastTarget)
                lastTarget = nil
            end
        end
    end
    button.MouseButton1Click:Connect(function()
        npcLock = not npcLock
        if npcLock then
            button.Text = "NPC Lock: ON"
            addPlayerHighlight()
            toggleLoop = runService.RenderStepped:Connect(updateCamera)
        else
            button.Text = "NPC Lock: OFF"
            removePlayerHighlight()
            if toggleLoop then
                toggleLoop:Disconnect()
            end
            if lastTarget then
                removeHighlight(lastTarget)
                lastTarget = nil
            end
        end
    end)
end)
