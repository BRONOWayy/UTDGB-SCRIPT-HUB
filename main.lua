if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

-- Build Tracking Manifest
local SCRIPT_VERSION = "1.0.4"

---------------------------------------------------------
-- 1. CLEAN INTERFACE CONSTRUCTOR
---------------------------------------------------------
if CoreGui:FindFirstChild("DeltaCancelPanel") then
    CoreGui.DeltaCancelPanel:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaCancelPanel"
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
Title.Text = "Animation & Cooldown Nullifier"
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

-- Toggle Button
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
ModeLabel.Text = "Cancel Animation Delays:"
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

local BypassActive = false
ToggleBtn.MouseButton1Click:Connect(function()
    BypassActive = not BypassActive
    ToggleBtn.Text = BypassActive and "ON" or "OFF"
    ToggleBtn.BackgroundColor3 = BypassActive and Color3.fromRGB(55, 55, 55) or Color3.fromRGB(25, 25, 25)
end)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -14, 0, 25)
StatusLabel.Position = UDim2.new(0, 7, 0, 90)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Monitoring local tool instance structures..."
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.Font = Enum.Font.SourceSansItalic
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
StatusLabel.Parent = MainFrame

---------------------------------------------------------
-- 2. ANIMATION CANCELLER & VALUE RESET pipeline
---------------------------------------------------------
RunService.Heartbeat:Connect(function()
    local character = Player.Character
    if not character then return end
    
    local activeTool = character:FindFirstChildOfClass("Tool")
    
    -- Part A: Always force the data value to 0.01 regardless of state
    if activeTool then
        local cd = activeTool:FindFirstChild("Cooldown", true)
        if cd and cd:IsA("ValueBase") then
            cd.Value = 0.01
        end
    end
    
    if not BypassActive then 
        StatusLabel.Text = "Monitoring weapon configuration..."
        return 
    end
    
    -- Part B: Intercept and forcefully terminate attack animations
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and activeTool then
        local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid
        local tracks = animator:GetPlayingAnimationTracks()
        
        local killedTracks = 0
        for i = 1, #tracks do
            local track = tracks[i]
            
            -- Keep the running idles/holds, drop everything else instantly
            if track.Name ~= "Hold" and track.Name ~= "Idle" and track.Name ~= "run" and track.Name ~= "walk" then
                track:Stop() -- Wipe out the track timing layout completely
                killedTracks = killedTracks + 1
            end
        end
        
        if killedTracks > 0 then
            StatusLabel.Text = "Interception Active: Dropped " .. tostring(killedTracks) .. " animation locks"
        else
            StatusLabel.Text = "Awaiting swing animation trigger..."
        end
    else
        StatusLabel.Text = "Hold a weapon to begin interception."
    end
end)
