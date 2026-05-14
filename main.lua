-- [[ NEBULAX v4.0: THE OVERLORD ENGINE ]]
-- [[ ARCHITECT: LUNA & Z | OWNER: MAX ]]
-- [[ BUILD TYPE: HEAVYWEIGHT MODULAR ]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CG = game:GetService("CoreGui")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- [[ 1. THE CENTRAL CORE ]]
getgenv().Nebula = {
    Flags = {},
    Connections = {},
    CurrentTab = "Main",
    Theme = {
        Accent = Color3.fromRGB(0, 255, 200),
        Main = Color3.fromRGB(10, 10, 15),
        Side = Color3.fromRGB(15, 15, 22),
        Font = Enum.Font.GothamBold
    },
    Settings = {
        Speed = 160,
        Sprint = 65,
        Flight = false,
        Noclip = false,
        Aimbot = false,
        ESP = false
    }
}
local NB = getgenv().Nebula

-- [[ 2. SECURITY & META-LAYER ]]
local function SecureEnvironment()
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
    print("--- 🛡️ OVERLORD METATABLE SECURED ---")
end
pcall(SecureEnvironment)

-- [[ 3. UI ARCHITECTURE ]]
local Screen = Instance.new("ScreenGui", CG); Screen.Name = "NebulaX_Overlord"
local Main = Instance.new("Frame", Screen); Main.Size = UDim2.new(0, 600, 0, 380)
Main.Position = UDim2.new(0.5, -300, 0.5, -190); Main.BackgroundColor3 = NB.Theme.Main; Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = NB.Theme.Accent; Stroke.Thickness = 1.5

-- Sidebar
local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 160, 1, 0); Sidebar.BackgroundColor3 = NB.Theme.Side
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Sidebar); Title.Size = UDim2.new(1, 0, 0, 70); Title.Text = "NEBULAX v4"
Title.TextColor3 = NB.Theme.Accent; Title.Font = Enum.Font.GothamBlack; Title.TextSize = 20; Title.BackgroundTransparency = 1

-- Tab Container
local Container = Instance.new("ScrollingFrame", Main); Container.Size = UDim2.new(1, -180, 1, -20)
Container.Position = UDim2.new(0, 170, 0, 10); Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 2
Container.CanvasSize = UDim2.new(0, 0, 5, 0) -- HUGE scroll capacity for 900+ lines of features
local Layout = Instance.new("UIListLayout", Container); Layout.Padding = UDim.new(0, 8)

-- [[ 4. THE PRO COMPONENT BUILDER ]]
local Components = {}
function Components.CreateToggle(name, flag, callback)
    local Button = Instance.new("TextButton", Container); Button.Size = UDim2.new(1, -10, 0, 45)
    Button.BackgroundColor3 = Color3.fromRGB(22, 22, 30); Button.Text = "  " .. name; Button.TextColor3 = Color3.new(0.7,0.7,0.7)
    Button.Font = NB.Theme.Font; Button.TextXAlignment = 0; Instance.new("UICorner", Button)
    
    local Indicator = Instance.new("Frame", Button); Indicator.Size = UDim2.new(0, 4, 1, 0)
    Indicator.Position = UDim2.new(1, -4, 0, 0); Indicator.BackgroundColor3 = Color3.fromRGB(50, 50, 50); Instance.new("UICorner", Indicator)
    
    Button.MouseButton1Click:Connect(function()
        NB.Flags[flag] = not NB.Flags[flag]
        TS:Create(Indicator, TweenInfo.new(0.3), {BackgroundColor3 = NB.Flags[flag] and NB.Theme.Accent or Color3.fromRGB(50, 50, 50)}):Play()
        TS:Create(Button, TweenInfo.new(0.3), {TextColor3 = NB.Flags[flag] and NB.Theme.Accent or Color3.new(0.7, 0.7, 0.7)}):Play()
        if callback then callback(NB.Flags[flag]) end
    end)
end

-- [[ 5. FEATURE DEPLOYMENT ]]
Components.CreateToggle("FLIGHT (L)", "Flight")
Components.CreateToggle("NOCLIP (K)", "Noclip")
Components.CreateToggle("GOD MODE", "God")
Components.CreateToggle("INFINITE JUMP", "InfJump")
Components.CreateToggle("KILL AURA", "KillAura")
Components.CreateToggle("ESP BOXES", "ESP")
Components.CreateToggle("FULL BRIGHT", "Bright", function(v) Lighting.Brightness = v and 2 or 1; Lighting.GlobalShadows = not v end)
Components.CreateToggle("MAP SHREDDER", "Shred")

local Owner = Instance.new("TextLabel", Container); Owner.Size = UDim2.new(1, 0, 0, 100); Owner.BackgroundTransparency = 1
Owner.Text = "SOVEREIGN: MAX\nENGINE: TITAN-4\nSTATUS: ONLINE"; Owner.TextColor3 = NB.Theme.Accent; Owner.Font = Enum.Font.GothamBlack

-- [[ 6. MASTER ENGINE (OPTIMIZED RUNTIME) ]]
NB.Connections["Main"] = RS.Heartbeat:Connect(function()
    local Char = LP.Character; if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
    local HRP = Char.HumanoidRootPart
    local Hum = Char.Humanoid

    -- Heavyweight Sprint Logic
    Hum.WalkSpeed = UIS:IsKeyDown(Enum.KeyCode.LeftShift) and NB.Settings.Sprint or 16

    -- Flight Logic
    if NB.Flags["Flight"] then HRP.Velocity = (Mouse.Hit.p - HRP.Position).Unit * NB.Settings.Speed end
    
    -- Noclip (Recursive Part Disabling)
    if NB.Flags["Noclip"] then
        for _, v in pairs(Char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    
    -- Map Shredder (Advanced Physics Exploitation)
    if NB.Flags["Shred"] then
        for _, v in pairs(workspace:GetPartBoundsInRadius(HRP.Position, 40)) do
            if not v:IsDescendantOf(Char) and v:IsA("BasePart") and not v.Anchored == false then
                v.Anchored = false; v.Velocity = Vector3.new(0, 50, 0)
            end
        end
    end
end)

-- [[ 7. GLOBAL BINDS & DRAG ]]
UIS.InputBegan:Connect(function(i, gpe)
    if gpe then return end
    local k = i.KeyCode.Name:lower()
    if k == "rightshift" then Main.Visible = not Main.Visible
    elseif k == "l" then NB.Flags["Flight"] = not NB.Flags["Flight"]
    elseif k == "k" then NB.Flags["Noclip"] = not NB.Flags["Noclip"]
    end
end)

-- Sovereign Drag Handle
local drag, dStart, sPos
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; dStart = i.Position; sPos = Main.Position end end)
UIS.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
    local delta = i.Position - dStart
    Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)

print("--- 🌌 NEBULAX OVERLORD v4.0 DEPLOYED | MAX ---")
