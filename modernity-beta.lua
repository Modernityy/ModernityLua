--[[

    Modernity by lawyer
    <3 - modernity.me (Soon™️)

]]

if _G.isModernityLoaded then
    game.Players.LocalPlayer.PlayerGui:FindFirstChild("Modernity"):Destroy()
    if _G.ModernityConnections then
        for _, connection in pairs(_G.ModernityConnections) do
            connection:Disconnect()
        end
    end
end

_G.isModernityLoaded = true
_G.ModernityConnections = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Workspace = game:GetService("Workspace")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Modernity"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BackgroundTransparency = 1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Modernity"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(0, 120, 1, -40)
TabContainer.Position = UDim2.new(0, 10, 0, 40)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -150, 1, -50)
ContentFrame.Position = UDim2.new(0, 140, 0, 40)
ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ContentFrame.BackgroundTransparency = 0.5
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = ContentFrame

local function createTab(name, yPos)
    local tab = Instance.new("TextButton")
    tab.Name = name
    tab.Size = UDim2.new(1, 0, 0, 30)
    tab.Position = UDim2.new(0, 0, 0, yPos)
    tab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    tab.BackgroundTransparency = 0.5
    tab.Text = name
    tab.TextColor3 = Color3.fromRGB(255, 255, 255)
    tab.TextSize = 14
    tab.Font = Enum.Font.Gotham
    tab.Parent = TabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tab
    
    return tab
end

local function createContent(name)
    local content = Instance.new("Frame")
    content.Name = name .. "Content"
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.Parent = ContentFrame
    return content
end

local tabs = {
    createTab("Aimbot", 0),
    createTab("Visuals", 40),
    createTab("Misc", 80),
    createTab("Config", 120)
}

local contents = {
    createContent("Aimbot"),
    createContent("Visuals"),
    createContent("Misc"),
    createContent("Config")
}

local function createToggle(parent, text, yPos, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(1, -20, 0, 30)
    toggle.Position = UDim2.new(0, 10, 0, yPos)
    toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggle.BackgroundTransparency = 0.7
    toggle.Text = text
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextSize = 14
    toggle.Font = Enum.Font.Gotham
    toggle.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggle

    local enabled = false
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggle.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
        callback(enabled)
    end)

    return toggle
end

local function createSlider(parent, text, minValue, maxValue, defaultValue, yPos, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 50)
    sliderFrame.Position = UDim2.new(0, 10, 0, yPos)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent

    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(1, 0, 0, 20)
    sliderLabel.Position = UDim2.new(0, 0, 0, 0)
    sliderLabel.Text = text .. ": " .. defaultValue
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderLabel.Parent = sliderFrame

    local sliderBackground = Instance.new("Frame")
    sliderBackground.Size = UDim2.new(1, 0, 0, 10)
    sliderBackground.Position = UDim2.new(0, 0, 0, 25)
    sliderBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBackground.Parent = sliderFrame

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    sliderFill.Parent = sliderBackground

    local sliderHandle = Instance.new("Frame")
    sliderHandle.Size = UDim2.new(0, 20, 1, 10)
    sliderHandle.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -10, -0.5, 0)
    sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderHandle.Parent = sliderBackground

    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBackground.AbsolutePosition.X) / sliderBackground.AbsoluteSize.X, 0, 1)
        local value = math.floor(minValue + (maxValue - minValue) * pos)
        
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        sliderHandle.Position = UDim2.new(pos, -10, -0.5, 0)
        sliderLabel.Text = text .. ": " .. value
        
        callback(value)
    end

    sliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    connection:Disconnect()
                end
            end)
            
            while input.UserInputState == Enum.UserInputState.Down do
                updateSlider(input)
                input = UserInputService.InputChanged:Wait()
            end
        end
    end)

    sliderBackground.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateSlider(input)
        end
    end)

    return sliderFrame
end

local function switchTab(tabName)
    for _, content in ipairs(contents) do
        content.Visible = content.Name == tabName .. "Content"
    end
end

for _, tab in ipairs(tabs) do
    tab.MouseButton1Click:Connect(function()
        switchTab(tab.Name)
    end)
end

switchTab("Aimbot")

local function fadeIn()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0.1})
    tween:Play()
end

local function fadeOut()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
    tween:Play()
    tween.Completed:Wait()
    MainFrame.Visible = false
end

fadeIn()

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

table.insert(_G.ModernityConnections, UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end))

table.insert(_G.ModernityConnections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Insert and not gameProcessed then
        if MainFrame.Visible then
            fadeOut()
        else
            MainFrame.Visible = true
            fadeIn()
        end
    end
end))

local LocalPlayer = Players.LocalPlayer
local espEnabled = false
local aimbotEnabled = false
local aimbotKey = Enum.UserInputType.MouseButton2

local function IsTeamMate(player)
    return player.Team and player.Team == LocalPlayer.Team
end

local function IsVisible(targetPosition)
    local rayOrigin = Camera.CFrame.Position
    local rayDirection = (targetPosition - rayOrigin).unit * (targetPosition - rayOrigin).magnitude
    
    local raycastResult = Workspace:Raycast(rayOrigin, rayDirection)

    return not raycastResult or raycastResult.Instance:IsDescendantOf(Workspace) and raycastResult.Instance.Name ~= "Head"
end

local function CreateBoxESP(player)
    if IsTeamMate(player) then return end

    local box = Drawing.new("Square")
    local nameText = Drawing.new("Text")
    
    box.Visible = false
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Thickness = 2
    box.Transparency = 1
    box.Filled = false

    nameText.Visible = false
    nameText.Color = Color3.fromRGB(255, 255, 255)
    nameText.Size = 14
    nameText.Center = true
    nameText.Outline = true

    local function UpdateESP()
        if not espEnabled then
            box.Visible = false
            nameText.Visible = false
            return
        end

        if IsTeamMate(player) then
            box.Visible = false
            nameText.Visible = false
            return
        end

        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = character.HumanoidRootPart
            local vector, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
            
            if onScreen then
                local headPos = Camera:WorldToViewportPoint(character.Head.Position)
                local legPos = Camera:WorldToViewportPoint(humanoidRootPart.Position - Vector3.new(0, 3, 0))
                
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height * 0.6
                
                box.Size = Vector2.new(width, height)
                box.Position = Vector2.new(vector.X - width / 2, vector.Y - height / 2)
                box.Visible = true

                nameText.Position = Vector2.new(vector.X, vector.Y - height - 20)
                nameText.Text = player.Name
                nameText.Visible = true
            else
                box.Visible = false
                nameText.Visible = false
            end
        else
            box.Visible = false
            nameText.Visible = false
        end
    end

    table.insert(_G.ModernityConnections, RunService.RenderStepped:Connect(UpdateESP))
end

local function GetClosestVisibleEnemy()
    local closestPlayer, closestDistance = nil, math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not IsTeamMate(player) and player.Character and player.Character:FindFirstChild("Head") then
            
                        local headPosition, onScreenHeadPosition = Camera:WorldToViewportPoint(player.Character.Head.Position)

            if onScreenHeadPosition and IsVisible(player.Character.Head.Position) then 
                local distanceToMouse = (Vector2.new(headPosition.X, headPosition.Y) - UserInputService:GetMouseLocation()).Magnitude
                
                if distanceToMouse < closestDistance then
                    closestDistance = distanceToMouse
                    closestPlayer = player
                end 
            end 
        end 
    end 

    return closestPlayer 
end 

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.NumSides = 100
fovCircle.Radius = 100
fovCircle.Filled = false
fovCircle.Visible = false
fovCircle.ZIndex = 999
fovCircle.Transparency = 1
fovCircle.Color = Color3.fromRGB(255, 255, 255)

local fovEnabled = false
local fovSize = 100

local function AimbotUpdate()
    fovCircle.Position = UserInputService:GetMouseLocation()
    fovCircle.Radius = fovSize
    fovCircle.Visible = fovEnabled

    if aimbotEnabled and UserInputService:IsMouseButtonPressed(aimbotKey) then
        local closestEnemy = GetClosestVisibleEnemy()
        if closestEnemy and closestEnemy.Character and closestEnemy.Character:FindFirstChild("Head") then 
            local headPositionOnScreen, onScreenHeadPosition =
                Camera:WorldToViewportPoint(closestEnemy.Character.Head.Position)

            if onScreenHeadPosition then 
                local mousePos = UserInputService:GetMouseLocation()
                local distance = (Vector2.new(headPositionOnScreen.X, headPositionOnScreen.Y) - mousePos).Magnitude
                
                if distance <= fovSize then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestEnemy.Character.Head.Position)
                end
            end 
        end
    end
end

table.insert(_G.ModernityConnections, RunService.RenderStepped:Connect(AimbotUpdate))

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateBoxESP(player)
    end
end

table.insert(_G.ModernityConnections, Players.PlayerAdded:Connect(CreateBoxESP))

createToggle(contents[2], "ESP Toggle", 10, function(enabled)
    espEnabled = enabled
end)

createToggle(contents[1], "Enable Aimbot", 10, function(enabled)
    aimbotEnabled = enabled
end)

local fovToggle = createToggle(contents[1], "Show FOV Circle", 50, function(enabled)
    fovEnabled = enabled
end)

createSlider(contents[1], "FOV Size", 0, 500, 100, 90, function(value)
    fovSize = value
end)

ScreenGui.Destroying:Connect(function()
    fovCircle:Remove()
    for _, connection in pairs(_G.ModernityConnections) do
        connection:Disconnect()
    end
    _G.isModernityLoaded = false
end)
