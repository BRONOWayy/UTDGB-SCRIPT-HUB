if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

-- Build Tracking Manifest
local SCRIPT_VERSION = "1.0.8-Universal"

---------------------------------------------------------
-- 1. CLEAN RESET OF ALL PREVIOUS INSTANCES
---------------------------------------------------------
local oldPanels = {
    "DeltaGlobalM1Panel",
    "DeltaNumberValuePanel",
    "DeltaLagFreePanel",
    "DeltaZeroLagPanel",
    "DeltaSelectorPanel",
    "DeltaWeaponFirePanel",
    "DeltaInterceptorPanel",
    "DeltaCancelPanel",
    "DeltaFixedCancelPanel",
    "DeltaHyperV6Panel"
}

for _, panelName in ipairs(oldPanels) do
    pcall(function()
        if CoreGui:FindFirstChild(panelName) then CoreGui[panelName]:Destroy() end
        if Player.PlayerGui:FindFirstChild(panelName) then Player.PlayerGui[panelName]:Destroy() end
    end)
end

---------------------------------------------------------
-- 2. UNIVERSAL COMPATIBILITY INTERFACE
---------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaUniversalV8Panel"
ScreenGui.ResetOnSpawn = false

local attached, _ = pcall(function() ScreenGui.Parent = CoreGui end)
if not attached then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 130)
MainFrame.Position = UDim2.new(0.2, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(55, 55, 55)
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MovingThing = Instance.new("Frame")
MovingThing.Size = UDim2.new(1, 0, 0, 30)
MovingThing.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MovingThing.BorderSizePixel = 1
MovingThing.BorderColor3 = Color3.fromRGB(55, 55, 55)
MovingThing.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Universal Weapon System"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.Font = Enum.Font.SourceSans
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MovingThing

local VerLabel = Instance.new("TextLabel")
VerLabel.Size = UDim2.new(0, 80, 1, 0)
VerLabel.Position = UDim2.new(1, -85, 0, 0)
VerLabel.BackgroundTransparency = 1
VerLabel.Text = "v" .. SCRIPT_VERSION
VerLabel.TextColor3 = Color3.fromRGB(0, 220, 255) -- Cyan indicator for pure compatibility
VerLabel.Font = Enum.Font.SourceSansBold
VerLabel.TextSize = 11
VerLabel.TextXAlignment = Enum.TextXAlignment.Right
VerLabel.Parent = MovingThing

-- Simple Drag Handler
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

-- Toggle Options
local ModeFrame = Instance.new("Frame")
ModeFrame.Size = UDim2.new(1, -14, 0, 35)
ModeFrame.Position = UDim2.new(0, 7, 0, 42)
ModeFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ModeFrame.BorderColor3 = Color3.fromRGB(45, 45, 45)
ModeFrame.Parent = MainFrame

local ModeLabel = Instance.new("TextLabel")
ModeLabel.Size = UDim2.new(0, 160, 1, 0)
ModeLabel.Position = UDim2.new(0, 8, 0, 0)
ModeLabel.BackgroundTransparency = 1
ModeLabel.Text = "Zero-Interval Fire Mode:"
ModeLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
ModeLabel.Font = Enum.Font.SourceSans
ModeLabel.TextSize = 13
ModeLabel.TextXAlignment = Enum.TextXAlignment.Left
ModeLabel.Parent = ModeFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 80, 0.7, 0)
ToggleBtn.Position = UDim2.new(1, -88, 0, 5)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.BorderColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.Text = "OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 13
ToggleBtn.Parent = ModeFrame

local SystemActive = false
ToggleBtn.MouseButton1Click:Connect(function()
    SystemActive = not SystemActive
    ToggleBtn.Text = SystemActive and "ON" or "OFF"
    ToggleBtn.BackgroundColor3 = SystemActive and Color3.fromRGB(40, 60, 80) or Color3.fromRGB(20, 20, 20)
end)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -14, 0, 25)
StatusLabel.Position = UDim2.new(0, 7, 0, 90)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Universal build loaded without experimental hooks."
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.Font = Enum.Font.SourceSansItalic
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
StatusLabel.Parent = MainFrame

---------------------------------------------------------
-- 3. INTERCEPTOR PIPELINE (ERROR-SAFE)
---------------------------------------------------------
RunService.Heartbeat:Connect(function()
    if not SystemActive then 
        StatusLabel.Text = "Awaiting activation toggle..."
        return 
    end

    local character = Player.Character
    if not character then return end
    
    local activeTool = character:FindFirstChildOfClass("Tool")
    local valueLocked = false
    
    -- Part A: Safe Structural Configuration Lock
    if activeTool then
        local cd = activeTool:FindFirstChild("Cooldown", true)
        if cd and cd:IsA("ValueBase") then
            cd.Value = 0.01 -- Set to minimum safe interval to prevent server lag drops
            valueLocked = true
        end
    end
    
    -- Part B: Safe Animation Track Accelerator
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and activeTool then
        local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid
        local tracks = animator:GetPlayingAnimationTracks()
        
        local acceleratedCount = 0
        for i = 1, #tracks do
            local track = tracks[i]
            
            -- Ignore basic movement/idles, target weapon swings only
            if track.Name ~= "Hold" and track.Name ~= "Idle" and track.Name ~= "run" and track.Name ~= "walk" then
                track:AdjustSpeed(35) -- Accelerate swing time securely without calling missing environment values
                acceleratedCount = acceleratedCount + 1
            end
        end
        
        if acceleratedCount > 0 and valueLocked then
            StatusLabel.Text = "Active: Cooldown Locked & Swings Accelerated!"
        elseif valueLocked then
            StatusLabel.Text = "Cooldown value forced down. Click to swing."
        else
            StatusLabel.Text = "Searching weapon configuration..."
        end
    else
        StatusLabel.Text = "Equip a weapon instance to start tracking."
    end
end)
