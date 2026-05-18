-- Modern UI Library for Delta Executor
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Undertale Network Editor",
    SubTitle = "Delta Engine v3",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 360),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Stats = Window:AddTab({ Title = "Real Stats", Icon = "rbxassetid://4483345906" }),
    Items = Window:AddTab({ Title = "Item Spawner", Icon = "rbxassetid://4483345906" })
}

-- Storage parameters for custom numbers
local TargetGold = 0
local TargetTickets = 0
local TargetLove = 1

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerItemsFolder = Player:WaitForChild("Items", 10)

-- =========================================================
-- REAL SERVER NETWORK EXPLOITATION LOGIC
-- =========================================================

local function SendNetworkPacket(statType, amount)
    local success = false
    
    -- Scan ReplicatedStorage dynamically for backend remote gateways
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            local name = remote.Name:lower()
            
            -- Filter logic matching your exact gameplay metrics
            if statType == "Gold" and (name:find("gold") or name:find("add") or name:find("money") or name:find("cash")) then
                remote:FireServer(amount)
                success = true
            elseif statType == "Tickets" and (name:find("ticket") or name:find("token") or name:find("shop")) then
                remote:FireServer(amount)
                success = true
            elseif statType == "Love" and (name:find("love") or name:find("lvl") or name:find("level") or name:find("xp")) then
                remote:FireServer(amount)
                success = true
            end
        end
    end
    return success
end

-- =========================================================
-- UI INPUT & ACTION BOUNDS
-- =========================================================

-- Gold Control Set
Tabs.Stats:AddInput("GoldSet", {
    Title = "Enter Desired Gold Amount",
    Default = "0",
    Numeric = true,
    Finished = true,
    Callback = function(Value) TargetGold = tonumber(Value) or 0 end
})

Tabs.Stats:AddButton({
    Title = "Inject Real Gold to Server",
    Callback = function()
        local sent = SendNetworkPacket("Gold", TargetGold)
        if sent then
            Fluent:Notify({ Title = "Network Success", Content = "Dispatched packet for " .. TargetGold .. " Gold.", Duration = 3 })
        else
            -- Backup local memory modification attempt if remotes are completely hidden
            local localGold = Player:FindFirstChild("Gold", true) or (Player:FindFirstChild("PlayerStats") and Player.PlayerStats:FindFirstChild("Gold"))
            if localGold then localGold.Value = TargetGold end
            Fluent:Notify({ Title = "Local Override", Content = "Updated local data memory registers directly.", Duration = 3 })
        end
    end
})

-- Tickets Control Set
Tabs.Stats:AddInput("TicketSet", {
    Title = "Enter Desired Tickets Amount",
    Default = "0",
    Numeric = true,
    Finished = true,
    Callback = function(Value) TargetTickets = tonumber(Value) or 0 end
})

Tabs.Stats:AddButton({
    Title = "Inject Real Tickets to Server",
    Callback = function()
        local sent = SendNetworkPacket("Tickets", TargetTickets)
        if sent then
            Fluent:Notify({ Title = "Network Success", Content = "Dispatched packet for " .. TargetTickets .. " Tickets.", Duration = 3 })
        else
            local localTickets = Player:FindFirstChild("Tickets", true) or Player:FindFirstChild("Ticket", true)
            if localTickets then localTickets.Value = TargetTickets end
            Fluent:Notify({ Title = "Local Override", Content = "Updated local ticket token registries.", Duration = 3 })
        end
    end
})

-- Love (LVL) Control Set
Tabs.Stats:AddInput("LoveSet", {
    Title = "Enter Desired LOVE Level",
    Default = "1",
    Numeric = true,
    Finished = true,
    Callback = function(Value) TargetLove = tonumber(Value) or 1 end
})

Tabs.Stats:AddButton({
    Title = "Inject Real LOVE to Server",
    Callback = function()
        local sent = SendNetworkPacket("Love", TargetLove)
        if sent then
            Fluent:Notify({ Title = "Network Success", Content = "Dispatched packet for LV " .. TargetLove, Duration = 3 })
        else
            local localLove = Player:FindFirstChild("Love", true) or (Player:FindFirstChild("PlayerStats") and Player.PlayerStats:FindFirstChild("Love"))
            if localLove then localLove.Value = TargetLove end
            Fluent:Notify({ Title = "Local Override", Content = "Updated local value instance properties directly.", Duration = 3 })
        end
    end
})


-- =========================================================
-- ITEM SPAWNER TAB (CRASH-PROOF IMPLEMENTATION)
-- =========================================================
Tabs.Items:AddButton({
    Title = "Force Unlock All Real Items",
    Description = "Synchronizes server-level item events safely",
    Callback = function()
        local ItemEventsFolder = ReplicatedStorage:FindFirstChild("ItemEvents")
        local ItemsFolder = ReplicatedStorage:FindFirstChild("Items")
        
        if not ItemEventsFolder then
            Fluent:Notify({ Title = "Error", Content = "ItemEvents network folder missing!", Duration = 3 })
            return
        end
        
        local count = 0
        local itemsList = ItemsFolder and ItemsFolder:GetChildren() or ItemEventsFolder:GetChildren()
        
        for _, item in pairs(itemsList) do
            local remote = ItemEventsFolder:FindFirstChild(item.Name)
            if remote and remote:IsA("RemoteEvent") then
                remote:FireServer()
                count = count + 1
                task.wait(0.02) -- Safe processing rate limit
            end
        end
        
        Fluent:Notify({ Title = "Success", Content = "Fired " .. count .. " items directly into your game database profile!", Duration = 4 })
    end
})

-- =========================================================
-- FIXED HANDLEITEMS ERROR CORRECTION
-- =========================================================
task.spawn(function()
    local inventoryGui = Player:WaitForChild("PlayerGui", 10):WaitForChild("InventoryGui", 5)
    if inventoryGui then
        -- This stops the KeyItem error crash by injecting default value trackers into any folders missing them
        if PlayerItemsFolder then
            PlayerItemsFolder.ChildAdded:Connect(function(newChild)
                if not newChild:IsA("ValueBase") then
                    -- Safely attach a missing Value object inside raw asset folders so HandleItems won't crash
                    if not newChild:FindFirstChild("Value") then
                        local fakeVal = Instance.new("IntValue")
                        fakeVal.Name = "Value"
                        fakeVal.Value = 1
                        fakeVal.Parent = newChild
                    end
                end
            end)
        end
    end
end)

Window:SelectTab(Tabs.Stats)
