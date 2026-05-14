-- [[ NEBULAX OFFICIAL VERSION 1.2 ]]
-- [[ ARCHITECTURE: HEAVYWEIGHT TERMINAL ]]
-- [[ AUTHOR: MAX ]]

-- [[ SYSTEM SERVICES ]]
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- [[ DATA STRUCTURE ]]
_G.NebulaX_Core = {
    -- Visual Config
    RainbowMode = false,
    CurrentEmoji = "🌌",
    MenuOpen = true,
    
    -- Combat & Glue Engine
    GlueState = "None", -- Classic, Reverse, Orbit
    TargetTable = {},
    LookAtActive = false,
    AutoClickerActive = false,
    HeightOffset = 3,
    OrbitRadius = 18,
    OrbitSpeed = 4,
    
    -- Movement Engine
    FlightEnabled = false,
    FlightSpeedValue = 85,
    FlightControlStyle = "Manual",
    
    -- Server Logic
    PlayerFilter = ""
}

-- [[ COLOR PALETTE ]]
local Colors = {
    Background = Color3.fromRGB(15, 12, 28),
    Sidebar = Color3.fromRGB(8, 6, 18),
    Accent = Color3.fromRGB(160, 80, 255),
    MainText = Color3.fromRGB(255, 255, 255),
    SecondaryText = Color3.fromRGB(200, 200, 200),
    ElementBG = Color3.fromRGB(25, 20, 45),
    CloseRed = Color3.fromRGB(200, 40, 40)
}

-- [[ GUI CLEANUP ]]
if CoreGui:FindFirstChild("NebulaX_V12_Heavy") then
    CoreGui.NebulaX_V12_Heavy:Destroy()
end

-- [[ MAIN CONTAINER ]]
local NebulaX = Instance.new("ScreenGui")
NebulaX.Name = "NebulaX_V12_Heavy"
NebulaX.Parent = CoreGui
NebulaX.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- [[ MINIMIZED ICON (THE EMOJI) ]]
local MinIcon = Instance.new("TextButton")
MinIcon.Name = "NebulaIcon"
MinIcon.Parent = NebulaX
MinIcon.Size = UDim2.new(0, 60, 0, 60)
MinIcon.Position = UDim2.new(0.02, 0, 0.8, 0)
MinIcon.BackgroundColor3 = Colors.Background
MinIcon.Text = _G.NebulaX_Core.CurrentEmoji
MinIcon.TextSize = 35
MinIcon.Visible = false
MinIcon.Active = true
MinIcon.Draggable = true
local IconCorner = Instance.new("UICorner", MinIcon)
IconCorner.CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", MinIcon)
IconStroke.Color = Colors.Accent
IconStroke.Thickness = 2

-- [[ MAIN SQUARE FRAME ]]
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = NebulaX
MainFrame.Size = UDim2.new(0, 720, 0, 520)
MainFrame.Position = UDim2.new(0.5, -360, 0.5, -260)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.Active = true
MainFrame.Draggable = true
local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Colors.Accent
MainStroke.Thickness = 2

-- [[ SIDEBAR RAIL ]]
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = MainFrame
Sidebar.Size = UDim2.new(0, 200, 1, 0)
Sidebar.BackgroundColor3 = Colors.Sidebar
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local Logo = Instance.new("TextLabel")
Logo.Name = "NebulaLogo"
Logo.Parent = Sidebar
Logo.Size = UDim2.new(1, 0, 0, 70)
Logo.BackgroundTransparency = 1
Logo.Text = "NEBULA X v1.2"
Logo.TextColor3 = Colors.Accent
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 24

-- [[ DEDICATED CREDIT MENU (STAYS ON TOP) ]]
local CreditFrame = Instance.new("Frame")
CreditFrame.Name = "CreditsMenu"
CreditFrame.Parent = Sidebar
CreditFrame.Size = UDim2.new(0.9, 0, 0, 100)
CreditFrame.Position = UDim2.new(0.05, 0, 1, -110)
CreditFrame.BackgroundColor3 = Colors.ElementBG
Instance.new("UICorner", CreditFrame)

local CreditHeader = Instance.new("TextLabel", CreditFrame)
CreditHeader.Size = UDim2.new(1, 0, 0, 40)
CreditHeader.BackgroundTransparency = 1
CreditHeader.Text = "SYSTEM OWNER"
CreditHeader.TextColor3 = Colors.Accent
CreditHeader.Font = Enum.Font.GothamBold
CreditHeader.TextSize = 14

local CreditName = Instance.new("TextLabel", CreditFrame)
CreditName.Size = UDim2.new(1, 0, 0, 40)
CreditName.Position = UDim2.new(0, 0, 0, 40)
CreditName.BackgroundTransparency = 1
CreditName.Text = "MAX"
CreditName.TextColor3 = Colors.MainText
CreditName.Font = Enum.Font.GothamBold
CreditName.TextSize = 26

-- [[ NAVIGATION SYSTEM ]]
local Pages = Instance.new("Frame", MainFrame)
Pages.Size = UDim2.new(1, -220, 1, -100)
Pages.Position = UDim2.new(0, 210, 0, 70)
Pages.BackgroundTransparency = 1

local CombatP = Instance.new("ScrollingFrame", Pages)
CombatP.Size = UDim2.new(1, 0, 1, 0)
CombatP.Visible = true
CombatP.BackgroundTransparency = 1
Instance.new("UIListLayout", CombatP).Padding = UDim.new(0, 10)

local MovementP = Instance.new("ScrollingFrame", Pages)
MovementP.Size = UDim2.new(1, 0, 1, 0)
MovementP.Visible = false
MovementP.BackgroundTransparency = 1
Instance.new("UIListLayout", MovementP).Padding = UDim.new(0, 10)

local ServerP = Instance.new("ScrollingFrame", Pages)
ServerP.Size = UDim2.new(1, 0, 1, 0)
ServerP.Visible = false
ServerP.BackgroundTransparency = 1
Instance.new("UIListLayout", ServerP).Padding = UDim.new(0, 10)

local SettingsP = Instance.new("ScrollingFrame", Pages)
SettingsP.Size = UDim2.new(1, 0, 1, 0)
SettingsP.Visible = false
SettingsP.BackgroundTransparency = 1
Instance.new("UIListLayout", SettingsP).Padding = UDim.new(0, 10)

-- [[ COMBAT: TARGET SELECT SYSTEM ]]
local TFrame = Instance.new("Frame", CombatP)
TFrame.Size = UDim2.new(1, -10, 0, 180)
TFrame.BackgroundColor3 = Colors.Sidebar
Instance.new("UICorner", TFrame)

local TTitle = Instance.new("TextLabel", TFrame)
TTitle.Size = UDim2.new(1, 0, 0, 30)
TTitle.Text = "TARGET SELECTOR"
TTitle.TextColor3 = Colors.Accent
TTitle.BackgroundTransparency = 1
TTitle.Font = Enum.Font.GothamBold

local TScroll = Instance.new("ScrollingFrame", TFrame)
TScroll.Size = UDim2.new(1, -10, 1, -40)
TScroll.Position = UDim2.new(0, 5, 0, 35)
TScroll.BackgroundTransparency = 1
local TLayout = Instance.new("UIListLayout", TScroll)
TLayout.Padding = UDim.new(0, 5)

local function UpdateTargets()
    for _, item in pairs(TScroll:GetChildren()) do if item:IsA("TextButton") then item:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local b = Instance.new("TextButton", TScroll)
            b.Size = UDim2.new(1, -10, 0, 30)
            b.Text = p.Name
            b.BackgroundColor3 = table.find(_G.NebulaX_Core.TargetTable, p.Name) and Colors.Accent or Colors.ElementBG
            b.TextColor3 = Colors.MainText
            Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(function()
                local idx = table.find(_G.NebulaX_Core.TargetTable, p.Name)
                if idx then table.remove(_G.NebulaX_Core.TargetTable, idx) else table.insert(_G.NebulaX_Core.TargetTable, p.Name) end
                UpdateTargets()
            end)
        end
    end
end
UpdateTargets()

local GlueModeBtn = Instance.new("TextButton", CombatP)
GlueModeBtn.Size = UDim2.new(1, -10, 0, 40)
GlueModeBtn.Text = "Glue Mode: None"
GlueModeBtn.BackgroundColor3 = Colors.ElementBG
GlueModeBtn.TextColor3 = Colors.MainText
Instance.new("UICorner", GlueModeBtn)

GlueModeBtn.MouseButton1Click:Connect(function()
    local list = {"None", "Classic", "Reverse", "Orbit"}
    local cur = table.find(list, _G.NebulaX_Core.GlueState) or 1
    _G.NebulaX_Core.GlueState = list[cur % #list + 1]
    GlueModeBtn.Text = "Glue Mode: " .. _G.NebulaX_Core.GlueState
end)

-- [[ SERVER BROWSER: SEARCHER ]]
local SearchArea = Instance.new("Frame", ServerP)
SearchArea.Size = UDim2.new(1, -10, 0, 60)
SearchArea.BackgroundColor3 = Colors.ElementBG
Instance.new("UICorner", SearchArea)

local SearchInput = Instance.new("TextBox", SearchArea)
SearchInput.Size = UDim2.new(1, -20, 0, 35)
SearchInput.Position = UDim2.new(0, 10, 0, 12)
SearchInput.PlaceholderText = "Search Player Name..."
SearchInput.Text = ""
SearchInput.BackgroundColor3 = Colors.Sidebar
SearchInput.TextColor3 = Colors.MainText
Instance.new("UICorner", SearchInput)

local ServerList = Instance.new("ScrollingFrame", ServerP)
ServerList.Size = UDim2.new(1, -10, 0, 250)
ServerList.BackgroundTransparency = 1
Instance.new("UIListLayout", ServerList).Padding = UDim.new(0, 5)

local function FilterServer(txt)
    for _, v in pairs(ServerList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if txt == "" or p.Name:lower():find(txt:lower()) then
            local b = Instance.new("TextButton", ServerList)
            b.Size = UDim2.new(1, -10, 0, 35)
            b.Text = p.DisplayName .. " (@" .. p.Name .. ")"
            b.BackgroundColor3 = Colors.ElementBG
            b.TextColor3 = Colors.MainText
            Instance.new("UICorner", b)
        end
    end
end
SearchInput:GetPropertyChangedSignal("Text"):Connect(function() FilterServer(SearchInput.Text) end)
FilterServer("")

-- [[ SETTINGS: RAINBOW & EMOJI ]]
local RainbowBtn = Instance.new("TextButton", SettingsP)
RainbowBtn.Size = UDim2.new(1, -10, 0, 45)
RainbowBtn.Text = "Rainbow UI: OFF"
RainbowBtn.BackgroundColor3 = Colors.ElementBG
RainbowBtn.TextColor3 = Colors.MainText
Instance.new("UICorner", RainbowBtn)

RainbowBtn.MouseButton1Click:Connect(function()
    _G.NebulaX_Core.RainbowMode = not _G.NebulaX_Core.RainbowMode
    RainbowBtn.Text = "Rainbow UI: " .. (_G.NebulaX_Core.RainbowMode and "ON" or "OFF")
end)

local EmojiInput = Instance.new("TextBox", SettingsP)
EmojiInput.Size = UDim2.new(1, -10, 0, 45)
EmojiInput.PlaceholderText = "Set Icon Emoji (e.g. 💀)"
EmojiInput.BackgroundColor3 = Colors.ElementBG
EmojiInput.TextColor3 = Colors.MainText
Instance.new("UICorner", EmojiInput)

EmojiInput.FocusLost:Connect(function()
    if EmojiInput.Text ~= "" then
        _G.NebulaX_Core.CurrentEmoji = EmojiInput.Text
        MinIcon.Text = EmojiInput.Text
    end
end)

-- [[ WINDOW CONTROLS ]]
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -45, 0, 10)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Colors.CloseRed
CloseBtn.TextColor3 = Colors.MainText
Instance.new("UICorner", CloseBtn)
CloseBtn.MouseButton1Click:Connect(function() NebulaX:Destroy() end)

local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Size = UDim2.new(0, 35, 0, 35)
MinBtn.Position = UDim2.new(1, -90, 0, 10)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Colors.ElementBG
MinBtn.TextColor3 = Colors.MainText
Instance.new("UICorner", MinBtn)
MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false MinIcon.Visible = true end)
MinIcon.MouseButton1Click:Connect(function() MainFrame.Visible = true MinIcon.Visible = false end)

-- [[ MASTER ENGINE LOOPS ]]
RunService.Heartbeat:Connect(function()
    local Char = LocalPlayer.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    if not Root then return end

    -- Rainbow System
    if _G.NebulaX_Core.RainbowMode then
        local hue = tick() % 5 / 5
        local clr = Color3.fromHSV(hue, 0.8, 1)
        MainStroke.Color = clr
        IconStroke.Color = clr
        Logo.TextColor3 = clr
        CreditName.TextColor3 = clr
    end

    -- Combat: Glue Engine
    if _G.NebulaX_Core.GlueState ~= "None" then
        local foundTargets = {}
        for _, n in pairs(_G.NebulaX_Core.TargetTable) do
            local tp = Players:FindFirstChild(n)
            if tp and tp.Character and tp.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(foundTargets, tp.Character.HumanoidRootPart)
            end
        end

        for i, targetRoot in ipairs(foundTargets) do
            targetRoot.Velocity = Vector3.zero
            if _G.NebulaX_Core.GlueState == "Classic" then
                targetRoot.CFrame = Root.CFrame * CFrame.new(0, _G.NebulaX_Core.HeightOffset, -(i * 7))
            elseif _G.NebulaX_Core.GlueState == "Reverse" then
                Root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 5)
            elseif _G.NebulaX_Core.GlueState == "Orbit" then
                local ang = (tick() * _G.NebulaX_Core.OrbitSpeed) + (i * (math.pi * 2 / #foundTargets))
                targetRoot.CFrame = Root.CFrame * CFrame.Angles(0, ang, 0) * CFrame.new(0, _G.NebulaX_Core.HeightOffset, _G.NebulaX_Core.OrbitRadius)
            end
        end
    end
end)
