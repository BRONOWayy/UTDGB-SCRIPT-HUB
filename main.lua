if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

-- Build Tracking Manifest
local SCRIPT_VERSION = "1.0.7-Overdrive"

---------------------------------------------------------
-- 1. SYSTEM UNLINKING PURGE (Wipes all old configurations)
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
    "DeltaFixedCancelPanel"
}

for _, panelName in ipairs(oldPanels) do
    pcall(function()
        if CoreGui:FindFirstChild(panelName) then CoreGui[panelName]:Destroy() end
        if Player.PlayerGui:FindFirstChild(panelName) then Player.PlayerGui[panelName]:Destroy() end
     pcall(function()
end)

---------------------------------------------------------
-- 2. COMPLETELY UNIQUE INTERFACE CONSTRUCTOR
---------------------------------------------------------
-- Using a completely untracked name to force Luau to draw a fresh UI window
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaHyperV6Panel"
ScreenGui.ResetOnSpawn = false

local attached, _ = pcall(function() ScreenGui.Parent = CoreGui end)
if not attached then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 130)
MainFrame.Position = UDim2.new(0.2, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(65, 65, 65)
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MovingThing = Instance.new("Frame")
MovingThing.Size = UDim2.new(1, 0, 0, 30)
MovingThing.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MovingThing.BorderSizePixel = 1
MovingThing.BorderColor3 = Color3.fromRGB(65, 65, 65)
MovingThing.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Zero-Interval Attack Engine"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSans
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MovingThing

local VerLabel = Instance.new("TextLabel")
VerLabel.Size = UDim2.new(0, 80, 1, 0)
VerLabel.Position = UDim2.new(1, -85, 0, 0)
VerLabel.BackgroundTransparency = 1
VerLabel.Text = "v" .. SCRIPT_VERSION
VerLabel.TextColor3 = Color3.fromRGB(255, 0, 100) -- Vibrant neon magenta line indicator
VerLabel.Font = Enum.Font.SourceSansBold
VerLabel.TextSize = 11
VerLabel.TextXAlignment = Enum.TextXAlignment.Right
VerLabel.Parent = MovingThing

-- Frame Drag Elements
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

-- Activation Toggle Layout Frame
local ModeFrame = Instance.new("Frame")
ModeFrame.Size = UDim2.new(1, -14, 0, 35)
ModeFrame.Position = UDim2.new(0, 7, 0, 42)
ModeFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ModeFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
ModeFrame.Parent = MainFrame

local ModeLabel = Instance.new("TextLabel")
ModeLabel.Size = UDim2.new(0, 160, 1, 0)
ModeLabel.Position = UDim2.new(0, 8, 0, 0)
ModeLabel.BackgroundTransparency = 1
ModeLabel.Text = "Engage Hyper-Speed Mode:"
ModeLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
ModeLabel.Font = Enum.Font.SourceSans
ModeLabel.TextSize = 13
ModeLabel.TextXAlignment = Enum.TextXAlignment.Left
ModeLabel.Parent = ModeFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 80, 0.7, 0)
ToggleBtn.Position = UDim2.new(1, -88, 0, 5)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleBtn.BorderColor3 = Color3.fromRGB(55, 55, 55)
ToggleBtn.Text = "OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 13
ToggleBtn.Parent = ModeFrame

local EngineActive = false
ToggleBtn.MouseButton1Click:Connect(function()
    EngineActive = not EngineActive
    ToggleBtn.Text = EngineActive and "ON" or "OFF"
    ToggleBtn.BackgroundColor3 = EngineActive and Color3.fromRGB(80, 20, 40) or Color3.fromRGB(15, 15, 15)
end)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -14, 0, 25)
StatusLabel.Position = UDim2.new(0, 7, 0, 90)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Session initialized. Cache bypassed."
StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
StatusLabel.Font = Enum.Font.SourceSansItalic
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
StatusLabel.Parent = MainFrame

---------------------------------------------------------
-- 3. UNRESTRICTED DUAL PIPELINE ENVIRONMENT LOOP
---------------------------------------------------------
RunService.Heartbeat:Connect(function()
    if not EngineActive then 
        StatusLabel.Text = "Awaiting activation..."
        return 
    end

    local character = Player.Character
    if not character then return end
    
    local activeTool = character:FindFirstChildOfClass("Tool")
    local valueOverrode = false
    
    -- Operational Step 1: Lock the runtime value tree properties down
    if activeTool then
        local cd = activeTool:FindFirstChild("Cooldown", true)
        if cd and cd:IsA("ValueBase") then
            cd.Value = 0.001 -- Lock numerical constraint property tree
            valueOverrode = true
        end
    end
    
    -- Operational Step 2: Push track rendering engine speed modifiers
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and activeTool then
        local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid
        local tracks = animator:GetPlayingAnimationTracks()
        
        local modifiedCount = 0
        for i = 1, #tracks do
            local track = tracks[i]
            
            -- Keep standard server states clean, throttle action loops 50x faster
            if track.Name ~= "Hold" and track.Name ~= "Idle" and track.Name ~= "run" and track.Name ~= "walk" then
                track:AdjustSpeed(50) 
                modifiedCount = modifiedCount + 1
            end
        end
        
        -- Screen Feedback Display Execution Status
        if modifiedCount > 0 and valueOverrode then
            StatusLabel.Text = "Overdrive Engaged: 50x Swing + 0.001 CD Locked!"
        elseif valueOverrode then
            StatusLabel.Text = "Targeting system properties... Swing weapon."
        else
            StatusLabel.Text = "Interrogating held item configurations..."
        end
    else
        StatusLabel.Text = "Equip a weapon to inject engine parameters."
    end
end)
