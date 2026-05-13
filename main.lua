-- [[ NEBULAX: GALACTIC HUB ]]
-- Created by Max
local P = game:GetService("Players")
local lp = P.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TS = game:GetService("TweenService")

-- Cleanup existing UI
if CoreGui:FindFirstChild("NebulaxHub") then CoreGui.NebulaxHub:Destroy() end

-- UI SETUP
local Nebulax = Instance.new("ScreenGui", CoreGui)
Nebulax.Name = "NebulaxHub"

local Main = Instance.new("Frame", Nebulax)
Main.Size = UDim2.new(0, 550, 0, 380)
Main.Position = UDim2.new(0.5, -275, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local MainCorner = Instance.new("UICorner", Main)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Thickness = 2
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Color = Color3.fromRGB(100, 50, 255) -- Galactic Glow

-- SIDEBAR
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(5, 5, 15)
Instance.new("UICorner", Sidebar)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "NebulaX"
Title.TextColor3 = Color3.fromRGB(180, 150, 255)
Title.TextSize = 25
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local UserLabel = Instance.new("TextLabel", Sidebar)
UserLabel.Size = UDim2.new(1, 0, 0, 30)
UserLabel.Position = UDim2.new(0, 0, 1, -40)
UserLabel.Text = "Made by Max"
UserLabel.TextColor3 = Color3.fromRGB(120, 120, 180)
UserLabel.TextSize = 14
UserLabel.Font = Enum.Font.Gotham
UserLabel.BackgroundTransparency = 1

-- PAGES CONTAINER
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -160, 1, -20)
Container.Position = UDim2.new(0, 155, 0, 10)
Container.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name, order)
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = (order == 1)
    Page.ScrollBarThickness = 0
    local Layout = Instance.new("UIListLayout", Page)
    Layout.Padding = UDim.new(0, 10)
    Pages[name] = Page

    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
    TabBtn.Position = UDim2.new(0.05, 0, 0, 60 + (order * 40))
    TabBtn.Text = name
    TabBtn.BackgroundColor3 = Page.Visible and Color3.fromRGB(40, 30, 80) or Color3.fromRGB(15, 15, 30)
    TabBtn.TextColor3 = Color3.new(1, 1, 1)
    TabBtn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", TabBtn)

    TabBtn.MouseButton1Click:Connect(function()
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
Welcome.Size = UDim2.new(1, 0, 0, 100)
Welcome.Text = "Thanks for using\nNebulax UTDGB Hub!"
Welcome.TextColor3 = Color3.new(1, 1, 1)
Welcome.TextSize = 18
Welcome.Font = Enum.Font.GothamBold
Welcome.BackgroundTransparency = 1

-- SETTINGS (CLOSE LOGIC)
local ConfirmFrame = Instance.new("Frame", Nebulax)
ConfirmFrame.Size = UDim2.new(0, 250, 0, 120)
ConfirmFrame.Position = UDim2.new(0.5, -125, 0.5, -60)
ConfirmFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ConfirmFrame.Visible = false
Instance.new("UICorner", ConfirmFrame)
Instance.new("UIStroke", ConfirmFrame).Color = Color3.new(1, 0, 0)

local ConfirmText = Instance.new("TextLabel", ConfirmFrame)
ConfirmText.Size = UDim2.new(1, 0, 0, 60)
ConfirmText.Text = "Are you sure you want to kill Nebulax?"
ConfirmText.TextColor3 = Color3.new(1, 1, 1)
ConfirmText.TextWrapped = true
ConfirmText.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", Pages["Settings"])
CloseBtn.Size = UDim2.new(1, -10, 0, 45)
CloseBtn.Text = "Kill Script"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn)

local Yes = Instance.new("TextButton", ConfirmFrame)
Yes.Size = UDim2.new(0.4, 0, 0, 30)
Yes.Position = UDim2.new(0.1, 0, 0.6, 0)
Yes.Text = "Yes, kill it"
Yes.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
Instance.new("UICorner", Yes)

local No = Instance.new("TextButton", ConfirmFrame)
No.Size = UDim2.new(0.4, 0, 0, 30)
No.Position = UDim2.new(0.5, 0, 0.6, 0)
No.Text = "No, wait!"
No.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
Instance.new("UICorner", No)

CloseBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = true end)
No.MouseButton1Click:Connect(function() ConfirmFrame.Visible = false end)
Yes.MouseButton1Click:Connect(function() Nebulax:Destroy() end)

-- MINIMIZE
local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -35, 0, 5)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
Instance.new("UICorner", MinBtn)

local isMin = false
MinBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    Sidebar.Visible = not isMin
    Container.Visible = not isMin
    Main:TweenSize(isMin and UDim2.new(0, 550, 0, 40) or UDim2.new(0, 550, 0, 380), "Out", "Quint", 0.3, true)
end)

-- ADDED GLUE PREVIEW TO FARMING
local GlueBtn = Instance.new("TextButton", Pages["Items/Farming"])
GlueBtn.Size = UDim2.new(1, -10, 0, 40)
GlueBtn.Text = "Activate Galactic Glue"
GlueBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 120)
GlueBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", GlueBtn)
