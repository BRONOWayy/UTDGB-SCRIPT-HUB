local P = game:GetService("Players")
local lp = P.LocalPlayer
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("NebulaX") then CoreGui.NebulaX:Destroy() end

local NebulaX = Instance.new("ScreenGui", CoreGui)
NebulaX.Name = "NebulaX"

-- [[ GRADIENT ANIMATOR FUNCTION ]]
local function ApplyGradient(object)
    local UIStroke = object:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke", object)
    UIStroke.Thickness = 2
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    local Gradient = Instance.new("UIGradient", UIStroke)
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),   -- Sky Blue
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(170, 0, 255)), -- Purple
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 80, 255))    -- Blue
    })

    task.spawn(function()
        while NebulaX.Parent do
            TS:Create(Gradient, TweenInfo.new(2, Enum.EasingStyle.Linear), {Rotation = 360}):Play()
            task.wait(2)
            Gradient.Rotation = 0
        end
    end)
end

-- [[ MAIN HUB ]]
local Main = Instance.new("Frame", NebulaX)
Main.Size = UDim2.new(0, 420, 0, 280) -- Made Smaller
Main.Position = UDim2.new(0.5, -210, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true -- Moveable around
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
ApplyGradient(Main)

-- [[ MINIMIZED SQUARE WIDGET ]]
local Widget = Instance.new("TextButton", NebulaX)
Widget.Size = UDim2.new(0, 50, 0, 50)
Widget.Position = UDim2.new(0.02, 0, 0.2, 0)
Widget.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Widget.Text = "🌌"
Widget.TextSize = 25
Widget.Visible = false
Widget.Draggable = true
Instance.new("UICorner", Widget).CornerRadius = UDim.new(0, 12)
ApplyGradient(Widget)

-- [[ SIDEBAR ]]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
Instance.new("UICorner", Sidebar)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "NebulaX 🌌"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

-- [[ TOP BAR CONTROLS ]]
local Controls = Instance.new("Frame", Main)
Controls.Size = UDim2.new(1, -130, 0, 30)
Controls.Position = UDim2.new(0, 125, 0, 5)
Controls.BackgroundTransparency = 1

local Close = Instance.new("TextButton", Controls)
Close.Size = UDim2.new(0, 25, 0, 25)
Close.Position = UDim2.new(1, -30, 0, 0)
Close.Text = "X"
Close.TextColor3 = Color3.new(1, 0, 0)
Close.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
Instance.new("UICorner", Close)
ApplyGradient(Close)

local Min = Instance.new("TextButton", Controls)
Min.Size = UDim2.new(0, 25, 0, 25)
Min.Position = UDim2.new(1, -60, 0, 0)
Min.Text = "-"
Min.TextColor3 = Color3.new(1, 1, 1)
Min.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Instance.new("UICorner", Min)
ApplyGradient(Min)

-- [[ PAGES ]]
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -135, 1, -50)
Container.Position = UDim2.new(0, 128, 0, 40)
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
    Tab.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    Tab.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    Tab.Font = Enum.Font.Gotham
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

-- [[ GALACTIC GLUE BUTTON ]]
local GlueBtn = Instance.new("TextButton", Pages["Items/Farming"])
GlueBtn.Size = UDim2.new(1, -10, 0, 40)
GlueBtn.Text = "[ GALACTIC GLUE ]"
GlueBtn.TextColor3 = Color3.fromRGB(200, 150, 255)
GlueBtn.BackgroundColor3 = Color3.fromRGB(15, 10, 30)
GlueBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", GlueBtn)
ApplyGradient(GlueBtn) -- Added flowing border to Glue button

-- [[ MINIMIZE / WIDGET LOGIC ]]
Min.MouseButton1Click:Connect(function()
    Main.Visible = false
    Widget.Visible = true
end)

Widget.MouseButton1Click:Connect(function()
    Widget.Visible = false
    Main.Visible = true
end)

-- [[ CLOSE LOGIC ]]
Close.MouseButton1Click:Connect(function()
    NebulaX:Destroy()
end)

print("NebulaX 🌌 Loaded Successfully")
