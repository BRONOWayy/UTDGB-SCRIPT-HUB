if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

-- Build Tracking Manifest
local SCRIPT_VERSION = "1.0.3"

---------------------------------------------------------
-- 1. CLEAN INTERFACE CONSTRUCTOR
---------------------------------------------------------
if CoreGui:FindFirstChild("DeltaInterceptorPanel") then
    CoreGui.DeltaInterceptorPanel:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaInterceptorPanel"
ScreenGui.ResetOnSpawn = false

local attached, _ = pcall(function() ScreenGui.Parent = CoreGui end)
if not attached then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 130)
MainFrame.Position = UDim2.new(0.15, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MovingThing = Instance.new("Frame")
MovingThing.Size = UDim2.new(1, 0, 0, 30)
MovingThing.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MovingThing.BorderSizePixel = 1
MovingThing.BorderColor3 = Color3.fromRGB(50, 50, 50)
MovingThing.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Pipeline Cooldown Lock"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.Font = Enum.Font.SourceSans
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MovingThing

local VerLabel = Instance.new("TextLabel")
VerLabel.Size = UDim2.new(0, 50, 1, 0)
VerLabel.Position = UDim2.new(1, -55, 0, 0)
VerLabel.BackgroundTransparency = 1
VerLabel.Text = "v" .. SCRIPT_VERSION
VerLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
VerLabel.Font = Enum.Font.SourceSansItalic
VerLabel.TextSize = 12
VerLabel.TextXAlignment = Enum.TextXAlignment.Right
VerLabel.Parent = MovingThing

-- Dragging Functionality Block
local dragging, dragInput, dragStart, startPos
MovingThing.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
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

-- Toggle Frame
local ModeFrame = Instance.new("Frame")
ModeFrame.Size = UDim2.new(1, -14, 0, 35)
ModeFrame.Position = UDim2.new(0, 7, 0, 42)
ModeFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ModeFrame.BorderColor3 = Color3.fromRGB(45, 45, 45)
ModeFrame.Parent = MainFrame

local ModeLabel = Instance.new("TextLabel")
ModeLabel.Size = UDim2.new(0.6, 0, 1, 0)
ModeLabel.Position = UDim2.new(0, 8, 0, 0)
ModeLabel.BackgroundTransparency = 1
ModeLabel.Text = "Force Absolute Cooldown (0.01):"
ModeLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
ModeLabel.Font = Enum.Font.SourceSans
ModeLabel.TextSize = 13
ModeLabel.TextXAlignment = Enum.TextXAlignment.Left
ModeLabel.Parent = ModeFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.35, 0, 0.7, 0)
ToggleBtn.Position = UDim2.new(0.62, 0, 0.15, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ToggleBtn.BorderColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.Text = "OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 13
ToggleBtn.Parent = ModeFrame

local LockActive = false
ToggleBtn.MouseButton1Click:Connect(function()
    LockActive = not LockActive
    ToggleBtn.Text = LockActive and "ON" or "OFF"
    ToggleBtn.BackgroundColor3 = LockActive and Color3.fromRGB(55, 55, 55) or Color3.fromRGB(25, 25, 25)
end)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -14, 0, 25)
StatusLabel.Position = UDim2.new(0, 7, 0, 90)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Operational"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.Font = Enum.Font.SourceSansItalic
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
MainFrame.Parent = ScreenGui
StatusLabel.Parent = MainFrame

---------------------------------------------------------
-- 2. DIRECT DATA OVERRIDE ENGINE
---------------------------------------------------------
RunService.Heartbeat:Connect(function()
    if not LockActive then return end
    
    local updatedCount = 0
    
    -- Target the inventory storage locations verified via your workspace layout
    local paths = { Player:FindFirstChild("Backpack"), Player.Character }
    
    for p = 1, #paths do
        local container = paths[p]
        if container then
            -- Locate tools inside your storage tree directly
            local items = container:GetDescendants()
            for i = 1, #items do
                local obj = items[i]
                -- Match specific NumberValue configurations
                if obj:IsA("NumberValue") and string.lower(obj.Name) == "cooldown" then
                    obj.Value = 0.01
                    updatedCount = updatedCount + 1
                end
            end
        end
    end
    
    if updatedCount > 0 then
        StatusLabel.Text = "Altered " .. tostring(updatedCount) .. " runtime value structures to 0.01"
    else
        StatusLabel.Text = "Searching for active weapon configurations..."
    end
end)
