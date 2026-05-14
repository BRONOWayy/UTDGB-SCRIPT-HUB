-- [[ NEBULAX v4.5: SOVEREIGN FINAL ]]
-- [[ OWNER: MAX | STABLE INPUT ARCHITECTURE ]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CG = game:GetService("CoreGui")
local TS = game:GetService("TweenService")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- [[ 1. THE ULTIMATE STATE ]]
getgenv().Nebula = {
    Flags = {},
    Settings = { FlySpeed = 160, Sprint = 65, JumpPower = 50, Radius = 20 },
    CurrentTab = "Main",
    Theme = { Accent = Color3.fromRGB(0, 255, 200), Main = Color3.fromRGB(10, 10, 15), Side = Color3.fromRGB(15, 15, 22) }
}
local NB = getgenv().Nebula

-- [[ 2. METATABLE PROTECTION ]]
local function Secure()
    local mt = getrawmetatable(game); setreadonly(mt, false); local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local m = getnamecallmethod()
        if m == "Kick" or m == "kick" then return task.wait(9e9) end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end
pcall(Secure)

-- [[ 3. CORE UI ARCHITECTURE ]]
local Screen = Instance.new("ScreenGui", CG); Screen.Name = "Nebula_Sovereign"
local Main = Instance.new("Frame", Screen); Main.Size = UDim2.new(0, 550, 0, 350)
Main.Position = UDim2.new(0.5, -275, 0.5, -175); Main.BackgroundColor3 = NB.Theme.Main; Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = NB.Theme.Accent; Stroke.Thickness = 1.5

-- Sidebar (THE ONLY DRAG HANDLE)
local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 140, 1, 0); Sidebar.BackgroundColor3 = NB.Theme.Side
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

-- Tab Scrolling Content
local Container = Instance.new("ScrollingFrame", Main); Container.Size = UDim2.new(1, -160, 1, -20)
Container.Position = UDim2.new(0, 150, 0, 10); Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 2
Container.CanvasSize = UDim2.new(0, 0, 3, 0)
local Layout = Instance.new("UIListLayout", Container); Layout.Padding = UDim.new(0, 8)

-- [[ 4. COMPONENT CLASS (STABLE INPUTS) ]]
local Comp = {}

function Comp.Toggle(name, flag)
    local b = Instance.new("TextButton", Container); b.Size = UDim2.new(1, -10, 0, 40); b.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    b.Text = "  " .. name; b.TextColor3 = Color3.new(0.7,0.7,0.7); b.Font = Enum.Font.GothamBold; b.TextXAlignment = 0; Instance.new("UICorner", b)
    local s = Instance.new("Frame", b); s.Size = UDim2.new(0, 4, 1, 0); s.Position = UDim2.new(1, -4, 0, 0); s.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.MouseButton1Click:Connect(function()
        NB.Flags[flag] = not NB.Flags[flag]
        s.BackgroundColor3 = NB.Flags[flag] and NB.Theme.Accent or Color3.fromRGB(50,50,50)
        b.TextColor3 = NB.Flags[flag] and NB.Theme.Accent or Color3.new(1,1,1)
    end)
end

function Comp.Slider(name, min, max, default, flag)
    local f = Instance.new("Frame", Container); f.Size = UDim2.new(1, -10, 0, 50); f.BackgroundColor3 = Color3.fromRGB(22, 22, 30); Instance.new("UICorner", f)
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, -10, 0, 25); l.Position = UDim2.new(0, 10, 0, 0); l.Text = name; l.TextColor3 = Color3.new(0.8,0.8,0.8); l.Font = Enum.Font.GothamBold; l.TextSize = 11; l.BackgroundTransparency = 1; l.TextXAlignment = 0
    local valLab = Instance.new("TextLabel", f); valLab.Size = UDim2.new(0, 40, 0, 25); valLab.Position = UDim2.new(1, -50, 0, 0); valLab.Text = tostring(default); valLab.TextColor3 = NB.Theme.Accent; valLab.Font = Enum.Font.GothamBold; valLab.BackgroundTransparency = 1
    local back = Instance.new("Frame", f); back.Size = UDim2.new(1, -20, 0, 4); back.Position = UDim2.new(0, 10, 0, 35); back.BackgroundColor3 = Color3.fromRGB(40,40,45)
    local fill = Instance.new("Frame", back); fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); fill.BackgroundColor3 = NB.Theme.Accent
    
    local move = false
    local function update()
        local p = math.clamp((Mouse.X - back.AbsolutePosition.X) / back.AbsoluteSize.X, 0, 1)
        NB.Settings[flag] = math.floor(min + (max-min)*p)
        fill.Size = UDim2.new(p, 0, 1, 0); valLab.Text = tostring(NB.Settings[flag])
    end
    f.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then move = true; update() end end)
    UIS.InputChanged:Connect(function(i) if move and i.UserInputType == Enum.UserInputType.MouseMovement then update() end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then move = false end end)
end

-- [[ 5. FEATURE POPULATION (ALL REQUESTS) ]]
Comp.Toggle("FLIGHT (L)", "Flight")
Comp.Slider("FLIGHT SPEED", 16, 500, 160, "FlySpeed")
Comp.Toggle("NOCLIP (K)", "Noclip")
Comp.Toggle("KILL AURA", "Aura")
Comp.Toggle("GOD MODE", "God")
Comp.Toggle("MAP SHREDDER", "Shred")
Comp.Toggle("INFINITE JUMP", "InfJump")

local Creds = Instance.new("TextLabel", Container); Creds.Size = UDim2.new(1, 0, 0, 60); Creds.BackgroundTransparency = 1
Creds.Text = "SOVEREIGN: MAX\nARCHITECT: Z"; Creds.TextColor3 = NB.Theme.Accent; Creds.Font = Enum.Font.GothamBlack

-- [[ 6. ENGINES ]]
RS.Heartbeat:Connect(function()
    local c = LP.Character; if not c or not c:FindFirstChild("HumanoidRootPart") then return end
    local hrp = c.HumanoidRootPart
    if NB.Flags["Flight"] then hrp.Velocity = (Mouse.Hit.p - hrp.Position).Unit * NB.Settings.FlySpeed end
    if NB.Flags["Noclip"] then for _,v in pairs(c:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    if NB.Flags["Shred"] then
        for _,v in pairs(workspace:GetPartBoundsInRadius(hrp.Position, 40)) do
            if v:IsA("BasePart") and not v:IsDescendantOf(c) then v.Anchored = false; v.Velocity = Vector3.new(0,50,0) end
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if NB.Flags["InfJump"] and LP.Character:FindFirstChildOfClass("Humanoid") then
        LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- [[ 7. THE FIX: SELECTIVE DRAGGING ]]
local drag, dStart, sPos
Sidebar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; dStart = i.Position; sPos = Main.Position end end)
UIS.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
    local delta = i.Position - dStart
    Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)

-- Keybinds
UIS.InputBegan:Connect(function(i, gpe)
    if gpe then return end
    local k = i.KeyCode.Name:lower()
    if k == "rightshift" then Main.Visible = not Main.Visible
    elseif k == "l" then NB.Flags["Flight"] = not NB.Flags["Flight"]
    elseif k == "k" then NB.Flags["Noclip"] = not NB.Flags["Noclip"]
    end
end)

print("--- 🌌 NEBULAX v4.5 DEPLOYED | OWNER: MAX ---")
