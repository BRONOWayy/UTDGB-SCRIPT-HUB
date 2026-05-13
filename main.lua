local P = game:GetService("Players")
local lp = P.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TS = game:GetService("TweenService")

-- Cleanup
if CoreGui:FindFirstChild("NebulaX") then CoreGui.NebulaX:Destroy() end

local NebulaX = Instance.new("ScreenGui", CoreGui)
NebulaX.Name = "NebulaX"

-- [[ THE MAIN HUB ]]
local Main = Instance.new("Frame", NebulaX)
Main.Name = "Main"
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true

local MainCorner = Instance.new("UICorner", Main)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(80, 50, 255)

-- [[ THE SQUARE LOGO BUTTON (WIDGET MODE) ]]
local SquareBtn = Instance.new("ImageButton", NebulaX)
SquareBtn.Name = "SquareBtn"
SquareBtn.Size = UDim2.new(0, 60, 0, 60)
SquareBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
SquareBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
SquareBtn.Visible = false
SquareBtn.Image = "rbxassetid://6031094067" -- A slick ninja/tech icon
SquareBtn.ScaleType = Enum.ScaleType.Fit
local SqCorner = Instance.new("UICorner", SquareBtn)
local SqStroke = Instance.new("UIStroke", SquareBtn)
SqStroke.Thickness = 2
SqStroke.Color = Color3.fromRGB(80, 50, 255)

-- [[ SIDEBAR ]]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 15)
Instance.new("UICorner", Sidebar)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "NebulaX"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(200, 180, 255)
Title.TextSize = 22
Title.BackgroundTransparency = 1

-- [[ TOP BAR BUTTONS ]]
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.Text = "X"
Close.TextColor3 = Color3.new(1,0,0)
Close.BackgroundTransparency = 1

local Minimize = Instance.new("TextButton", Main)
Minimize.Size = UDim2.new(0, 30, 0, 30)
Minimize.Position = UDim2.new(1, -65, 0, 5)
Minimize.Text = "-"
Minimize.TextColor3 = Color3.new(1,1,1)
Minimize.BackgroundTransparency = 1

-- [[ PAGES CONTAINER ]]
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -150, 1, -50)
Container.Position = UDim2.new(0, 145, 0, 40)
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
    Tab.Size = UDim2.new(0.9, 0, 0, 35)
    Tab.Position = UDim2.new(0.05, 0, 0, 60 + (order-1)*40)
    Tab.Text = name
    Tab.Font = Enum.Font.Gotham
    Tab.TextColor3 = Color3.new(1,1,1)
    Tab.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    Instance.new("UICorner", Tab)

    Tab.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)
end

-- SECTIONS
CreatePage("Home", 1)
CreatePage("Items/Farming", 2)
CreatePage("Auto Get", 3)
CreatePage("Performance", 4)
CreatePage("Settings", 5)
CreatePage("Updates", 6)

-- HOME CONTENT
local Welcome = Instance.new("TextLabel", Pages["Home"])
Welcome.Size = UDim2.new(1,0,0,40)
Welcome.Text = "Thanks for using NebulaX Script Hub!"
Welcome.TextColor3 = Color3.new(1,1,1)
Welcome.BackgroundTransparency = 1
Welcome.Font = Enum.Font.GothamMedium

local Dev = Instance.new("TextLabel", Pages["Home"])
Dev.Size = UDim2.new(1,0,0,20)
Dev.Text = "Made by Max"
Dev.TextColor3 = Color3.fromRGB(150,150,255)
Dev.BackgroundTransparency = 1

-- CLOSE LOGIC (DOUBLE CONFIRM)
local Confirm = Instance.new("Frame", NebulaX)
Confirm.Size = UDim2.new(0, 220, 0, 100)
Confirm.Position = UDim2.new(0.5, -110, 0.5, -50)
Confirm.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
Confirm.Visible = false
Instance.new("UICorner", Confirm)

local ConfTxt = Instance.new("TextLabel", Confirm)
ConfTxt.Size = UDim2.new(1, 0, 0, 50)
ConfTxt.Text = "Kill NebulaX?"
ConfTxt.TextColor3 = Color3.new(1,1,1)
ConfTxt.BackgroundTransparency = 1

local Yes = Instance.new("TextButton", Confirm)
Yes.Size = UDim2.new(0.4, 0, 0, 30)
Yes.Position = UDim2.new(0.05, 0, 0.6, 0)
Yes.Text = "Yes"
Yes.BackgroundColor3 = Color3.new(0.5,0,0)
Instance.new("UICorner", Yes)

local No = Instance.new("TextButton", Confirm)
No.Size = UDim2.new(0.4, 0, 0, 30)
No.Position = UDim2.new(0.55, 0, 0.6, 0)
No.Text = "No"
No.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
Instance.new("UICorner", No)

Close.MouseButton1Click:Connect(function() Confirm.Visible = true end)
No.MouseButton1Click:Connect(function() Confirm.Visible = false end)
Yes.MouseButton1Click:Connect(function() NebulaX:Destroy() end)

-- [[ MINIMIZE TO SQUARE LOGO ]]
Minimize.MouseButton1Click:Connect(function()
    Main.Visible = false
    SquareBtn.Visible = true
end)

SquareBtn.MouseButton1Click:Connect(function()
    SquareBtn.Visible = false
    Main.Visible = true
end)

-- Items/Farming (Glue Preview)
local GlueTitle = Instance.new("TextLabel", Pages["Items/Farming"])
GlueTitle.Size = UDim2.new(1,0,0,30)
GlueTitle.Text = "[ GALACTIC GLUE ]"
GlueTitle.TextColor3 = Color3.fromRGB(180, 100, 255)
GlueTitle.BackgroundTransparency = 1
