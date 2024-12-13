local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Workspace = game:GetService("Workspace")

-- Your existing UI code here (unchanged)
-- ...

-- ESP and Aimbot functionality
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

    RunService.RenderStepped:Connect(UpdateESP)
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

-- Aimbot function
local function AimbotUpdate()
    if aimbotEnabled and UserInputService:IsMouseButtonPressed(aimbotKey) then
        local closestEnemy = GetClosestVisibleEnemy()
        if closestEnemy and closestEnemy.Character and closestEnemy.Character:FindFirstChild("Head") then 
            local headPositionOnScreen, onScreenHeadPosition =
                Camera:WorldToViewportPoint(closestEnemy.Character.Head.Position)

            if onScreenHeadPosition then 
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestEnemy.Character.Head.Position)
            end 
        end
    end
end

-- Connect Aimbot to RenderStepped
RunService.RenderStepped:Connect(AimbotUpdate)

-- Initialize ESP for existing players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateBoxESP(player)
    end
end

-- Initialize ESP for new players
Players.PlayerAdded:Connect(CreateBoxESP)

-- Modify your existing UI elements to control ESP and Aimbot
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
end

-- Create toggles for ESP and Aimbot
createToggle(contents[2], "ESP Toggle", 10, function(enabled)
    espEnabled = enabled
end)

createToggle(contents[1], "Enable Aimbot", 10, function(enabled)
    aimbotEnabled = enabled
end)

-- You can add more UI elements to control other aspects of the ESP and Aimbot if needed

-- The rest of your UI code remains unchanged
