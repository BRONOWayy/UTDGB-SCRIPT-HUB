-- [[ NEBULAX V1.1 OFFICIAL ]]
-- [[ STATUS: EXPANDED AUTHORITY BUILD ]]
-- [[ PRIMARY DEVELOPER: MAX ]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- [[ GLOBAL CONFIGURATION DATA ]]
_G.NebulaX_Settings = {
    -- UI SYSTEM
    RainbowMode = false,
    RainbowSpeed = 4,
    CurrentEmoji = "🌌",
    UI_Visible = true,
    
    -- COMBAT ENGINE
    GlueEnabled = false,
    GlueType = "None", -- Classic, Reverse, Orbit
    TargetList = {},
    LookAtLock = false,
    AutoClicker = false,
    GlueHeight = 3,
    OrbitDist = 18,
    
    -- MOVEMENT ENGINE
    FlightOn = false,
    FlightSpeed = 80,
    FlightControl = "Manual",
    
    -- SERVER SYSTEM
    SearchQuery = ""
}

-- [[ COLOR SCHEME ]]
local Theme = {
    MainBG = Color3.fromRGB(14, 11, 26),
    SideBG = Color3.fromRGB(8, 6, 18),
    Accent = Color3.fromRGB(165, 85, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Element = Color3.fromRGB(26, 21, 48),
    Danger = Color3.fromRGB(220, 50, 50)
}

-- [[ UI CLEANUP ]]
if CoreGui:FindFirstChild("NebulaX_Heavy_V1") then
    CoreGui.NebulaX_Heavy_V1:Destroy()
end

-- [[ SCREEN GUI INITIALIZATION ]]
local NebulaX = Instance.new("ScreenGui")
NebulaX.Name = "NebulaX_Heavy_V1"
NebulaX.Parent = CoreGui
NebulaX.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- [[ GALAXY MINIMIZE BUTTON ]]
local GalaxyBtn = Instance.new("TextButton")
GalaxyBtn.Name = "NebulaIcon"
GalaxyBtn.Parent = NebulaX
GalaxyBtn.Size = UDim2.new(0, 58, 0, 58)
GalaxyBtn.Position = UDim2.new(0.02, 0, 0.75, 0)
GalaxyBtn.BackgroundColor3 = Theme.MainBG
GalaxyBtn.Text = _G.NebulaX_Settings.CurrentEmoji
GalaxyBtn.TextSize = 32
GalaxyBtn.Visible = false
GalaxyBtn.Active = true
GalaxyBtn.Draggable = true
local IconCorner = Instance.new("UICorner", GalaxyBtn)
IconCorner.CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", GalaxyBtn)
IconStroke.Color = Theme.Accent
IconStroke.Thickness = 2

-- [[ MAIN SQUARE FRAME (Slightly Rounded) ]]
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainHub"
MainFrame.Parent = NebulaX
MainFrame.Size = UDim2.new(0, 720, 0, 520)
MainFrame.Position = UDim2.new(0.5, -360, 0.5, -260)
MainFrame.BackgroundColor3 = Theme.MainBG
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Theme.Accent
MainStroke.Thickness = 2

-- [[ SIDEBAR ]]
local Sidebar = Instance.new("Frame")
Sidebar.Name = "NavRail"
Sidebar.Parent = MainFrame
Sidebar.Size = UDim2.new(0, 190, 1, 0)
Sidebar.BackgroundColor3 = Theme.SideBG
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = Sidebar
TitleLabel.Size = UDim2.new(1, 0, 0, 65)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "NEBULA X v1.1"
TitleLabel.TextColor3 = Theme.Accent
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 22

-- [[ THE CREDITS MENU (WHO MADE IT) ]]
local CreditsBox = Instance.new("Frame")
CreditsBox.Name = "CreditsSection"
CreditsBox.Parent = Sidebar
CreditsBox.Size = UDim2.new(0.9, 0, 0, 80)
CreditsBox.Position = UDim2.new(0.05, 0, 1, -90)
CreditsBox.BackgroundColor3 = Theme.Element
Instance.new("UICorner", CreditsBox)

local CreditsText = Instance.new("TextLabel")
CreditsText.Parent = CreditsBox
CreditsText.Size = UDim2.new(1, 0, 1, 0)
CreditsText.BackgroundTransparency = 1
CreditsText.Text = "CREATED BY\nMAX"
CreditsText.TextColor3 = Theme.Accent
CreditsText.Font = Enum.Font.GothamBold
CreditsText.TextSize = 16

-- [[ PAGE SYSTEM CONTAINER ]]
local PageHolder = Instance.new("Frame")
PageHolder.Name = "PageContainer"
PageHolder.Parent = MainFrame
PageHolder.Size = UDim2.new(1, -210, 1, -110)
PageHolder.Position = UDim2.new(0, 200, 0, 70)
PageHolder.BackgroundTransparency = 1

-- [[ NAVIGATION BUTTONS (MANUAL DEPLOYMENT) ]]
local CombatBtn = Instance.new("TextButton", Sidebar)
CombatBtn.Size = UDim2.new(0.9, 0, 0, 42)
CombatBtn.Position = UDim2.new(0.05, 0, 0, 80)
CombatBtn.Text = "COMBAT"
CombatBtn.BackgroundColor3 = Theme.Accent
CombatBtn.TextColor3 = Theme.Text
Instance.new("UICorner", CombatBtn)

local MoveBtn = Instance.new("TextButton", Sidebar)
MoveBtn.Size = UDim2.new(0.9, 0, 0, 42)
MoveBtn.Position = UDim2.new(0.05, 0, 0, 125)
MoveBtn.Text = "MOVEMENT"
MoveBtn.BackgroundColor3 = Theme.Element
MoveBtn.TextColor3 = Theme.Text
Instance.new("UICorner", MoveBtn)

local ServerBtn = Instance.new("TextButton", Sidebar)
ServerBtn.Size = UDim2.new(0.9, 0, 0, 42)
ServerBtn.Position = UDim2.new(0.05, 0, 0, 170)
ServerBtn.Text = "SERVER BROWSER"
ServerBtn.BackgroundColor3 = Theme.Element
ServerBtn.TextColor3 = Theme.Text
Instance.new("UICorner", ServerBtn)

local SettingsBtn = Instance.new("TextButton", Sidebar)
SettingsBtn.Size = UDim2.new(0.9, 0, 0, 42)
SettingsBtn.Position = UDim2.new(0.05, 0, 0, 215)
SettingsBtn.Text = "SETTINGS"
SettingsBtn.BackgroundColor3 = Theme.Element
SettingsBtn.TextColor3 = Theme.Text
Instance.new("UICorner", SettingsBtn)

-- [[ INDIVIDUAL PAGES ]]
local CombatPage = Instance.new("ScrollingFrame", PageHolder)
CombatPage.Size = UDim2.new(1, 0, 1, 0)
CombatPage.BackgroundTransparency = 1
CombatPage.Visible = true
Instance.new("UIListLayout", CombatPage).Padding = UDim.new(0, 10)

local MovePage = Instance.new("ScrollingFrame", PageHolder)
MovePage.Size = UDim2.new(1, 0, 1, 0)
MovePage.BackgroundTransparency = 1
MovePage.Visible = false
Instance.new("UIListLayout", MovePage).Padding = UDim.new(0, 10)

local ServerPage = Instance.new("ScrollingFrame", PageHolder)
ServerPage.Size = UDim2.new(1, 0, 1, 0)
ServerPage.BackgroundTransparency = 1
ServerPage.Visible = false
Instance.new("UIListLayout", ServerPage).Padding = UDim.new(0, 10)

local SettingsPage = Instance.new("ScrollingFrame", PageHolder)
SettingsPage.Size = UDim2.new(1, 0, 1, 0)
SettingsPage.BackgroundTransparency = 1
SettingsPage.Visible = false
Instance.new("UIListLayout", SettingsPage).Padding = UDim.new(0, 10)

-- [[ NAVIGATION LOGIC ]]
local function SwitchPage(name)
    CombatPage.Visible = (name == "Combat")
    MovePage.Visible = (name == "Move")
    ServerPage.Visible = (name == "Server")
    SettingsPage.Visible = (name == "Settings")
    
    CombatBtn.BackgroundColor3 = (name == "Combat" and Theme.Accent or Theme.Element)
    MoveBtn.BackgroundColor3 = (name == "Move" and Theme.Accent or Theme.Element)
    ServerBtn.BackgroundColor3 = (name == "Server" and Theme.Accent or Theme.Element)
    SettingsBtn.BackgroundColor3 = (name == "Settings" and Theme.Accent or Theme.Element)
end

CombatBtn.MouseButton1Click:Connect(function() SwitchPage("Combat") end)
MoveBtn.MouseButton1Click:Connect(function() SwitchPage("Move") end)
ServerBtn.MouseButton1Click:Connect(function() SwitchPage("Server") end)
SettingsBtn.MouseButton1Click:Connect(function() SwitchPage("Settings") end)

-- [[ COMBAT: TARGET SCROLL WHEEL ]]
local TargetFrame = Instance.new("Frame", CombatPage)
TargetFrame.Size = UDim2.new(1, -10, 0, 160)
TargetFrame.BackgroundColor3 = Theme.SideBG
Instance.new("UICorner", TargetFrame)

local TargetTitle = Instance.new("TextLabel", TargetFrame)
TargetTitle.Size = UDim2.new(1, 0, 0, 30)
TargetTitle.Text = "SELECT GLUE TARGETS"
TargetTitle.TextColor3 = Theme.Accent
TargetTitle.BackgroundTransparency = 1
TargetTitle.Font = Enum.Font.GothamBold

local PlayerScroll = Instance.new("ScrollingFrame", TargetFrame)
PlayerScroll.Size = UDim2.new(1, -10, 1, -40)
PlayerScroll.Position = UDim2.new(0, 5, 0, 35)
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.ScrollBarThickness = 4
local ListLayout = Instance.new("UIListLayout", PlayerScroll)
ListLayout.Padding = UDim.new(0, 4)

local function UpdateTargets()
    for _, obj in pairs(PlayerScroll:GetChildren()) do if obj:IsA("TextButton") then obj:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local pBtn = Instance.new("TextButton", PlayerScroll)
            pBtn.Size = UDim2.new(1, -10, 0, 28)
            pBtn.Text = p.DisplayName .. " (@" .. p.Name .. ")"
            pBtn.BackgroundColor3 = table.find(_G.NebulaX_Settings.TargetList, p.Name) and Theme.Accent or Theme.Element
            pBtn.TextColor3 = Theme.Text
            Instance.new("UICorner", pBtn)
            
            pBtn.MouseButton1Click:Connect(function()
                local found = table.find(_G.NebulaX_Settings.TargetList, p.Name)
                if found then
                    table.remove(_G.NebulaX_Settings.TargetList, found)
                else
                    table.insert(_G.NebulaX_Settings.TargetList, p.Name)
                end
                UpdateTargets()
            end)
        end
    end
end
UpdateTargets()
Players.PlayerAdded:Connect(UpdateTargets)
Players.PlayerRemoving:Connect(UpdateTargets)

-- [[ COMBAT: GLUE MODES ]]
local GlueToggle = Instance.new("TextButton", CombatPage)
GlueToggle.Size = UDim2.new(1, -10, 0, 40)
GlueToggle.Text = "Glue Mode: None"
GlueToggle.BackgroundColor3 = Theme.Element
GlueToggle.TextColor3 = Theme.Text
Instance.new("UICorner", GlueToggle)

GlueToggle.MouseButton1Click:Connect(function()
    local modes = {"None", "Classic", "Reverse", "Orbit"}
    local current = table.find(modes, _G.NebulaX_Settings.GlueType) or 1
    _G.NebulaX_Settings.GlueType = modes[current % #modes + 1]
    GlueToggle.Text = "Glue Mode: " .. _G.NebulaX_Settings.GlueType
end)

-- [[ SERVER BROWSER: SEARCH SYSTEM ]]
local SearchFrame = Instance.new("Frame", ServerPage)
SearchFrame.Size = UDim2.new(1, -10, 0, 50)
SearchFrame.BackgroundColor3 = Theme.Element
Instance.new("UICorner", SearchFrame)

local SearchInput = Instance.new("TextBox", SearchFrame)
SearchInput.Size = UDim2.new(1, -20, 0, 30)
SearchInput.Position = UDim2.new(0, 10, 0, 10)
SearchInput.PlaceholderText = "Search Players in Server..."
SearchInput.Text = ""
SearchInput.BackgroundColor3 = Theme.SideBG
SearchInput.TextColor3 = Theme.Text
Instance.new("UICorner", SearchInput)

local ServerList = Instance.new("ScrollingFrame", ServerPage)
ServerList.Size = UDim2.new(1, -10, 0, 250)
ServerList.BackgroundTransparency = 1
Instance.new("UIListLayout", ServerList).Padding = UDim.new(0, 5)

local function FilterServer(text)
    for _, v in pairs(ServerList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if text == "" or p.Name:lower():find(text:lower()) or p.DisplayName:lower():find(text:lower()) then
            local b = Instance.new("TextButton", ServerList)
            b.Size = UDim2.new(1, -10, 0, 30)
            b.Text = p.DisplayName .. " (@" .. p.Name .. ")"
            b.BackgroundColor3 = Theme.Element
            b.TextColor3 = Theme.Text
            Instance.new("UICorner", b)
        end
    end
end
SearchInput:GetPropertyChangedSignal("Text"):Connect(function() FilterServer(SearchInput.Text) end)
FilterServer("")

-- [[ SETTINGS: RAINBOW & EMOJI ]]
local RainbowBtn = Instance.new("TextButton", SettingsPage)
RainbowBtn.Size = UDim2.new(1, -10, 0, 40)
RainbowBtn.Text = "Rainbow UI: OFF"
RainbowBtn.BackgroundColor3 = Theme.Element
RainbowBtn.TextColor3 = Theme.Text
Instance.new("UICorner", RainbowBtn)

RainbowBtn.MouseButton1Click:Connect(function()
    _G.NebulaX_Settings.RainbowMode = not _G.NebulaX_Settings.RainbowMode
    RainbowBtn.Text = "Rainbow UI: " .. (_G.NebulaX_Settings.RainbowMode and "ON" or "OFF")
end)

local EmojiBox = Instance.new("TextBox", SettingsPage)
EmojiBox.Size = UDim2.new(1, -10, 0, 40)
EmojiBox.PlaceholderText = "Icon Emoji (e.g. 💀)"
EmojiBox.Text = ""
EmojiBox.BackgroundColor3 = Theme.Element
EmojiBox.TextColor3 = Theme.Text
Instance.new("UICorner", EmojiBox)

EmojiBox.FocusLost:Connect(function()
    if EmojiBox.Text ~= "" then
        _G.NebulaX_Settings.CurrentEmoji = EmojiBox.Text
        GalaxyBtn.Text = EmojiBox.Text
    end
end)

-- [[ WINDOW CONTROLS (X and -) ]]
local CloseX = Instance.new("TextButton", MainFrame)
CloseX.Size = UDim2.new(0, 32, 0, 32)
CloseX.Position = UDim2.new(1, -42, 0, 10)
CloseX.Text = "X"
CloseX.BackgroundColor3 = Theme.Element
CloseX.TextColor3 = Theme.Danger
Instance.new("UICorner", CloseX)
local XStroke = Instance.new("UIStroke", CloseX)
XStroke.Color = Theme.Accent

CloseX.MouseButton1Click:Connect(function() NebulaX:Destroy() end)

local MinDash = Instance.new("TextButton", MainFrame)
MinDash.Size = UDim2.new(0, 32, 0, 32)
MinDash.Position = UDim2.new(1, -82, 0, 10)
MinDash.Text = "-"
MinDash.BackgroundColor3 = Theme.Element
MinDash.TextColor3 = Theme.Text
Instance.new("UICorner", MinDash)
local MStroke = Instance.new("UIStroke", MinDash)
MStroke.Color = Theme.Accent

MinDash.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    GalaxyBtn.Visible = true
end)

GalaxyBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    GalaxyBtn.Visible = false
end)

-- [[ MASTER ENGINE LOOPS ]]
RunService.Heartbeat:Connect(function()
    local Char = LocalPlayer.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    if not Root then return end

    -- RAINBOW ENGINE
    if _G.NebulaX_Settings.RainbowMode then
        local hue = tick() % _G.NebulaX_Settings.RainbowSpeed / _G.NebulaX_Settings.RainbowSpeed
        local col = Color3.fromHSV(hue, 0.8, 1)
        MainStroke.Color = col
        IconStroke.Color = col
        TitleLabel.TextColor3 = col
        CreditsText.TextColor3 = col
    end

    -- GLUE / ORBIT ENGINE
    if _G.NebulaX_Settings.GlueType ~= "None" then
        local targets = {}
        for _, name in pairs(_G.NebulaX_Settings.TargetList) do
            local p = Players:FindFirstChild(name)
            if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(targets, p.Character.HumanoidRootPart)
            end
        end

        for i, targetRoot in ipairs(targets) do
            targetRoot.Velocity = Vector3.zero
            
            if _G.NebulaX_Settings.GlueType == "Classic" then
                targetRoot.CFrame = Root.CFrame * CFrame.new(0, _G.NebulaX_Settings.GlueHeight, -(i * 7))
            elseif _G.NebulaX_Settings.GlueType == "Reverse" then
                Root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 6)
            elseif _G.NebulaX_Settings.GlueType == "Orbit" then
                local angle = (tick() * 4) + (i * (math.pi * 2 / #targets))
                targetRoot.CFrame = Root.CFrame * CFrame.Angles(0, angle, 0) * CFrame.new(0, _G.NebulaX_Settings.GlueHeight, _G.NebulaX_Settings.OrbitDist)
            end
        end
    end
end)
