-- Modern UI Library for Delta Executor
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Item Spawner | Delta Hub",
    SubTitle = "Safe Inventory Edition",
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
    Title = "Unlock All Items Safely",
    Description = "Adds items to your inventory UI without crashing",
    Callback = function()
        -- Look inside ReplicatedStorage for the master list of item assets
        local ItemsStorage = ReplicatedStorage:FindFirstChild("Items")
        
        if not ItemsStorage then
            Fluent:Notify({ Title = "Error", Content = "Could not find 'Items' in ReplicatedStorage!", Duration = 3 })
            return
        end

        local count = 0

        for _, itemTemplate in pairs(ItemsStorage:GetChildren()) do
            local itemName = itemTemplate.Name

            if PlayerItemsFolder then
                -- Check if you already have this item registered
                local existingItem = PlayerItemsFolder:FindFirstChild(itemName)
                
                if not existingItem then
                    -- Create an IntValue to match what HandleItems expects
                    local itemValue = Instance.new("IntValue")
                    itemValue.Name = itemName
                    itemValue.Value = 1 -- Sets quantity/ownership
                    itemValue.Parent = PlayerItemsFolder
                    count = count + 1
                else
                    -- If it's already a value object, just make sure it's activated
                    if existingItem:IsA("ValueBase") then
                        existingItem.Value = 1
                    end
                end
            end
        end

        Fluent:Notify({
            Title = "Success",
            Content = "Added " .. count .. " items! Open your in-game inventory to check.",
            Duration = 4
        })
    end
})

Window:SelectTab(Tabs.Items)
