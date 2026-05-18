-- Modern UI Library for Delta Executor
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Custom Stats Hub | Delta",
    SubTitle = "Manual Stat Manager",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 340),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Stats = Window:AddTab({ Title = "Stat Editor", Icon = "rbxassetid://4483345906" }),
    Items = Window:AddTab({ Title = "Item Spawner", Icon = "rbxassetid://4483345906" })
}

-- Values to hold input text
local InputGold = 0
local InputTickets = 0
local InputLove = 0

-- Target Variables
local Player = game.Players.LocalPlayer
local PlayerStats = Player:WaitForChild("PlayerStats", 10)
local PlayerItemsFolder = Player:WaitForChild("Items", 10)
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Helper functions to locate specific stats dynamically
local function getStat(statName)
    if PlayerStats and PlayerStats:FindFirstChild(statName) then
        return PlayerStats[statName]
    end
    return Player:FindFirstChild(statName, true) -- Fallback fallback recursive search
end

-- STAT EDITOR TAB CONTROLS

-- Gold Input & Button
Tabs.Stats:AddInput("GoldInput", {
    Title = "Enter Gold Amount",
    Default = "0",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        InputGold = tonumber(Value) or 0
    end
})

Tabs.Stats:AddButton({
    Title = "Set Gold",
    Callback = function()
        local gold = getStat("Gold")
        if gold then
            gold.Value = InputGold
            Fluent:Notify({ Title = "Success", Content = "Gold set to " .. InputGold, Duration = 2 })
        else
            Fluent:Notify({ Title = "Error", Content = "Could not find Gold stat!", Duration = 3 })
        end
    end
})

-- Tickets Input & Button
Tabs.Stats:AddInput("TicketInput", {
    Title = "Enter Tickets Amount",
    Default = "0",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        InputTickets = tonumber(Value) or 0
    end
})

Tabs.Stats:AddButton({
    Title = "Set Tickets",
    Callback = function()
        local tickets = getStat("Tickets") or getStat("Ticket")
        if tickets then
            tickets.Value = InputTickets
            Fluent:Notify({ Title = "Success", Content = "Tickets set to " .. InputTickets, Duration = 2 })
        else
            Fluent:Notify({ Title = "Error", Content = "Could not find Tickets stat!", Duration = 3 })
        end
    end
})

-- Love Input & Button
Tabs.Stats:AddInput("LoveInput", {
    Title = "Enter Love (LVL) Amount",
    Default = "0",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        InputLove = tonumber(Value) or 0
    end
})

Tabs.Stats:AddButton({
    Title = "Set Love",
    Callback = function()
        local love = getStat("Love")
        if love then
            love.Value = InputLove
            Fluent:Notify({ Title = "Success", Content = "Love set to " .. InputLove, Duration = 2 })
        else
            Fluent:Notify({ Title = "Error", Content = "Could not find Love stat!", Duration = 3 })
        end
    end
})


-- ITEM SPAWNER TAB CONTROLS
Tabs.Items:AddButton({
    Title = "Unlock All Items",
    Description = "Injects items to PlayerStats & Inventory UI",
    Callback = function()
        local ItemsStorage = ReplicatedStorage:FindFirstChild("Items")
        if not ItemsStorage then
            Fluent:Notify({ Title = "Error", Content = "Items folder missing from ReplicatedStorage!", Duration = 3 })
            return
        end

        for _, itemTemplate in pairs(ItemsStorage:GetChildren()) do
            local itemName = itemTemplate.Name

            -- 1. Register to PlayerStats
            if PlayerStats then
                if not PlayerStats:FindFirstChild(itemName) then
                    local statValue = Instance.new("IntValue")
                    statValue.Name = itemName
                    statValue.Value = 1
                    statValue.Parent = PlayerStats
                end
            end

            -- 2. Inject directly into Inventory UI folder
            if PlayerItemsFolder then
                if not PlayerItemsFolder:FindFirstChild(itemName) then
                    local clonedItem = itemTemplate:Clone()
                    clonedItem.Parent = PlayerItemsFolder
                else
                    local existing = PlayerItemsFolder:FindFirstChild(itemName)
                    if existing:IsA("ValueBase") then
                        existing.Value = 1
                    end
                end
            end
        end

        Fluent:Notify({ Title = "Success", Content = "All items given! Inventory refreshed.", Duration = 4 })
    end
})


----------------------------------------------------------------
-- YOUR ORIGINAL INVENTORY GUI SYSTEM (INTEGRATED & COMPATIBLE) --
----------------------------------------------------------------

local Frame = script.Parent.Inv.Weapons
local Frame2 = script.Parent.Inv
local SelectSound = Instance.new("Sound")
SelectSound.TimePosition = 0.8
SelectSound.Volume = 5
SelectSound.SoundId = "rbxassetid://4547467536"
SelectSound.Parent = Frame

Frame2.Position = UDim2.new(1, 0, 0.173, 0)
Frame2.Visible = false
Frame.Visible = false

local ExampleFrame = ReplicatedStorage:WaitForChild("GuiStuff"):WaitForChild("ExampleFrame")
local ScrollFrame = script.Parent.Inv.Items.Frame.ScrollingFrame
local Stats = script.Parent.Inv.Items.Stats

local function ResetSelected()
    Stats.Desc.Text = "Select Item"
    Stats.Rarity.Text = "N/A"
    Stats.Selected.Value = nil
    Stats.ToolTitle.Text = "NIL"
end

local function ResetFrames()
    ResetSelected()
    local CurrentFrames = ScrollFrame:GetChildren()
    for i = 1, #CurrentFrames do
        if CurrentFrames[i].ClassName == "ImageLabel" then
            CurrentFrames[i]:Destroy()
        end
    end
    
    local CurrentWeapons = PlayerItemsFolder:GetChildren()
    for i = 1, #CurrentWeapons do
        local OwnWeapon = CurrentWeapons[i]        
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
                SelectSound:Play()
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

script.Parent.Inv.Items.Changed:Connect(ResetFrames)
PlayerItemsFolder.ChildAdded:Connect(ResetFrames)

task.spawn(function()
    task.wait(1)
    ResetFrames()
end)

Stats.Equip.MouseButton1Click:Connect(function()
    if Stats.Selected.Value ~= nil and Stats.FrameSelected.Value ~= nil then
        if ReplicatedStorage:FindFirstChild("ItemEvents") and ReplicatedStorage.ItemEvents:FindFirstChild(Stats.Selected.Value.Name) then
            ReplicatedStorage.ItemEvents:FindFirstChild(Stats.Selected.Value.Name):FireServer()
        end
        task.wait(0.1)
        ResetFrames()
    end
end)

Window:SelectTab(Tabs.Stats)
