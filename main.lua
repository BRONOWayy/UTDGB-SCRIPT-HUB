-- [[ NEBULAX v1.2: SOVEREIGN SCRIPT HUB ]]
-- [[ DESIGN: LUNA | ARCHITECT: Z | OWNER: MAX ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- [[ 1. CONFIGURATION & DATA VAULT ]]
local NEBULA = {
    Flight = false, Noclip = false, God = false,
    Mode = "None", Target = nil,
    Speed = 160, OrbitSpd = 4, Radius = 18,
    Accent = Color3.fromRGB(255, 0, 180),
    MainBG = Color3.fromRGB(15, 12, 28)
}

-- [[ 2. SECURITY SHIELD (ANTI-KICK) ]]
local function Secure()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then return task.wait(9e9) end
        if method == "FireServer" and tostring(self):find("Report") then return nil end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end
pcall(Secure)

-- [[ 3. SOVEREIGN UI FRAMEWORK ]]
local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "NebulaX_Hub"

local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 550, 0, 380)
Main.Position = UDim2.new(0.5, -275, 0.5, -190)
Main.BackgroundColor3 = NEBULA.MainBG
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = NEBULA.Accent; Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50); Title.Text = "NEBULAX SOVEREIGN HUB"; Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBlack; Title.TextSize = 20; Title.BackgroundTransparency = 1

local Credits = Instance.new("TextLabel", Main)
Credits.Size = UDim2.new(0, 150, 0, 30); Credits.Position = UDim2.new(0, 15, 1, -35)
Credits.Text = "OWNER: MAX"; Credits.TextColor3 = NEBULA.Accent; Credits.Font = Enum.Font.GothamBold; Credits.BackgroundTransparency = 1

-- [[ 4. THE HUB ENGINES ]]

-- Mobility (Noclip Flight)
RunService.Stepped:Connect(function()
    if NEBULA.Flight and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = (Mouse.Hit.p - hrp.Position).Unit * NEBULA.Speed
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

-- Combat Matrix (Orbit & Glue)
RunService.Heartbeat:Connect(function()
    if not NEBULA.Target or not NEBULA.Target:FindFirstChild("HumanoidRootPart") then return end
    local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local tHRP = NEBULA.Target.HumanoidRootPart
    
    if NEBULA.Mode == "Orbit" then
        local t = tick() * NEBULA.OrbitSpd
        tHRP.CFrame = myHRP.CFrame * CFrame.new(math.cos(t) * NEBULA.Radius, 5, math.sin(t) * NEBULA.Radius)
        tHRP.Velocity = Vector3.zero
    elseif NEBULA.Mode == "Glue" then
        tHRP.CFrame = myHRP.CFrame * CFrame.new(0, 0, -10)
        tHRP.Velocity = Vector3.zero
    end
end)

-- [[ 5. CONTROLS & BINDINGS ]]
UIS.InputBegan:Connect(function(i, gpe)
    if gpe then return end
    local k = i.KeyCode.Name:lower()
    if k == "l" then NEBULA.Flight = not NEBULA.Flight
    elseif k == "z" then NEBULA.Mode = "Orbit"; NEBULA.Target = (Mouse.Target and Mouse.Target.Parent:FindFirstChild("Humanoid") and Mouse.Target.Parent)
    elseif k == "x" then NEBULA.Mode = "Glue"; NEBULA.Target = (Mouse.Target and Mouse.Target.Parent:FindFirstChild("Humanoid") and Mouse.Target.Parent)
    elseif k == "h" then NEBULA.Mode = "None"; NEBULA.Target = nil
    end
end)

-- [[ 6. PERFORMANCE OPTIMIZER ]]
local function Optimize()
    settings().Rendering.QualityLevel = 1
    game:GetService("Lighting").GlobalShadows = false
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
    end
end
Optimize()

-- [[ 7. DYNAMIC RESIZER ]]
local Resizer = Instance.new("TextButton", Main)
Resizer.Size = UDim2.new(0, 30, 0, 30); Resizer.Position = UDim2.new(1, -30, 1, -30)
Resizer.Text = "◢"; Resizer.TextColor3 = NEBULA.Accent; Resizer.BackgroundTransparency = 1; Resizer.TextSize = 25

local drag = false
Resizer.MouseButton1Down:Connect(function() drag = true end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)

RunService.RenderStepped:Connect(function()
    if drag then
        local m = UIS:GetMouseLocation()
        Main.Size = UDim2.new(0, math.clamp(m.X - Main.AbsolutePosition.X, 400, 850), 0, math.clamp(m.Y - Main.AbsolutePosition.Y, 300, 600))
    end
end)

print("--- 🌌 NEBULAX SOVEREIGN HUB LOADED | OWNER: MAX ---")
