-- [[ NEBULAX v1.3: ULTRA-SOVEREIGN HUB ]]
-- [[ OWNER: MAX | THE ULTIMATE DEFINITIVE BUILD ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- [[ 1. GLOBAL STATE & CONFIG ]]
getgenv().NebulaConfig = {
    -- Security
    AntiKick = true, AntiLog = true, MetaHook = true,
    -- Movement
    Flight = false, Speed = 160, Noclip = false, InfJump = false,
    -- Combat
    Mode = "None", Target = nil, OrbitSpd = 5, Radius = 20, StalkerDist = 12,
    AutoClicker = false, KillAura = false, AuraRange = 25,
    -- Visuals
    ESP = false, Tracers = false, FullBright = false,
    -- UI Style
    Accent = Color3.fromRGB(255, 0, 180), -- Hyper Magenta
    BG = Color3.fromRGB(15, 12, 28),      -- Midnight Violet
    Sidebar = Color3.fromRGB(10, 8, 20),
    Connections = {}
}

local CFG = getgenv().NebulaConfig

-- [[ 2. THE VAULT: SUPREME PROTECTION ]]
local function InitializeVault()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if CFG.AntiKick and (method == "Kick" or method == "kick") then return task.wait(9e9) end
        if CFG.AntiLog and method == "FireServer" then
            local name = tostring(self)
            if name:find("Log") or name:find("Error") or name:find("Report") then return nil end
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
    print("--- 🛡️ VAULT SECURITY ACTIVE ---")
end
pcall(InitializeVault)

-- [[ 3. THE UI CORE (LUNA'S ARCHIVE DESIGN) ]]
local NebulaUI = Instance.new("ScreenGui", CoreGui)
NebulaUI.Name = "NebulaX_Ultra"

local Main = Instance.new("Frame", NebulaUI)
Main.Size = UDim2.new(0, 750, 0, 480)
Main.Position = UDim2.new(0.5, -375, 0.5, -240)
Main.BackgroundColor3 = CFG.BG
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = CFG.Accent; MainStroke.Thickness = 2

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 200, 1, 0); Sidebar.BackgroundColor3 = CFG.Sidebar; Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, 0, 0, 80); Logo.Text = "NEBULAX"; Logo.TextColor3 = CFG.Accent
Logo.Font = Enum.Font.GothamBlack; Logo.TextSize = 35; Logo.BackgroundTransparency = 1

local OwnerTag = Instance.new("TextLabel", Sidebar)
OwnerTag.Size = UDim2.new(1, 0, 0, 40); OwnerTag.Position = UDim2.new(0,0,1,-50)
OwnerTag.Text = "OWNER: MAX"; OwnerTag.TextColor3 = CFG.Accent; OwnerTag.Font = Enum.Font.GothamBold; OwnerTag.BackgroundTransparency = 1

-- Scrolling Content
local Content = Instance.new("ScrollingFrame", Main)
Content.Size = UDim2.new(1, -220, 1, -20); Content.Position = UDim2.new(0, 210, 0, 10)
Content.BackgroundTransparency = 1; Content.ScrollBarThickness = 3; Content.CanvasSize = UDim2.new(0,0,2,0)
local List = Instance.new("UIListLayout", Content); List.Padding = UDim.new(0, 10)

-- [[ 4. HUB COMPONENTS ]]
local function CreateToggle(name, var, callback)
    local btn = Instance.new("TextButton", Content)
    btn.Size = UDim2.new(1, -15, 0, 50); btn.BackgroundColor3 = Color3.fromRGB(30, 25, 50)
    btn.Text = "   " .. name; btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", btn)
    
    local Status = Instance.new("Frame", btn)
    Status.Size = UDim2.new(0, 6, 1, 0); Status.Position = UDim2.new(1, -6, 0, 0)
    Status.BackgroundColor3 = Color3.fromRGB(80, 80, 80); Instance.new("UICorner", Status)
    
    btn.MouseButton1Click:Connect(function()
        CFG[var] = not CFG[var]
        Status.BackgroundColor3 = CFG[var] and CFG.Accent or Color3.fromRGB(80, 80, 80)
        btn.TextColor3 = CFG[var] and CFG.Accent or Color3.new(1,1,1)
        if callback then callback(CFG[var]) end
    end)
end

-- [[ 5. THE ENGINES (ARCHITECT Z) ]]

-- Movement & Flight
CFG.Connections["Movement"] = RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    if CFG.Flight then
        hrp.Velocity = (Mouse.Hit.p - hrp.Position).Unit * CFG.Speed
    end
    if CFG.Noclip then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- Infinite Jump
UIS.JumpRequest:Connect(function()
    if CFG.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Combat Engines
CFG.Connections["Combat"] = RunService.Heartbeat:Connect(function()
    if not CFG.Target or not CFG.Target:FindFirstChild("HumanoidRootPart") then return end
    local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local tHRP = CFG.Target.HumanoidRootPart

    if CFG.Mode == "Orbit" then
        local t = tick() * CFG.OrbitSpd
        tHRP.CFrame = myHRP.CFrame * CFrame.new(math.cos(t) * CFG.Radius, 5, math.sin(t) * CFG.Radius)
        tHRP.Velocity = Vector3.zero
    elseif CFG.Mode == "Glue" then
        tHRP.CFrame = myHRP.CFrame * CFrame.new(0, 0, -CFG.StalkerDist)
        tHRP.Velocity = Vector3.zero
    end
end)

-- [[ 6. POPULATING THE HUB ]]
CreateToggle("FLIGHT (L)", "Flight")
CreateToggle("NOCLIP (K)", "Noclip")
CreateToggle("INFINITE JUMP", "InfJump")
CreateToggle("GOD MODE (G)", "GodMode", function(state)
    if state then
        LocalPlayer.Character.Humanoid.MaxHealth = 9e18
        LocalPlayer.Character.Humanoid.Health = 9e18
    end
end)
CreateToggle("FULL BRIGHT", "FullBright", function(state)
    Lighting.Brightness = state and 2 or 1
    Lighting.ClockTime = state and 14 or 12
    Lighting.GlobalShadows = not state
end)

-- [[ 7. DYNAMIC RESIZER & DRAG ]]
local function EnableDrag(f)
    local drag, start, startPos
    f.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; start = i.Position; startPos = f.Position end end)
    UIS.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - start
        f.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
end

local Resizer = Instance.new("TextButton", Main)
Resizer.Size = UDim2.new(0, 35, 0, 35); Resizer.Position = UDim2.new(1, -35, 1, -35)
Resizer.Text = "◢"; Resizer.TextColor3 = CFG.Accent; Resizer.BackgroundTransparency = 1; Resizer.TextSize = 30
local isResizing = false
Resizer.MouseButton1Down:Connect(function() isResizing = true end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then isResizing = false end end)

RunService.RenderStepped:Connect(function()
    if isResizing then
        local m = UIS:GetMouseLocation()
        Main.Size = UDim2.new(0, math.clamp(m.X - Main.AbsolutePosition.X, 450, 950), 0, math.clamp(m.Y - Main.AbsolutePosition.Y, 350, 750))
    end
end)

-- [[ 8. FINAL CONTROLS ]]
UIS.InputBegan:Connect(function(i, gpe)
    if gpe then return end
    local k = i.KeyCode.Name:lower()
    if k == "l" then CFG.Flight = not CFG.Flight
    elseif k == "k" then CFG.Noclip = not CFG.Noclip
    elseif k == "z" then CFG.Mode = "Orbit"; CFG.Target = (Mouse.Target and Mouse.Target.Parent:FindFirstChild("Humanoid") and Mouse.Target.Parent)
    elseif k == "x" then CFG.Mode = "Glue"; CFG.Target = (Mouse.Target and Mouse.Target.Parent:FindFirstChild("Humanoid") and Mouse.Target.Parent)
    elseif k == "h" then CFG.Mode = "None"; CFG.Target = nil
    end
end)

EnableDrag(Main)
print("--- 🌌 NEBULAX ULTRA-SOVEREIGN HUB v1.3 ONLINE ---")
