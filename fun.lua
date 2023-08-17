local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local screenGui = Instance.new("ScreenGui")
screenGui.IgnoreGuiInset = true
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, 0, 1, 0)
frame.Position = UDim2.new(0, 0, 0, 0)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.Parent = screenGui

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 150, 0, 150)
logo.Position = UDim2.new(0.5, -75, 0.5, -75)
logo.AnchorPoint = Vector2.new(0.5, 0.5)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://133293265"
logo.Parent = frame

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, -40, 1, -220)
textLabel.Position = UDim2.new(0, 20, 0, 160)
textLabel.Text = "Fuck You Nigger."
textLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
textLabel.Font = Enum.Font.SourceSans
textLabel.TextSize = 24
textLabel.BackgroundTransparency = 1
textLabel.TextWrapped = true
textLabel.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 120, 0, 40)
closeButton.Position = UDim2.new(0.5, -60, 1, -80)
closeButton.AnchorPoint = Vector2.new(0.5, 1)
closeButton.Text = "Leave Game"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
closeButton.BorderSizePixel = 0
closeButton.Parent = frame

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
