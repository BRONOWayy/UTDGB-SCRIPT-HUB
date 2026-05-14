-- ========================================================
-- 🌌 NEBULAX v1.2: SOVEREIGN (DYNAMIC ARCHIVE)
-- VERSION: 1.2 [DYNAMIC]
-- CONTROLS: L (Flight) | Z (Orbit) | X (Glue) | H (Halt)
-- FEATURES: Sovereign Slider, Noclip Matrix, Orbit Engine
-- ========================================================

local l = game:GetService("Players").LocalPlayer; local w = workspace; local d = game:GetService("Debris")
local rs = game:GetService("RunService"); local ts = game:GetService("TweenService"); local m = l:GetMouse()
local uis = game:GetService("UserInputService")

-- 🛡️ I. DYNAMIC DATA
local NEBULA_DATA = {
    Connections = {},
    FlightSpeed = 160,
    OrbitSpeed = 4,
    PrimaryColor = Color3.fromRGB(30, 0, 50), -- Midnight Violet
    AccentColor = Color3.fromRGB(255, 0, 200) -- Hyper Magenta
}

-- 🚀 II. THE MOBILITY MATRIX (Speed Linked)
local flightEnabled = false
local function handleMobility()
    if not flightEnabled then return end
    local char = l.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Velocity = (m.Hit.p - hrp.Position).Unit * NEBULA_DATA.FlightSpeed
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end
NEBULA_DATA.Connections["Mobility"] = rs.Stepped:Connect(handleMobility)

-- ⚔️ III. THE COMBAT ENGINES
local stalkerTarget = nil
local combatMode = "None" 
local function runCombat()
    if not stalkerTarget or not stalkerTarget:FindFirstChild("HumanoidRootPart") then return end
    local char = l.Character; if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local targetHRP = stalkerTarget.HumanoidRootPart
    local myHRP = char.HumanoidRootPart
    if combatMode == "Orbit" then
        local t = tick() * NEBULA_DATA.OrbitSpeed
        targetHRP.CFrame = myHRP.CFrame * CFrame.new(math.cos(t) * 18, 5, math.sin(t) * 18)
    elseif combatMode == "Glue" then
        targetHRP.CFrame = myHRP.CFrame * CFrame.new(0, 0, -10)
    end
end
NEBULA_DATA.Connections["Combat"] = rs.Heartbeat:Connect(runCombat)

-- ⚙️ IV. SOVEREIGN UI (Dynamic Build)
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "NebulaX_Sovereign"

local main = Instance.new("Frame", sg); main.ClipsDescendants = true
main.Size = UDim2.new(0, 450, 0, 320); main.Position = UDim2.new(0.5, -225, 0.5, -160)
main.BackgroundColor3 = NEBULA_DATA.PrimaryColor; main.BorderSizePixel = 0

local accent = Instance.new("Frame", main)
accent.Size = UDim2.new(1, 0, 0, 3); accent.BackgroundColor3 = NEBULA_DATA.AccentColor; accent.BorderSizePixel = 0

local title = Instance.new("TextLabel", main)
title.Text = "🌌 NEBULAX v1.2 | SOVEREIGN ARCHIVE"; title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1; title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold; title.TextSize = 16

-- 🎚️ THE SOVEREIGN SLIDER (Speed Control)
local sliderFrame = Instance.new("Frame", main)
sliderFrame.Size = UDim2.new(0, 300, 0, 10); sliderFrame.Position = UDim2.new(0.5, -150, 0.4, 0)
sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50); sliderFrame.BorderSizePixel = 0

local sliderThumb = Instance.new("TextButton", sliderFrame)
sliderThumb.Size = UDim2.new(0, 20, 0, 20); sliderThumb.Position = UDim2.new(0.5, -10, 0.5, -10)
sliderThumb.BackgroundColor3 = NEBULA_DATA.AccentColor; sliderThumb.Text = ""

local speedLabel = Instance.new("TextLabel", main)
speedLabel.Text = "FLIGHT SPEED: 160"; speedLabel.Position = UDim2.new(0.5, -150, 0.4, -25)
speedLabel.Size = UDim2.new(0, 300, 0, 20); speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1,1,1); speedLabel.Font = Enum.Font.Gotham; speedLabel.TextSize = 14

local sliding = false
sliderThumb.MouseButton1Down:Connect(function() sliding = true end)
uis.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)

rs.RenderStepped:Connect(function()
    if sliding then
        local mPos = uis:GetMouseLocation().X
        local relPos = math.clamp((mPos - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
        sliderThumb.Position = UDim2.new(relPos, -10, 0.5, -10)
        NEBULA_DATA.FlightSpeed = math.floor(20 + (relPos * 280)) -- 20 to 300
        speedLabel.Text = "FLIGHT SPEED: " .. NEBULA_DATA.FlightSpeed
    end
end)

-- ⌨️ INTERFACE BINDINGS
m.KeyDown:Connect(function(k)
    local key = k:lower()
    if key == "l" then flightEnabled = not flightEnabled 
    elseif key == "z" then combatMode = "Orbit"; stalkerTarget = m.Target and m.Target.Parent:FindFirstChild("Humanoid") and m.Target.Parent
    elseif key == "x" then combatMode = "Glue"; stalkerTarget = m.Target and m.Target.Parent:FindFirstChild("Humanoid") and m.Target.Parent
    elseif key == "h" then combatMode = "None"; stalkerTarget = nil end
end)

-- Resizer Glyph (◢)
local resizer = Instance.new("TextButton", main); resizer.Text = "◢"; resizer.Size = UDim2.new(0, 25, 0, 25)
resizer.Position = UDim2.new(1, -25, 1, -25); resizer.BackgroundTransparency = 1
resizer.TextColor3 = NEBULA_DATA.AccentColor; resizer.TextSize = 20

local isResizing = false
resizer.MouseButton1Down:Connect(function() isResizing = true end)
uis.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then isResizing = false end end)
rs.RenderStepped:Connect(function()
    if isResizing then
        local mPos = uis:GetMouseLocation()
        main.Size = UDim2.new(0, math.clamp(mPos.X - main.AbsolutePosition.X, 400, 850), 0, math.clamp(mPos.Y - main.AbsolutePosition.Y, 300, 600))
    end
end)

print("--- 🌌 NEBULAX v1.2 SOVEREIGN DYNAMIC ARCHIVE LOCKED ---")
