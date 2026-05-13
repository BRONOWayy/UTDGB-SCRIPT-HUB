-- [[ NebulaX Ultimate Galactic Hub - Developed by Max ]]
local P = game:GetService("Players")
local lp = P.LocalPlayer
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Cleanup
if CoreGui:FindFirstChild("NebulaX") then CoreGui.NebulaX:Destroy() end

local NebulaX = Instance.new("ScreenGui", CoreGui)
NebulaX.Name = "NebulaX"

-- [[ COLOR CONFIG ]]
local c_sky = Color3.fromRGB(0, 200, 255)
local c_purple = Color3.fromRGB(150, 0, 255)
local c_deep = Color3.fromRGB(0, 50, 255)

-- [[ DYNAMIC GRADIENT ENGINE ]]
local function ApplyGalacticBorder(object, thickness)
    local stroke = Instance.new("UIStroke", object)
    stroke.Thickness = thickness or 2.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    local grad = Instance.new("UIGradient", stroke)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, c_sky),
        ColorSequenceKeypoint.new(0.5, c_purple),
        ColorSequenceKeypoint.new(1, c_deep)
    })

    task.spawn(function()
        while NebulaX.Parent do
            grad.Rotation = grad.Rotation + 3 -- Flow speed
            task.wait(0.02)
        end
    end)
end

-- [[ MAIN HUB ]]
local Main = Instance.new("Frame", NebulaX)
Main.Size = UDim2.new(0, 420, 0, 280)
Main.Position = UDim2.new(0.5, -210, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
ApplyGalacticBorder(Main, 3)

-- [[ MINIMIZED SQUARE WIDGET ]]
local Widget = Instance.new("ImageButton", NebulaX)
Widget.Size = UDim2.new(0, 60, 0, 60)
Widget.Position = UDim2.new(0.05, 0, 0.1, 0)
Widget.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
Widget.Image = "rbxassetid://6031094067" -- Ninja/Space Icon
Widget.Visible = false
Widget.Draggable = true
Instance.new("UICorner", Widget).CornerRadius = UDim.new(0, 12)
ApplyGalacticBorder(Widget, 2.5)

-- [[ SIDEBAR ]]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(4, 4, 8)
Instance.new("UICorner", Sidebar)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "NebulaX 🌌"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
Title.BackgroundTransparency = 1

-- [[ CONTROLS ]]
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 26, 0, 26)
Close.Position = UDim2.new(1, -32, 0, 6)
Close.Text = "X"
Close.TextColor3 = Color3.new(1, 0, 0)
Close.BackgroundColor3 = Color3.fromRGB(20, 5, 5)
Instance.new("UICorner", Close)
ApplyGalacticBorder(Close, 1.5)

local Min = Instance.new("TextButton", Main)
Min.Size = UDim2.new(0, 26, 0, 26)
Min.Position = UDim2.new(1, -64, 0, 6)
Min.Text = "-"
Min.TextColor3 = Color3.new(1, 1, 1)
Min.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Instance.new("UICorner", Min)
ApplyGalacticBorder(Min, 1.5)

-- [[ PAGES ]]
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

CreatePage("Home", 1)
CreatePage("Items/Farming", 2)
CreatePage("Auto Get", 3)
CreatePage("Performance", 4)
CreatePage("Settings", 5)
CreatePage("Updates", 6)

-- Home Tab Content
local Thanks = Instance.new("TextLabel", Pages["Home"])
Thanks.Size = UDim2.new(1,0,0,40)
Thanks.Text = "Thanks for using UTDGB Script Hub!"
Thanks.TextColor3 = Color3.new(1,1,1)
Thanks.BackgroundTransparency = 1
Thanks.Font = Enum.Font.GothamMedium

-- Galactic Glue Button
local GlueBtn = Instance.new("TextButton", Pages["Items/Farming"])
GlueBtn.Size = UDim2.new(1, -10, 0, 40)
GlueBtn.Text = "[ GALACTIC GLUE ]"
GlueBtn.TextColor3 = Color3.fromRGB(200, 150, 255)
GlueBtn.BackgroundColor3 = Color3.fromRGB(15, 10, 30)
GlueBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", GlueBtn)
ApplyGalacticBorder(GlueBtn, 2) -- Individual Flowing Border

-- [[ KILL CONFIRMATION ]]
local KillBox = Instance.new("Frame", NebulaX)
KillBox.Size = UDim2.new(0, 200, 0, 100)
KillBox.Position = UDim2.new(0.5, -100, 0.5, -50)
KillBox.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
KillBox.Visible = false
Instance.new("UICorner", KillBox)
ApplyGalacticBorder(KillBox, 2)

local KillTxt = Instance.new("TextLabel", KillBox)
KillTxt.Size = UDim2.new(1,0,0,50)
KillTxt.Text = "Are you sure?"
KillTxt.TextColor3 = Color3.new(1,1,1)
KillTxt.BackgroundTransparency = 1

local Yes = Instance.new("TextButton", KillBox)
Yes.Size = UDim2.new(0.4, 0, 0, 30)
Yes.Position = UDim2.new(0.05, 0, 0.6, 0)
Yes.Text = "Yes"
Yes.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
Instance.new("UICorner", Yes)

local No = Instance.new("TextButton", KillBox)
No.Size = UDim2.new(0.4, 0, 0, 30)
No.Position = UDim2.new(0.55, 0, 0.6, 0)
No.Text = "No"
No.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", No)

-- [[ INTERACTION LOGIC ]]
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
end)itle.Text = "NebulaX 🌌"
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
