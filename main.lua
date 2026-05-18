-- Modern UI Library for Delta Executor
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Undertale Hub | Final Edition",
    SubTitle = "Delta Engine",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 340),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Real Stats", Icon = "rbxassetid://4483345906" }),
    Items = Window:AddTab({ Title = "Item Spawner", Icon = "rbxassetid://4483345906" })
}

local TargetGold = 0
local TargetTickets = 0
local TargetLove = 1

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerItemsFolder = Player:WaitForChild("Items", 10)

-- =========================================================
-- SERVER NETWORK UTILITY
-- =========================================================
local function FireNetworkRemote(statType, val)
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local rName = remote.Name:lower()
            if statType == "Gold" and (rName:find("gold") or rName:find("money") or rName:find("add")) then
                remote:FireServer(val)
            elseif statType == "Tickets" and (rName:find("ticket") or rName:find("token")) then
                remote:FireServer(val)
            elseif statType == "Love" and (rName:find("love") or rName:find("lvl") or rName:find("xp")) then
                remote:FireServer(val)
            end
        end
    end
end

-- =========================================================
-- STAT EDITOR INTERFACE
-- =========================================================
Tabs.Main:AddInput("GoldAmount", {
    Title = "Gold Value",
    Default = "0",
    Numeric = true,
    Finished = true,
    Callback = function(v) TargetGold = tonumber(v) or 0 end
})

Tabs.Main:AddButton({
    Title = "Update Server Gold",
    Callback = function()
        FireNetworkRemote("Gold", TargetGold)
        Fluent:Notify({ Title = "Dispatched", Content = "Gold modification network request sent.", Duration = 2 })
    end
})

Tabs.Main:AddInput("TicketAmount", {
    Title = "Tickets Value",
    Default = "0",
    Numeric = true,
    Finished = true,
    Callback = function(v) TargetTickets = tonumber(v) or 0 end
})

Tabs.Main:AddButton({
    Title = "Update Server Tickets",
    Callback = function()
        FireNetworkRemote("Tickets", TargetTickets)
        Fluent:Notify({ Title = "Dispatched", Content = "Ticket modification network request sent.", Duration = 2 })
    end
})

Tabs.Main:AddInput("LoveAmount", {
    Title = "LOVE Level (LV)",
    Default = "1",
    Numeric = true,
    Finished = true,
    Callback = function(v) TargetLove = tonumber(v) or 1 end
})

Tabs.Main:AddButton({
    Title = "Update Server LOVE",
    Callback = function()
        FireNetworkRemote("Love", TargetLove)
        Fluent:Notify({ Title = "Dispatched", Content = "LOVE verification level request sent.", Duration = 2 })
    end
})

-- =========================================================
-- REAL ITEM EXPLOITER & CRASH PATCH
-- =========================================================
Tabs.Items:AddButton({
    Title = "Unlock All Game Items",
    Description = "Safely fires all events matching your ItemEvents directory",
    Callback = function()
        local ItemEvents = ReplicatedStorage:FindFirstChild("ItemEvents")
        if not ItemEvents then
            Fluent:Notify({ Title = "Error", Content = "ItemEvents folder not found in ReplicatedStorage!", Duration = 3 })
            return
        end

        local count = 0
        for _, remote in pairs(ItemEvents:GetChildren()) do
            if remote:IsA("RemoteEvent") then
                remote:FireServer()
                count = count + 1
                task.wait(0.02)
            end
        end

        Fluent:Notify({ Title = "Success", Content = "Fired " .. count .. " database item events!", Duration = 4 })
    end
})

-- BACKGROUND LOOP: FIX AND SANITIZE INVENTORY CODES TO PREVENT CRASHES
task.spawn(function()
    while task.wait(0.5) do
        if PlayerItemsFolder then
            for _, child in pairs(PlayerItemsFolder:GetChildren()) do
                -- If it's a raw folder like "KeyItem" and doesn't have a value property, fix it so HandleItems won't error out
                if child:IsA("Folder") or child:IsA("Model") or child:IsA("Tool") then
                    if not child:FindFirstChild("Value") then
                        local intVal = Instance.new("IntValue")
                        intVal.Name = "Value"
                        intVal.Value = 1
                        intVal.Parent = child
                    end
                end
            end
        end
    end
end)

Window:SelectTab(Tabs.Main)
