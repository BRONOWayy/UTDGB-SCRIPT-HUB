-- [[ NEBULAX v1.2: SOVEREIGN HUB ]]
-- [[ OWNER: MAX | NO CHAT SPAMMER EDITION ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- [[ 1. THE VAULT: SECURITY & CLEANUP ]]
local NEBULA_DATA = {
    Connections = {},
    FlightSpeed = 160,
    OrbitSpeed = 4,
    OrbitRadius = 18,
    StalkerDist = 10,
    CombatMode = "None",
    Target = nil,
    FlightActive = false,
    Noclip = false,
    GodMode = false,
    Accent = Color3.fromRGB(255, 0, 180),
    BG = Color3.fromRGB(15, 12, 28)
}

local function Protect()
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        local m = getnamecallmethod()
        if m == "Kick" or m == "kick" then return task.wait(9e9) end
        if m == "FireServer" and tostring(self):find("Report") then return nil end
        return old(self, ...)
    end)
end
pcall(Protect)

-- [[ 2. UI CONSTRUCTION (LUNA'S DESIGN) ]]
local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "NebulaX_Sovereign"

local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = NEBULA_DATA.BG
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

local AccentLine = Instance.new("Frame", Main)
AccentLine.Size = UDim2.new(1, 0, 0, 2)
AccentLine.BackgroundColor3 = NEBULA_DATA.Accent
AccentLine.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "NEBULAX v1.2 | SOVEREIGN HUB"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local Credits = Instance.new("TextLabel", Main)
Credits.Size = UDim2.new(1, -20, 0, 20)
Credits.Position = UDim2.new(0, 10, 1, -25)
Credits.Text = "OWNER: MAX"
Credits.TextColor3 = NEBULA_DATA.Accent
Credits.Font = Enum.Font.GothamBold
Credits.BackgroundTransparency = 1
Credits.TextXAlignment = Enum.TextXAlignment.Left

-- [[ 3. THE ENGINES (ARCHITECT Z) ]]

-- Mobility Loop
NEBULA_DATA.Connections["Flight"] = RunService.Stepped:Connect(function()
    if NEBULA_DATA.FlightActive and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = (Mouse.Hit.p - hrp.Position).Unit * NEBULA_DATA.FlightSpeed
            if NEBULA_DATA.Noclip then
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end
    end
end)

-- Combat Loop
NEBULA_DATA.Connections["Combat"] = RunService.Heartbeat:Connect(function()
    if not NEBULA_DATA.Target or not NEBULA_DATA.Target:FindFirstChild("HumanoidRootPart") then return end
    local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local tHRP = NEBULA_DATA.Target.HumanoidRootPart
    
    if NEBULA_DATA.CombatMode == "Orbit" then
        local t = tick() * NEBULA_DATA.OrbitSpeed
        tHRP.CFrame = myHRP.CFrame * CFrame.new(math.cos(t) * NEBULA_DATA.OrbitRadius, 5, math.sin(t) * NEBULA_DATA.OrbitRadius)
        tHRP.Velocity = Vector3.new(0,0,0)
    elseif NEBULA_DATA.CombatMode == "Glue" then
        tHRP.CFrame = myHRP.CFrame * CFrame.new(0, 0, -NEBULA_DATA.StalkerDist)
        tHRP.Velocity = Vector3.new(0,0,0)
    end
end)

-- [[ 4. INTERACTION & BINDINGS ]]
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local key = input.KeyCode.Name:lower()
    
    if key == "l" then -- FLIGHT
        NEBULA_DATA.FlightActive = not NEBULA_DATA.FlightActive
        NEBULA_DATA.Noclip = NEBULA_DATA.FlightActive
    elseif key == "z" then -- ORBIT
        NEBULA_DATA.CombatMode = "Orbit"
        NEBULA_DATA.Target = Mouse.Target and Mouse.Target.Parent:FindFirstChild("Humanoid") and Mouse.Target.Parent or nil
    elseif key == "x" then -- GLUE
        NEBULA_DATA.CombatMode = "Glue"
        NEBULA_DATA.Target = Mouse.Target and Mouse.Target.Parent:FindFirstChild("Humanoid") and Mouse.Target.Parent or nil
    elseif key == "h" then -- HALT
        NEBULA_DATA.CombatMode = "None"
        NEBULA_DATA.Target = nil
    end
end)

-- [[ 5. PERFORMANCE BOOST ]]
local function Boost()
    settings().Rendering.QualityLevel = 1
    game:GetService("Lighting").GlobalShadows = false
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then
            v.Material = Enum.Material.SmoothPlastic
        end
    end
end
Boost()

-- [[ 6. RESIZER GLYPH ]]
local Resizer = Instance.new("TextButton", Main)
Resizer.Size = UDim2.new(0, 25, 0, 25)
Resizer.Position = UDim2.new(1, -25, 1, -25)
Resizer.Text = "◢"
Resizer.TextColor3 = NEBULA_DATA.Accent
Resizer.BackgroundTransparency = 1
Resizer.TextSize = 20

local dragging = false
Resizer.MouseButton1Down:Connect(function() dragging = true end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local mPos = UIS:GetMouseLocation()
        local nX = math.clamp(mPos.X - Main.AbsolutePosition.X, 400, 850)
        local nY = math.clamp(mPos.Y - Main.AbsolutePosition.Y, 300, 600)
        Main.Size = UDim2.new(0, nX, 0, nY)
    end
end)

print("--- ✅ NEBULAX SOVEREIGN HUB LOADED | OWNER: MAX ---")
