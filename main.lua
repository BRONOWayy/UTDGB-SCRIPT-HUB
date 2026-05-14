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
    GlueMode = "None", -- Classic, Reverse, Orbit
    GlueHeight = 2,
    LookAt = false,
    OrbitSpeed = 3,
    
    Flight = false,
    FlightMode = "Manual", 
    FlightSpeed = 50,
    WalkSpeed = 16,
    Noclip = false,
    InfJump = false,
    
    AutoSkill = false,
    Ignore = {"FROM_THE_FOUNTAIN", "Rig", "Model", "Bone"},
    Version = "v4.1"
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

-- [[ GALAXY MINIMIZE ICON ]]
local GalaxyBtn = Instance.new("TextButton", NebulaX)
GalaxyBtn.Size = UDim2.new(0, 55, 0, 55)
GalaxyBtn.Position = UDim2.new(0.02, 0, 0.85, 0)
GalaxyBtn.BackgroundColor3 = theme.bg
GalaxyBtn.Text, GalaxyBtn.TextSize = "🌌", 35
GalaxyBtn.Visible = false
GalaxyBtn.Active, GalaxyBtn.Draggable = true, true
Instance.new("UICorner", GalaxyBtn).CornerRadius = UDim.new(0, 50)
Instance.new("UIStroke", GalaxyBtn).Color = theme.accent
GalaxyBtn.MouseButton1Click:Connect(function() Main.Visible, GalaxyBtn.Visible = true, false end)

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

-- [[ SIDEBAR & PAGES ]]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = theme.side
Instance.new("UICorner", Sidebar)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "MAX ELITE"
Title.TextColor3 = theme.accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -180, 1, -60)
Container.Position = UDim2.new(0, 175, 0, 45)
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
local logs = CreateTab("Update Logs", 3)

-- [[ UI ELEMENTS HELPERS ]]
local function NewButton(txt, parent, cb)
    local b = Instance.new("TextButton", parent)
    b.Size, b.Text = UDim2.new(1, -10, 0, 35), txt
    b.BackgroundColor3, b.TextColor3 = theme.dark, theme.txt
    b.Font = Enum.Font.GothamMedium
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() cb(b) end)
end

-- [[ COMBAT TAB ]]
NewButton("Glue: " .. _G.NebData.GlueMode, combat, function(b)
    local m = {"None", "Classic", "Reverse", "Orbit"}
    local i = table.find(m, _G.NebData.GlueMode) or 1
    _G.NebData.GlueMode = m[i % #m + 1]
    b.Text = "Glue: " .. _G.NebData.GlueMode
end)

NewButton("Look-At Target: OFF", combat, function(b)
    _G.NebData.LookAt = not _G.NebData.LookAt
    b.Text = "Look-At Target: " .. (_G.NebData.LookAt and "ON" or "OFF")
end)

NewButton("Auto-Skill Spam: OFF", combat, function(b)
    _G.NebData.AutoSkill = not _G.NebData.AutoSkill
    b.Text = "Auto-Skill Spam: " .. (_G.NebData.AutoSkill and "ON" or "OFF")
end)

-- [[ MOVEMENT TAB ]]
NewButton("Flight: OFF", movement, function(b)
    _G.NebData.Flight = not _G.NebData.Flight
    b.Text = "Flight: " .. (_G.NebData.Flight and "ON" or "OFF")
end)

NewButton("Flight Mode: " .. _G.NebData.FlightMode, movement, function(b)
    _G.NebData.FlightMode = (_G.NebData.FlightMode == "Manual" and "Automatic" or "Manual")
    b.Text = "Flight Mode: " .. _G.NebData.FlightMode
end)

NewButton("Noclip: OFF", movement, function(b)
    _G.NebData.Noclip = not _G.NebData.Noclip
    b.Text = "Noclip: " .. (_G.NebData.Noclip and "ON" or "OFF")
end)

-- [[ LOGS ]]
local LT = Instance.new("TextLabel", logs)
LT.Size, LT.BackgroundTransparency = UDim2.new(1,0,1,0), 1
LT.TextColor3, LT.Font = theme.txt, Enum.Font.Gotham
LT.Text = "v4.1 Final Build:\n- Integrated UI & Engine\n- Multi-Target Orbit Logic\n- Manual/Auto Flight Modes\n- Speed/Height Config Ready\n- Galaxy Toggle System\n- Made by Max"
LT.TextYAlignment = 0

-- [[ THE ENGINE (Logic Loop) ]]
R.Heartbeat:Connect(function()
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    -- Flight Engine
    if _G.NebData.Flight then
        hrp.Velocity = Vector3.zero
        if _G.NebData.FlightMode == "Manual" then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (_G.NebData.FlightSpeed / 10))
        else
            if UIS:IsKeyDown(Enum.KeyCode.W) then hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -_G.NebData.FlightSpeed / 10) end
            if UIS:IsKeyDown(Enum.KeyCode.S) then hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, _G.NebData.FlightSpeed / 10) end
        end
    end

    -- Noclip Engine
    if _G.NebData.Noclip then
        for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end

    -- Multi-Glue / Orbit Engine
    if _G.NebData.GlueMode ~= "None" then
        local targets = {}
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v ~= char then
                local ign = false
                for _, n in pairs(_G.NebData.Ignore) do if v.Name:find(n) then ign = true end end
                if not ign and v:FindFirstChild("HumanoidRootPart") then table.insert(targets, v.HumanoidRootPart) end
            end
            if #targets >= 3 then break end
        end

        for i, t in ipairs(targets) do
            t.Velocity, t.RotVelocity = Vector3.zero, Vector3.zero
            if _G.NebData.GlueMode == "Classic" then
                t.CFrame = hrp.CFrame * CFrame.new(0, _G.NebData.GlueHeight, -(i * 3))
            elseif _G.NebData.GlueMode == "Reverse" then
                hrp.CFrame = t.CFrame * CFrame.new(0, 0, 3)
            elseif _G.NebData.GlueMode == "Orbit" then
                local angle = (tick() * _G.NebData.OrbitSpeed) + (i * (math.pi * 2 / #targets))
                t.CFrame = hrp.CFrame * CFrame.Angles(0, angle, 0) * CFrame.new(0, _G.NebData.GlueHeight, 7)
            end
            if _G.NebData.LookAt then hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(t.Position.X, hrp.Position.Y, t.Position.Z)) end
        end
    end
    
    -- Auto Skill Engine
    if _G.NebData.AutoSkill then
        VU:Button1Down(Vector2.new())
    end
end)

-- Border Resize logic
MainStroke.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then isResizing = true end end)
UIS.InputChanged:Connect(function(i)
    if isResizing and i.UserInputType == Enum.UserInputType.MouseMovement then
        local mPos = UIS:GetMouseLocation()
        Main.Size = UDim2.new(0, math.max(450, mPos.X - Main.AbsolutePosition.X), 0, math.max(300, mPos.Y - Main.AbsolutePosition.Y))
    end
end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then isResizing = false end end)
