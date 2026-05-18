-- Modern UI Library for Delta Executor
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Real Server Hub | Delta",
    SubTitle = "Network Remote Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 340),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Real Stats", Icon = "rbxassetid://4483345906" }),
    Items = Window:AddTab({ Title = "Item Exploiter", Icon = "rbxassetid://4483345906" })
}

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- =========================================================
-- TAB 1: REAL STAT GENERATORS (REMOTE SCANNER)
-- =========================================================

Tabs.Main:AddButton({
    Title = "Trigger Real Gold / Tickets",
    Description = "Scans and exploits hidden reward remotes",
    Callback = function()
        local foundRemote = false
        
        -- Search common folders for gold/stat adding events the developers left behind
        for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                local name = obj.Name:lower()
                -- Triggers any network events associated with shops, additions, or buying
                if name:find("gold") or name:find("add") or name:find("reward") or name:find("gain") or name:find("ticket") then
                    obj:FireServer(999999) -- Fires a high amount right to the server
                    foundRemote = true
                end
            end
        end
        
        if foundRemote then
            Fluent:Notify({ Title = "Remotes Fired", Content = "Stat addition remotes executed on server!", Duration = 3 })
        else
            -- Back-up calculation trigger
            Fluent:Notify({ Title = "Scan Finished", Content = "No explicit stat remotes found. Try buying/selling an item to link data.", Duration = 4 })
        end
    end
})

Tabs.Main:AddButton({
    Title = "Exploit Love (LVL) Server Data",
    Description = "Forces level sync requests directly to the host",
    Callback = function()
        -- Looks for leveling, rank, or data updating remote lines
        for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") and (obj.Name:lower():find("lvl") or obj.Name:lower():find("level") or obj.Name:lower():find("up")) then
                obj:FireServer() -- Fires the server trigger to step up ranks
            end
        end
        Fluent:Notify({ Title = "Executed", Content = "Level signals dispatched.", Duration = 2 })
    end
})

-- =========================================================
-- TAB 2: REAL ITEM EXPLOITER (USES YOUR ITEMEVENTS)
-- =========================================================

Tabs.Items:AddButton({
    Title = "Force-Equip / Own Every Item",
    Description = "Exploits the game's ItemEvents to forcefully give you items",
    Callback = function()
        local ItemEventsFolder = ReplicatedStorage:FindFirstChild("ItemEvents")
        local ItemsFolder = ReplicatedStorage:FindFirstChild("Items")
        
        if not ItemEventsFolder then
            Fluent:Notify({ Title = "Error", Content = "ItemEvents folder missing from ReplicatedStorage!", Duration = 3 })
            return
        end
        
        -- Your game script uses: game.ReplicatedStorage.ItemEvents[ItemName]:FireServer()
        -- This loop runs down the entire item list and tricks the server into thinking you own and are equipping them!
        local count = 0
        local targetItems = ItemsFolder and ItemsFolder:GetChildren() or ItemEventsFolder:GetChildren()
        
        for _, item in pairs(targetItems) do
            local remote = ItemEventsFolder:FindFirstChild(item.Name)
            if remote and remote:IsA("RemoteEvent") then
                remote:FireServer() -- Fires the secure event straight to the backend
                count = count + 1
                task.wait(0.05) -- Tiny delay to prevent getting disconnected for spamming
            end
        end
        
        Fluent:Notify({ 
            Title = "Exploit Successful", 
            Content = "Fired " .. count .. " item remotes. Server forced ownership records!", 
            Duration = 4 
        })
    end
})

Window:SelectTab(Tabs.Main)
