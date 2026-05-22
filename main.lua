if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

---------------------------------------------------------
-- 1. BACKGROUND ENVIRONMENT PROTECTION HOOK
---------------------------------------------------------
local SafeColor = Instance.new("Color3Value")
SafeColor.Name = "NameColors"
SafeColor.Value = Color3.fromRGB(255, 255, 255)

local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
    if tostring(key) == "NameColors" and self:IsA("Player") then
        local success, realChild = pcall(function() 
            return oldIndex(game, "FindFirstChild")(self, "NameColors") 
        end)
        if success and realChild then 
            return realChild 
        end
        return SafeColor
    end
    return oldIndex(self, key)
end)

---------------------------------------------------------
-- 2. INTERFACE CONSTRUCTOR (Plain Theme)
---------------------------------------------------------
if CoreGui:FindFirstChild("DeltaLagFreePanel") then
    CoreGui.DeltaLagFreePanel:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaLagFreePanel"
ScreenGui.ResetOnSpawn = false

local attached, _ = pcall(function() ScreenGui.Parent = CoreGui end)
if not attached then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 270, 0, 110)
MainFrame.Position = UDim2.new(0.15, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MovingThing = Instance.new("Frame")
MovingThing.Size = UDim2.new(1, 0, 0, 30)
MovingThing.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MovingThing.BorderSizePixel = 1
MovingThing.BorderColor3 = Color3.fromRGB(60, 60, 60)
MovingThing.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Lag-Free Cooldown Overrider"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.Font = Enum.Font.SourceSans
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MovingThing

-- Drag Handling Block
local dragging, dragInput, dragStart, startPos
MovingThing.InputBegan:Connect(function(input)
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

MovingThing.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Cooldown Text Input Box
local ConfigHeaderBox = Instance.new("Frame")
ConfigHeaderBox.Size = UDim2.new(1, -14, 0, 35)
ConfigHeaderBox.Position = UDim2.new(0, 7, 0, 37)
ConfigHeaderBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ConfigHeaderBox.BorderColor3 = Color3.fromRGB(55, 55, 55)
ConfigHeaderBox.Parent = MainFrame

local ConfigLabel = Instance.new("TextLabel")
ConfigLabel.Size = UDim2.new(0.6, 0, 1, 0)
ConfigLabel.Position = UDim2.new(0, 8, 0, 0)
ConfigLabel.BackgroundTransparency = 1
ConfigLabel.Text = "Lock Cooldown Value:"
ConfigLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
ConfigLabel.Font = Enum.Font.SourceSans
ConfigLabel.TextSize = 13
ConfigLabel.TextXAlignment = Enum.TextXAlignment.Left
ConfigLabel.Parent = ConfigHeaderBox

local CooldownValueInput = Instance.new("TextBox")
CooldownValueInput.Size = UDim2.new(0.35, 0, 0.7, 0)
CooldownValueInput.Position = UDim2.new(0.62, 0, 0.15, 0)
CooldownValueInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
CooldownValueInput.BorderColor3 = Color3.fromRGB(60, 60, 60)
CooldownValueInput.Text = "0.01"
CooldownValueInput.TextColor3 = Color3.fromRGB(255, 255, 255)
CooldownValueInput.Font = Enum.Font.SourceSansBold
CooldownValueInput.TextSize = 13
CooldownValueInput.ClearTextOnFocus = false
CooldownValueInput.Parent = ConfigHeaderBox

-- Status Feedback Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -14, 0, 25)
StatusLabel.Position = UDim2.new(0, 7, 0, 77)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "FPS Optimized. Monitoring cached values..."
StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
StatusLabel.Font = Enum.Font.SourceSansItalic
Status
