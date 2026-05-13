local P = game:GetService("Players")
local lp = P.LocalPlayer
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Cleanup
if CoreGui:FindFirstChild("NebulaX_Elite_Purple") then CoreGui.NebulaX_Elite_Purple:Destroy() end

local NebulaX = Instance.new("ScreenGui", CoreGui)
NebulaX.Name = "NebulaX_Elite_Purple"

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
MainStroke.Thickness = 3
MainStroke.Color = accent_purple

-- [[ SIDEBAR ]]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = sidebar_color
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 70)
Title.Text = "NebulaX 🌌" 
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextColor3 = accent_purple
Title.BackgroundTransparency = 1

-- [[ NAVIGATION ]]
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

-- [[ GALACTIC GLUE BUTTON ]]
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

-- [[ LARGE NINJA WIDGET ]]
local Widget = Instance.new("ImageButton", NebulaX)
Widget.Size = UDim2.new(0, 80, 0, 80)
Widget.Position = UDim2.new(0, 20, 0.5, -40)
Widget.BackgroundColor3 = bg_color
Widget.Image = "rbxassetid://13835032549"
Widget.Visible = false
Widget.Draggable = true
Instance.new("UICorner", Widget).CornerRadius = UDim.new(0, 15)
local WidgetStroke = Instance.new("UIStroke", Widget)
WidgetStroke.Thickness = 3
WidgetStroke.Color = accent_purple

-- [[ WINDOW CONTROLS ]]
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 10)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 80, 80)
Close.BackgroundTransparency = 1
Close.Font = Enum.Font.GothamBold
Close.TextSize = 20

local Min = Instance.new("TextButton", Main)
Min.Size = UDim2.new(0, 30, 0, 30)
Min.Position = UDim2.new(1, -65, 0, 10)
Min.Text = "-"
Min.TextColor3 = text_color
Min.BackgroundTransparency = 1
Min.Font = Enum.Font.GothamBold
Min.TextSize = 25

-- [[ CLOSE CONFIRMATION ]]
local KillBox = Instance.new("Frame", NebulaX)
KillBox.Size = UDim2.new(0, 250, 0, 130)
KillBox.Position = UDim2.new(0.5, -125, 0.5, -65)
KillBox.BackgroundColor3 = Color3.fromRGB(35, 15, 60)
KillBox.Visible = false
Instance.new("UICorner", KillBox)
local KillStroke = Instance.new("UIStroke", KillBox)
KillStroke.Thickness = 3
KillStroke.Color = Color3.fromRGB(255, 80, 80)

local KillText = Instance.new("TextLabel", KillBox)
KillText.Size = UDim2.new(1, 0, 0.6, 0)
KillText.Text = "Are you sure you want to exit?"
KillText.Font = Enum.Font.GothamBold
KillText.TextColor3 = text_color
KillText.TextSize = 16
KillText.TextWrapped = true
KillText.BackgroundTransparency = 1

local Yes = Instance.new("TextButton", KillBox)
Yes.Size = UDim2.new(0.4, 0, 0, 35)
Yes.Position = UDim2.new(0.07, 0, 0.65, 0)
Yes.Text = "Close"
Yes.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
Yes.TextColor3 = text_color
Instance.new("UICorner", Yes)

local No = Instance.new("TextButton", KillBox)
No.Size = UDim2.new(0.4, 0, 0, 35)
No.Position = UDim2.new(0.53, 0, 0.65, 0)
No.Text = "Cancel"
No.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
No.TextColor3 = text_color
Instance.new("UICorner", No)

-- [[ INTERACTIONS ]]
Min.MouseButton1Click:Connect(function()
    Main.Visible = false
    Widget.Visible = true
end)

Widget.MouseButton1Click:Connect(function()
    Main.Visible = true
    Widget.Visible = false
end)

Close.MouseButton1Click:Connect(function()
    KillBox.Visible = true
end)

No.MouseButton1Click:Connect(function()
    KillBox.Visible = false
end)

Yes.MouseButton1Click:Connect(function()
    NebulaX:Destroy()
end)
