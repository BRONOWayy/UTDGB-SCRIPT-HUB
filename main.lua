local P = game:GetService("Players")
local lp = P.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Cleanup old UI
if CoreGui:FindFirstChild("NebulaX_Elite_Final") then CoreGui.NebulaX_Elite_Final:Destroy() end

local NebulaX = Instance.new("ScreenGui", CoreGui)
NebulaX.Name = "NebulaX_Elite_Final"

-- [[ THEME ]]
local bg_color = Color3.fromRGB(20, 10, 40) 
local sidebar_color = Color3.fromRGB(12, 5, 25)
local accent_purple = Color3.fromRGB(150, 70, 255)
local text_color = Color3.fromRGB(255, 255, 255)

-- [[ MAIN UI ]]
local Main = Instance.new("Frame", NebulaX)
Main.Size = UDim2.new(0, 550, 0, 380)
Main.Position = UDim2.new(0.5, -275, 0.5, -190)
Main.BackgroundColor3 = bg_color
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = accent_purple

-- [[ SIDEBAR ]]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = sidebar_color
Instance.new("UICorner", Sidebar)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 80)
Title.Text = "NEB\nX"
Title.TextColor3 = accent_purple
Title.Font = Enum.Font.GothamBold
Title.TextSize = 30
Title.BackgroundTransparency = 1

-- [[ PAGE SYSTEM ]]
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -180, 1, -50)
Container.Position = UDim2.new(0, 170, 0, 40)
Container.BackgroundTransparency = 1

_G.Pages = {}
local function CreatePage(name, order)
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = (order == 1)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)
    _G.Pages[name] = Page

    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
    TabBtn.Position = UDim2.new(0.05, 0, 0, 90 + (order-1)*40)
    TabBtn.Text = name
    TabBtn.BackgroundColor3 = (order == 1) and accent_purple or Color3.fromRGB(30, 20, 50)
    TabBtn.TextColor3 = text_color
    TabBtn.Font = Enum.Font.GothamMedium
    Instance.new("UICorner", TabBtn)

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(_G.Pages) do p.Visible = false end
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(30, 20, 50) end
        end
        Page.Visible = true
        TabBtn.BackgroundColor3 = accent_purple
    end)
    return Page
end

-- Initialize Tabs
CreatePage("Home", 1)
CreatePage("Items/Farming", 2)
CreatePage("Auto Get", 3)
CreatePage("Performance", 4)
CreatePage("Settings", 5)

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.Text = "X"
Close.TextColor3 = Color3.new(1,0,0)
Close.BackgroundTransparency = 1
Close.MouseButton1Click:Connect(function() NebulaX:Destroy() end)








local R = game:GetService("RunService")
local lp = game:GetService("Players").LocalPlayer

_G.GlueConfig = {
    Enabled = false,
    CurrentTarget = nil,
    Ignore = {"FROM_THE_FOUNTAIN", "Rig", "Model", "Bone"} -- Filter based on your images
}

-- [[ UI INTEGRATION ]]
local farmTab = _G.Pages["Items/Farming"]

local GlueBtn = Instance.new("TextButton", farmTab)
GlueBtn.Size = UDim2.new(1, -10, 0, 45)
GlueBtn.Text = "CLOSEST GLUE: OFF"
GlueBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 70)
GlueBtn.TextColor3 = Color3.new(1,1,1)
GlueBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", GlueBtn)

GlueBtn.MouseButton1Click:Connect(function()
    _G.GlueConfig.Enabled = not _G.GlueConfig.Enabled
    GlueBtn.Text = "CLOSEST GLUE: " .. (_G.GlueConfig.Enabled and "ON" or "OFF")
    GlueBtn.BackgroundColor3 = _G.GlueConfig.Enabled and Color3.fromRGB(150, 70, 255) or Color3.fromRGB(40, 30, 70)
end)

-- [[ ENGINE ]]
local function getClosest()
    local closest, dist = nil, math.huge
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= lp.Character then
            local isIgnored = false
            for _, name in pairs(_G.GlueConfig.Ignore) do
                if v.Name:find(name) then isIgnored = true break end
            end

            if not isIgnored and v.Humanoid.Health > 0 then
                local targetHrp = v:FindFirstChild("HumanoidRootPart")
                if targetHrp then
                    local d = (hrp.Position - targetHrp.Position).Magnitude
                    if d < dist then
                        dist = d
                        closest = targetHrp
                    end
                end
            end
        end
    end
    return closest
end

R.Heartbeat:Connect(function()
    if not _G.GlueConfig.Enabled then return end
    local myHrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    
    local target = getClosest()
    if target and myHrp then
        target.CanCollide = false
        target.Velocity = Vector3.zero
        -- Glue directly to your position (Distance removed)
        target.CFrame = myHrp.CFrame 
    end
end)
