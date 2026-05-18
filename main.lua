local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Network Tester | Delta",
    SubTitle = "Server-Side Verification",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 320),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Test = Window:AddTab({ Title = "Remote Tester", Icon = "rbxassetid://4483345906" })
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemEvents = ReplicatedStorage:FindFirstChild("ItemEvents")

-- Helper function to test different ways a server likes to receive instructions
local function TestRemoteFormat(remoteName)
    local remote = ItemEvents and ItemEvents:FindFirstChild(remoteName)
    if not remote or not remote:IsA("RemoteEvent") then
        Fluent:Notify({ Title = "Error", Content = remoteName .. " event not found!", Duration = 3 })
        return
    end

    -- Format 1: Pass the name of the item as text
    remote:FireServer(remoteName)
    
    -- Format 2: Pass a quantity number
    remote:FireServer(10)
    
    -- Format 3: Pass both item name and a quantity amount
    remote:FireServer(remoteName, 10)
    
    -- Format 4: Pass a boolean validation flag
    remote:FireServer(true)

    Fluent:Notify({ 
        Title = "Packets Sent", 
        Content = "Dispatched multiple parameter formats for: " .. remoteName, 
        Duration = 4 
    })
end

-- BUTTON 1: Test specifically with the Token of LOVE (The Ticket)
Tabs.Test:AddButton({
    Title = "Test 'Token of LOVE' Server Giving",
    Description = "Sends 4 distinct data types to force a server reply",
    Callback = function()
        TestRemoteFormat("Token of LOVE")
    end
})

-- BUTTON 2: Test with a regular item like Gold Booster
Tabs.Test:AddButton({
    Title = "Test 'Gold Booster' Server Giving",
    Description = "Fires alternative structures for item configurations",
    Callback = function()
        TestRemoteFormat("Gold Booster")
    end
})

Window:SelectTab(Tabs.Test)
