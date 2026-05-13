-- NebulaX: Ultimate Standalone Build
local P = game:GetService("Players")
local lp = P.LocalPlayer
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Clean existing UI
if CoreGui:FindFirstChild("NebulaX") then CoreGui.NebulaX:Destroy() end

local NebulaX = Instance.new("ScreenGui", CoreGui)
NebulaX.Name = "NebulaX"

-- [[ RGB GRADIENT SYSTEM ]]
local function ApplyRainbowBorder(object, thickness)
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
            rot = rot + 3
            grad.Rotation = rot
            task.wait(0.02)
        end
    end)
end

-- [[ MAIN HUB ]]
local Main = Instance.new("Frame", NebulaX)
Main.Size = UDim2.new(0, 420, 0, 280)
Main.Position = UDim2.new(0.5, -210, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
ApplyRainbowBorder(Main, 3)

-- [[ NINJA WIDGET ]]
local Widget = Instance.new("ImageButton", NebulaX)
Widget.Size = UDim2.new(0, 60, 0, 60)
Widget.Position = UDim2.new(0.05, 0, 0.2, 0)
Widget.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Widget.Image = "rbxassetid://13835032549" -- Ninja Icon
Widget.Visible = false
Widget.Draggable = true
Instance.new("UICorner", Widget).CornerRadius = UDim.new(0, 12)
ApplyRainbowBorder(Widget, 2.5)

-- [[ SIDEBAR ]]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
Instance.new("UICorner", Sidebar)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "NebulaX 🌌"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
Title.BackgroundTransparency = 1

-- [[ NAVIGATION ]]
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -135, 1, -60)
Container.Position = UDim2.new(0, 125, 0, 45)
Container.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name, order)
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = (order == 1)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)
    Pages[name] = Page

    local Tab = Instance.new("TextButton", Sidebar)
    Tab.Size = UDim2.new(0.9, 0, 0, 30)
    Tab.Position = UDim2.new(0.05, 0, 0, 55 + (order-1)*35)
    Tab.Text = name
    Tab.Font = Enum.Font.GothamSemibold
    Tab.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    Tab.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    Instance.new("UICorner", Tab)

    Tab.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)
end

local tabs = {"Home", "Items/Farming", "Auto Get", "Performance", "Settings", "Updates"}
for i, name in ipairs(tabs) do CreatePage(name, i) end

-- [[ GALACTIC GLUE BUTTON ]]
local GlueBtn = Instance.new("TextButton", Pages["Items/Farming"])
GlueBtn.Size = UDim2.new(1, -10, 0, 40)
GlueBtn.Text = "[ GALACTIC GLUE ]"
GlueBtn.TextColor3 = Color3.fromRGB(200, 160, 255)
GlueBtn.BackgroundColor3 = Color3.fromRGB(15, 12, 28)
GlueBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", GlueBtn)
ApplyRainbowBorder(GlueBtn, 2)

-- [[ WINDOW CONTROLS ]]
local Min = Instance.new("TextButton", Main)
Min.Size = UDim2.new(0, 26, 0, 26)
Min.Position = UDim2.new(1, -64, 0, 6)
Min.Text = "-"
Min.TextColor3 = Color3.new(1, 1, 1)
Min.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Instance.new("UICorner", Min)

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 26, 0, 26)
Close.Position = UDim2.new(1, -32, 0, 6)
Close.Text = "X"
Close.TextColor3 = Color3.new(1, 0, 0)
Close.BackgroundColor3 = Color3.fromRGB(25, 10, 10)
Instance.new("UICorner", Close)

-- [[ LOGIC ]]
Min.MouseButton1Click:Connect(function()
    Main.Visible = false
    Widget.Visible = true
end)

Widget.MouseButton1Click:Connect(function()
    Widget.Visible = false
    Main.Visible = true
end)

Close.MouseButton1Click:Connect(function()
    NebulaX:Destroy()
end)
