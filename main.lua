-- [[ NEBULAX OFFICIAL V1.0 ]]
-- [[ DEVELOPED BY: MAX ]]
-- [[ SYSTEM: TITAN TERMINAL ]]

-- [[ CORE SERVICES ]]
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- [[ GLOBAL SETTINGS ]]
_G.NebulaX_Config = {
    -- UI Visuals
    RainbowActive = false,
    RainbowSpeed = 5,
    MenuIcon = "🌌",
    MenuVisible = true,
    
    -- Combat Logic
    GlueActive = false,
    GlueTargetMode = "Classic", -- Classic, Orbit
    CurrentTargets = {},
    GlueHeightOffset = 3,
    OrbitDistance = 20,
    OrbitRotationSpeed = 4,
    M1SpamEnabled = false,
    
    -- Movement Logic
    FlightActive = false,
    FlightControlMode = "Manual", -- Manual, Automatic
    SpeedMultiplier = 75,
    NoclipEnabled = false,
    InfJumpEnabled = false,
    
    -- World & Server
    ServerFilter = "",
    GravityValue = 196.2,
    FullBrightActive = false
}

-- [[ THEME DATA ]]
local ColorTheme = {
    Background = Color3.fromRGB(12, 10, 22),
    Sidebar = Color3.fromRGB(7, 5, 15),
    Accent = Color3.fromRGB(160, 80, 255),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    ButtonDull = Color3.fromRGB(25, 18, 40),
    ButtonBright = Color3.fromRGB(160, 80, 255)
}

-- [[ UI CONSTRUCTION ]]
if CoreGui:FindFirstChild("NebulaX_V1_Final") then
    CoreGui.NebulaX_V1_Final:Destroy()
end

local MainGui = Instance.new("ScreenGui")
MainGui.Name = "NebulaX_V1_Final"
MainGui.Parent = CoreGui
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- [[ RAINBOW ENGINE ]]
RunService.RenderStepped:Connect(function()
    if _G.NebulaX_Config.RainbowActive then
        local H = tick() % _G.NebulaX_Config.RainbowSpeed / _G.NebulaX_Config.RainbowSpeed
        local RainbowColor = Color3.fromHSV(H, 0.7, 1)
        
        if MainGui:FindFirstChild("MainFrame") then
            MainGui.MainFrame.UIStroke.Color = RainbowColor
            if MainGui.MainFrame:FindFirstChild("Sidebar") then
                MainGui.MainFrame.Sidebar.Branding.TextColor3 = RainbowColor
            end
        end
        if MainGui:FindFirstChild("MinimizeIcon") then
            MainGui.MinimizeIcon.UIStroke.Color = RainbowColor
        end
    end
end)

-- [[ MINIMIZE ICON ]]
local MinIcon = Instance.new("TextButton")
MinIcon.Name = "MinimizeIcon"
MinIcon.Parent = MainGui
MinIcon.Size = UDim2.new(0, 60, 0, 60)
MinIcon.Position = UDim2.new(0.02, 0, 0.8, 0)
MinIcon.BackgroundColor3 = ColorTheme.Background
MinIcon.Text = _G.NebulaX_Config.MenuIcon
MinIcon.TextSize = 35
MinIcon.Visible = false
MinIcon.Active = true
MinIcon.Draggable = true

local MinCorner = Instance.new("UICorner", MinIcon)
MinCorner.CornerRadius = UDim.new(1, 0)
local MinStroke = Instance.new("UIStroke", MinIcon)
MinStroke.Color = ColorTheme.Accent
MinStroke.Thickness = 2

-- [[ MAIN FRAME ]]
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = MainGui
MainFrame.Size = UDim2.new(0, 700, 0, 500)
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
MainFrame.BackgroundColor3 = ColorTheme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner", MainFrame)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = ColorTheme.Accent
MainStroke.Thickness = 2

-- [[ SIDEBAR ]]
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = MainFrame
Sidebar.Size = UDim2.new(0, 200, 1, 0)
Sidebar.BackgroundColor3 = ColorTheme.Sidebar
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar)

local Branding = Instance.new("TextLabel")
Branding.Name = "Branding"
Branding.Parent = Sidebar
Branding.Size = UDim2.new(1, 0, 0, 70)
Branding.BackgroundTransparency = 1
Branding.Text = "NEBULA X v1.0\nBY MAX"
Branding.TextColor3 = ColorTheme.Accent
Branding.Font = Enum.Font.GothamBold
Branding.TextSize = 22

-- [[ NAVIGATION TAB BUTTONS (Manual Lines) ]]
local CombatTabBtn = Instance.new("TextButton")
CombatTabBtn.Name = "CombatBtn"
CombatTabBtn.Parent = Sidebar
CombatTabBtn.Size = UDim2.new(0.9, 0, 0, 45)
CombatTabBtn.Position = UDim2.new(0.05, 0, 0, 90)
CombatTabBtn.BackgroundColor3 = ColorTheme.ButtonBright
CombatTabBtn.Text = "COMBAT"
CombatTabBtn.TextColor3 = ColorTheme.TextPrimary
Instance.new("UICorner", CombatTabBtn)

local MoveTabBtn = Instance.new("TextButton")
MoveTabBtn.Name = "MovementBtn"
MoveTabBtn.Parent = Sidebar
MoveTabBtn.Size = UDim2.new(0.9, 0, 0, 45)
MoveTabBtn.Position = UDim2.new(0.05, 0, 0, 140)
MoveTabBtn.BackgroundColor3 = ColorTheme.ButtonDull
MoveTabBtn.Text = "MOVEMENT"
MoveTabBtn.TextColor3 = ColorTheme.TextPrimary
Instance.new("UICorner", MoveTabBtn)

local WorldTabBtn = Instance.new("TextButton")
WorldTabBtn.Name = "WorldBtn"
WorldTabBtn.Parent = Sidebar
WorldTabBtn.Size = UDim2.new(0.9, 0, 0, 45)
WorldTabBtn.Position = UDim2.new(0.05, 0, 0, 190)
WorldTabBtn.BackgroundColor3 = ColorTheme.ButtonDull
WorldTabBtn.Text = "WORLD"
WorldTabBtn.TextColor3 = ColorTheme.TextPrimary
Instance.new("UICorner", WorldTabBtn)

local ServerTabBtn = Instance.new("TextButton")
ServerTabBtn.Name = "ServerBtn"
ServerTabBtn.Parent = Sidebar
ServerTabBtn.Size = UDim2.new(0.9, 0, 0, 45)
ServerTabBtn.Position = UDim2.new(0.05, 0, 0, 240)
ServerTabBtn.BackgroundColor3 = ColorTheme.ButtonDull
ServerTabBtn.Text = "SERVER BROWSER"
ServerTabBtn.TextColor3 = ColorTheme.TextPrimary
Instance.new("UICorner", ServerTabBtn)

local SettingsTabBtn = Instance.new("TextButton")
SettingsTabBtn.Name = "SettingsBtn"
SettingsTabBtn.Parent = Sidebar
SettingsTabBtn.Size = UDim2.new(0.9, 0, 0, 45)
SettingsTabBtn.Position = UDim2.new(0.05, 0, 0, 290)
SettingsTabBtn.BackgroundColor3 = ColorTheme.ButtonDull
SettingsTabBtn.Text = "SETTINGS"
SettingsTabBtn.TextColor3 = ColorTheme.TextPrimary
Instance.new("UICorner", SettingsTabBtn)

-- [[ PAGE SYSTEM ]]
local PageContainer = Instance.new("Frame")
PageContainer.Parent = MainFrame
PageContainer.Size = UDim2.new(1, -220, 1, -80)
PageContainer.Position = UDim2.new(0, 210, 0, 60)
PageContainer.BackgroundTransparency = 1

local CombatPage = Instance.new("ScrollingFrame", PageContainer)
CombatPage.Size = UDim2.new(1, 0, 1, 0)
CombatPage.BackgroundTransparency = 1
CombatPage.ScrollBarThickness = 2
CombatPage.Visible = true

local MovePage = Instance.new("ScrollingFrame", PageContainer)
MovePage.Size = UDim2.new(1, 0, 1, 0)
MovePage.BackgroundTransparency = 1
MovePage.Visible = false

local ServerPage = Instance.new("ScrollingFrame", PageContainer)
ServerPage.Size = UDim2.new(1, 0, 1, 0)
ServerPage.BackgroundTransparency = 1
ServerPage.Visible = false

local SettingsPage = Instance.new("ScrollingFrame", PageContainer)
SettingsPage.Size = UDim2.new(1, 0, 1, 0)
SettingsPage.BackgroundTransparency = 1
SettingsPage.Visible = false

-- [[ TAB SWITCHING LOGIC ]]
CombatTabBtn.MouseButton1Click:Connect(function()
    CombatPage.Visible = true MovePage.Visible = false ServerPage.Visible = false SettingsPage.Visible = false
    CombatTabBtn.BackgroundColor3 = ColorTheme.ButtonBright MoveTabBtn.BackgroundColor3 = ColorTheme.ButtonDull ServerTabBtn.BackgroundColor3 = ColorTheme.ButtonDull SettingsTabBtn.BackgroundColor3 = ColorTheme.ButtonDull
end)

MoveTabBtn.MouseButton1Click:Connect(function()
    CombatPage.Visible = false MovePage.Visible = true ServerPage.Visible = false SettingsPage.Visible = false
    CombatTabBtn.BackgroundColor3 = ColorTheme.ButtonDull MoveTabBtn.BackgroundColor3 = ColorTheme.ButtonBright ServerTabBtn.BackgroundColor3 = ColorTheme.ButtonDull SettingsTabBtn.BackgroundColor3 = ColorTheme.ButtonDull
end)

ServerTabBtn.MouseButton1Click:Connect(function()
    CombatPage.Visible = false MovePage.Visible = false ServerPage.Visible = true SettingsPage.Visible = false
    CombatTabBtn.BackgroundColor3 = ColorTheme.ButtonDull MoveTabBtn.BackgroundColor3 = ColorTheme.ButtonDull ServerTabBtn.BackgroundColor3 = ColorTheme.ButtonBright SettingsTabBtn.BackgroundColor3 = ColorTheme.ButtonDull
end)

SettingsTabBtn.MouseButton1Click:Connect(function()
    CombatPage.Visible = false MovePage.Visible = false ServerPage.Visible = false SettingsPage.Visible = true
    CombatTabBtn.BackgroundColor3 = ColorTheme.ButtonDull MoveTabBtn.BackgroundColor3 = ColorTheme.ButtonDull ServerTabBtn.BackgroundColor3 = ColorTheme.ButtonDull SettingsTabBtn.BackgroundColor3 = ColorTheme.ButtonBright
end)

-- [[ COMBAT: TARGET SCROLL WHEEL ]]
local TargetArea = Instance.new("Frame", CombatPage)
TargetArea.Size = UDim2.new(1, -10, 0, 200)
TargetArea.BackgroundColor3 = ColorTheme.Sidebar
Instance.new("UICorner", TargetArea)

local ScrollTitle = Instance.new("TextLabel", TargetArea)
ScrollTitle.Size = UDim2.new(1, 0, 0, 30)
ScrollTitle.Text = "SELECT TARGETS"
ScrollTitle.TextColor3 = ColorTheme.Accent
ScrollTitle.BackgroundTransparency = 1

local PlayerScroll = Instance.new("ScrollingFrame", TargetArea)
PlayerScroll.Size = UDim2.new(1, -10, 1, -40)
PlayerScroll.Position = UDim2.new(0, 5, 0, 35)
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.ScrollBarThickness = 4
local ScrollLayout = Instance.new("UIListLayout", PlayerScroll)
ScrollLayout.Padding = UDim.new(0, 5)

local function RefreshPlayerList()
    for _, item in pairs(PlayerScroll:GetChildren()) do if item:IsA("TextButton") then item:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local pBtn = Instance.new("TextButton", PlayerScroll)
            pBtn.Size = UDim2.new(1, -10, 0, 30)
            pBtn.Text = p.Name
            pBtn.BackgroundColor3 = table.find(_G.NebulaX_Config.CurrentTargets, p.Name) and ColorTheme.Accent or ColorTheme.ButtonDull
            pBtn.TextColor3 = ColorTheme.TextPrimary
            Instance.new("UICorner", pBtn)
            pBtn.MouseButton1Click:Connect(function()
                local idx = table.find(_G.NebulaX_Config.CurrentTargets, p.Name)
                if idx then table.remove(_G.NebulaX_Config.CurrentTargets, idx) else table.insert(_G.NebulaX_Config.CurrentTargets, p.Name) end
                RefreshPlayerList()
            end)
        end
    end
end
RefreshPlayerList()

-- [[ SERVER BROWSER: SEARCHER ]]
local SearchFrame = Instance.new("Frame", ServerPage)
SearchFrame.Size = UDim2.new(1, -10, 0, 50)
SearchFrame.BackgroundColor3 = ColorTheme.ButtonDull
Instance.new("UICorner", SearchFrame)

local SearchInput = Instance.new("TextBox", SearchFrame)
SearchInput.Size = UDim2.new(1, -20, 0, 30)
SearchInput.Position = UDim2.new(0, 10, 0, 10)
SearchInput.PlaceholderText = "Search Player Name..."
SearchInput.Text = ""
SearchInput.BackgroundColor3 = ColorTheme.Sidebar
SearchInput.TextColor3 = ColorTheme.TextPrimary
Instance.new("UICorner", SearchInput)

local ServerList = Instance.new("ScrollingFrame", ServerPage)
ServerList.Size = UDim2.new(1, -10, 0, 300)
ServerList.Position = UDim2.new(0, 0, 0, 60)
ServerList.BackgroundTransparency = 1
Instance.new("UIListLayout", ServerList).Padding = UDim.new(0, 5)

local function UpdateSearch(text)
    for _, v in pairs(ServerList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if text == "" or p.Name:lower():find(text:lower()) then
            local b = Instance.new("TextButton", ServerList)
            b.Size = UDim2.new(1, -10, 0, 35)
            b.Text = p.DisplayName .. " (@" .. p.Name .. ")"
            b.BackgroundColor3 = ColorTheme.ButtonDull
            b.TextColor3 = ColorTheme.TextPrimary
            Instance.new("UICorner", b)
        end
    end
end
SearchInput:GetPropertyChangedSignal("Text"):Connect(function() UpdateSearch(SearchInput.Text) end)
UpdateSearch("")

-- [[ SETTINGS: EMOJI CHANGER ]]
local EmojiInput = Instance.new("TextBox", SettingsPage)
EmojiInput.Size = UDim2.new(1, -10, 0, 40)
EmojiInput.PlaceholderText = "Type Emoji for Icon (e.g. 🔥)"
EmojiInput.BackgroundColor3 = ColorTheme.ButtonDull
EmojiInput.TextColor3 = ColorTheme.TextPrimary
Instance.new("UICorner", EmojiInput)

EmojiInput.FocusLost:Connect(function()
    if EmojiInput.Text ~= "" then
        _G.NebulaX_Config.MenuIcon = EmojiInput.Text
        MinIcon.Text = EmojiInput.Text
    end
end)

-- [[ SETTINGS: RAINBOW TOGGLE ]]
local RainbowBtn = Instance.new("TextButton", SettingsPage)
RainbowBtn.Size = UDim2.new(1, -10, 0, 40)
RainbowBtn.Text = "RAINBOW UI: OFF"
RainbowBtn.BackgroundColor3 = ColorTheme.ButtonDull
RainbowBtn.TextColor3 = ColorTheme.TextPrimary
Instance.new("UICorner", RainbowBtn)

RainbowBtn.MouseButton1Click:Connect(function()
    _G.NebulaX_Config.RainbowActive = not _G.NebulaX_Config.RainbowActive
    RainbowBtn.Text = "RAINBOW UI: " .. (_G.NebulaX_Config.RainbowActive and "ON" or "OFF")
    if not _G.NebulaX_Config.RainbowActive then MainStroke.Color = ColorTheme.Accent end
end)

-- [[ WINDOW CONTROLS ]]
local CloseX = Instance.new("TextButton", MainFrame)
CloseX.Size = UDim2.new(0, 30, 0, 30)
CloseX.Position = UDim2.new(1, -40, 0, 10)
CloseX.Text = "X"
CloseX.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseX.TextColor3 = ColorTheme.TextPrimary
Instance.new("UICorner", CloseX)
CloseX.MouseButton1Click:Connect(function() MainGui:Destroy() end)

local MinD = Instance.new("TextButton", MainFrame)
MinD.Size = UDim2.new(0, 30, 0, 30)
MinD.Position = UDim2.new(1, -80, 0, 10)
MinD.Text = "-"
MinD.BackgroundColor3 = ColorTheme.ButtonDull
MinD.TextColor3 = ColorTheme.TextPrimary
Instance.new("UICorner", MinD)
MinD.MouseButton1Click:Connect(function() MainFrame.Visible = false MinIcon.Visible = true end)
MinIcon.MouseButton1Click:Connect(function() MainFrame.Visible = true MinIcon.Visible = false end)

-- [[ ENGINE LOOPS ]]
RunService.Heartbeat:Connect(function()
    local Char = LocalPlayer.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    if not Root then return end

    -- Flight Logic
    if _G.NebulaX_Config.FlightActive then
        Root.Velocity = Vector3.zero
        Root.CFrame = Root.CFrame + (Char.Humanoid.MoveDirection * (_G.NebulaX_Config.SpeedMultiplier / 10))
    end

    -- Glue / Orbit Logic
    if #_G.NebulaX_Config.CurrentTargets > 0 then
        for i, tName in ipairs(_G.NebulaX_Config.CurrentTargets) do
            local TPlayer = Players:FindFirstChild(tName)
            if TPlayer and TPlayer.Character and TPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local TRoot = TPlayer.Character.HumanoidRootPart
                TRoot.Velocity = Vector3.zero
                
                if _G.NebulaX_Config.GlueTargetMode == "Classic" then
                    TRoot.CFrame = Root.CFrame * CFrame.new(0, _G.NebulaX_Config.GlueHeightOffset, -(i * 7))
                elseif _G.NebulaX_Config.GlueTargetMode == "Orbit" then
                    local Ang = (tick() * _G.NebulaX_Config.OrbitRotationSpeed) + (i * (math.pi * 2 / #_G.NebulaX_Config.CurrentTargets))
                    TRoot.CFrame = Root.CFrame * CFrame.Angles(0, Ang, 0) * CFrame.new(0, _G.NebulaX_Config.GlueHeightOffset, _G.NebulaX_Config.OrbitDistance)
                end
            end
        end
    end
end)
