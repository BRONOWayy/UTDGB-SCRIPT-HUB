local P = game:GetService("Players")
local lp = P.LocalPlayer
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Cleanup
if CoreGui:FindFirstChild("NebulaX_Elite_Final") then CoreGui.NebulaX_Elite_Final:Destroy() end

local NebulaX = Instance.new("ScreenGui", CoreGui)
NebulaX.Name = "NebulaX_Elite_Final"
NebulaX.DisplayOrder = 9999

-- [[ THEME CONFIG ]]
local bg_color = Color3.fromRGB(20, 10, 40) 
local sidebar_color = Color3.fromRGB(12, 5, 25)
local accent_purple = Color3.fromRGB(150, 70, 255)
local text_color = Color3.fromRGB(255, 255, 255)

-- [[ MAIN HUB ]]
local Main = Instance.new("Frame", NebulaX)
Main.Size = UDim2.new(0, 550, 0, 380)
Main.Position = UDim2.new(0.5, -275, 0.5, -190)
Main.BackgroundColor3 = bg_color
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true -- Keeps things tidy when resizing
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Thickness = 2
MainStroke.Color = accent_purple

-- [[ RESIZE LOGIC ]]
local ResizeButton = Instance.new("Frame", Main)
ResizeButton.Size = UDim2.new(0, 20, 0, 20)
ResizeButton.Position = UDim2.new(1, -20, 1, -20)
ResizeButton.BackgroundTransparency = 1
ResizeButton.ZIndex = 10

local ResizeIcon = Instance.new("TextLabel", ResizeButton)
ResizeIcon.Size = UDim2.new(1, 0, 1, 0)
ResizeIcon.Text = "◢"
ResizeIcon.TextColor3 = accent_purple
ResizeIcon.TextSize = 18
ResizeIcon.BackgroundTransparency = 1

local dragging = false
ResizeButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UIS:GetMouseLocation()
        local relativePos = mousePos - Main.AbsolutePosition
        -- Set minimum constraints
        local newWidth = math.max(400, relativePos.X)
        local newHeight = math.max(300, relativePos.Y)
        Main.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- [[ SIDEBAR ]]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = sidebar_color
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

-- STACKED TITLE: NEB X
local TitleFrame = Instance.new("Frame", Sidebar)
TitleFrame.Size = UDim2.new(1, 0, 0, 100)
TitleFrame.BackgroundTransparency = 1

local NebLabel = Instance.new("TextLabel", TitleFrame)
NebLabel.Size = UDim2.new(1, 0, 0.5, 0)
NebLabel.Position = UDim2.new(0, 0, 0, 15)
NebLabel.Text = "NEB"
NebLabel.Font = Enum.Font.GothamBold
NebLabel.TextSize = 32
NebLabel.TextColor3 = accent_purple
NebLabel.BackgroundTransparency = 1

local XLabel = Instance.new("TextLabel", TitleFrame)
XLabel.Size = UDim2.new(1, 0, 0.5, 0)
XLabel.Position = UDim2.new(0, 0, 0.5, 0)
XLabel.Text = "X"
XLabel.Font = Enum.Font.GothamBold
XLabel.TextSize = 40
XLabel.TextColor3 = text_color
XLabel.BackgroundTransparency = 1

-- [[ PAGES CONTAINER ]]
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -180, 1, -50)
Container.Position = UDim2.new(0, 170, 0, 40)
Container.BackgroundTransparency = 1

local Pages = {}
local function CreateTab(name, order)
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = (order == 1)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = accent_purple
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)
    Pages[name] = Page

    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(0.85, 0, 0, 40)
    TabBtn.Position = UDim2.new(0.075, 0, 0, 110 + (order-1)*48)
    TabBtn.Text = name
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.TextSize = 14
    TabBtn.TextColor3 = text_color
    TabBtn.BackgroundColor3 = (order == 1) and accent_purple or Color3.fromRGB(35, 20, 60)
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(35, 20, 60) end
        end
        Page.Visible = true
        TabBtn.BackgroundColor3 = accent_purple
    end)
end

local tabs = {"Home", "Items/Farming", "Auto Get", "Performance", "Settings", "Updates"}
for i, name in ipairs(tabs) do CreateTab(name, i) end

-- [[ NINJA WIDGET FIX ]]
local Widget = Instance.new("ImageButton", NebulaX)
Widget.Size = UDim2.new(0, 55, 0, 55) 
Widget.Position = UDim2.new(0.02, 0, 0.45, 0)
Widget.BackgroundColor3 = sidebar_color
Widget.Image = "rbxassetid://13835032549" -- Updated ID
Widget.Visible = false
Widget.Draggable = true
Instance.new("UICorner", Widget).CornerRadius = UDim.new(0, 10)
local WidgetStroke = Instance.new("UIStroke", Widget)
WidgetStroke.Thickness = 2
WidgetStroke.Color = accent_purple

-- [[ ARE YOU SURE MENU ]]
local ConfirmMenu = Instance.new("Frame", NebulaX)
ConfirmMenu.Size = UDim2.new(0, 240, 0, 120)
ConfirmMenu.Position = UDim2.new(0.5, -120, 0.5, -60)
ConfirmMenu.BackgroundColor3 = sidebar_color
ConfirmMenu.Visible = false
ConfirmMenu.ZIndex = 500
Instance.new("UICorner", ConfirmMenu)
local ConfirmStroke = Instance.new("UIStroke", ConfirmMenu)
ConfirmStroke.Color = Color3.fromRGB(255, 50, 50)
ConfirmStroke.Thickness = 2

local ConfirmLabel = Instance.new("TextLabel", ConfirmMenu)
ConfirmLabel.Size = UDim2.new(1, 0, 0.5, 0)
ConfirmLabel.Text = "Are you sure?"
ConfirmLabel.TextColor3 = text_color
ConfirmLabel.Font = Enum.Font.GothamBold
ConfirmLabel.TextSize = 18
ConfirmLabel.BackgroundTransparency = 1
ConfirmLabel.ZIndex = 501

local Yes = Instance.new("TextButton", ConfirmMenu)
Yes.Size = UDim2.new(0.4, 0, 0, 35)
Yes.Position = UDim2.new(0.07, 0, 0.6, 0)
Yes.Text = "Kill UI"
Yes.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
Yes.TextColor3 = text_color
Yes.ZIndex = 501
Instance.new("UICorner", Yes)

local No = Instance.new("TextButton", ConfirmMenu)
No.Size = UDim2.new(0.4, 0, 0, 35)
No.Position = UDim2.new(0.53, 0, 0.6, 0)
No.Text = "Cancel"
No.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
No.TextColor3 = text_color
No.ZIndex = 501
Instance.new("UICorner", No)

-- [[ TOP CONTROLS ]]
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 35, 0, 35)
Close.Position = UDim2.new(1, -45, 0, 10)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 50, 50)
Close.BackgroundTransparency = 1
Close.Font = Enum.Font.GothamBold
Close.TextSize = 20

local Min = Instance.new("TextButton", Main)
Min.Size = UDim2.new(0, 35, 0, 35)
Min.Position = UDim2.new(1, -80, 0, 10)
Min.Text = "-"
Min.TextColor3 = text_color
Min.BackgroundTransparency = 1
Min.Font = Enum.Font.GothamBold
Min.TextSize = 25

-- [[ CONTROLS LOGIC ]]
Min.MouseButton1Click:Connect(function()
    Main.Visible = false
    Widget.Visible = true
end)

Widget.MouseButton1Click:Connect(function()
    Main.Visible = true
    Widget.Visible = false
end)

Close.MouseButton1Click:Connect(function()
    ConfirmMenu.Visible = true
end)

No.MouseButton1Click:Connect(function()
    ConfirmMenu.Visible = false
end)

Yes.MouseButton1Click:Connect(function()
    NebulaX:Destroy()
end)

local P = game:GetService("Players")
local lp = P.LocalPlayer
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local R = game:GetService("RunService")

-- Cleanup
if CoreGui:FindFirstChild("NebulaX_Elite_Final") then CoreGui.NebulaX_Elite_Final:Destroy() end

local NebulaX = Instance.new("ScreenGui", CoreGui)
NebulaX.Name = "NebulaX_Elite_Final"
NebulaX.DisplayOrder = 9999

-- [[ CONFIG ]]
local conf = {
    glueMode = "None", -- "Persistent", "AutoChain", or "None"
    dist = 5,
    currentTarget = nil,
    ignoreList = {"FROM_THE_FOUNTAIN", "Rig", "Model", "Bone"} -- Filtered based on your UI images
}

local bg_color = Color3.fromRGB(20, 10, 40) 
local sidebar_color = Color3.fromRGB(12, 5, 25)
local accent_purple = Color3.fromRGB(150, 70, 255)
local text_color = Color3.fromRGB(255, 255, 255)

-- [[ LOGIC ENGINE ]]
local function isAlive(model)
    if model and model:FindFirstChild("Humanoid") and model.Humanoid.Health > 0 then
        return true
    end
    return false
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
    local myHrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp or conf.glueMode == "None" then return end

    -- Mode 1: Persistent (Target one, stay until dead)
    if conf.glueMode == "Persistent" then
        if not isAlive(conf.currentTarget) then
            conf.currentTarget = getClosest()
        end
    -- Mode 2: Auto-Chain (Always jump to the absolute closest)
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

-- [[ UI CONSTRUCTION ]]
local Main = Instance.new("Frame", NebulaX)
Main.Size = UDim2.new(0, 550, 0, 380)
Main.Position = UDim2.new(0.5, -275, 0.5, -190)
Main.BackgroundColor3 = bg_color
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = accent_purple

-- Sidebar Title (Stacked NEB X)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = sidebar_color
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local Neb = Instance.new("TextLabel", Sidebar)
Neb.Size = UDim2.new(1, 0, 0, 50)
Neb.Position = UDim2.new(0,0,0,10)
Neb.Text = "NEB"
Neb.TextColor3 = accent_purple
Neb.Font = Enum.Font.GothamBold
Neb.TextSize = 30
Neb.BackgroundTransparency = 1

local X = Instance.new("TextLabel", Sidebar)
X.Size = UDim2.new(1, 0, 0, 50)
X.Position = UDim2.new(0,0,0,45)
X.Text = "X"
X.TextColor3 = text_color
X.Font = Enum.Font.GothamBold
X.TextSize = 38
X.BackgroundTransparency = 1

-- Page System
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -180, 1, -50)
Container.Position = UDim2.new(0, 170, 0, 40)
Container.BackgroundTransparency = 1

local FarmPage = Instance.new("ScrollingFrame", Container)
FarmPage.Size = UDim2.new(1, 0, 1, 0)
FarmPage.BackgroundTransparency = 1
FarmPage.ScrollBarThickness = 0
local Layout = Instance.new("UIListLayout", FarmPage)
Layout.Padding = UDim.new(0, 10)

-- [[ FARMING BUTTONS ]]
local function MakeModeBtn(name, mode)
    local b = Instance.new("TextButton", FarmPage)
    b.Size = UDim2.new(1, -10, 0, 45)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(35, 20, 60)
    b.TextColor3 = text_color
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    
    R.RenderStepped:Connect(function()
        b.BackgroundColor3 = (conf.glueMode == mode) and accent_purple or Color3.fromRGB(35, 20, 60)
    end)

    b.MouseButton1Click:Connect(function()
        if conf.glueMode == mode then
            conf.glueMode = "None"
            conf.currentTarget = nil
        else
            conf.glueMode = mode
        end
    end)
end

MakeModeBtn("PERSISTENT GLUE (Wait for Death)", "Persistent")
MakeModeBtn("AUTO-CHAIN GLUE (Closest)", "AutoChain")

-- Distance Input
local DistBox = Instance.new("TextBox", FarmPage)
DistBox.Size = UDim2.new(1, -10, 0, 40)
DistBox.Text = "Distance: " .. conf.dist
DistBox.BackgroundColor3 = Color3.fromRGB(15, 10, 30)
DistBox.TextColor3 = text_color
Instance.new("UICorner", DistBox)
DistBox.FocusLost:Connect(function()
    conf.dist = tonumber(DistBox.Text:match("%d+")) or 5
    DistBox.Text = "Distance: " .. conf.dist
end)

-- Window Controls
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -40, 0, 10)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 50, 50)
Close.BackgroundTransparency = 1
Close.MouseButton1Click:Connect(function() NebulaX:Destroy() end)
