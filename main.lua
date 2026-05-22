if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

-- Build Tracking Manifest
local SCRIPT_VERSION = "1.0.4-Staging-Fix"

---------------------------------------------------------
-- 1. HARD PURGE OF VERSION 1.0.3 AND OLD RESIDUE
---------------------------------------------------------
-- This forces the game to delete version 1.0.3 so it cannot pop up anymore
local targets = {"DeltaInterceptorPanel", "DeltaCancelPanel", "DeltaFixedCancelPanel", "DeltaWeaponFirePanel"}

for _, panelName in ipairs(targets) do
    if CoreGui:FindFirstChild(panelName) then
        CoreGui[panelName]:Destroy()
    end
    if Player:WaitForChild("PlayerGui"):FindFirstChild(panelName) then
        Player.PlayerGui[panelName]:Destroy()
    end
end

---------------------------------------------------------
-- 2. NEW FRESH INTERFACE CONSTRUCTOR (Version 1.0.4 Base)
---------------------------------------------------------
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
VerLabel.Size = UDim2.new(0, 70, 1, 0)
VerLabel.Position = UDim2.new(1, -75, 0, 0)
VerLabel.BackgroundTransparency = 1
VerLabel.Text = "v" .. SCRIPT_VERSION
VerLabel.TextColor3 = Color3.fromRGB(255, 85, 85) -- Colored red-orange so you can instantly verify it loaded right
VerLabel.Font = Enum.Font.SourceSansBold
VerLabel.TextSize = 11
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
        local delta = input.Position -
