-- [[ NEBULAX v4.1: OVERLORD ENGINE ]]
-- [[ OWNER: MAX | FEATURE: LINEAR SLIDER ENGINE ]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CG = game:GetService("CoreGui")
local TS = game:GetService("TweenService")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- [[ 1. CONFIG ]]
getgenv().Nebula = {
    Flags = {},
    Settings = {
        FlySpeed = 160, -- Default
        Sprint = 65
    },
    Theme = {
        Accent = Color3.fromRGB(0, 255, 200),
        Main = Color3.fromRGB(10, 10, 15),
        Side = Color3.fromRGB(15, 15, 22),
    }
}
local NB = getgenv().Nebula

-- [[ 2. UI BASE ]]
local Screen = Instance.new("ScreenGui", CG); Screen.Name = "NebulaX_V4.1"
local Main = Instance.new("Frame", Screen); Main.Size = UDim2.new(0, 600, 0, 400)
Main.Position = UDim2.new(0.5, -300, 0.5, -200); Main.BackgroundColor3 = NB.Theme.Main; Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", Main).Color = NB.Theme.Accent

local Container = Instance.new("ScrollingFrame", Main); Container.Size = UDim2.new(1, -180, 1, -20)
Container.Position = UDim2.new(0, 170, 0, 10); Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 2
local Layout = Instance.new("UIListLayout", Container); Layout.Padding = UDim.new(0, 10)

-- [[ 3. THE SLIDER ENGINE ]]
local Components = {}

function Components.CreateSlider(name, min, max, default, callback)
    local SliderFrame = Instance.new("Frame", Container); SliderFrame.Size = UDim2.new(1, -10, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 30); Instance.new("UICorner", SliderFrame)
    
    local Label = Instance.new("TextLabel", SliderFrame); Label.Size = UDim2.new(1, -10, 0, 25); Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1; Label.Text = name; Label.TextColor3 = Color3.new(0.8, 0.8, 0.8); Label.Font = Enum.Font.GothamBold; Label.TextSize = 11; Label.TextXAlignment = 0
    
    local ValueLabel = Instance.new("TextLabel", SliderFrame); ValueLabel.Size = UDim2.new(0, 50, 0, 25); ValueLabel.Position = UDim2.new(1, -60, 0, 0)
    ValueLabel.BackgroundTransparency = 1; ValueLabel.Text = tostring(default); ValueLabel.TextColor3 = NB.Theme.Accent; ValueLabel.Font = Enum.Font.GothamBold; ValueLabel.TextSize = 11
    
    local SliderBack = Instance.new("Frame", SliderFrame); SliderBack.Size = UDim2.new(1, -20, 0, 4); SliderBack.Position = UDim2.new(0, 10, 0, 35)
    SliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 45); Instance.new("UICorner", SliderBack)
    
    local SliderFill = Instance.new("Frame", SliderBack); SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = NB.Theme.Accent; Instance.new("UICorner", SliderFill)
    
    local function UpdateSlider()
        local percent = math.clamp((Mouse.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * percent)
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        ValueLabel.Text = tostring(value)
        callback(value)
    end
    
    local dragging = false
    SliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; UpdateSlider() end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then UpdateSlider() end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- [[ 4. DEPLOY COMPONENTS ]]
Components.CreateSlider("FLIGHT SPEED", 16, 500, NB.Settings.FlySpeed, function(val)
    NB.Settings.FlySpeed = val
end)

-- Flight Toggle
local FlightBtn = Instance.new("TextButton", Container); FlightBtn.Size = UDim2.new(1, -10, 0, 40)
FlightBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30); FlightBtn.Text = "  TOGGLE FLIGHT (L)"; FlightBtn.TextColor3 = Color3.new(0.7,0.7,0.7)
FlightBtn.Font = Enum.Font.GothamBold; FlightBtn.TextXAlignment = 0; Instance.new("UICorner", FlightBtn)

FlightBtn.MouseButton1Click:Connect(function()
    NB.Flags["Flight"] = not NB.Flags["Flight"]
    FlightBtn.TextColor3 = NB.Flags["Flight"] and NB.Theme.Accent or Color3.new(0.7, 0.7, 0.7)
end)

-- [[ 5. CORE LOOP ]]
RS.Heartbeat:Connect(function()
    local Char = LP.Character; if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
    if NB.Flags["Flight"] then
        Char.HumanoidRootPart.Velocity = (Mouse.Hit.p - Char.HumanoidRootPart.Position).Unit * NB.Settings.FlySpeed
    end
end)

-- [[ 6. DRAG LOGIC ]]
local drag, dStart, sPos
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; dStart = i.Position; sPos = Main.Position end end)
UIS.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
    local delta = i.Position - dStart
    Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)

print("--- 🌌 NEBULAX v4.1 | SLIDER ENGINE LOADED ---")
