if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

local SCRIPT_VERSION = "1.2.0-DungeonTP"

---------------------------------------------------------
-- 1. INTERFACE CLEANER
---------------------------------------------------------
local oldPanels = {
    "DeltaUniversalV8Panel", "DeltaSignalV9Panel", "DeltaCancelPanel", 
    "DeltaHyperV6Panel", "DeltaRemoteV10Panel", "DeltaMultiCastPanel",
    "DeltaSpellMatrixPanel", "DeltaPureMatrixPanel", "DeltaInstanceMatrixPanel",
    "DeltaDungeonTPPanel"
}
for _, panelName in ipairs(oldPanels) do
    pcall(function()
        if CoreGui:FindFirstChild(panelName) then CoreGui[panelName]:Destroy() end
        if Player.PlayerGui:FindFirstChild(panelName) then Player.PlayerGui[panelName]:Destroy() end
    end)
end

---------------------------------------------------------
-- 2. UI FRAME CONSTRUCTOR
---------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaDungeonTPPanel"
ScreenGui.ResetOnSpawn = false

local attached, _ = pcall(function() ScreenGui.Parent = CoreGui end)
if not attached then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 220)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(50, 55, 65)
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local DragBar = Instance.new("Frame")
DragBar.Size = UDim2.new(1, 0, 0, 32)
DragBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
DragBar.BorderSizePixel = 1
DragBar.BorderColor3 = Color3.fromRGB(50, 55, 65)
DragBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Dungeon Navigator"
Title.TextColor3 = Color3.fromRGB(240, 240, 245)
Title.Font = Enum.Font.SourceSans
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = DragBar

local VerLabel = Instance.new("TextLabel")
VerLabel.Size = UDim2.new(0, 60, 1, 0)
VerLabel.Position = UDim2.new(1, -65, 0, 0)
VerLabel.BackgroundTransparency = 1
VerLabel.Text = "v" .. SCRIPT_VERSION
VerLabel.TextColor3 = Color3.fromRGB(0, 180, 255)
VerLabel.Font = Enum.Font.SourceSansBold
VerLabel.TextSize = 10
VerLabel.TextXAlignment = Enum.TextXAlignment.Right
VerLabel.Parent = DragBar

-- Dragging Functionality
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

-- Scroll Menu for Manifest Items
local ScrollList = Instance.new("ScrollingFrame")
ScrollList.Size = UDim2.new(1, -14, 0, 145)
ScrollList.Position = UDim2.new(0, 7, 0, 40)
ScrollList.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
ScrollList.BorderColor3 = Color3.fromRGB(40, 42, 48)
ScrollList.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollList.ScrollBarThickness = 6
ScrollList.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 2)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollList

local DynamicStatus = Instance.new("TextLabel")
DynamicStatus.Size = UDim2.new(1, -14, 0, 25)
DynamicStatus.Position = UDim2.new(0, 7, 0, 190)
DynamicStatus.BackgroundTransparency = 1
DynamicStatus.Text = "Awaiting layout sync..."
DynamicStatus.TextColor3 = Color3.fromRGB(140, 145, 150)
DynamicStatus.Font = Enum.Font.SourceSansItalic
DynamicStatus.TextSize = 12
DynamicStatus.Parent = MainFrame

---------------------------------------------------------
-- 3. DYNAMIC INTERFACE POPULATION
---------------------------------------------------------
-- Direct look-up logic checking ReplicatedStorage
local DungeonsFolder = ReplicatedStorage:FindFirstChild("Dungeons")

if DungeonsFolder then
    local mapTemplates = DungeonsFolder:GetChildren()
    local builtNames = {} -- Keep list clean from duplicate template rows
    
    for i = 1, #mapTemplates do
        local template = mapTemplates[i]
        
        if not builtNames[template.Name] then
            builtNames[template.Name] = true
            
            local ItemBtn = Instance.new("TextButton")
            ItemBtn.Size = UDim2.new(1, -8, 0, 28)
            ItemBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 30)
            ItemBtn.BorderColor3 = Color3.fromRGB(40, 40, 45)
            ItemBtn.Text = "  Deploy TP to: " .. template.Name
            ItemBtn.TextColor3 = Color3.fromRGB(200, 210, 220)
            ItemBtn.Font = Enum.Font.SourceSansBold
            ItemBtn.TextSize = 12
            ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
            ItemBtn.Parent = ScrollList
            
            ScrollList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
            
            -- Teleport Event Logic
            ItemBtn.MouseButton1Click:Connect(function()
                local character = Player.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                
                if not rootPart then
                    DynamicStatus.Text = "Error: Character root part missing."
                    return
                end
                
                DynamicStatus.Text = "Searching workspace for active " .. template.Name .. "..."
                
                -- Check the active workspace for the spawned instance match
                local activeDungeon = workspace:FindFirstChild(template.Name) or workspace.Dungeons:FindFirstChild(template.Name)
                
                -- Broad recursive fallback scan if map structure is nested inside a container folder
                if not activeDungeon then
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj.Name == template.Name and (obj:IsA("Model") or obj:IsA("Folder") or obj:IsA("Part")) then
                            activeDungeon = obj
                            break
                        end
                    end
                end
                
                if activeDungeon then
                    -- Locate a valid placement point inside the target model structure
                    local tpTargetPart = activeDungeon:FindFirstChildWhichIsA("BasePart", true) or activeDungeon:PrimaryPart
                    
                    if tpTargetPart then
                        -- Safe positioning offset to keep you from falling through the platform
                        rootPart.CFrame = tpTargetPart.CFrame + Vector3.new(0, 4, 0)
                        DynamicStatus.Text = "Teleported successfully to " .. template.Name .. "!"
                    else
                        -- Vector fallback using structural center coordinates if no part is found directly
                        local boundingCFrame, _ = activeDungeon:GetBoundingBox()
                        rootPart.CFrame = boundingCFrame + Vector3.new(0, 4, 0)
                        DynamicStatus.Text = "Teleported to bounding center of " .. template.Name .. "."
                    end
                else
                    DynamicStatus.Text = "Inactive! " .. template.Name .. " is not spawned in the server."
                end
            end)
        end
    end
    DynamicStatus.Text = "Dungeon listings synchronized. Ready."
else
    DynamicStatus.Text = "Error: ReplicatedStorage.Dungeons path missing."
end
