local P = game:GetService("Players")
local lp = P.LocalPlayer
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Cleanup existing UI to prevent overlapping
if CoreGui:FindFirstChild("NebulaX_Purple") then CoreGui.NebulaX_Purple:Destroy() end

local NebulaX = Instance.new("ScreenGui", CoreGui)
NebulaX.Name = "NebulaX_Purple"

-- [[ THEME CONFIG ]]
local bg_color = Color3.fromRGB(25, 10, 50) -- Deep Purple Background
local sidebar_color = Color3.fromRGB(15, 5, 30) -- Darker Purple Sidebar
local accent_purple = Color3.fromRGB(160, 80, 255) -- Bright Purple Accent
local text_color = Color3.fromRGB(255, 255, 255)

-- [[ MAIN HUB ]]
local Main = Instance.new("Frame", NebulaX)
Main.Size = UDim2.new(0, 480, 0, 320)
Main.Position = UDim2.new(0.5, -240, 0.5, -160)
Main.BackgroundColor3 = bg_color
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 15)

-- Solid Purple Border
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Thickness = 3
MainStroke.Color = accent_purple
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- [[ SIDEBAR ]]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = sidebar_color
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 15)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "NebulaX 🌌" -- Added Galaxy Emoji
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = accent_purple
Title.BackgroundTransparency = 1

-- [[ PAGES CONTAINER ]]
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -160, 1, -50)
Container.Position = UDim2.new(0, 150, 0, 30)
Container.BackgroundTransparency = 1

local Pages = {}
local function CreateTab(name, order)
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = (order == 1)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = accent_purple
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)
    Pages[name] = Page

    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(0.85, 0, 0, 35)
    TabBtn.Position = UDim2.new(0.075, 0, 0, 70 + (order-1)*42)
    TabBtn.Text = name
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.TextSize = 14
    TabBtn.TextColor3 = text_color
    TabBtn.BackgroundColor3 = (order == 1) and accent_purple or Color3.fromRGB(40, 20, 70)
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(40, 20, 70) end
        end
        Page.Visible = true
        TabBtn.BackgroundColor3 = accent_purple
    end)
end

local tabs = {"Home", "Items/Farming", "Auto Get", "Performance", "Settings", "Updates"}
for i, name in ipairs(tabs) do CreateTab(name, i) end

-- [[ GALACTIC GLUE ]]
local GlueBtn = Instance.new("TextButton", Pages["Items/Farming"])
GlueBtn.Size = UDim2.new(1, -10, 0, 45)
GlueBtn.Text = "[ GALACTIC GLUE ]"
GlueBtn.Font = Enum.Font.GothamBold
GlueBtn.TextSize = 16
GlueBtn.TextColor3 = text_color
GlueBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 100)
Instance.new("UICorner", GlueBtn).CornerRadius = UDim.new(0, 10)

local GlueStroke = Instance.new("UIStroke", GlueBtn)
GlueStroke.Thickness = 2
GlueStroke.Color = accent_purple

-- [[ NINJA WIDGET ]]
local Widget = Instance.new("ImageButton", NebulaX)
Widget.Size = UDim2.new(0, 60, 0, 60)
Widget.Position = UDim2.new(0.02, 0, 0.4, 0)
Widget.BackgroundColor3 = bg_color
Widget.Image = "rbxassetid://13835032549" -- Ninja Icon
Widget.Visible = false
Widget.Draggable = true
Instance.new("UICorner", Widget).CornerRadius = UDim.new(0, 12)
local WidgetStroke = Instance.new("UIStroke", Widget)
WidgetStroke.Thickness = 2
WidgetStroke.Color = accent_purple

-- [[ TOP CONTROLS ]]
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 80, 80)
Close.BackgroundTransparency = 1
Close.TextSize = 20

local Min = Instance.new("TextButton", Main)
Min.Size = UDim2.new(0, 30, 0, 30)
Min.Position = UDim2.new(1, -65, 0, 5)
Min.Text = "-"
Min.TextColor3 = text_color
Min.BackgroundTransparency = 1
Min.TextSize = 25

-- [[ LOGIC ]]
Close.MouseButton1Click:Connect(function() NebulaX:Destroy() end)

Min.MouseButton1Click:Connect(function()
    Main.Visible = false
    Widget.Visible = true
end)

Widget.MouseButton1Click:Connect(function()
    Main.Visible = true
    Widget.Visible = false
end)
