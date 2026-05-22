if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

---------------------------------------------------------
-- 1. MEMORY OVERRIDE METAMETHOD HOOK (Bypass tick/os.clock checks)
---------------------------------------------------------
local CooldownActive = true

local oldHook
oldHook = hooknummethod or hookmetamethod(game, "__index", function(self, key)
    if CooldownActive and (key == "Cooldown" or key == "cd" or key == "AttackDelay") then
        return 0
    end
    return oldHook(self, key)
end)

-- Garbage Collection Scan to force internal tables to 0 cooldown
local function bypassMemoryTables()
    for _, v in pairs(getgc(true)) do
        if type(v) == "table" then
            if rawget(v, "Cooldown") or rawget(v, "cooldown") then
                rawset(v, "Cooldown", 0)
                rawset(v, "cooldown", 0)
                rawset(v, "MaxCooldown", 0)
            end
        end
    end
end

---------------------------------------------------------
-- 2. INTERFACE CONSTRUCTOR (Plain Gray UI Frame)
---------------------------------------------------------
if CoreGui:FindFirstChild("UniversalM1BypassPanel") then
    CoreGui.UniversalM1BypassPanel:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalM1BypassPanel"
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
Title.Text = "Memory-Level Cooldown Bypass"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.Font = Enum.Font.SourceSans
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MovingThing

-- Simple Drag Handler
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

-- Toggle Button Frame
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
ConfigLabel.Text = "No-Cooldown State:"
ConfigLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
ConfigLabel.Font = Enum.Font.SourceSans
ConfigLabel.TextSize = 13
ConfigLabel.TextXAlignment = Enum.TextXAlignment.Left
ConfigLabel.Parent = ConfigHeaderBox

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.35, 0, 0.7, 0)
ToggleBtn.Position = UDim2.new(0.62, 0, 0.15, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleBtn.BorderColor3 = Color3.fromRGB(80, 80, 80)
ToggleBtn.Text = "ACTIVE"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 13
ToggleBtn.Parent = ConfigHeaderBox

ToggleBtn.MouseButton1Click:Connect(function()
    CooldownActive = not CooldownActive
    if CooldownActive then
        ToggleBtn.Text = "ACTIVE"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    else
        ToggleBtn.Text = "DISABLED"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    end
end)

-- Live Status Feedback Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -14, 0, 25)
StatusLabel.Position = UDim2.new(0, 7, 0, 77)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Monitoring memory frames & values..."
StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
StatusLabel.Font = Enum.Font.SourceSansItalic
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
StatusLabel.Parent = MainFrame

---------------------------------------------------------
-- 3. CONSTANT BACKPACK & ATTACK DATA CLEANER LOOP
---------------------------------------------------------
RunService.Heartbeat:Connect(function()
    if not CooldownActive then return end
    
    -- Clear standard configurations if they appear
    local character = Player.Character
    if character then
        local activeTool = character:FindFirstChildOfClass("Tool") or Player.Backpack:FindFirstChildOfClass("Tool")
        if activeTool then
            local cd = activeTool:FindFirstChild("Cooldown", true) or activeTool:FindFirstChild("cd", true)
            if cd and cd:IsA("ValueBase") then
                cd.Value = 0
            end
            StatusLabel.Text = "Bypassing: " .. activeTool.Name
        else
            StatusLabel.Text = "Status: Safe (Memory Hooks Armed)"
        end
    end
    
    -- Perform routine table sweeps in memory
    pcall(bypassMemoryTables)
end)
