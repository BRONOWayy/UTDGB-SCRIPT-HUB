-- [[ NebulaX Hub - Created by Max ]]
local P = game:GetService("Players")
local lp = P.LocalPlayer
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("NebulaX") then CoreGui.NebulaX:Destroy() end

local NebulaX = Instance.new("ScreenGui", CoreGui)
NebulaX.Name = "NebulaX"

-- [[ THEME COLORS ]]
local color1 = Color3.fromRGB(0, 170, 255)   -- Sky Blue
local color2 = Color3.fromRGB(170, 0, 255) -- Purple
local color3 = Color3.fromRGB(0, 80, 255)  -- Deep Blue

-- [[ GRADIENT ENGINE ]]
local function MakeFancy(object)
    local stroke = Instance.new("UIStroke", object)
    stroke.Thickness = 2.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    local grad = Instance.new("UIGradient", stroke)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(0.5, color2),
        ColorSequenceKeypoint.new(1, color3)
    })

    task.spawn(function()
        while NebulaX.Parent do
            grad.Rotation = grad.Rotation + 2
            task.wait(0.02)
        end
    end)
end

-- [[ MAIN FRAME ]]
local Main = Instance.new("Frame", NebulaX)
Main.Size = UDim2.new(0, 400, 0, 260) -- Smaller & Compact
Main.Position = UDim2.new(0.5, -200, 0.5, -130)
Main.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
MakeFancy(Main)

-- [[ MINIMIZED SQUARE ]]
local Widget = Instance.new("TextButton", NebulaX)
Widget.Size = UDim2.new(0, 55, 0, 55)
Widget.Position = UDim2.new(0.05, 0, 0.1, 0)
Widget.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Widget.Text = "🌌"
Widget.TextSize = 25
Widget.Visible = false
Widget.Draggable = true
Instance.new("UICorner", Widget).CornerRadius = UDim.new(0, 12)
MakeFancy(Widget)

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

-- [[ TOP CONTROLS ]]
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 24, 0, 24)
Close.Position = UDim2.new(1, -30, 0, 6)
Close.Text = "X"
Close.TextColor3 = Color3.new(1, 0, 0)
Close.BackgroundColor3 = Color3.fromRGB(20, 5, 5)
Instance.new("UICorner", Close)
MakeFancy(Close)

local Min = Instance.new("TextButton", Main)
Min.Size = UDim2.new(0, 24, 0, 24)
Min.Position = UDim2.new(1, -60, 0, 6)
Min.Text = "-"
Min.TextColor3 = Color3.new(1, 1, 1)
Min.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Instance.new("UICorner", Min)
MakeFancy(Min)

-- [[ TAB SYSTEM ]]
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -125, 1, -50)
Container.Position = UDim2.new(0, 118, 0, 40)
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
    Tab.Size = UDim2.new(0.9, 0, 0, 28)
    Tab.Position = UDim2.new(0.05, 0, 0, 45 + (order-1)*32)
    Tab.Text = name
    Tab.Font = Enum.Font.Gotham
    Tab.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    Tab.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    Instance.new("UICorner", Tab)

    Tab.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)
end

CreatePage("Home", 1)
CreatePage("Items/Farming", 2)
CreatePage("Auto Get", 3)
CreatePage("Performance", 4)
CreatePage("Settings", 5)
CreatePage("Updates", 6)

-- [[ HOME TAB ]]
local Welcome = Instance.new("TextLabel", Pages["Home"])
Welcome.Size = UDim2.new(1, 0, 0, 30)
Welcome.Text = "Thanks for using NebulaX!"
Welcome.TextColor3 = Color3.new(1, 1, 1)
Welcome.BackgroundTransparency = 1
Welcome.Font = Enum.Font.GothamSemibold

-- [[ FARMING TAB - GALACTIC GLUE ]]
local GlueBtn = Instance.new("TextButton", Pages["Items/Farming"])
GlueBtn
