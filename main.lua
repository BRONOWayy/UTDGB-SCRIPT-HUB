local P = game:GetService("Players")
local lp = P.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local R = game:GetService("RunService")

-- Cleanup old UI
if CoreGui:FindFirstChild("NebulaX_Elite_Final") then CoreGui.NebulaX_Elite_Final:Destroy() end

local NebulaX = Instance.new("ScreenGui", CoreGui)
NebulaX.Name = "NebulaX_Elite_Final"

local conf = {
    glueMode = "None", 
    dist = 5,
    currentTarget = nil,
    ignoreList = {"FROM_THE_FOUNTAIN", "Rig", "Model", "Bone"} 
}

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

local Pages = {}
local function CreatePage(name, order)
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = (order == 1)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)
    Pages[name] = Page

    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
    TabBtn.Position = UDim2.new(0.05, 0, 0, 90 + (order-1)*40)
    TabBtn.Text = name
    TabBtn.BackgroundColor3 = (order == 1) and accent_purple or Color3.fromRGB(30, 20, 50)
    TabBtn.TextColor3 = text_color
    TabBtn.Font = Enum.Font.GothamMedium
    Instance.new("UICorner", TabBtn)

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(30, 20, 50) end
        end
        Page.Visible = true
        TabBtn.BackgroundColor3 = accent_purple
    end)
    return Page
end

local home = CreatePage("Home", 1)
local farm = CreatePage("Items/Farming", 2)
local aget = CreatePage("Auto Get", 3)
local perf = CreatePage("Performance", 4)
local sett = CreatePage("Settings", 5)

-- [[ FARMING CONTENT ]]
local function ModeBtn(name, mode)
    local b = Instance.new("TextButton", farm)
    b.Size = UDim2.new(1, -10, 0, 45)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(40, 30, 70)
    b.TextColor3 = text_color
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        conf.glueMode = (conf.glueMode == mode) and "None" or mode
    end)

    R.RenderStepped:Connect(function()
        b.BackgroundColor3 = (conf.glueMode == mode) and accent_purple or Color3.fromRGB(40, 30, 70)
    end)
end

ModeBtn("PERSISTENT GLUE (Wait for Death)", "Persistent")
ModeBtn("AUTO-CHAIN GLUE (Closest)", "AutoChain")

local DistBox = Instance.new("TextBox", farm)
DistBox.Size = UDim2.new(1, -10, 0, 40)
DistBox.Text = "Distance: " .. conf.dist
DistBox.BackgroundColor3 = Color3.fromRGB(15, 10, 30)
DistBox.TextColor3 = text_color
Instance.new("UICorner", DistBox)
DistBox.FocusLost:Connect(function()
    conf.dist = tonumber(DistBox.Text:match("%d+")) or 5
    DistBox.Text = "Distance: " .. conf.dist
end)

-- [[ LOGIC ENGINE ]]
local function isAlive(model)
    return model and model:FindFirstChild("Humanoid") and model.Humanoid.Health > 0
end

local function getClosest()
    local closest, dist = nil, math.huge
    local myHrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp then return nil end

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= lp.Character then
            local isIgnored = false
            for _, name in pairs(conf.ignoreList) do
                if v.Name:find(name) then isIgnored = true break end
            end

            if not isIgnored and v.Humanoid.Health > 0 then
                local hrp = v:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local d = (myHrp.Position - hrp.Position).Magnitude
                    if d < dist then
                        dist = d
                        closest = v
                    end
                end
            end
        end
    end
    return closest
end

R.Heartbeat:Connect(function()
    if conf.glueMode == "None" then return end
    local myHrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end

    if conf.glueMode == "Persistent" then
        if not isAlive(conf.currentTarget) then conf.currentTarget = getClosest() end
    elseif conf.glueMode == "AutoChain" then
        conf.currentTarget = getClosest()
    end

    if conf.currentTarget and conf.currentTarget:FindFirstChild("HumanoidRootPart") then
        local th = conf.currentTarget.HumanoidRootPart
        th.CanCollide = false
        th.Velocity = Vector3.zero
        th.CFrame = myHrp.CFrame * CFrame.new(0, 0, -conf.dist)
    end
end)

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.Text = "X"
Close.TextColor3 =
