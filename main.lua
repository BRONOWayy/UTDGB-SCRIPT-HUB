-- Modern UI Library for Delta Executor
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Item Master | Step 1",
    SubTitle = "Delta Engine",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 300),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Items = Window:AddTab({ Title = "Item Spawner", Icon = "rbxassetid://4483345906" })
}

local Player = game.Players.LocalPlayer
local PlayerItemsFolder = Player:WaitForChild("Items", 10)
local ReplicatedStorage = game:GetService("ReplicatedStorage")

Tabs.Items:AddButton({
    Title = "Give All Real Items & Tickets",
    Description = "Safely fills your slots and hooks server functions",
    Callback = function()
        local ItemsStorage = ReplicatedStorage:FindFirstChild("Items")
        
        if not ItemsStorage then
            Fluent:Notify({ Title = "Error", Content = "Missing master 'Items' folder in ReplicatedStorage!", Duration = 3 })
            return
        end

        local count = 0

        -- 1. CLEAN UP THE CRASHING FOLDER INSIDE YOUR INVENTORY FIRST
        -- If 'KeyItem' exists as a raw folder, we delete it so line 55 of HandleItems doesn't break
        if PlayerItemsFolder then
            local brokenKeyItem = PlayerItemsFolder:FindFirstChild("KeyItem")
            if brokenKeyItem and brokenKeyItem:IsA("Folder") then
                brokenKeyItem:Destroy()
            end
        end

        -- 2. SPAWN EVERY ITEM MATCHING THE EXACT VALUES THE GAME LOGIC EXPECTS
        for _, itemTemplate in pairs(ItemsStorage:GetChildren()) do
            local itemName = itemTemplate.Name

            if PlayerItemsFolder then
                local existing = PlayerItemsFolder:FindFirstChild(itemName)
                
                if not existing then
                    -- Create an IntValue so OwnWeapon.Value works perfectly on line 55!
                    local itemValue = Instance.new("IntValue")
                    itemValue.Name = itemName
                    itemValue.Value = 5 -- Give yourself 5 copies of everything (Tickets, Potions, Boosters)
                    itemValue.Parent = PlayerItemsFolder
                    count = count + 1
                else
                    -- If it's already there, just replenish the count
                    if existing:IsA("ValueBase") then
                        existing.Value = 5
                    end
                end
            end
        end

        Fluent:Notify({
            Title = "Success",
            Content = "Loaded " .. count .. " items! Check your inventory menu now.",
            Duration = 4
        })
    end
})

Window:SelectTab(Tabs.Items)
