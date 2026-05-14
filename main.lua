-- [[ NEBULAX v3.0: TITAN ENGINE ]]
-- [[ OWNER: MAX | ARCHITECT: Z | DESIGN: LUNA ]]
-- [[ STATUS: OVERLORD | BUILD: 051426 ]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CG = game:GetService("CoreGui")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- [[ 1. THE ARCHIVE (Heavyweight State Management) ]]
getgenv().Titan = {
    -- State
    Active = true,
    Visible = true,
    CurrentTab = "Home",
    -- Features
    Flight = false, Noclip = false, God = false, InfJump = false,
    FlySpeed = 160, WalkSpeed = 16, SprintSpeed = 65, IsSprinting = false,
    -- Combat
    Aimbot = false, KillAura = false, AuraRange = 25,
    Mode = "None", Target = nil, OrbitSpd = 5, OrbitRad = 20,
    -- Visuals
    ESP = false, Tracers = false, FullBright = false, NoFog = false,
    -- World
    ShredMap = false, Gravity = 196.2,
    -- UI Theme
    Accent = Color3.fromRGB(0, 255, 200),
    BG = Color3.fromRGB(10, 10, 15),
    SideBG = Color3.fromRGB(15, 15, 22),
    Elements = {}
}
local T = getgenv().Titan

-- [[ 2. METATABLE VAULT (Security & Anti-Detection) ]]
local function InitializeSecurity()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then return task.wait(9e9) end
        if method == "FireServer" and tostring(self):lower():find("report") then return nil end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
    pcall(function() for _,v in pairs(CG:GetDescendants()) do if v:IsA("LocalScript") and v.Name:find("Anti") then v.Disabled = true end end end)
end
pcall(InitializeSecurity)

-- [[ 3. UI ARCHITECTURE (Titan-Class Modular Framework) ]]
local Screen = Instance.new("ScreenGui", CG); Screen.Name = "Titan_Core"
local Main = Instance.new("Frame", Screen); Main.Size = UDim2.new(0, 550, 0, 360)
Main.Position = UDim2.new(0.5, -275, 0.5, -180); Main.BackgroundColor3 = T.BG; Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = T.Accent; Stroke.Thickness = 1.5

-- Sidebar
local Side = Instance.new("Frame", Main); Side.Size = UDim2.new(0, 150, 1, 0); Side.BackgroundColor3 = T.SideBG; Side.BorderSizePixel = 0
Instance.new("UICorner", Side).CornerRadius = UDim.new(0, 10)
local Logo = Instance.new("TextLabel", Side); Logo.Size = UDim2.new(1, 0, 0, 60); Logo.Text = "NEBULAX TITAN"; Logo.TextColor3 = T.Accent
Logo.Font = Enum.Font.GothamBlack; Logo.TextSize = 16; Logo.BackgroundTransparency = 1

-- Scrolling Content Factory
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -170, 1, -20); Container.Position = UDim2.new(0, 160, 0, 10)
Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 2; Container.CanvasSize = UDim2.new(0, 0, 4, 0)
local List = Instance.new("UIListLayout", Container); List.Padding = UDim.new(0, 6)

-- [[ 4. THE COMPONENT ENGINE (PRO LOGIC) ]]
local function AddToggle(name, var, callback)
    local b = Instance.new("TextButton", Container); b.Size = UDim2.new(1, -10, 0, 42); b.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    b.Text = "  " .. name; b.TextColor3 = Color3.new(0.8, 0.8, 0.8); b.Font = Enum.Font.GothamBold; b.TextXAlignment = 0; Instance.new("UICorner", b)
    local s = Instance.new("Frame", b); s.Size = UDim2.new(0, 4, 1, 0); s.Position = UDim2.new(1, -4, 0, 0); s.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    
    b.MouseButton1Click:Connect(function()
        T[var] = not T[var]
        TS:Create(s, TweenInfo.new(0.2), {BackgroundColor3 = T[var] and T.Accent or Color3.fromRGB(60, 60, 60)}):Play()
        TS:Create(b, TweenInfo.new(0.2), {TextColor3 = T[var] and T.Accent or Color3.new(0.8, 0.8, 0.8)}):Play()
        if callback then callback(T[var]) end
    end)
end

-- [[ 5. POPULATING TITAN (ALL FEATURES) ]]
AddToggle("FLIGHT (L)", "Flight")
AddToggle("PHYSICAL NOCLIP (K)", "Noclip")
AddToggle("INFINITE JUMP", "InfJump")
AddToggle("GOD MODE (G)", "God")
AddToggle("KILL AURA", "KillAura")
AddToggle("ESP BOXES", "ESP")
AddToggle("ESP TRACERS", "Tracers")
AddToggle("FULL BRIGHT", "FullBright", function(v) Lighting.Brightness = v and 2 or 1; Lighting.GlobalShadows = not v end)
AddToggle("NO FOG", "NoFog", function(v) Lighting.FogEnd = v and 100000 or 1000 end)
AddToggle("MAP SHREDDER", "ShredMap")

-- Credits (Hardcoded Ownership)
local OwnerInfo = Instance.new("TextLabel", Container)
OwnerInfo.Size = UDim2.new(1, 0, 0, 80); OwnerInfo.BackgroundTransparency = 1
OwnerInfo.Text = "ARCHITECT: Z\nENGINEER: LUNA\nSOVEREIGN: MAX"; OwnerInfo.TextColor3 = T.Accent
OwnerInfo.Font = Enum.Font.GothamBlack; OwnerInfo.TextSize = 14

-- [[ 6. MASTER ENGINES (PRO MOVEMENT & WORLD) ]]
RS.Stepped:Connect(function()
    local char = LP.Character; if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local hum = char.Humanoid

    -- Sprint/Walk Logic
    hum.WalkSpeed = T.IsSprinting and T.SprintSpeed or T.WalkSpeed
    
    -- Flight Logic
    if T.Flight then hrp.Velocity = (Mouse.Hit.p - hrp.Position).Unit * T.FlySpeed end
    
    -- Noclip Logic
    if T.Noclip then for _,v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    
    -- World Shredder
    if T.ShredMap then
        for _,p in pairs(workspace:GetPartBoundsInRadius(hrp.Position, 40)) do
            if not p:IsDescendantOf(char) and p:IsA("BasePart") then p.Anchored = false; p.Velocity = Vector3.new(0, 50, 0); end
        end
    end
end)

-- [[ 7. COMBAT & BIND HANDLERS ]]
UIS.InputBegan:Connect(function(i, gpe)
    if gpe then return end
    local k = i.KeyCode.Name:lower()
    
    if k == "leftshift" then T.IsSprinting = true
    elseif k == "rightshift" then T.Visible = not T.Visible; Main.Visible = T.Visible
    elseif k == "l" then T.Flight = not T.Flight
    elseif k == "k" then T.Noclip = not T.Noclip
    elseif k == "z" then T.Mode = "Orbit"; T.Target = (Mouse.Target and Mouse.Target.Parent:FindFirstChild("Humanoid") and Mouse.Target.Parent)
    elseif k == "h" then T.Mode = "None"; T.Target = nil
    end
end)

UIS.InputEnded:Connect(function(i) if i.KeyCode == Enum.KeyCode.LeftShift then T.IsSprinting = false end end)

-- Dragging (Sovereign Handle)
local drag, dStart, sPos
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; dStart = i.Position; sPos = Main.Position end end)
UIS.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
    local delta = i.Position - dStart
    Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)

print("--- 🌌 NEBULAX TITAN v3.0 LOADED | SOVEREIGN: MAX ---")
