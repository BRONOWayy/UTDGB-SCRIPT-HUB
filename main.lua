local P, UIS = game:GetService("Players"), game:GetService("UserInputService")
local lp = P.LocalPlayer
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("NebulaX_Elite_Final") then CoreGui.NebulaX_Elite_Final:Destroy() end

local NebulaX = Instance.new("ScreenGui", CoreGui)
NebulaX.Name = "NebulaX_Elite_Final"

local theme = {
    bg = Color3.fromRGB(15, 10, 25),
    side = Color3.fromRGB(8, 4, 15),
    accent = Color3.fromRGB(160, 80, 255),
    txt = Color3.fromRGB(255, 255, 255),
    dark = Color3.fromRGB(25, 15, 40)
}

-- [[ MAIN HUB ]]
local Main = Instance.new("Frame", NebulaX)
Main.Size = UDim2.new(0, 560, 0, 390)
Main.Position = UDim2.new(0.5, -280, 0.5, -195)
Main.BackgroundColor3 = theme.bg
Main.Active, Main.Draggable = true, true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color, MainStroke.Thickness = theme.accent, 2

-- [[ BORDER RESIZE LOGIC ]]
local isResizing = false
MainStroke.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        isResizing = true
    end
end)

UIS.InputChanged:Connect(function(i)
    if isResizing and i.UserInputType == Enum.UserInputType.MouseMovement then
        local mPos = UIS:GetMouseLocation()
        local newX = math.max(450, mPos.X - Main.AbsolutePosition.X)
        local newY = math.max(300, mPos.Y - Main.AbsolutePosition.Y)
        Main.Size = UDim2.new(0, newX, 0, newY)
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then isResizing = false end
end)

-- [[ SIDEBAR ]]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = theme.side
Instance.new("UICorner", Sidebar)

_G.Pages = {}
local function NewTab(name, order)
    local Page = Instance.new("ScrollingFrame", Main)
    Page.Size = UDim2.new(1, -180, 1, -60)
    Page.Position = UDim2.new(0, 170, 0, 45)
    Page.Visible = (order == 1)
    Page.BackgroundTransparency, Page.BorderSizePixel = 1, 0
    Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    _G.Pages[name] = Page

    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(0.9, 0, 0, 38)
    b.Position = UDim2.new(0.05, 0, 0, 100 + (order-1)*45)
    b.Text, b.TextColor3 = name, theme.txt
    b.BackgroundColor3 = (order == 1) and theme.accent or theme.dark
    b.Font = Enum.Font.GothamMedium
    Instance.new("UICorner", b)

    b.MouseButton1Click:Connect(function()
        for _, p in pairs(_G.Pages) do p.Visible = false end
        for _, v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = theme.dark end end
        Page.Visible = true
        b.BackgroundColor3 = theme.accent
    end)
    return Page
end

local home = NewTab("Home", 1)
local farm = NewTab("Items/Farming", 2)
local logs = NewTab("Update Logs", 3)
NewTab("Settings", 4)

-- [[ HOME SECTION ]]
local Credits = Instance.new("TextLabel", home)
Credits.Size = UDim2.new(1, 0, 0, 100)
Credits.Text = "NebulaX Elite\nMade by Max\nStatus: Optimized"
Credits.TextColor3 = theme.txt
Credits.BackgroundTransparency = 1
Credits.Font = Enum.Font.GothamBold
Credits.TextSize = 18

-- [[ UPDATE LOGS SECTION ]]
local LogText = Instance.new("TextLabel", logs)
LogText.Size = UDim2.new(1, 0, 1, 0)
LogText.Text = "UPDATE LOG [2026-05-14]:\n- Removed AI credits, added 'Made by Max'\n- Border-clip resizing enabled\n- New Reverse Glue Mode added\n- Added confirmation exit prompt"
LogText.TextColor3 = theme.txt
LogText.BackgroundTransparency = 1
LogText.Font = Enum.Font.Gotham
LogText.TextSize = 14
LogText.TextXAlignment = Enum.TextXAlignment.Left
LogText.TextYAlignment = Enum.TextYAlignment.Top

-- [[ WINDOW CONTROLS ]]
local Min = Instance.new("TextButton", Main)
Min.Size = UDim2.new(0, 30, 0, 30)
Min.Position = UDim2.new(1, -70, 0, 5)
Min.Text, Min.TextColor3 = "-", theme.txt
Min.BackgroundTransparency = 1
Min.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.Text, Close.TextColor3 = "X", Color3.fromRGB(255, 50, 50)
Close.BackgroundTransparency = 1

local Prompt = Instance.new("Frame", NebulaX)
Prompt.Size = UDim2.new(0, 200, 0, 100)
Prompt.Position = UDim2.new(0.5, -100, 0.5, -50)
Prompt.BackgroundColor3 = theme.dark
Prompt.Visible = false
Instance.new("UIStroke", Prompt).Color = theme.accent
Instance.new("UICorner", Prompt)

local PText = Instance.new("TextLabel", Prompt)
PText.Size = UDim2.new(1, 0, 0, 50)
PText.Text = "Close NebulaX?"
PText.TextColor3 = theme.txt
PText.BackgroundTransparency = 1

local Yes = Instance.new("TextButton", Prompt)
Yes.Size = UDim2.new(0.4, 0, 0, 30)
Yes.Position = UDim2.new(0.05, 0, 0.6, 0)
Yes.Text, Yes.BackgroundColor3 = "Yes", Color3.fromRGB(0, 150, 0)
Yes.MouseButton1Click:Connect(function() NebulaX:Destroy() end)

local No = Instance.new("TextButton", Prompt)
No.Size = UDim2.new(0.4, 0, 0, 30)
No.Position = UDim2.new(0.55, 0, 0.6, 0)
No.Text, No.BackgroundColor3 = "No", Color3.fromRGB(150, 0, 0)
No.MouseButton1Click:Connect(function() Prompt.Visible = false end)

Close.MouseButton1Click:Connect(function() Prompt.Visible = true end)
