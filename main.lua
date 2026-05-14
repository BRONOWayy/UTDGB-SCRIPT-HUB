local P, UIS, R = game:GetService("Players"), game:GetService("UserInputService"), game:GetService("RunService")
local lp = P.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local VU = game:GetService("VirtualUser")

-- [[ CLEANUP ]]
if CoreGui:FindFirstChild("NebulaX_Final") then CoreGui.NebulaX_Final:Destroy() end

local NebulaX = Instance.new("ScreenGui", CoreGui)
NebulaX.Name = "NebulaX_Final"

-- [[ DATA CONFIG ]]
_G.NebData = {
    GlueMode = "None",
    GlueHeight = 2,
    OrbitRadius = 15,
    OrbitSpeed = 3,
    Flight = false,
    FlightSpeed = 50,
    Noclip = false,
    M1Spam = false,
    SelectedTargets = {}, -- Stores names of specifically chosen players
    Version = "v4.3"
}

local theme = {
    bg = Color3.fromRGB(12, 8, 20),
    side = Color3.fromRGB(6, 4, 12),
    accent = Color3.fromRGB(160, 80, 255),
    txt = Color3.fromRGB(255, 255, 255),
    dark = Color3.fromRGB(25, 18, 40)
}

-- [[ MAIN HUB ]]
local Main = Instance.new("Frame", NebulaX)
Main.Size = UDim2.new(0, 600, 0, 420)
Main.Position = UDim2.new(0.5, -300, 0.5, -210)
Main.BackgroundColor3 = theme.bg
Main.Active, Main.Draggable = true, true
Instance.new("UICorner", Main)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color, MainStroke.Thickness = theme.accent, 2

-- [[ GALAXY ICON (Resized/Fitted) ]]
local GalaxyBtn = Instance.new("TextButton", NebulaX)
GalaxyBtn.Size = UDim2.new(0, 45, 0, 45) -- Smaller, fitted size
GalaxyBtn.Position = UDim2.new(0.02, 0, 0.85, 0)
GalaxyBtn.BackgroundColor3 = theme.bg
GalaxyBtn.Text, GalaxyBtn.TextSize = "🌌", 25
GalaxyBtn.Visible = false
GalaxyBtn.Active, GalaxyBtn.Draggable = true, true
Instance.new("UICorner", GalaxyBtn).CornerRadius = UDim.new(1, 0)
local GalStroke = Instance.new("UIStroke", GalaxyBtn)
GalStroke.Color, GalStroke.Thickness = theme.accent, 2

GalaxyBtn.MouseButton1Click:Connect(function()
    Main.Visible, GalaxyBtn.Visible = true, false
end)

-- [[ WINDOW CONTROLS ]]
local function CreateControl(txt, pos, color, cb)
    local b = Instance.new("TextButton", Main)
    b.Size, b.Position = UDim2.new(0, 30, 0, 30), pos
    b.Text, b.TextColor3 = txt, color
    b.BackgroundColor3 = theme.dark
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    Instance.new("UIStroke", b).Color = theme.accent
    b.MouseButton1Click:Connect(cb)
end
CreateControl("-", UDim2.new(1, -75, 0, 10), theme.txt, function() Main.Visible, GalaxyBtn.Visible = false, true end)
CreateControl("X", UDim2.new(1, -35, 0, 10), Color3.new(1,0,0), function() NebulaX:Destroy() end)

-- [[ TABS ]]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size, Sidebar.BackgroundColor3 = UDim2.new(0, 160, 1, 0), theme.side
Instance.new("UICorner", Sidebar)

local Container = Instance.new("Frame", Main)
Container.Size, Container.Position = UDim2.new(1, -180, 1, -60), UDim2.new(0, 175, 0, 45)
Container.BackgroundTransparency = 1

local Pages = {}
local function CreateTab(name, order)
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size, Page.Visible = UDim2.new(1, 0, 1, 0), (order == 1)
    Page.BackgroundTransparency, Page.ScrollBarThickness = 1, 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)
    Pages[name] = Page
    local b = Instance.new("TextButton", Sidebar)
    b.Size, b.Position = UDim2.new(0.9, 0, 0, 38), UDim2.new(0.05, 0, 0, 70 + (order-1)*45)
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

-- [[ PLAYER SELECTOR (TARGET GLUE) ]]
local TargetFrame = Instance.new("Frame", combat)
TargetFrame.Size = UDim2.new(1, -10, 0, 150)
TargetFrame.BackgroundColor3 = theme.dark
Instance.new("UICorner", TargetFrame)

local TargetScroll = Instance.new("ScrollingFrame", TargetFrame)
TargetScroll.Size, TargetScroll.Position = UDim2.new(1, -10, 1, -40), UDim2.new(0, 5, 0, 35)
TargetScroll.BackgroundTransparency, TargetScroll.ScrollBarThickness = 1, 2
Instance.new("UIListLayout", TargetScroll).Padding = UDim.new(0, 2)

local TargetTitle = Instance.new("TextLabel", TargetFrame)
TargetTitle.Size, TargetTitle.Text = UDim2.new(1, 0, 0, 30), "SELECT TARGETS TO GLUE"
TargetTitle.TextColor3, TargetTitle.BackgroundTransparency = theme.accent, 1
TargetTitle.Font = Enum.Font.GothamBold

local function RefreshPlayers()
    for _, v in pairs(TargetScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(P:GetPlayers()) do
        if p ~= lp then
            local b = Instance.new("TextButton", TargetScroll)
            b.Size, b.Text = UDim2.new(1, -10, 0, 25), p.DisplayName
            b.BackgroundColor3 = table.find(_G.NebData.SelectedTargets, p.Name) and theme.accent or theme.side
            b.TextColor3 = theme.txt
            Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(function()
                local idx = table.find(_G.NebData.SelectedTargets, p.Name)
                if idx then table.remove(_G.NebData.SelectedTargets, idx) else table.insert(_G.NebData.SelectedTargets, p.Name) end
                RefreshPlayers()
            end)
        end
    end
end
RefreshPlayers()
P.PlayerAdded:Connect(RefreshPlayers)
P.PlayerRemoving:Connect(RefreshPlayers)

-- [[ UI BUTTONS ]]
local function AddB(txt, p, cb)
    local b = Instance.new("TextButton", p)
    b.Size, b.Text = UDim2.new(1, -10, 0, 35), txt
    b.BackgroundColor3, b.TextColor3 = theme.dark, theme.txt
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() cb(b) end)
end

AddB("M1 Spam: OFF", combat, function(b)
    _G.NebData.M1Spam = not _G.NebData.M1Spam
    b.Text = "M1 Spam: " .. (_G.NebData.M1Spam and "ON" or "OFF")
    b.BackgroundColor3 = _G.NebData.M1Spam and theme.accent or theme.dark
end)

AddB("Glue Mode: " .. _G.NebData.GlueMode, combat, function(b)
    local m = {"None", "Classic", "Reverse", "Orbit"}
    local i = table.find(m, _G.NebData.GlueMode) or 1
    _G.NebData.GlueMode = m[i % #m + 1]
    b.Text = "Glue Mode: " .. _G.NebData.GlueMode
end)

-- [[ LOGS ]]
local LT = Instance.new("TextLabel", logs)
LT.Size, LT.BackgroundTransparency = UDim2.new(1,0,1,0), 1
LT.TextColor3, LT.Text = theme.txt, "v4.3 Update Log:\n- Added Manual Target Selector\n- Fitted Galaxy Icon size\n- Fixed Mouse Lock bug\n- Radius Orbit logic polished\n- Made by Max"
LT.TextYAlignment = 0

-- [[ CORE ENGINE ]]
R.Heartbeat:Connect(function()
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if _G.NebData.M1Spam and not Main.Visible then VU:Button1Down(Vector2.new(0,0)) end

    if _G.NebData.Flight then
        hrp.Velocity = Vector3.zero
        hrp.CFrame = hrp.CFrame + (char.Humanoid.MoveDirection * (_G.NebData.FlightSpeed / 10))
    end

    if _G.NebData.GlueMode ~= "None" then
        local targets = {}
        for _, name in pairs(_G.NebData.SelectedTargets) do
            local p = P:FindFirstChild(name)
            if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(targets, p.Character.HumanoidRootPart)
            end
        end

        for i, t in ipairs(targets) do
            t.Velocity = Vector3.zero
            if _G.NebData.GlueMode == "Classic" then
                t.CFrame = hrp.CFrame * CFrame.new(0, _G.NebData.GlueHeight, -(i * 4))
            elseif _G.NebData.GlueMode == "Orbit" then
                local angle = (tick() * _G.NebData.OrbitSpeed) + (i * (math.pi * 2 / #targets))
                t.CFrame = hrp.CFrame * CFrame.Angles(0, angle, 0) * CFrame.new(0, _G.NebData.GlueHeight, _G.NebData.OrbitRadius)
            end
        end
    end
end)
