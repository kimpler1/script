local fov = 136
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Cam = workspace.CurrentCamera
local Player = game:GetService("Players").LocalPlayer
local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 2
FOVring.Color = Color3.fromRGB(128, 0, 128)
FOVring.Filled = false
FOVring.Radius = fov
FOVring.Position = Cam.ViewportSize / 2
local isAiming = false
local validNPCs = {}
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 120, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.Text = "AIMBOT: OFF"
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.TextColor3 = Color3.fromRGB(255, 50, 50)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.Parent = ScreenGui
local function isNPC(obj)
    return obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 and obj:FindFirstChild("Head") and obj:FindFirstChild("HumanoidRootPart") and not game:GetService("Players"):GetPlayerFromCharacter(obj)
end
local function updateNPCs()
    local tempTable = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if isNPC(obj) then
            tempTable[obj] = true
        end
    end
    for i = #validNPCs, 1, -1 do
        if not tempTable[validNPCs[i]] then
            table.remove(validNPCs, i)
        end
    end
    for obj in pairs(tempTable) do
        if not table.find(validNPCs, obj) then
            table.insert(validNPCs, obj)
        end
    end
end
local function handleDescendantAdded(obj)
    if isNPC(obj) then
        table.insert(validNPCs, obj)
    end
end
local function handleDescendantRemoving(obj)
    for i, npc in ipairs(validNPCs) do
        if npc == obj then
            table.remove(validNPCs, i)
            break
        end
    end
end
workspace.DescendantAdded:Connect(handleDescendantAdded)
workspace.DescendantRemoving:Connect(handleDescendantRemoving)
RunService.RenderStepped:Connect(function()
    updateNPCs()
end)
local function getClosestNPCInFOV()
    local closestNPC = nil
    local shortestDistance = fov
    for _, npc in ipairs(validNPCs) do
        local head = npc:FindFirstChild("Head")
        if head then
            local screenPos, onScreen = Cam:WorldToViewportPoint(head.Position)
            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - Cam.ViewportSize / 2).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestNPC = npc
                end
            end
        end
    end
    return closestNPC
end
local function isVisible(targetPosition)
    raycastParams.FilterDescendantsInstances = {Player.Character}
    local raycastResult = workspace:Raycast(Cam.CFrame.Position, (targetPosition - Cam.CFrame.Position).Unit * 500, raycastParams)
    return raycastResult == nil or raycastResult.Position == targetPosition
end
local function aimAtNPC(npc)
    local head = npc:FindFirstChild("Head")
    if head and isVisible(head.Position) then
        Cam.CFrame = CFrame.lookAt(Cam.CFrame.Position, head.Position)
    end
end
local connection
ToggleButton.MouseButton1Click:Connect(function()
    isAiming = not isAiming
    if isAiming then
        ToggleButton.Text = "AIMBOT: ON"
        ToggleButton.TextColor3 = Color3.fromRGB(50, 255, 50)
        FOVring.Visible = true
        connection = RunService.RenderStepped:Connect(function()
            FOVring.Position = Cam.ViewportSize / 2
            local closestNPC = getClosestNPCInFOV()
            if closestNPC then
                aimAtNPC(closestNPC)
            end
        end)
    else
        ToggleButton.Text = "AIMBOT: OFF"
        ToggleButton.TextColor3 = Color3.fromRGB(255, 50, 50)
        FOVring.Visible = false
        if connection then
            connection:Disconnect()
        end
    end
end)
