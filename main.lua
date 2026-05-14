-- [[ NEBULAX v2.1: PRO ENGINE (COMPACT PATCH) ]]
-- [[ OWNER: MAX | ADVANCED EXECUTOR BUILD ]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CG = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- [[ 1. PRO STATE & CONFIGURATION ]]
getgenv().NebulaPro = {
    Flight = false, Speed = 160, Noclip = false, God = false,
    Mode = "None", Target = nil, OrbitS = 5, Radius = 20,
    Aimbot = false, AimPart = "Head", AimSmooth = 0.5,
    ESPBoxes = false, ESPTracers = false,
    Accent = Color3.fromRGB(0, 255, 200),
    BG = Color3.fromRGB(10, 10, 15)
}
local PRO = getgenv().NebulaPro

-- [[ 2. ADVANCED VAULT SECURITY ]]
local function DeepSecure()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    local oldIndex = mt.__index

    mt.__namecall = newcclosure(function(self, ...)
        local m = getnamecallmethod()
        if m == "Kick" or m == "kick" then return task.wait(9e9) end
        if m == "FireServer" and tostring(self):lower():find("report") then return nil end
        return oldNamecall(self, ...)
    end)
    
    mt.__index = newcclosure(function(t, k)
        if t == CG and k == "NebulaX_Pro" then return nil end
        return oldIndex(t, k)
    end)
    setreadonly(mt, true)
end
pcall(DeepSecure)

-- [[ 3. CUSTOM NOTIFICATION ENGINE ]]
local function Notify(text)
    local sg = CG:FindFirstChild("NebulaX_Pro")
    if not sg then return end
    local notif = Instance.new("TextLabel", sg)
    notif.Size = UDim2.new(0, 200, 0, 35); notif.Position = UDim2.new(1, 10, 1, -45)
    notif.BackgroundColor3 = Color3.fromRGB(20, 20, 25); notif.TextColor3 = PRO.Accent
    notif.Text = "  [PRO]: " .. text; notif.Font = Enum.Font.GothamBold; notif.TextXAlignment = 0
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 6)
    
    local ts = game:GetService("TweenService")
    ts:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(1, -210, 1, -45)}):Play()
    task.delay(3, function()
        ts:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(1, 10, 1, -45)}):Play()
        task.wait(0.3); notif:Destroy()
    end)
end

-- [[ 4. COMPACT PRO UI ARCHITECTURE ]]
local Screen = Instance.new("ScreenGui", CG); Screen.Name = "NebulaX_Pro"
-- LOWERED DEFAULT SIZE TO 450x300
local Main = Instance.new("Frame", Screen); Main.Size = UDim2.new(0, 450, 0, 300); Main.Position = UDim2.new(0.5, -225, 0.5, -150)
Main.BackgroundColor3 = PRO.BG; Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = PRO.Accent; Stroke.Thickness = 1

local Side = Instance.new("Frame", Main); Side.Size = UDim2.new(0, 140, 1, 0); Side.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", Side).CornerRadius = UDim.new(0, 8)
local Logo = Instance.new("TextLabel", Side); Logo.Size = UDim2.new(1, 0, 0, 50); Logo.Text = "NEBULAX"; Logo.TextColor3 = PRO.Accent
Logo.Font = Enum.Font.GothamBlack; Logo.TextSize = 18; Logo.BackgroundTransparency = 1
local User = Instance.new("TextLabel", Side); User.Size = UDim2.new(1, 0, 0, 25); User.Position = UDim2.new(0,0,1,-25)
User.Text = "OWNER: MAX"; User.TextColor3 = PRO.Accent; User.Font = Enum.Font.GothamBold; User.TextSize = 12; User.BackgroundTransparency = 1

local Scroll = Instance.new("ScrollingFrame", Main); Scroll.Size = UDim2.new(1, -150, 1, -10); Scroll.Position = UDim2.new(0, 145, 0, 5)
Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 2; Scroll.CanvasSize = UDim2.new(0,0,2,0)
local List = Instance.new("UIListLayout", Scroll); List.Padding = UDim.new(0, 5)

-- [[ 5. PRO COMPONENT BUILDER ]]
local function Toggle(name, var, callback)
    local b = Instance.new("TextButton", Scroll); b.Size = UDim2.new(1, -10, 0, 35); b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    b.Text = "  " .. name; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextXAlignment = 0; b.TextSize = 12; Instance.new("UICorner", b)
    local s = Instance.new("Frame", b); s.Size = UDim2.new(0, 4, 1, 0); s.Position = UDim2.new(1,-4,0,0); s.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.MouseButton1Click:Connect(function()
        PRO[var] = not PRO[var]
        s.BackgroundColor3 = PRO[var] and PRO.Accent or Color3.fromRGB(50,50,50)
        b.TextColor3 = PRO[var] and PRO.Accent or Color3.new(1,1,1)
        Notify(name .. " set to " .. tostring(PRO[var]))
        if callback then callback(PRO[var]) end
    end)
end

Toggle("FLIGHT [L]", "Flight")
Toggle("NOCLIP [K]", "Noclip")
Toggle("AIMBOT", "Aimbot")
Toggle("ESP BOXES", "ESPBoxes")

-- [[ 6. EXECUTOR DRAWING API ESP ]]
local Drawings = {}
RS.RenderStepped:Connect(function()
    if PRO.ESPBoxes then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
                if vis then
                    if not Drawings[p.Name] then
                        Drawings[p.Name] = Drawing.new("Square")
                        Drawings[p.Name].Color = PRO.Accent
                        Drawings[p.Name].Thickness = 1
                        Drawings[p.Name].Filled = false
                    end
                    local scale = 1000 / pos.Z
                    Drawings[p.Name].Size = Vector2.new(40 * scale, 60 * scale)
                    Drawings[p.Name].Position = Vector2.new(pos.X - Drawings[p.Name].Size.X/2, pos.Y - Drawings[p.Name].Size.Y/2)
                    Drawings[p.Name].Visible = true
                else
                    if Drawings[p.Name] then Drawings[p.Name].Visible = false end
                end
            elseif Drawings[p.Name] then Drawings[p.Name].Visible = false end
        end
    else
        for k, v in pairs(Drawings) do v.Visible = false end
    end
end)

-- [[ 7. CAMERA AIMBOT & MOVEMENT ]]
RS.Stepped:Connect(function()
    local c = LP.Character; if not c then return end
    if PRO.Flight then c.HumanoidRootPart.Velocity = (Mouse.Hit.p - c.HumanoidRootPart.Position).Unit * PRO.Speed end
    if PRO.Noclip then for _,v in pairs(c:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    if PRO.Aimbot and PRO.Target and PRO.Target:FindFirstChild(PRO.AimPart) then
        local tPos = PRO.Target[PRO.AimPart].Position
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, tPos), PRO.AimSmooth)
    end
end)

-- [[ 8. ADVANCED BINDS & RESIZER ]]
UIS.InputBegan:Connect(function(i, gpe)
    if gpe then return end
    local k = i.KeyCode.Name:lower()
    
    if k == "rightshift" then Main.Visible = not Main.Visible -- HIDE UI BIND
    elseif k == "l" then PRO.Flight = not PRO.Flight; Notify("Flight: " .. tostring(PRO.Flight))
    elseif k == "k" then PRO.Noclip = not PRO.Noclip; Notify("Noclip: " .. tostring(PRO.Noclip))
    elseif k == "z" then PRO.Mode = "Orbit"; PRO.Target = (Mouse.Target and Mouse.Target.Parent:FindFirstChild("Humanoid") and Mouse.Target.Parent); Notify("Orbit Target")
    elseif k == "x" then PRO.Mode = "Glue"; PRO.Target = (Mouse.Target and Mouse.Target.Parent:FindFirstChild("Humanoid") and Mouse.Target.Parent); Notify("Glue Target")
    elseif k == "h" then PRO.Mode = "None"; PRO.Target = nil; Notify("Halted")
    end
end)

local Rez = Instance.new("TextButton", Main); Rez.Size = UDim2.new(0,25,0,25); Rez.Position = UDim2.new(1,-25,1,-25)
Rez.Text = "◢"; Rez.TextColor3 = PRO.Accent; Rez.BackgroundTransparency = 1; Rez.TextSize = 20
local drg = false; Rez.MouseButton1Down:Connect(function() drg = true end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drg = false end end)
RS.RenderStepped:Connect(function()
    if drg then
        local m = UIS:GetMouseLocation()
        -- CHANGED MINIMUM SIZE TO 250x200
        Main.Size = UDim2.new(0, math.clamp(m.X - Main.AbsolutePosition.X, 250, 800), 0, math.clamp(m.Y - Main.AbsolutePosition.Y, 200, 600))
    end
end)

-- Dragging logic for the top bar
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = Main.Position
    end
end)
Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

Notify("PRO ENGINE COMPACT DEPLOYED")
