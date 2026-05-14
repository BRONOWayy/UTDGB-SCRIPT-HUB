local P, UIS = game:GetService("Players"), game:GetService("UserInputService")
local lp = P.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Cleanup
if CoreGui:FindFirstChild("NebulaX_Elite_Final") then CoreGui.NebulaX_Elite_Final:Destroy() end

local NebulaX = Instance.new("ScreenGui", CoreGui)
NebulaX.Name = "NebulaX_Elite_Final"

-- [[ THEME ]]
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
Instance.new("UIStroke", Main).Color = theme.accent

-- [[ RESIZE HANDLE ]]
local Resize = Instance.new("TextLabel", Main)
Resize.Size = UDim2.new(0, 20, 0, 20)
Resize.Position = UDim2.new(1, -20, 1, -20)
Resize.Text = "◢"
Resize.TextColor3 = theme.accent
Resize.BackgroundTransparency = 1
Resize.ZIndex = 10

local resizing = false
Resize.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then resizing = true end end)
UIS.InputChanged:Connect(function(i)
    if resizing and i.UserInputType == Enum.UserInputType.MouseMovement then
        local mPos = UIS:GetMouseLocation()
        Main.Size = UDim2.new(0, math.max(400, mPos.X - Main.AbsolutePosition.X), 0, math.max(300, mPos.Y - Main.AbsolutePosition.Y))
    end
end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then resizing = false end end)

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

-- Initialize Tabs
local home = NewTab("Home", 1)
local farm = NewTab("Items/Farming", 2)
NewTab("Auto Get", 3)
NewTab("Performance", 4)
NewTab("Settings", 5)

-- [[ HOME SECTION (Credits) ]]
local Credits = Instance.new("TextLabel", home)
Credits.Size = UDim2.new(1, 0, 0, 100)
Credits.Text = "NebulaX Elite\nCreated by: Gemini AI & User\nStatus: Active"
Credits.TextColor3 = theme.txt
Credits.BackgroundTransparency = 1
Credits.Font = Enum.Font.GothamBold

-- [[ WINDOW CONTROLS (- and X) ]]
local Min = Instance.new("TextButton", Main)
Min.Size = UDim2.new(0, 30, 0, 30)
Min.Position = UDim2.new(1, -70, 0, 5)
Min.Text, Min.TextColor3 = "-", theme.txt
Min.BackgroundTransparency = 1
Min.MouseButton1Click:Connect(function() Main.Visible = false end)

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.Text, Close.TextColor3 = "X", Color3.fromRGB(255, 50, 50)
Close.BackgroundTransparency = 1

-- [[ ARE YOU SURE? PROMPT ]]
local Prompt = Instance.new("Frame", NebulaX)
Prompt.Size = UDim2.new(0, 200, 0, 100)
Prompt.Position = UDim2.new(0.5, -100, 0.5, -50)
Prompt.BackgroundColor3 = theme.dark
Prompt.Visible = false
Instance.new("UIStroke", Prompt).Color = theme.accent
Instance.new("UICorner", Prompt)

local PText = Instance.new("TextLabel", Prompt)
PText.Size = UDim2.new(1, 0, 0, 50)
PText.Text = "Are you sure?"
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



local R = game:GetService("RunService")

_G.GlueData = {
    Mode = "None", -- Classic, Reverse, None
    Ignore = {"FROM_THE_FOUNTAIN", "Rig", "Model", "Bone"}
}

local farmPage = _G.Pages["Items/Farming"]

-- [[ GLUE FOLDER BUTTON ]]
local GlueMain = Instance.new("Frame", farmPage)
GlueMain.Size = UDim2.new(1, -10, 0, 50)
GlueMain.BackgroundColor3 = Color3.fromRGB(25, 20, 45)
Instance.new("UICorner", GlueMain)

local GlueIcon = Instance.new("ImageLabel", GlueMain)
GlueIcon.Size = UDim2.new(0, 40, 0, 40)
GlueIcon.Position = UDim2.new(0, 5, 0.5, -20)
GlueIcon.BackgroundTransparency = 1
GlueIcon.Image = "rbxassetid://12601712217" -- Ninja/Combat Icon

local OpenBtn = Instance.new("TextButton", GlueMain)
OpenBtn.Size = UDim2.new(1, -50, 1, 0)
OpenBtn.Position = UDim2.new(0, 50, 0, 0)
OpenBtn.Text = "GALACTIC GLUE MENU >"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.BackgroundTransparency = 1
OpenBtn.Font = Enum.Font.GothamBold

local OptionFolder = Instance.new("Frame", farmPage)
OptionFolder.Size = UDim2.new(1, -10, 0, 120)
OptionFolder.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
OptionFolder.Visible = false
Instance.new("UIListLayout", OptionFolder).Padding = UDim.new(0, 5)

OpenBtn.MouseButton1Click:Connect(function() OptionFolder.Visible = not OptionFolder.Visible end)

local function AddMode(txt, mode)
    local b = Instance.new("TextButton", OptionFolder)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        _G.GlueData.Mode = (_G.GlueData.Mode == mode) and "None" or mode
    end)
end

AddMode("Classic (Enemy -> You)", "Classic")
AddMode("Reverse (You -> Enemy)", "Reverse")
AddMode("Disable All Glue", "None")

-- [[ THE ENGINE ]]
R.Heartbeat:Connect(function()
    if _G.GlueData.Mode == "None" then return end
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local target, dist = nil, math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v ~= lp.Character then
            local ignored = false
            for _, n in pairs(_G.GlueData.Ignore) do if v.Name:find(n) then ignored = true end end
            if not ignored then
                local th = v:FindFirstChild("HumanoidRootPart")
                if th then
                    local d = (hrp.Position - th.Position).Magnitude
                    if d < dist then dist = d target = th end
                end
            end
        end
    end

    if target then
        target.Velocity, target.RotVelocity = Vector3.zero, Vector3.zero
        if _G.GlueData.Mode == "Classic" then
            target.CanCollide = false
            target.CFrame = hrp.CFrame * CFrame.new(0, 0, -1)
        elseif _G.GlueData.Mode == "Reverse" then
            hrp.CFrame = target.CFrame * CFrame.new(0, 0, 1)
        end
    end
end)
