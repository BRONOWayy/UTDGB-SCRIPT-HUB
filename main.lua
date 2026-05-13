-- [[ NebulaX: Developed by Max ]]
local P = game:GetService("Players")
local lp = P.LocalPlayer
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Cleanup
if CoreGui:FindFirstChild("NebulaX") then CoreGui.NebulaX:Destroy() end

local NebulaX = Instance.new("ScreenGui", CoreGui)
NebulaX.Name = "NebulaX"

-- [[ FLOWING GRADIENT SYSTEM ]]
local function ApplyFlowingBorder(object, thickness)
    local stroke = Instance.new("UIStroke", object)
    stroke.Thickness = thickness or 2.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    local grad = Instance.new("UIGradient", stroke)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),   -- Sky Blue
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(130, 0, 255)), -- Purple
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 50, 255))     -- Blue
    })

    task.spawn(function()
        local rot = 0
        while NebulaX.Parent do
            rot = rot + 2.5
            grad.Rotation = rot
            task.wait(0.02)
        end
    end)
end

-- [[ MAIN HUB ]]
local Main = Instance.new("Frame", NebulaX)
Main.Size = UDim2.new(0, 400, 0, 260) -- Compact Size
Main.Position = UDim2.new(0.5, -200, 0.5, -130)
Main.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
ApplyFlowingBorder(Main, 3)

-- [[ NINJA LOGO WIDGET ]]
local Widget = Instance.new("ImageButton", NebulaX)
Widget.Size = UDim2.new(0, 60, 0, 60)
Widget.Position = UDim2.new(0.02, 0, 0.15, 0)
Widget.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Widget.Image = "rbxassetid://13835032549" -- Ninja Icon
Widget.Visible = false
Widget.Draggable = true
Instance.new("UICorner", Widget).CornerRadius = UDim.new(0, 12)
ApplyFlowingBorder(Widget, 2.5)

-- [[ SIDEBAR ]]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 110, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(4, 4, 8)
Instance.new("UICorner", Sidebar)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "NebulaX 🌌"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 16
Title.BackgroundTransparency = 1

-- [[ CONTROLS ]]
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 24, 0, 24)
Close.Position = UDim2.new(1, -30, 0, 6)
Close.Text = "X"
Close.TextColor3 = Color3.new(1, 0, 0)
Close.BackgroundColor3 = Color3.fromRGB(25, 5, 5)
Instance.new("UICorner", Close)
ApplyFlowingBorder(Close, 1.5)

local Min = Instance.new("TextButton", Main)
Min.Size = UDim2.new(0, 24, 0, 24)
Min.Position = UDim2.new(1, -60, 0, 6)
Min.Text = "-"
Min.TextColor3 = Color3.new(1, 1, 1)
Min.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Instance.new("UICorner", Min)
ApplyFlowingBorder(Min, 1.5)

-- [[ PAGES ]]
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -125, 1, -55)
Container.Position = UDim2.new(0, 115, 0, 45)
Container.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name, order)
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = (order == 1)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    Pages[name] = Page

    local Tab = Instance.new("TextButton", Sidebar)
    Tab.Size = UDim2.new(0.9, 0, 0, 30)
    Tab.Position = UDim2.new(0.05, 0, 0, 45 + (order-1)*35)
    Tab.Text = name
    Tab.Font = Enum.Font.Gotham
    Tab.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    Tab.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    Instance.new("UICorner", Tab)

    Tab.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)
end

local tabs = {"Home", "Items/Farming", "Auto Get", "Performance", "Settings", "Updates"}
for i, name in ipairs(tabs) do CreatePage(name, i) end

-- [[ GALACTIC GLUE ]]
local GlueBtn = Instance.new("TextButton", Pages["Items/Farming"])
GlueBtn.Size = UDim2.new(1, -10, 0, 38)
GlueBtn.Text = "[ GALACTIC GLUE ]"
GlueBtn.TextColor3 = Color3.fromRGB(180, 130, 255)
GlueBtn.BackgroundColor3 = Color3.fromRGB(15, 12, 25)
GlueBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", GlueBtn)
ApplyFlowingBorder(GlueBtn, 2) -- High contrast border

-- [[ KILL CONFIRMATION ]]
local KillBox = Instance.new("Frame", NebulaX)
KillBox.Size = UDim2.new(0, 180, 0, 90)
KillBox.Position = UDim2.new(0.5, -90, 0.5, -45)
KillBox.BackgroundColor3 = Color3.fromRGB(20, 5, 5)
KillBox.Visible = false
Instance.new("UICorner", KillBox)
ApplyFlowingBorder(KillBox, 2)

local Yes = Instance.new("TextButton", KillBox)
Yes.Size = UDim2.new(0.4, 0, 0, 25)
Yes.Position = UDim2.new(0.05, 0, 0.6, 0)
Yes.Text = "Kill"
Yes.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
Instance.new("UICorner", Yes)

local No = Instance.new("TextButton", KillBox)
No.Size = UDim2.new(0.4, 0, 0, 25)
No.Position = UDim2.new(0.55, 0, 0.6, 0)
No.Text = "Cancel"
No.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", No)

-- [[ LOGIC ]]
Close.MouseButton1Click:Connect(function() KillBox.Visible = true end)
No.MouseButton1Click:Connect(function() KillBox.Visible = false end)
Yes.MouseButton1Click:Connect(function() NebulaX:Destroy() end)

Min.MouseButton1Click:Connect(function()
    Main.Visible = false
    Widget.Visible = true
end)

Widget.MouseButton1Click:Connect(function()
    Widget.Visible = false
    Main.Visible = true
end)
