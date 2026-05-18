-- Modern UI Library for Delta Executor
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Item Activator | Delta Hub",
    SubTitle = "Server-Side Network Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 300),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Items = Window:AddTab({ Title = "Item Exploiter", Icon = "rbxassetid://4483345906" })
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

Tabs.Items:AddButton({
    Title = "Server-Give All Items",
    Description = "Fires network events so the server gives you the items",
    Callback = function()
        -- Pointing directly to your exact folder from the screenshot
        local ItemEventsFolder = ReplicatedStorage:FindFirstChild("ItemEvents")
        
        if not ItemEventsFolder then
            Fluent:Notify({ Title = "Network Error", Content = "Could not find ItemEvents in ReplicatedStorage!", Duration = 3 })
            return
        end

        local count = 0
        
        -- Loop through every single real RemoteEvent inside your ItemEvents folder
        for _, remote in pairs(ItemEventsFolder:GetChildren()) do
            if remote:IsA("RemoteEvent") then
                -- This sends a packet down the game's network line to the server host
                remote:FireServer()
                count = count + 1
                task.wait(0.05) -- Small delay to prevent the server from kicking you for spamming
            end
        end

        Fluent:Notify({
            Title = "Network Packets Sent",
            Content = "Successfully fired " .. count .. " item remotes directly to the server!",
            Duration = 4
        })
    end
})

Window:SelectTab(Tabs.Items)
