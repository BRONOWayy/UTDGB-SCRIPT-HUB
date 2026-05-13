local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [[ NEBULAX CONFIGURATION ]]
local Window = Rayfield:CreateWindow({
   Name = "Nebulax | UTDGB Script Hub",
   LoadingTitle = "Nebulax Galactic Interface",
   LoadingSubtitle = "by Undertale-Dungeons",
   ConfigurationSaving = {
      Enabled = true,
      Folder = "NebulaxData",
      FileName = "UTDGB_Settings"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false
})

-- [[ VARIABLES ]]
local lp = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")
local conf = {
    glue = false,
    dist = 5,
    fov = 70,
    target = nil
}

-- [[ 1. WELCOME SECTION ]]
local MainTab = Window:CreateTab("Home", 4483362458)
MainTab:CreateSection("Welcome")
MainTab:CreateLabel("Thanks for using Nebulax UTDGB Script Hub!")
MainTab:CreateParagraph({Title = "Status", Content = "Version: 1.0.2 (Galactic Edition)\nStatus: Undetected"})

-- [[ 2. ITEMS / FARMING ]]
local FarmTab = Window:CreateTab("Items/Farming", 4483362458)
FarmTab:CreateSection("Enemy Manipulation")

FarmTab:CreateToggle({
   Name = "Glue Enemies to Player",
   CurrentValue = false,
   Callback = function(Value)
      conf.glue = Value
   end,
})

FarmTab:CreateSlider({
   Name = "Glue Distance",
   Min = 1, Max = 20, Default = 5,
   Callback = function(Value)
      conf.dist = Value
   end,
})

-- [[ 3. AUTO GET ITEM ]]
local ItemTab = Window:CreateTab("Auto Get", 4483362458)
ItemTab:CreateSection("Automatic Collection")
ItemTab:CreateButton({
   Name = "Start Auto-Get Items",
   Callback = function()
       Rayfield:Notify({Title = "Nebulax", Content = "Scanning for dropped items...", Duration = 3})
       -- Add your item collection loop here
   end,
})

-- [[ 4. FPS BOOST & WIDENER ]]
local VisualTab = Window:CreateTab("Visuals/Performance", 4483362458)
VisualTab:CreateSection("Screen Tweaks")

VisualTab:CreateSlider({
   Name = "Screen Widener (FOV)",
   Min = 70, Max = 120, Default = 70,
   Callback = function(Value)
      workspace.CurrentCamera.FieldOfView = Value
   end,
})

VisualTab:CreateButton({
   Name
