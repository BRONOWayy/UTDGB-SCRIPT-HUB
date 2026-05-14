-- [[ NEBULAX v2.2: MICRO-SOVEREIGN HUB ]]
-- [[ OWNER: MAX | ULTRA-COMPACT BUILD ]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CG = game:GetService("CoreGui")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- [[ 1. CONFIG ]]
getgenv().NebulaPro = {
    Flight = false, Speed = 160, Noclip = false,
    Mode = "None", Target = nil,
    Accent = Color3.fromRGB(0, 255, 200),
    BG = Color3.fromRGB(10, 10, 15)
}
local PRO = getgenv().NebulaPro

-- [[ 2. UI ARCHITECTURE (THE MICRO-FRAME) ]]
local Screen = Instance.new("ScreenGui", CG); Screen.Name = "NebulaX_Micro"

-- BOOTS AT 300x200 (TRUE COMPACT)
local Main = Instance.new("Frame", Screen); Main.Size = UDim2.new(0, 300, 0, 200)
Main.Position = UDim2.new(0.5, -150, 0.5, -100); Main.BackgroundColor3 = PRO.BG
Main.BorderSizePixel = 0; Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = PRO.Accent; Stroke.Thickness = 1

-- Minimal Header
local Header = Instance.new("Frame", Main); Header.Size = UDim2.new(1, 0, 0, 25); Header.BackgroundTransparency = 1
local Title = Instance.new("TextLabel", Header); Title.Size = UDim2.new(1, -10, 1, 0); Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "NEBULAX v2.2 | MICRO"; Title.TextColor3 = PRO.Accent; Title.Font = Enum.Font.GothamBold; Title.TextSize = 12; Title.TextXAlignment = 0; Title.BackgroundTransparency = 1

-- Scrolling Body
local Scroll = Instance.new("ScrollingFrame", Main); Scroll.Size = UDim2.new(1, -10, 1, -55); Scroll.Position = UDim2.new(0, 5, 0, 30)
Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 2; Scroll.CanvasSize = UDim2.new(0,0,2,0)
local List = Instance.new("UIListLayout", Scroll); List.Padding = UDim.new(0, 4)

-- [[ 3. COMPACT BUTTON FACTORY ]]
local function TinyToggle(name, var)
    local b = Instance.new("TextButton", Scroll); b.Size = UDim2.new(1, -5, 0, 30); b.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    b.Text = "  " .. name; b.TextColor3 = Color3.new(0.8, 0.8, 0.8); b.Font = Enum.Font.GothamBold; b.TextSize = 10; b.TextXAlignment = 0; Instance.new("UICorner", b)
    local s = Instance.new("Frame", b); s.Size = UDim2.new(0, 3, 1, 0); s.Position = UDim2.new(1, -3, 0, 0); s.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    
    b.MouseButton1Click:Connect(function()
        PRO[var] = not PRO[var]
        s.BackgroundColor3 = PRO[var] and PRO.Accent or Color3.fromRGB(40, 40, 40)
        b.TextColor3 = PRO[var] and PRO.Accent or Color3.new(0.8, 0.8, 0.8)
    end)
end

TinyToggle("FLIGHT (L)", "Flight")
TinyToggle("NOCLIP (K)", "Noclip")

-- Footer
local Foot = Instance.new("TextLabel", Main); Foot.Size = UDim2.new(1, 0, 0, 20); Foot.Position = UDim2.new(0, 0, 1, -20)
Foot.Text = "OWNER: MAX"; Foot.TextColor3 = Color3.fromRGB(100, 100, 100); Foot.Font = Enum.Font.GothamBold; Foot.TextSize = 10; Foot.BackgroundTransparency = 1

-- [[ 4. THE ENGINES ]]
RS.Stepped:Connect(function()
    local c = LP.Character; if not c or not c:FindFirstChild("HumanoidRootPart") then return end
    if PRO.Flight then c.HumanoidRootPart.Velocity = (Mouse.Hit.p - c.HumanoidRootPart.Position).Unit * PRO.Speed end
    if PRO.Noclip then for _,v in pairs(c:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
end)

-- [[ 5. COMPACT CONTROLS ]]
UIS.InputBegan:Connect(function(i, gpe)
    if gpe then return end
    local k = i.KeyCode.Name:lower()
    if k == "rightshift" then Main.Visible = not Main.Visible
    elseif k == "l" then PRO.Flight = not PRO.Flight
    elseif k == "k" then PRO.Noclip = not PRO.Noclip
    end
end)

-- Simple Dragging
local drag, start, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; start = input.Position; startPos = Main.Position end
end)
UIS.InputChanged:Connect(function(input)
    if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - start
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)

print("--- ✅ NEBULAX MICRO DEPLOYED ---")
