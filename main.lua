-- Modern UI Library for Delta Executor
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Currency Network Hub | Delta",
    SubTitle = "Server-Side Currency Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 320),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Currency = Window:AddTab({ Title = "Real Currency", Icon = "rbxassetid://4483345906" })
}

-- Input variables for your custom amounts
local InputTickets = 0
local InputGold = 0

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Function to hunt down remotes and fire them
local function ExploitNetworkValue(searchName, finalAmount)
    local firedAny = false
    
    -- Deep scan all folders inside ReplicatedStorage for currency handlers
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            local currentName = remote.Name:lower()
            
            -- If the network event matches our currency search term
            if currentName:find(searchName) or currentName:find("add" .. searchName) or currentName:find("give" .. searchName) then
                -- Fire the number straight to the server host
                remote:FireServer(finalAmount)
                firedAny = true
            end
        end
    end
    return firedAny
end

-- =========================================================
-- TICKETS SECTION
-- =========================================================
Tabs.Currency:AddInput("TicketBox", {
    Title = "Enter Ticket Amount",
    Default = "0",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        InputTickets = tonumber(Value) or 0
    end
})

Tabs.Currency:AddButton({
    Title = "Inject Real Tickets",
    Callback = function()
        -- Scans for 'ticket' or 'token' remotes
        local success = ExploitNetworkValue("ticket", InputTickets) or ExploitNetworkValue("token", InputTickets)
        
        if success then
            Fluent:Notify({ Title = "Network Packet Sent", Content = "Fired ticket updates to the server!", Duration = 3 })
        else
            -- Fallback: If no server remote exists, try forcing it locally inside your player statistics
            local statFolder = Player:FindFirstChild("PlayerStats") or Player
            local ticketObj = statFolder:FindFirstChild("Tickets", true) or statFolder:FindFirstChild("Ticket", true)
            if ticketObj then
                ticketObj.Value = InputTickets
                Fluent:Notify({ Title = "Local Update", Content = "Set local ticket value property.", Duration = 3 })
            else
                Fluent:Notify({ Title = "Error", Content = "Could not find a ticket network line or value!", Duration = 4 })
            end
        end
    end
})

-- =========================================================
-- GOLD SECTION
-- =========================================================
Tabs.Currency:AddInput("GoldBox", {
    Title = "Enter Gold Amount",
    Default = "0",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        InputGold = tonumber(Value) or 0
    end
})

Tabs.Currency:AddButton({
    Title = "Inject Real Gold",
    Callback = function()
        local success = ExploitNetworkValue("gold", InputGold) or ExploitNetworkValue("money", InputGold)
        
        if success then
            Fluent:Notify({ Title = "Network Packet Sent", Content = "Fired gold updates to the server!", Duration = 3 })
        else
            local statFolder = Player:FindFirstChild("PlayerStats") or Player
            local goldObj = statFolder:FindFirstChild("Gold", true)
            if goldObj then
                goldObj.Value = InputGold
                Fluent:Notify({ Title = "Local Update", Content = "Set local gold value property.", Duration = 3 })
            else
                Fluent:Notify({ Title = "Error", Content = "Could not find a gold network line or value!", Duration = 4 })
            end
        end
    end
})

Window:SelectTab(Tabs.Currency)
