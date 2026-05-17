-- =========================================================================
-- UNIVERSAL OMNI-INJECTOR ENGINE (GITHUB ALL-IN-ONE MASTER PROTOTYPE)
-- Description: Unified inventory/hotbar injector framework for mobile scripts.
-- Compatible with Delta Executor and mobile script hubs.
-- =========================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
repeat task.wait(0.5) until Player.Character and Player.Character:FindFirstChild("Humanoid")

-- ==========================================
-- 1. FILE & DIRECTORY COMPILING ENGINE
-- ==========================================
local StorageSpells  = ReplicatedStorage:WaitForChild("Cards", 5)
local StorageItems   = ReplicatedStorage:WaitForChild("Items", 5)
local StorageWeapons = ReplicatedStorage:WaitForChild("Weapons", 5) or ReplicatedStorage:FindFirstChild("Tools")
local StorageArmor   = ReplicatedStorage:WaitForChild("Armor", 5) or ReplicatedStorage:FindFirstChild("Equipments")

-- Resolve network pointers and remotes safely across the server boundary
local SendServer = ReplicatedStorage:WaitForChild("SendServer", 5)
local RemoteEquipCard   = SendServer and SendServer:WaitForChild("EquipCard", 5) or ReplicatedStorage:FindFirstChild("EquipCard")
local RemoteEquipWeapon = SendServer and SendServer:WaitForChild("EquipWeapon", 5) or ReplicatedStorage:FindFirstChild("EquipWeapon")
local RemoteEquipArmor  = SendServer and SendServer:WaitForChild("EquipArmor", 5) or ReplicatedStorage:FindFirstChild("EquipArmor")
local RemoteUseItem     = SendServer and SendServer:WaitForChild("UseItem", 5) or ReplicatedStorage:FindFirstChild("UseItem")

-- Configuration runtime tracking parameters
local SelectedTargetSlot = 1
local ActiveCategoryMode = "Spells"
local ModeList = {"Spells", "Weapons", "Armor", "Items"}
local ModeIndex = 1

-- ==========================================
-- 2. DYNAMIC USER INTERFACE LAYOUT (MOBILE)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GitHubOmniPanel"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 270, 0, 360)
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Full touch dragging support for mobile
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Application Window Header
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 38)
Title.Text = "🛠️ REPOSITORY OMNI-INJECTOR"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 13
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- CONFIGURATION SLOT TOGGLE CONTROLLER
local SlotBtn = Instance.new("TextButton")
SlotBtn.Size = UDim2.new(0, 120, 0, 32)
SlotBtn.Position = UDim2.new(0, 10, 0, 45)
SlotBtn.Text = "🎯 SLOT TARGET: 1"
SlotBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SlotBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 160)
SlotBtn.Font = Enum.Font.SourceSansBold
SlotBtn.TextSize = 11
SlotBtn.Parent = MainFrame

local SlotCorner = Instance.new("UICorner")
SlotCorner.CornerRadius = UDim.new(0, 5)
SlotCorner.Parent = SlotBtn

-- CONFIGURATION INVENTORY CATEGORY CONTROLLER
local CatBtn = Instance.new("TextButton")
CatBtn.Size = UDim2.new(0, 120, 0, 32)
CatBtn.Position = UDim2.new(0, 140, 0, 45)
CatBtn.Text = "📁 MODE: SPELLS"
CatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CatBtn.BackgroundColor3 = Color3.fromRGB(110, 60, 160)
CatBtn.Font = Enum.Font.SourceSansBold
CatBtn.TextSize = 11
CatBtn.Parent = MainFrame

local CatCorner = Instance.new("UICorner")
CatCorner.CornerRadius = UDim.new(0, 5)
CatCorner.Parent = CatBtn

-- CONTAINER SCROLL VIEW FOR DYNAMIC GENERATIONS
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -95)
ScrollFrame.Position = UDim2.new(0, 10, 0, 85)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 130)
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollFrame

-- ==========================================
-- 3. NETWORK DATA STREAM GENERATOR LOOP
-- ==========================================
local function RenderAssetList()
    -- Clean existing button child assets safely to prevent visual overlap bugs
    for _, item in ipairs(ScrollFrame:GetChildren()) do
        if item:IsA("TextButton") then item:Destroy() end
    end

    -- Determine target folder directory depending on active category state
    local TargetDirectory = nil
    if ActiveCategoryMode == "Spells" then TargetDirectory = StorageSpells
    elseif ActiveCategoryMode == "Weapons" then TargetDirectory = StorageWeapons
    elseif ActiveCategoryMode == "Armor" then TargetDirectory = StorageArmor
    elseif ActiveCategoryMode == "Items" then TargetDirectory = StorageItems
    end

    if not TargetDirectory then return end

    -- Extract master item blueprint blocks from target server folders
    for _, gameAsset in ipairs(TargetDirectory:GetChildren()) do
        local ItemBtn = Instance.new("TextButton")
        ItemBtn.Size = UDim2.new(1, -5, 0, 34)
        ItemBtn.Text = "  ▶ Inject: " .. gameAsset.Name
        ItemBtn.TextColor3 = Color3.fromRGB(235, 235, 240)
        ItemBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
        ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
        ItemBtn.Font = Enum.Font.SourceSansBold
        ItemBtn.TextSize = 13
        ItemBtn.Parent = ScrollFrame

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 4)
        BtnCorner.Parent = ItemBtn

        -- Apply color filtering maps matching standard asset rarities
        if gameAsset:FindFirstChild("Rarity") then
            local r = gameAsset.Rarity.Value
            if r == "Rare" then ItemBtn.TextColor3 = Color3.fromRGB(110, 150, 255)
            elseif r == "Legendary" then ItemBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
            elseif r == "Mythic" then ItemBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
            end
        end

        -- DETECT CLICK INPUT: Pipe injection payload straight into targeted server hotbar channel
        ItemBtn.MouseButton1Click:Connect(function()
            local targetSlot = SelectedTargetSlot or 1
            
            pcall(function()
                if ActiveCategoryMode == "Spells" and RemoteEquipCard then
                    RemoteEquipCard:FireServer(gameAsset, targetSlot)
                elseif ActiveCategoryMode == "Weapons" and RemoteEquipWeapon then
                    RemoteEquipWeapon:FireServer(gameAsset, targetSlot)
                elseif ActiveCategoryMode == "Armor" and RemoteEquipArmor then
                    RemoteEquipArmor:FireServer(gameAsset, targetSlot)
                elseif ActiveCategoryMode == "Items" and RemoteUseItem then
                    RemoteUseItem:FireServer(gameAsset)
                end
            end)

            -- Execution verification confirmation animation flash
            local originalColor = ItemBtn.BackgroundColor3
            ItemBtn.BackgroundColor3 = Color3.fromRGB(45, 140, 75) -- Green confirmation flash
            ItemBtn.Text = "  ✔ INJECTED TO SLOT " .. targetSlot
            task.wait(0.4)
            ItemBtn.BackgroundColor3 = originalColor
            ItemBtn.Text = "  ▶ Inject: " .. gameAsset.Name
        end)
    end

    -- Automatically recalculate vertical scroller viewport constraints
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end

-- ==========================================
-- 4. CONTROL ACTION INTERFACE BINDINGS
-- ==========================================
SlotBtn.MouseButton1Click:Connect(function()
    SelectedTargetSlot = (SelectedTargetSlot % 3) + 1
    SlotBtn.Text = "🎯 SLOT TARGET: " .. SelectedTargetSlot
    
    -- Cycle color styles to represent slot configurations
    if SelectedTargetSlot == 1 then SlotBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 160)
    elseif SelectedTargetSlot == 2 then SlotBtn.BackgroundColor3 = Color3.fromRGB(160, 100, 40)
    else SlotBtn.BackgroundColor3 = Color3.fromRGB(140, 60, 160)
    end
end)

CatBtn.MouseButton1Click:Connect(function()
    ModeIndex = (ModeIndex % #ModeList) + 1
    ActiveCategoryMode = ModeList[ModeIndex]
    CatBtn.Text = "📁 MODE: " .. ActiveCategoryMode:upper()
    
    -- Force render list compilation update
    RenderAssetList()
end)

-- Initialize master compiling routine
RenderAssetList()
print("[GitHub Engine]: Omni-Injector loaded completely into execution framework.")
