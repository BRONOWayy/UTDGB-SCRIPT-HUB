if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

-- Build Tracking Manifest
local SCRIPT_VERSION = "1.0.2"

---------------------------------------------------------
-- 1. STAGE PROTECTION HOOK
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
-- 2. INTERFACE CONSTRUCTOR
---------------------------------------------------------
if CoreGui:FindFirstChild("DeltaWeaponFirePanel") then
    CoreGui.DeltaWeaponFirePanel:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaWeaponFirePanel"
ScreenGui.ResetOnSpawn = false

local attached, _ = pcall(function() ScreenGui.Parent = CoreGui end)
if not attached then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 150)
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
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Animation & Cooldown Override"
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

-- Simple Drag Block
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

-- Controls Container
local ModeFrame = Instance.new("Frame")
ModeFrame.Size = UDim2.new(1, -14, 0, 35)
ModeFrame.Position = UDim2.new(0, 7, 0, 40)
ModeFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ModeFrame.BorderColor3 = Color3.fromRGB(55, 55, 55)
ModeFrame.Parent = MainFrame

local ModeLabel = Instance.new("TextLabel")
ModeLabel.Size = UDim2.new(0.6, 0, 1, 0)
ModeLabel.Position = UDim2.new(0, 8, 0, 0)
ModeLabel.BackgroundTransparency = 1
ModeLabel.Text = "Hacked Swift Swing Loop:"
ModeLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
ModeLabel.Font = Enum.Font.SourceSans
ModeLabel.TextSize = 13
ModeLabel.TextXAlignment = Enum.TextXAlignment.Left
ModeLabel.Parent = ModeFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.35, 0, 0.7, 0)
ToggleBtn.Position = UDim2.new(0.62, 0, 0.15, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ToggleBtn.BorderColor3 = Color3.fromRGB(60, 60, 60)
ToggleBtn.Text = "OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 13
ToggleBtn.Parent = ModeFrame

local FastSwingActive = false
ToggleBtn.MouseButton1Click:Connect(function()
    FastSwingActive = not FastSwingActive
    ToggleBtn.Text = FastSwingActive and "ON" or "OFF"
    ToggleBtn.BackgroundColor3 = FastSwingActive and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(25, 25, 25)
end)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -14, 0, 25)
StatusLabel.Position = UDim2.new(0, 7, 0, 85)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Monitoring local tool instance structures..."
StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
StatusLabel.Font = Enum.Font.SourceSansItalic
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
StatusLabel.Parent = MainFrame

---------------------------------------------------------
-- 3. ANIMATION AND DELAY CANCELLATION PIPELINE
---------------------------------------------------------
RunService.Heartbeat:Connect(function()
    local character = Player.Character
    if not character then return end
    
    local activeTool = character:FindFirstChildOfClass("Tool")
    if not activeTool then 
        StatusLabel.Text = "Ready. Hold your weapon to process."
        return 
    end
    
    -- Fast step 1: Force the configuration variable down to absolute zero
    local cd = activeTool:FindFirstChild("Cooldown", true)
    if cd and cd:IsA("ValueBase") then
        cd.Value = 0
    end
    
    if not FastSwingActive then 
        StatusLabel.Text = "Monitoring weapon values safely..."
        return 
    end
    
    -- Fast step 2: Intercept the playing attack track and freeze animation delay time
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid
        local playingTracks = animator:GetPlayingAnimationTracks()
        
        for i = 1, #playingTracks do
            local track = playingTracks[i]
            -- If it's playing an attack animation, speed it up massively to force Loaded.Length to 0
            if track.Name ~= "Hold" and track.Name ~= "Idle" then
                track:AdjustSpeed(100) -- Force animation to complete instantly
            end
        end
    end
    
    -- Fast step 3: Directly execute Activation triggers
    activeTool:Activate()
    StatusLabel.Text = "Bypassing animation timers on: " .. activeTool.Name
end)
