-- Bullshit GUI --
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("BullShit", "DarkTheme")

-- Main --
local ESP = Window:NewTab("ESP")
local ESPSection = ESP:NewSection("ESP Section")
local Aimbot = Window:NewTab("Aimbot")
local AimbotSection = Aimbot:NewSection("Aimbot Section")
local AimbotTogglesSection = Aimbot:NewSection("Aimbot Toggles")
local FOVTogglesSection = Aimbot:NewSection("FOV Toggles")
local character = Window:NewTab("Character")
local movementSection = character:NewSection("Movement Section")


ESPSection:NewButton("ESP", "Shows enemy player chams, heath, name and distance from you.", function()
    local player = game.Players.LocalPlayer
    local RunService = game:GetService("RunService")
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "Highlight"
    
    local function createHighlight(character)
        if character and not character:FindFirstChild("HumanoidRootPart"):FindFirstChild("Highlight") then
            local highlightClone = highlight:Clone()
            highlightClone.Adornee = character
            highlightClone.Parent = character:FindFirstChild("HumanoidRootPart")
            highlightClone.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlightClone.Name = "Highlight"
        end
    end
    
    local function updatePlayerLabels()
        for _, otherPlayer in pairs(game.Players:GetPlayers()) do
            if otherPlayer ~= player then
                local character = otherPlayer.Character
                local humanoid = character and character:FindFirstChild("Humanoid")
                local head = character and character:FindFirstChild("Head")
    
                local nameLabel = head and head:FindFirstChild("PlayerLabel")
                if humanoid and head and humanoid.Health > 0 then
                    local distance = (head.Position - player.Character.Head.Position).Magnitude
    
                    if not nameLabel then
                        nameLabel = Instance.new("BillboardGui")
                        nameLabel.Name = "PlayerLabel"
                        nameLabel.AlwaysOnTop = true
                        nameLabel.ExtentsOffset = Vector3.new(0, 2, 0)
                        nameLabel.Size = UDim2.new(0, 100, 0, 30)
    
                        local nameLabelText = Instance.new("TextLabel")
                        nameLabelText.Name = "NameLabel"
                        nameLabelText.BackgroundTransparency = 1
                        nameLabelText.Position = UDim2.new(0, 0, 0, 0)
                        nameLabelText.Size = UDim2.new(1, 0, 0.5, 0)
                        nameLabelText.Text = ""
                        nameLabelText.TextColor3 = Color3.new(1, 1, 1)
                        nameLabelText.Font = Enum.Font.SourceSansBold
                        nameLabelText.TextSize = 18
                        nameLabelText.Parent = nameLabel
    
                        local healthLabel = Instance.new("TextLabel")
                        healthLabel.Name = "HealthLabel"
                        healthLabel.BackgroundTransparency = 1
                        healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
                        healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
                        healthLabel.Text = ""
                        healthLabel.TextColor3 = Color3.new(1, 1, 1)
                        healthLabel.Font = Enum.Font.SourceSansBold
                        healthLabel.TextSize = 18
                        healthLabel.Parent = nameLabel
    
                        nameLabel.Parent = head
                    end
    
                    nameLabel.NameLabel.Text = otherPlayer.Name
                    nameLabel.HealthLabel.Text = string.format("Distance: %.2f | Health: %d", distance, humanoid.Health)
                    nameLabel.Adornee = head
                elseif nameLabel then
                    nameLabel:Destroy()
                end
            end
        end
    end
    
    local function playerAdded(playerAdded)
        repeat wait() until playerAdded.Character
        createHighlight(playerAdded.Character)
        updatePlayerLabels()
    end
    
    game.Players.PlayerAdded:Connect(playerAdded)
    
    game.Players.PlayerRemoving:Connect(function(playerRemoved)
        local character = playerRemoved.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local nameLabel = humanoidRootPart:FindFirstChild("PlayerLabel")
                if nameLabel then
                    nameLabel:Destroy()
                end
            end
        end
    end)
    
    RunService.Heartbeat:Connect(function()
        for _, player in ipairs(game.Players:GetPlayers()) do
            createHighlight(player.Character)
        end
        updatePlayerLabels()
    end)    
end)

AimbotSection:NewButton("Add Aimbot", "Click This For Aimbot To Work", function()
-- BullShit Aimbot ---
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Holding = false

-- aimbot settings --
_G.AimbotEnabled = true
_G.TeamCheck = false
_G.Aimpart = "Head"
_G.Sensitivity = 0.1 -- the lower the number the faster the lock --

-- Fov settings --
_G.CircleSides = 64
_G.CircleColor = Color3.fromRGB(255, 255, 255)
_G.CircleTransparency = 0.7
_G.CircleRadius = 80
_G.CircleFilled = false
_G.CircleVisible = true
_G.CircleThickness = 0

local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCircle.Radius = _G.CircleRadius
FOVCircle.Color = _G.CircleColor
FOVCircle.Visible = _G.CircleVisible
FOVCircle.Transparency = _G.CircleTransparency
FOVCircle.NumSides = _G.CircleSides
FOVCircle.Thickness = _G.CircleThickness

local function IsInFrontOfCamera(part)
    local cameraCFrame = Camera.CFrame
    local partPosition = part.Position
    local cameraLookVector = cameraCFrame.LookVector
    local directionToPart = (partPosition - cameraCFrame.Position).Unit
    local dotProduct = cameraLookVector:Dot(directionToPart)
    return dotProduct > 0
end

local function GetClosestPlayerInFront()
    local MaximumDistance = _G.CircleRadius
    local Target = nil
    local BestAngle = math.huge

    for _, v in next, Players:GetPlayers() do
        if v.Name ~= LocalPlayer.Name then
            if not _G.TeamCheck or (v.Team ~= LocalPlayer.Team) then
                local character = v.Character
                if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") and character:FindFirstChild("Humanoid").Health > 0 then
                    local ScreenPoint = Camera:WorldToScreenPoint(character.HumanoidRootPart.Position)
                    local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude

                    if VectorDistance < MaximumDistance then
                        local angle = math.acos(Vector3.new(ScreenPoint.X, ScreenPoint.Y, 0).Unit:Dot(Vector3.new(1, 0, 0)))
                        if angle < BestAngle and IsInFrontOfCamera(character.HumanoidRootPart) then
                            BestAngle = angle
                            Target = v
                        end
                    end
                end
            end
        end
    end

    return Target
end

UserInputService.InputBegan:Connect(function (Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = true
    end        
end)

UserInputService.InputEnded:Connect(function (Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = false
    end        
end)

RunService.RenderStepped:Connect(function ()
    FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    FOVCircle.Radius = _G.CircleRadius
    FOVCircle.Color = _G.CircleColor
    FOVCircle.Visible = _G.CircleVisible
    FOVCircle.Transparency = _G.CircleTransparency
    FOVCircle.NumSides = _G.CircleSides
    FOVCircle.Thickness = _G.CircleThickness

    if Holding and _G.AimbotEnabled then
        local closestPlayer = GetClosestPlayerInFront()
        if closestPlayer then
            TweenService:Create(Camera, TweenInfo.new(_G.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, closestPlayer.Character[_G.Aimpart].Position)}):Play()
        end
    end
end)
end)

AimbotTogglesSection:NewToggle("Enable Aimbot", "Enables Aimbot", function(state)
    if state then
        _G.AimbotEnabled = true
    else
        _G.AimbotEnabled = false
    end
end)

AimbotTogglesSection:NewToggle("Enable Team Check", "Enables Team Check", function(state)
    if state then
        _G.TeamCheck = true
    else
        _G.TeamCheck = false
    end
end)

AimbotTogglesSection:NewSlider("Aimlock Speed", "The Lower The Number The Faster The Lock", 1, 0, function(s)
    _G.Sensitivity = s
end)

FOVTogglesSection:NewSlider("FOV Size", "Changes The Size Of The FOV", 1000, 0, function(s)
    _G.CircleRadius = s
end)

FOVTogglesSection:NewSlider("FOV Sides", "Changes The Amount Of Sides The FOV Has", 100, 0, function(s)
    _G.CircleSides = s
end)

FOVTogglesSection:NewSlider("FOV Transparency", "Changes The Transparency Of The FOV", 2, 0, function(s)
    _G.CircleTransparency = s
end)

FOVTogglesSection:NewSlider("FOV Thickness", "Changes The Thickness Of The FOV", 30, 0, function(s)
    _G.CircleThickness = s
end)



FOVTogglesSection:NewToggle("FOV Visible", "Great Now You Dont Know Where You Gonna Lock", function(state)
    if state then
        _G.CircleVisible = true
    else
        _G.CircleVisible = false
    end
end)

FOVTogglesSection:NewColorPicker("FOV Color", "Changes The FOV Color", Color3.fromRGB(0, 0, 0), function(color)
    _G.CircleColor = color
end)

movementSection:NewSlider("Walk Speed Slider", "Speed", 500, 0, function(s) -- 500 (MaxValue) | 0 (MinValue)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

movementSection:NewSlider("Jump power Slider", "Jump", 500, 0, function(s) -- 500 (MaxValue) | 0 (MinValue)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = s
end)