local P = game:GetService("Players")
local lp = P.LocalPlayer
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Cleanup
if CoreGui:FindFirstChild("NebulaX_Elite_Final") then CoreGui.NebulaX_Elite_Final:Destroy() end

local NebulaX = Instance.new("ScreenGui", CoreGui)
NebulaX.Name = "NebulaX_Elite_Final"

-- [[ THEME CONFIG ]]
local bg_color = Color3.fromRGB(20, 10, 40) 
local sidebar_color = Color3.fromRGB(12, 5, 25)
local accent_purple = Color3.fromRGB(150, 70, 255)
local text_color = Color3.fromRGB(255, 255, 255)

-- [[ MAIN HUB ]]
local Main = Instance.new("Frame", NebulaX)
Main.Size = UDim2.new(0, 500, 0, 340)
Main.Position = UDim2.new(0.5, -250, 0.5, -170)
Main.BackgroundColor3 = bg_color
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Thickness = 2
MainStroke.Color = accent_purple

-- [[ SIDEBAR ]]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = sidebar_color
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

-- Header with Galaxy Emoji on the Right
local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 70)
Title.Text = "NebulaX 🌌 " -- Galaxy emoji on the right
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = accent_purple
Title.BackgroundTransparency = 1

-- [[ PAGES CONTAINER ]]
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -170, 1, -60)
Container.Position = UDim2.new(0, 160, 0, 40)
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
    TabBtn.Size = UDim2.new(0.85, 0, 0, 38)
    TabBtn.Position = UDim2.new(0.075, 0, 0, 80 + (order-1)*45)
    TabBtn.Text = name
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.TextSize = 14
    TabBtn.TextColor3 = text_color
    TabBtn.BackgroundColor3 = (order == 1) and accent_purple or Color3.fromRGB(45, 25, 75)
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(45, 25, 75) end
        end
        Page.Visible = true
        TabBtn.BackgroundColor3 = accent_purple
    end)
end

local tabs = {"Home", "Items/Farming", "Auto Get", "Performance", "Settings", "Updates"}
for i, name in ipairs(tabs) do CreateTab(name, i) end

-- [[ COMPONENT: GALACTIC GLUE ]]
local GlueBtn = Instance.new("TextButton", Pages["Items/Farming"])
GlueBtn.Size = UDim2.new(1, -10, 0, 45)
GlueBtn.Text = "[ GALACTIC GLUE ]"
GlueBtn.Font = Enum.Font.GothamBold
GlueBtn.TextSize = 16
GlueBtn.TextColor3 = text_color
GlueBtn.BackgroundColor3 = Color3.fromRGB(70, 35, 110)
Instance.new("UICorner", GlueBtn).CornerRadius = UDim.new(0, 10)
local GlueStroke = Instance.new("UIStroke", GlueBtn)
GlueStroke.Thickness = 2
GlueStroke.Color = accent_purple

-- [[ NINJA WIDGET (RESIZED SMALLER) ]]
local Widget = Instance.new("ImageButton", NebulaX)
Widget.Size = UDim2.new(0, 55, 0, 55) -- Fixed size to not be "way to fuckin big"
Widget.Position = UDim2.new(0, 15, 0.5, -27)
Widget.BackgroundColor3 = bg_color
Widget.Image = "rbxassetid://13835032549" 
Widget.Visible = false
Widget.Draggable = true
Instance.new("UICorner", Widget).CornerRadius = UDim.new(0, 10)
local WidgetStroke = Instance.new("UIStroke", Widget)
WidgetStroke.Thickness = 2
WidgetStroke.Color = accent_purple

-- [[ TOP BAR CONTROLS ]]
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 8)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 80, 80)
Close.BackgroundTransparency = 1
Close.Font = Enum.Font.GothamBold
Close.TextSize = 18

local Min = Instance.new("TextButton", Main)
Min.Size = UDim2.new(0, 30, 0, 30)
Min.Position = UDim2.new(1, -65, 0, 8)
Min.Text = "-"
Min.TextColor3 = text_color
Min.BackgroundTransparency = 1
Min.Font = Enum.Font.GothamBold
Min.TextSize = 22

-- [[ ARE YOU SURE MENU ]]
local ConfirmMenu = Instance.new("Frame", NebulaX)
ConfirmMenu.Size = UDim2.new(0, 220, 0, 110)
ConfirmMenu.Position = UDim2.new(0.5, -110, 0.5, -55)
ConfirmMenu.BackgroundColor3 = Color3.fromRGB(30, 15, 50)
ConfirmMenu.Visible = false
Instance.new("UICorner", ConfirmMenu)
local ConfirmStroke = Instance.new("UIStroke", ConfirmMenu)
ConfirmStroke.Color = accent_purple
ConfirmStroke.Thickness = 2

local ConfirmLabel = Instance.new("TextLabel", ConfirmMenu)
ConfirmLabel.Size = UDim2.new(1, 0, 0.5, 0)
ConfirmLabel.Text = "Are you sure?"
ConfirmLabel.TextColor3 = text_color
ConfirmLabel.Font = Enum.Font.GothamBold
ConfirmLabel.TextSize = 16
ConfirmLabel.BackgroundTransparency = 1

local Yes = Instance.new("TextButton", ConfirmMenu)
Yes.Size = UDim2.new(0.4, 0, 0, 30)
Yes.Position = UDim2.new(0.07, 0, 0.6, 0)
Yes.Text = "Kill UI"
Yes.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
Yes.TextColor3 = text_color
Instance.new("UICorner", Yes)

local No = Instance.new("TextButton", ConfirmMenu)
No.Size = UDim2.new(0.4, 0, 0, 30)
No.Position = UDim2.new(0.53, 0, 0.6, 0)
No.Text = "Cancel"
No.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
No.TextColor3 = text_color
Instance.new("UICorner", No)

-- [[ LOGIC ]]
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
