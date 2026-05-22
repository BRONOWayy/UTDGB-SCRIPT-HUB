if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

-- Build Tracking Manifest
local SCRIPT_VERSION = "1.1.1-Multicaster"

---------------------------------------------------------
-- 1. STUBBORN STORAGE PURGE
---------------------------------------------------------
local oldPanels = {"DeltaUniversalV8Panel", "DeltaSignalV9Panel", "DeltaCancelPanel", "DeltaHyperV6Panel", "DeltaRemoteV10Panel"}
for _, panelName in ipairs(oldPanels) do
    pcall(function()
        if CoreGui:FindFirstChild(panelName) then CoreGui[panelName]:Destroy() end
        if Player.PlayerGui:FindFirstChild(panelName) then Player.PlayerGui[panelName]:Destroy() end
    end)
end

---------------------------------------------------------
-- 2. DYNAMIC INTERFACE CONSTRUCTOR
---------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaMultiCastPanel"
ScreenGui.ResetOnSpawn = false

local attached, _ = pcall(function() ScreenGui.Parent = CoreGui end)
if not attached then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

-- Main Window Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 240)
MainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(55, 55, 55)
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- Drag Bar
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
Title.Text = "Multi-Spell Casting Matrix"
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
VerLabel.TextColor3 = Color3.fromRGB(180, 100, 255)
VerLabel.Font = Enum.Font.SourceSansBold
VerLabel.TextSize = 10
VerLabel.TextXAlignment = Enum.TextXAlignment.Right
VerLabel.Parent = MovingThing

-- Dragging Scripts
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
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Scrolling Selection Container
local ScrollList = Instance.new("ScrollingFrame")
ScrollList.Size = UDim2.new(1, -14, 0, 110)
ScrollList.Position = UDim2.new(0, 7, 0, 38)
ScrollList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ScrollList.BorderColor3 = Color3.fromRGB(45, 45, 45)
ScrollList.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollList.ScrollBarThickness = 6
ScrollList.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 2)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollList

-- Control Configurations Panel Frame
local ControlFrame = Instance.new("Frame")
ControlFrame.Size = UDim2.new(1, -14, 0, 40)
ControlFrame.Position = UDim2.new(0, 7, 0, 154)
ControlFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ControlFrame.BorderColor3 = Color3.fromRGB(45, 45, 45)
ControlFrame.Parent = MainFrame

-- Delay Control Textbox
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0, 65, 1, 0)
SpeedLabel.Position = UDim2.new(0, 5, 0, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Delay (sec):"
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.Font = Enum.Font.SourceSans
SpeedLabel.TextSize = 13
SpeedLabel.Parent = ControlFrame

local DelayInput = Instance.new("TextBox")
DelayInput.Size = UDim2.new(0, 50, 0.6, 0)
DelayInput.Position = UDim2.new(0, 70, 0, 8)
DelayInput.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
DelayInput.BorderColor3 = Color3.fromRGB(50, 50, 50)
DelayInput.Text = "0.1"
DelayInput.TextColor3 = Color3.fromRGB(0, 255, 150)
DelayInput.Font = Enum.Font.SourceSansBold
DelayInput.TextSize = 13
DelayInput.ClearTextOnFocus = false
DelayInput.Parent = ControlFrame

-- Master Action Trigger Button
local MasterToggle = Instance.new("TextButton")
MasterToggle.Size = UDim2.new(0, 140, 0.7, 0)
MasterToggle.Position = UDim2.new(1, -148, 0, 6)
MasterToggle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MasterToggle.BorderColor3 = Color3.fromRGB(50, 50, 50)
MasterToggle.Text = "AUTO SHOOT: OFF"
MasterToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
MasterToggle.Font = Enum.Font.SourceSansBold
MasterToggle.TextSize = 12
MasterToggle.Parent = ControlFrame

local DynamicStatus = Instance.new("TextLabel")
DynamicStatus.Size = UDim2.new(1, -14, 0, 25)
DynamicStatus.Position = UDim2.new(0, 7, 0, 202)
DynamicStatus.BackgroundTransparency = 1
DynamicStatus.Text = "Select your target spells above."
DynamicStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
DynamicStatus.Font = Enum.Font.SourceSansItalic
DynamicStatus.TextSize = 12
DynamicStatus.Parent = MainFrame

---------------------------------------------------------
-- 3. INTERACTIVE SELECTION PARSING ENGINE
---------------------------------------------------------
local SelectedSpells = {}
local AutoShootActive = false

-- Read available game spells directly from ReplicatedStorage definition folders
local CardsFolder = ReplicatedStorage:FindFirstChild("Cards")
if CardsFolder then
    local availableCards = CardsFolder:GetChildren()
    for i = 1, #availableCards do
        local card = availableCards[i]
        
        -- Generate interactive item rows inside scroll view dynamically
        local ItemButton = Instance.new("TextButton")
        ItemButton.Size = UDim2.new(1, -8, 0, 24)
        ItemButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        ItemButton.BorderColor3 = Color3.fromRGB(45, 45, 50)
        ItemButton.Text = "  [ ] " .. card.Name
        ItemButton.TextColor3 = Color3.fromRGB(210, 210, 210)
        ItemButton.Font = Enum.Font.SourceSans
        ItemButton.TextSize = 13
        ItemButton.TextXAlignment = Enum.TextXAlignment.Left
        ItemButton.Parent = ScrollList
        
        -- Adjust inner scroll panel size boundaries sequentially
        ScrollList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
        
        -- Multi-selection indexing toggle logic 
        ItemButton.MouseButton1Click:Connect(function()
            if SelectedSpells[card.Name] then
                SelectedSpells[card.Name] = nil
                ItemButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                ItemButton.TextColor3 = Color3.fromRGB(210, 210, 210)
                ItemButton.Text = "  [ ] " .. card.Name
            else
                SelectedSpells[card.Name] = true
                ItemButton.BackgroundColor3 = Color3.fromRGB(45, 35, 55)
                ItemButton.TextColor3 = Color3.fromRGB(200, 150, 255)
                ItemButton.Text = "  [*] " .. card.Name
            end
        end)
    end
else
    DynamicStatus.Text = "Error: ReplicatedStorage.Cards index missing."
end

-- Master Auto-Shoot Loop Activation
MasterToggle.MouseButton1Click:Connect(function()
    AutoShootActive = not AutoShootActive
    MasterToggle.Text = AutoShootActive and "AUTO SHOOT: ON" or "AUTO SHOOT: OFF"
    MasterToggle.BackgroundColor3 = AutoShootActive and Color3.fromRGB(90, 30, 30) or Color3.fromRGB(20, 20, 20)
end)

---------------------------------------------------------
-- 4. BACKEND SEQUENCE FIRE PIPELINE
---------------------------------------------------------
local UseSpellRemote = ReplicatedStorage:FindFirstChild("UseSpell")

task.spawn(function()
    while true do
        task.wait() -- Prevent engine hangs completely
        
        if AutoShootActive and UseSpellRemote then
            -- Safely pull execution intervals directly from textbox configurations 
            local rawInterval = tonumber(DelayInput.Text)
            local
