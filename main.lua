local P, UIS, R = game:GetService("Players"), game:GetService("UserInputService"), game:GetService("RunService")
local lp = P.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local VU = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

-- [[ CLEANUP ]]
if CoreGui:FindFirstChild("NebulaX_Final") then CoreGui.NebulaX_Final:Destroy() end

local NebulaX = Instance.new("ScreenGui", CoreGui)
NebulaX.Name = "NebulaX_Final"

-- [[ DATA CONFIG & SAVE SYSTEM ]]
_G.NebData = {
    GlueMode = "None",
    GlueHeight = 2,
    OrbitRadius = 15,
    OrbitSpeed = 3,
    Flight = false,
    FlightMode = "Manual", -- Manual or Automatic
    FlightSpeed = 50,
    Noclip = false,
    M1Spam = false,
    SelectedTargets = {},
    Version = "v5.0"
}

local function SaveConfig()
    if writefile then
        writefile("NebulaX_Config.json", HttpService:JSONEncode(_G.NebData))
    end
end

local function LoadConfig()
    if isfile and isfile("NebulaX_Config.json") then
        local data = HttpService:JSONDecode(readfile("NebulaX_Config.json"))
        for k, v in pairs(data) do _G.NebData[k] = v end
    end
end
LoadConfig()

local theme = {
    bg = Color3.fromRGB(10, 6, 18),
    side = Color3.fromRGB(5, 3, 10),
    accent = Color3.fromRGB(160, 80, 255),
    txt = Color3.fromRGB(255, 255, 255),
    dark = Color3.fromRGB(22, 15, 35)
}

-- [[ MAIN HUB ]]
local Main = Instance.new("Frame", NebulaX)
Main.Size = UDim2.new(0, 620, 0, 440)
Main.Position = UDim2.new(0.5, -310, 0.5, -220)
Main.BackgroundColor3 = theme.bg
Main.Active, Main.Draggable = true, true
Instance.new("UICorner", Main)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color, MainStroke.Thickness = theme.accent, 2

-- [[ GALAXY ICON (Small & Fitted) ]]
local GalaxyBtn = Instance.new("TextButton", NebulaX)
GalaxyBtn.Size = UDim2.new(0, 38, 0, 38) -- Resized smaller as requested
GalaxyBtn.Position = UDim2.new(0.02, 0, 0.88, 0)
GalaxyBtn.BackgroundColor3 = theme.bg
GalaxyBtn.Text, GalaxyBtn.TextSize = "🌌", 20
GalaxyBtn.Visible = false
GalaxyBtn.Active, GalaxyBtn.Draggable = true, true
Instance.new("UICorner", GalaxyBtn).CornerRadius = UDim.new(1, 0)
local GalStroke = Instance.new("UIStroke", GalaxyBtn)
GalStroke.Color, GalStroke.Thickness = theme.accent, 2
GalaxyBtn.MouseButton1Click:Connect(function() Main.Visible, GalaxyBtn.Visible = true, false end)

-- [[ WINDOW CONTROLS ]]
local function CreateControl(txt, pos, color, cb)
    local b = Instance.new("TextButton", Main)
    b.Size, b.Position = UDim2.new(0, 28, 0, 28), pos
    b.Text, b.TextColor3 = txt, color
    b.BackgroundColor3 = theme.dark
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", b).Color = theme.accent
    b.MouseButton1Click:Connect(cb)
end
CreateControl("-", UDim2.new(1, -70, 0, 10), theme.txt, function() Main.Visible, GalaxyBtn.Visible = false, true end)
CreateControl("X", UDim2.new(1, -35, 0, 10), Color3.new(1,0,0), function() NebulaX:Destroy() end)

-- [[ SIDEBAR ]]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size, Sidebar.BackgroundColor3 = UDim2.new(0, 170, 1, 0), theme.side
Instance.new("UICorner", Sidebar)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "NEBULA X\nBy MAX" -- Created by Max branding
Title.TextColor3, Title.Font = theme.accent, Enum.Font.GothamBold
Title.TextSize, Title.BackgroundTransparency = 16, 1

local Container = Instance.new("Frame", Main)
Container.Size, Container.Position = UDim2.new(1, -190, 1, -60), UDim2.new(0, 180, 0, 50)
Container.BackgroundTransparency = 1

local Pages = {}
local function CreateTab(name, order)
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size, Page.Visible = UDim2.new(1, 0, 1, 0), (order == 1)
    Page.BackgroundTransparency, Page.ScrollBarThickness = 1, 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)
    Pages[name] = Page
    local b = Instance.new("TextButton", Sidebar)
    b.Size, b.Position = UDim2.new(0.9, 0, 0, 35), UDim2.new(0.05, 0, 0, 60 + (order-1)*40)
    b.Text, b.TextColor3, b.BackgroundColor3 = name, theme.txt, (order == 1 and theme.accent or theme.dark)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = theme.dark end end
        Page.Visible, b.BackgroundColor3 = true, theme.accent
    end)
    return Page
end

local combat = CreateTab("Combat", 1)
local movement = CreateTab("Movement", 2)
local settings = CreateTab("Settings", 3)
local logs = CreateTab("Update Logs", 4)

-- [[ COMBAT: GLUE SCROLL WHEEL ]]
local TargetFrame = Instance.new("Frame", combat)
TargetFrame.Size = UDim2.new(1, -10, 0, 120)
TargetFrame.BackgroundColor3 = theme.dark
Instance.new("UICorner", TargetFrame)

local TargetScroll = Instance.new("ScrollingFrame", TargetFrame)
TargetScroll.Size, TargetScroll.Position = UDim2.new(1, -10, 1, -30), UDim2.new(0, 5, 0, 25)
TargetScroll.BackgroundTransparency, TargetScroll.ScrollBarThickness = 1, 3
Instance.new("UIListLayout", TargetScroll).Padding = UDim.new(0, 4)

local function RefreshTargets()
    for _, v in pairs(TargetScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(P:GetPlayers()) do
        if p ~= lp then
            local b = Instance.new("TextButton", TargetScroll)
            b.Size, b.Text = UDim2.new(1, -10, 0, 25), p.Name
            b.BackgroundColor3 = table.find(_G.NebData.SelectedTargets, p.Name) and theme.accent or theme.side
            b.TextColor3 = theme.txt
            Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(function()
                local idx = table.find(_G.NebData.SelectedTargets, p.Name)
                if idx then table.remove(_G.NebData.SelectedTargets, idx) else table.insert(_G.NebData.SelectedTargets, p.Name) end
                RefreshTargets()
            end)
        end
    end
end
RefreshTargets()

-- [[ SETTINGS: FPS & SAVING ]]
local function NewBtn(txt, p, cb)
    local b = Instance.new("TextButton", p)
    b.Size, b.Text = UDim2.new(1, -10, 0, 35), txt
    b.BackgroundColor3, b.TextColor3 = theme.dark, theme.txt
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() cb(b) end)
end

NewBtn("Save Changes", settings, function() SaveConfig() end)
NewBtn("Boost FPS (Low Graphics)", settings, function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then v.Material = Enum.Material.SmoothPlastic end
        if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
    end
    settings.Brightness, settings.GlobalShadows = 1, false
end)

-- [[ MOVEMENT: DUAL FLIGHT ]]
NewBtn("Flight: OFF", movement, function(b)
    _G.NebData.Flight = not _G.NebData.Flight
    b.Text = "Flight: " .. (_G.NebData.Flight and "ON" or "OFF")
end)
NewBtn("Flight Mode: Manual", movement, function(b)
    _G.NebData.FlightMode = (_G.NebData.FlightMode == "Manual" and "Automatic" or "Manual")
    b.Text = "Flight Mode: " .. _G.NebData.FlightMode
end)

-- [[ LOGS ]]
local LT = Instance.new("TextLabel", logs)
LT.Size, LT.BackgroundTransparency = UDim2.new(1,0,1,0), 1
LT.TextColor3, LT.Text = theme.txt, "v5.0 - THE MAX UPDATE\n- Fixed Target Selector Scroll Wheel\n- Added FPS Booster\n- Added Save Config System\n- 2-Mode Flight: Manual (WASD) vs Auto (Camera)\n- Galaxy Icon resized smaller\n- Major Glue Logic Overhaul"
LT.TextWrapped, LT.TextYAlignment = true, 0

-- [[ ENGINE ]]
R.Heartbeat:Connect(function()
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Dual Flight
    if _G.NebData.Flight then
        hrp.Velocity = Vector3.zero
        if _G.NebData.FlightMode == "Manual" then
            hrp.CFrame = hrp.CFrame + (char.Humanoid.MoveDirection * (_G.NebData.FlightSpeed / 10))
        else
            local cam = workspace.CurrentCamera.CFrame
            if UIS:IsKeyDown(Enum.KeyCode.W) then hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -_G.NebData.FlightSpeed / 10) end
            if UIS:IsKeyDown(Enum.KeyCode.S) then hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, _G.NebData.FlightSpeed / 10) end
        end
    end

    -- Fix: Glue Logic
    if _G.NebData.GlueMode ~= "None" then
        for i, name in pairs(_G.NebData.SelectedTargets) do
            local tp = P:FindFirstChild(name)
            if tp and tp.Character and tp.Character:FindFirstChild("HumanoidRootPart") then
                local th = tp.Character.HumanoidRootPart
                th.Velocity = Vector3.zero
                if _G.NebData.GlueMode == "Classic" then
                    th.CFrame = hrp.CFrame * CFrame.new(0, _G.NebData.GlueHeight, -(i * 5))
                elseif _G.NebData.GlueMode == "Orbit" then
                    local angle = (tick() * _G.NebData.OrbitSpeed) + (i * (math.pi * 2 / #_G.NebData.SelectedTargets))
                    th.CFrame = hrp.CFrame * CFrame.Angles(0, angle, 0) * CFrame.new(0, _G.NebData.GlueHeight, _G.NebData.OrbitRadius)
                end
            end
        end
    end
end)
