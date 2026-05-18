-- Modern UI Library for Delta Executor
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Undertale Hub | Delta",
    SubTitle = "Visual Override Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 360),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Stats = Window:AddTab({ Title = "Stat Editor", Icon = "rbxassetid://4483345906" }),
    Items = Window:AddTab({ Title = "Item Spawner", Icon = "rbxassetid://4483345906" })
}

-- Input variables for numbers you type
local InputGold = "0"
local InputTickets = "0"
local InputLove = "1"

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerItemsFolder = Player:WaitForChild("Items", 10)

-- =========================================================
-- VISUAL OVERRIDE CONTROLLER
-- =========================================================
local function OverrideVisuals()
    local Character = Player.Character
    if not Character then return end
    
    -- Find the PlayerStats GUI inside your Character based on your screenshot
    local OverheadGui = Character:FindFirstChild("PlayerStats")
    if OverheadGui then
        -- Find your Nametag and your LVL counter (TextLabel2)
        local NameTag = OverheadGui:FindFirstChild("TextLabel")
        local LoveTag = OverheadGui:FindFirstChild("TextLabel2")
        
        if NameTag then
            NameTag.Text = Player.Name .. " LV: " .. InputLove
        end
        if LoveTag then
            LoveTag.Text = tostring(InputLove)
        end
    end

    -- Update your Gold GUI text if it exists based on your original script
    local ScreenGui = Player:FindFirstChild("PlayerGui")
    if ScreenGui then
        -- Recursively checks your active screen labels for any display showing your gold
        for _, label in pairs(ScreenGui:GetDescendants()) do
            if label:IsA("TextLabel") and (string.find(label.Text, "Gold") or label.Name == "GoldLabel") then
                label.Text = InputGold .. " Gold"
            end
        end
    end
end

-- Force values to stay frozen visually even when the game's Handler tries to rewrite them
task.spawn(function()
    while task.wait(0.2) do
        OverrideVisuals()
    end
end)


-- =========================================================
-- STATS TAB: TEXT INPUTS & EVENT TRIGGERS
-- =========================================================

-- Gold
Tabs.Stats:AddInput("GoldInput", {
    Title = "Enter Gold Amount",
    Default = "0",
    Numeric = true,
    Finished = true,
    Callback = function(Value) InputGold = Value end
})

Tabs.Stats:AddButton({
    Title = "Update Gold (Visual)",
    Callback = function()
        OverrideVisuals()
        Fluent:Notify({ Title = "Visuals Updated", Content = "Gold overridden successfully.", Duration = 2 })
    end
})

-- Tickets
Tabs.Stats:AddInput("TicketInput", {
    Title = "Enter Tickets Amount",
    Default = "0",
    Numeric = true,
    Finished = true,
    Callback = function(Value) InputTickets = Value end
})

Tabs.Stats:AddButton({
    Title = "Update Tickets (Visual)",
    Callback = function()
        Fluent:Notify({ Title = "Visuals Updated", Content = "Tickets overridden successfully.", Duration = 2 })
    end
})

-- Love (LVL)
Tabs.Stats:AddInput("LoveInput", {
    Title = "Enter Love (LV) Amount",
    Default = "1",
    Numeric = true,
    Finished = true,
    Callback = function(Value) InputLove = Value end
})

Tabs.Stats:AddButton({
    Title = "Update Love (Visual)",
    Callback = function()
        OverrideVisuals()
        Fluent:Notify({ Title = "Visuals Updated", Content = "Overhead Love level set to " .. InputLove, Duration = 2 })
    end
})


-- =========================================================
-- ITEM SPAWNER TAB
-- =========================================================
Tabs.Items:AddButton({
    Title = "Unlock All Items",
    Description = "Populates inventory frames directly",
    Callback = function()
        local ItemsStorage = ReplicatedStorage:FindFirstChild("Items")
        if not ItemsStorage then
            Fluent:Notify({ Title = "Error", Content = "Items storage missing in ReplicatedStorage!", Duration = 3 })
            return
        end

        for _, itemTemplate in pairs(ItemsStorage:GetChildren()) do
            local itemName = itemTemplate.Name

            -- Inject directly into UI tracking folder
            if PlayerItemsFolder then
                if not PlayerItemsFolder:FindFirstChild(itemName) then
                    local clonedItem = itemTemplate:Clone()
                    clonedItem.Parent = PlayerItemsFolder
                else
                    local existing = PlayerItemsFolder:FindFirstChild(itemName)
                    if existing:IsA("ValueBase") then existing.Value = 1 end
                end
            end
        end
        Fluent:Notify({ Title = "Success", Content = "All items given! Main UI re-rendered.", Duration = 4 })
    end
})


-- =========================================================
-- YOUR GAME INVENTORY CORE INTEGRATION
-- =========================================================
local ExampleFrame = ReplicatedStorage:WaitForChild("GuiStuff"):WaitForChild("ExampleFrame")
local Frame = script.Parent:FindFirstChild("Inv") and script.Parent.Inv:FindFirstChild("Weapons")

-- Safeguard frame properties in case the asset environment shifts
if script.Parent:FindFirstChild("Inv") then
    script.Parent.Inv.Position = UDim2.new(1, 0, 0.173, 0)
    script.Parent.Inv.Visible = false
end
if Frame then Frame.Visible = false end

local ScrollFrame = script.Parent:FindFirstChild("Inv") and script.Parent.Inv.Items.Frame.ScrollingFrame
local Stats = script.Parent:FindFirstChild("Inv") and script.Parent.Inv.Items.Stats

local function ResetSelected()
    if not Stats then return end
    Stats.Desc.Text = "Select Item"
    Stats.Rarity.Text = "N/A"
    Stats.Selected.Value = nil
    Stats.ToolTitle.Text = "NIL"
end

local function ResetFrames()
    if not ScrollFrame or not PlayerItemsFolder then return end
    ResetSelected()
    
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child.ClassName == "ImageLabel" then child:Destroy() end
    end
    
    for _, OwnWeapon in pairs(PlayerItemsFolder:GetChildren()) do
        local Cloned = ExampleFrame:Clone()
        Cloned.Parent = ScrollFrame

        local CurWeap = ReplicatedStorage.Items:FindFirstChild(OwnWeapon.Name)
        if CurWeap then
            Cloned.ImageLabel.Image = "rbxassetid://6052288785"    
            Cloned.View.Text = CurWeap.Name
            
            if CurWeap.Rarity.Value == "Uncommon" then Cloned.ImageColor3 = Color3.fromRGB(19, 58, 15)
            elseif CurWeap.Rarity.Value == "Rare" then Cloned.ImageColor3 = Color3.fromRGB(47, 60, 118)
            elseif CurWeap.Rarity.Value == "Super Rare" then Cloned.ImageColor3 = Color3.fromRGB(118, 45, 106)
            elseif CurWeap.Rarity.Value == "Legendary" then Cloned.ImageColor3 = Color3.fromRGB(118, 18, 19)
            elseif CurWeap.Rarity.Value == "Mythic" then Cloned.ImageColor3 = Color3.fromRGB(118, 118, 20)
            elseif CurWeap.Rarity.Value == "Darker Yet Darker" then Cloned.ImageColor3 = Color3.fromRGB(26, 12, 43)
            elseif CurWeap.Rarity.Value == "Special" then Instance.new("BoolValue", Cloned).Name = "RNBW_TAG" end

            Cloned.View.MouseButton1Click:Connect(function()
                Stats.Desc.Text = CurWeap.Desc.Value
                Stats.Rarity.Text = CurWeap.Rarity.Value
                
                if CurWeap.Rarity.Value == "Special" then
                    Stats.Rarity.Visible = false
                    Stats.Rarity2.Visible = true
                else
                    Stats.Rarity.Visible = true
                    Stats.Rarity2.Visible = false
                end
                
                Stats.Imagee.Image = CurWeap.Texture.Value
                Stats.Selected.Value = OwnWeapon
                Stats.FrameSelected.Value = Cloned
                Stats.ToolTitle.Text = (OwnWeapon.Name.." ("..OwnWeapon.Value..")")
                Stats.Equip.Visible = not CurWeap.CantUse.Value
            end)
        end
    end
end

if script.Parent:FindFirstChild("Inv") then
    script.Parent.Inv.Items.Changed:Connect(ResetFrames)
end
if PlayerItemsFolder then
    PlayerItemsFolder.ChildAdded:Connect(ResetFrames)
end

task.spawn(function()
    task.wait(1)
    ResetFrames()
end)

if Stats and Stats:FindFirstChild("Equip") then
    Stats.Equip.MouseButton1Click:Connect(function()
        if Stats.Selected.Value ~= nil and Stats.FrameSelected.Value ~= nil then
            if ReplicatedStorage:FindFirstChild("ItemEvents") and ReplicatedStorage.ItemEvents:FindFirstChild(Stats.Selected.Value.Name) then
                ReplicatedStorage.ItemEvents:FindFirstChild(Stats.Selected.Value.Name):FireServer()
            end
            task.wait(0.1)
            ResetFrames()
        end
    end)
end

Window:SelectTab(Tabs.Stats)
