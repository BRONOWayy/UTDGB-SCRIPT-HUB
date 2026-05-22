if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

local SCRIPT_VERSION = "1.1.2-SpellMatrix"

---------------------------------------------------------
-- 1. STUBBORN WINDOW CLEANER
---------------------------------------------------------
local oldPanels = {"DeltaUniversalV8Panel", "DeltaSignalV9Panel", "DeltaCancelPanel", "DeltaHyperV6Panel", "DeltaRemoteV10Panel", "DeltaMultiCastPanel"}
for _, panelName in ipairs(oldPanels) do
    pcall(function()
        if CoreGui:FindFirstChild(panelName) then CoreGui[panelName]:Destroy() end
        if Player.PlayerGui:FindFirstChild(panelName) then Player.PlayerGui[panelName]:Destroy() end
    end)
end

---------------------------------------------------------
-- 2. PANEL INTERFACE BUILDER
---------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaSpellMatrixPanel"
ScreenGui.ResetOnSpawn = false

local attached, _ = pcall(function() ScreenGui.Parent = CoreGui end)
if not attached then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 310, 0, 250)
MainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(60, 55, 70)
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local DragBar = Instance.new("Frame")
DragBar.Size = UDim2.new(1, 0, 0, 32)
DragBar.BackgroundColor3 = Color3.fromRGB(30, 28, 35)
DragBar.BorderSizePixel = 1
DragBar.BorderColor3 = Color3.fromRGB(60, 55, 70)
DragBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Automated Spell Matrix"
Title.TextColor3 = Color3.fromRGB(245, 245, 250)
Title.Font = Enum.Font.SourceSans
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = DragBar

local VerLabel = Instance.new("TextLabel")
VerLabel.Size = UDim2.new(0, 60, 1, 0)
VerLabel.Position = UDim2.new(1, -65, 0, 0)
VerLabel.BackgroundTransparency = 1
VerLabel.Text = "v" .. SCRIPT_VERSION
VerLabel.TextColor3 = Color3.fromRGB(160, 110, 255)
VerLabel.Font = Enum.Font.SourceSansBold
VerLabel.TextSize = 10
VerLabel.TextXAlignment = Enum.TextXAlignment.Right
VerLabel.Parent = DragBar

-- Simple UI Dragging Engine
local dragging, dragInput, dragStart, startPos
DragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
DragBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Scroll view containing only Spells/Cards
local ScrollList = Instance.new("ScrollingFrame")
ScrollList.Size = UDim2.new(1, -14, 0, 115)
ScrollList.Position = UDim2.new(0, 7, 0, 40)
ScrollList.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
ScrollList.BorderColor3 = Color3.fromRGB(45, 42, 50)
ScrollList.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollList.ScrollBarThickness = 6
ScrollList.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 2)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollList

-- Speed and Activation Layout Panel
local ControlPanel = Instance.new("Frame")
ControlPanel.Size = UDim2.new(1, -14, 0, 42)
ControlPanel.Position = UDim2.new(0, 7, 0, 162)
ControlPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
ControlPanel.BorderColor3 = Color3.fromRGB(45, 42, 50)
ControlPanel.Parent = MainFrame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0, 70, 1, 0)
SpeedLabel.Position = UDim2.new(0, 5, 0, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Delay (sec):"
SpeedLabel.TextColor3 = Color3.fromRGB(210, 210, 215)
SpeedLabel.Font = Enum.Font.SourceSans
SpeedLabel.TextSize = 13
SpeedLabel.Parent = ControlPanel

local DelayInput = Instance.new("TextBox")
DelayInput.Size = UDim2.new(0, 55, 0.6, 0)
DelayInput.Position = UDim2.new(0, 75, 0.2, 0)
DelayInput.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
DelayInput.BorderColor3 = Color3.fromRGB(55, 50, 65)
DelayInput.Text = "0.1"
DelayInput.TextColor3 = Color3.fromRGB(0, 255, 170)
DelayInput.Font = Enum.Font.SourceSansBold
DelayInput.TextSize = 13
DelayInput.ClearTextOnFocus = false
DelayInput.Parent = ControlPanel

local AutoShootBtn = Instance.new("TextButton")
AutoShootBtn.Size = UDim2.new(0, 145, 0.7, 0)
AutoShootBtn.Position = UDim2.new(1, -152, 0.15, 0)
AutoShootBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
AutoShootBtn.BorderColor3 = Color3.fromRGB(55, 50, 65)
AutoShootBtn.Text = "AUTO SHOOT: OFF"
AutoShootBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
AutoShootBtn.Font = Enum.Font.SourceSansBold
AutoShootBtn.TextSize = 12
AutoShootBtn.Parent = ControlPanel

local DynamicStatus = Instance.new("TextLabel")
DynamicStatus.Size = UDim2.new(1, -14, 0, 25)
DynamicStatus.Position = UDim2.new(0, 7, 0, 212)
DynamicStatus.BackgroundTransparency = 1
DynamicStatus.Text = "Scanning spell storage..."
DynamicStatus.TextColor3 = Color3.fromRGB(150, 150, 155)
DynamicStatus.Font = Enum.Font.SourceSansItalic
DynamicStatus.TextSize = 12
DynamicStatus.Parent = MainFrame

---------------------------------------------------------
-- 3. CARD RETRIEVAL AND POPULATION ENGINE
---------------------------------------------------------
local ActiveCastManifest = {}
local AutoShootActive = false

-- Targets the spell asset index folder exclusively
local CardsFolder = ReplicatedStorage:FindFirstChild("Cards")
if CardsFolder then
    local items = CardsFolder:GetChildren()
    for i = 1, #items do
        local card = items[i]
        
        local ItemBtn = Instance.new("TextButton")
        ItemBtn.Size = UDim2.new(1, -8, 0, 26)
        ItemBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
        ItemBtn.BorderColor3 = Color3.fromRGB(40, 40, 45)
        ItemBtn.Text = "  [ ] " .. card.Name
        ItemBtn.TextColor3 = Color3.fromRGB(200, 200, 205)
        ItemBtn.Font = Enum.Font.SourceSans
        ItemBtn.TextSize = 13
        ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
        ItemBtn.Parent = ScrollList
        
        ScrollList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
        
        -- Multi-selection tracking logic
        ItemBtn.MouseButton1Click:Connect(function()
            if ActiveCastManifest[card.Name] then
                ActiveCastManifest[card.Name] = nil
                ItemBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
                ItemBtn.TextColor3 = Color3.fromRGB(200, 200, 205)
                ItemBtn.Text = "  [ ] " .. card.Name
            else
                ActiveCastManifest[card.Name] = true
                ItemBtn.BackgroundColor3 = Color3.fromRGB(50, 35, 70)
                ItemBtn.TextColor3 = Color3.fromRGB(210, 160, 255)
                ItemBtn.Text = "  [*] " .. card.Name
            end
        end)
    end
    DynamicStatus.Text = "Spell system initialized. Select targets."
else
    DynamicStatus.Text = "Error: ReplicatedStorage.Cards not found."
end

-- Toggle Switch Engine
AutoShootBtn.MouseButton1Click:Connect(function()
    AutoShootActive = not AutoShootActive
    AutoShootBtn.Text = AutoShootActive and "AUTO SHOOT: ON" or "AUTO SHOOT: OFF"
    AutoShootBtn.BackgroundColor3 = AutoShootActive and Color3.fromRGB(110, 35, 45) or Color3.fromRGB(20, 20, 25)
end)

---------------------------------------------------------
-- 4. PIPELINE SCHEDULER
---------------------------------------------------------
local UseSpellRemote = ReplicatedStorage:FindFirstChild("UseSpell")

task.spawn(function()
    while true do
        task.wait() -- Baseline protection link
        
        if AutoShootActive and UseSpellRemote then
            local speedSetting = tonumber(DelayInput.Text)
            local currentDelay = (speedSetting and speedSetting >= 0.01) and speedSetting or 0.1
            
            local currentFired = 0
            for spellName, _ in pairs(ActiveCastManifest) do
                pcall(function()
                    -- Fires exclusively to the UseSpell endpoint
                    UseSpellRemote:FireServer(spellName)
                end)
                currentFired = currentFired + 1
            end
            
            if currentFired > 0 then
                DynamicStatus.Text = "Casting " .. tostring(currentFired) .. " spells at " .. tostring(currentDelay) .. "s intervals."
                task.wait(currentDelay)
            else
                DynamicStatus.Text = "Auto-shoot is running but no spells are selected!"
            end
        elseif not AutoShootActive then
            DynamicStatus.Text = "System Standby."
        end
    end
end)
