local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [[ NEBULAX CORE WINDOW ]]
local Window = Rayfield:CreateWindow({
   Name = "Nebulax | UTDGB Script Hub",
   LoadingTitle = "Nebulax Galactic Interface",
   LoadingSubtitle = "by Undertale-Dungeons",
   ConfigurationSaving = {
      Enabled = true,
      Folder = "NebulaxData",
      FileName = "UTDGB_Settings"
   },
   Theme = "Ocean" -- This gives that blue/dark galactic vibe
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
       Rayfield:Notify({Title = "Boost Applied", Content = "Reduced lag by disabling particles.", Duration = 2})
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
UpdateTab:CreateLabel("- Added Glue & Performance Boosters")

-- [[ BACKGROUND ENGINES ]]
RS.Heartbeat:Connect(function()
    -- Glue Script Logic
    if flags.glue then
        -- This logic looks for a folder named 'Enemies' or 'Mobs' 
        -- Update the path below to match the game's mob folder
        local enemies = workspace:FindFirstChild("Enemies") 
        if enemies then
            for _, mob in pairs(enemies:GetChildren()) do
                local hrp = mob:FindFirstChild("HumanoidRootPart")
                local myHrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                if hrp and myHrp then
                    hrp.CFrame = myHrp.CFrame * CFrame.new(0, 0, -
