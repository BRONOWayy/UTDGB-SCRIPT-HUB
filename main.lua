-- [[ NEBULAX BOOTSTRAPPER ]]
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareDesign/Rayfield/main/source.lua'))()
end)

if not success or not Rayfield then
    warn("Nebulax: Failed to load UI Library. Check your internet or executor.")
    return
end

local Window = Rayfield:CreateWindow({
   Name = "Nebulax | UTDGB Script Hub",
   LoadingTitle = "Nebulax Galactic Interface",
   LoadingSubtitle = "by Undertale-Dungeons",
   ConfigurationSaving = {
      Enabled = true,
      Folder = "NebulaxData",
      FileName = "UTDGB_Settings"
   },
   Theme = "Ocean" 
})

-- [[ GLOBAL FLAGS ]]
local P = game:GetService("Players")
local lp = P.LocalPlayer
local RS = game:GetService("RunService")
local flags = { glue = false, dist = 5, autoGet = false }

-- [[ SECTION 1: HOME ]]
local HomeTab = Window:CreateTab("Home", 4483362458)
HomeTab:CreateSection("Welcome & Credits")
HomeTab:CreateLabel("Thanks for using Nebulax UTDGB Script Hub!")
HomeTab:CreateParagraph({Title = "Developer Note", Content = "The first ever UTDGB script. Stay galactic."})

-- [[ SECTION 2: ITEMS / FARMING ]]
local FarmTab = Window:CreateTab("Items/Farming", 4483362458)
FarmTab:CreateSection("Enemy Logic")

FarmTab:CreateToggle({
   Name = "Glue Enemies (Nebulax Style)",
   CurrentValue = false,
   Callback = function(Value)
      flags.glue = Value
   end,
})

FarmTab:CreateSlider({
   Name = "Glue Distance",
   Min = 1, Max = 15, Default = 5,
   Callback = function(Value)
      flags.dist = Value
   end,
})

-- [[ SECTION 3: AUTO GET ITEM ]]
local ItemTab = Window:CreateTab("Auto Get", 4483362458)
ItemTab:CreateSection("Collector")
ItemTab:CreateToggle({
   Name = "Auto-Pickup Items",
   CurrentValue = false,
   Callback = function(Value)
      flags.autoGet = Value
   end,
})

-- [[ SECTION 4: VISUALS & PERFORMANCE ]]
local PerfTab = Window:CreateTab("Performance", 4483362458)
PerfTab:CreateSection("Visual Tweaks")

PerfTab:CreateSlider({
   Name = "Screen Widener (FOV)",
   Min = 70, Max = 120, Default = 70,
   Callback = function(Value)
      workspace.CurrentCamera.FieldOfView = Value
   end,
})

PerfTab:CreateButton({
   Name = "Nebulax FPS Boost",
   Callback = function()
       for _, v in pairs(game:GetDescendants()) do
           if v:IsA("PostProcessEffect") or v:IsA("ParticleEmitter") then
               v.Enabled = false
           end
       end
       Rayfield:Notify({Title = "Boost Applied", Content = "Reduced lag.", Duration = 2})
   end,
})

-- [[ SECTION 5: SETTINGS & EXIT ]]
local SettingsTab = Window:CreateTab("Settings", 4483362458)
SettingsTab:CreateSection("UI Controls")

SettingsTab:CreateButton({
   Name = "Close Script (Safe)",
   Callback = function()
       Rayfield:Notify({
           Title = "Are you sure?",
           Content = "Nebulax will stop running.",
           Duration = 5,
           Actions = {
               Ignore = { Name = "No, wait!", Callback = function() end },
               Accept = { Name = "Yes, I'm sure", Callback = function() Rayfield:Destroy() end }
           }
       })
   end,
})

-- [[ SECTION 6: UPDATE LIST ]]
local UpdateTab = Window:CreateTab("Updates", 4483362458)
UpdateTab:CreateSection("Changelog")
UpdateTab:CreateLabel("- v1.0.0 Initial Galactic Release")

-- [[ BACKGROUND ENGINES ]]
RS.Heartbeat:Connect(function()
    if flags.glue then
        -- Logic to move mobs to you
        local mobs = workspace:FindFirstChild("Mobs") or workspace:FindFirstChild("Enemies")
        if mobs then
            for _, mob in pairs(mobs:GetChildren()) do
                local hrp = mob:FindFirstChild("HumanoidRootPart")
                local myHrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                if hrp and myHrp then-- [[ NEBULAX: GALACTIC SCRIPT HUB ]]
-- Created by Max

local P = game:GetService("Players")
local lp = P.LocalPlayer
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Destroy existing UI if it exists
if CoreGui:FindFirstChild("NebulaxHub") then CoreGui.NebulaxHub:Destroy() end

-- [[ MAIN UI SETUP ]]
local Nebulax = Instance.new("ScreenGui", CoreGui)
Nebulax.Name = "NebulaxHub"

local Main = Instance.new("Frame", Nebulax)
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 25) -- Deep Space Blue
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

-- Slick Rounded Corners & Border
local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = Tooltonumber and UDim.new(0, 10) or UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(80, 0, 200) -- Galactic Purple Border

-- [[ SIDEBAR ]]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 130, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
local SideCorner = Instance.new("UICorner", Sidebar)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "NEBULAX"
Title.TextColor3 = Color3.fromRGB(200, 200, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local Credits = Instance.new("TextLabel", Sidebar)
Credits.Size = UDim2.new(1, 0, 0, 20)
Credits.Position = UDim2.new(0, 0, 1, -30)
Credits.Text = "Made by Max"
Credits.TextColor3 = Color3.fromRGB(100, 100, 150)
Credits.TextSize = 12
Credits.Font = Enum.Font.Gotham
Credits.BackgroundTransparency = 1

-- [[ CONTAINER FOR SECTIONS ]]
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -140, 1, -20)
Container.Position = UDim2.new(0, 135, 0, 10)
Container.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name, order)
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = (order == 1)
    Page.ScrollBarThickness = 2
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)
    Pages[name] = Page
    
    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
    TabBtn.Position = UDim2.new(0.05, 0, 0, 50 + (order * 40))
    TabBtn.Text = name
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    TabBtn.TextColor3 = Color3.new(1,1,1)
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.TextSize = 13
    Instance.new("UICorner", TabBtn)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)
end

-- [[ THE 6 SECTIONS ]]
CreatePage("Home", 1)
CreatePage("Items/Farming", 2)
CreatePage("Auto Get", 3)
CreatePage("Performance", 4)
CreatePage("Settings", 5)
CreatePage("Updates", 6)

-- [[ SECTION 1: HOME ]]
local welcome = Instance.new("TextLabel", Pages["Home"])
welcome.Size = UDim2.new(1, 0, 0, 50)
welcome.Text = "Thanks for using UTDGB Script Hub!"
welcome.TextColor3 = Color3.new(1,1,1)
welcome.BackgroundTransparency = 1
welcome.Font = Enum.Font.GothamSemibold

-- [[ SECTION 5: SETTINGS (WITH CLOSE LOGIC) ]]
local CloseBtn = Instance.new("TextButton", Pages["Settings"])
CloseBtn.Size = UDim2.new(1, -10, 0,
