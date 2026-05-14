local P, UIS, R = game:GetService("Players"), game:GetService("UserInputService"), game:GetService("RunService")
local lp = P.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- [[ CLEANUP & INITIALIZATION ]]
if CoreGui:FindFirstChild("NebulaX_Final") then CoreGui.NebulaX_Final:Destroy() end

local NebulaX = Instance.new("ScreenGui", CoreGui)
NebulaX.Name = "NebulaX_Final"
NebulaX.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

_G.NebData = {
    GlueMode = "None",
    Ignore = {"FROM_THE_FOUNTAIN", "Rig", "Model", "Bone"},
    Version = "v2.0"
}

local theme = {
    bg = Color3.fromRGB(15, 10, 25),
    side = Color3.fromRGB(8, 4, 15),
    accent = Color3.fromRGB(160, 80, 255),
    txt = Color3.fromRGB(255, 255, 255),
    dark = Color3.fromRGB(25, 15, 40)
}

-- [[ MAIN FRAME ]]
local Main = Instance.new("Frame", NebulaX)
Main.Size = UDim2.new(0, 580, 0, 400)
Main.Position = UDim2.new(0.5, -290, 0.5, -200)
Main.BackgroundColor3 = theme.bg
Main.BorderSizePixel = 0
Main.Active, Main.Draggable = true, true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color, MainStroke.Thickness = theme.accent, 2
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- [[ BORDER RESIZE ]]
local isResizing = false
MainStroke.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then isResizing = true end
end)
UIS.InputChanged:Connect(function(i)
    if isResizing and i.UserInputType == Enum.UserInputType.MouseMovement then
        local mPos = UIS:GetMouseLocation()
        Main.Size = UDim2.new(0, math.max(450, mPos.X - Main.AbsolutePosition.X), 0, math.max(300, mPos.Y - Main.AbsolutePosition.Y))
    end
end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then isResizing = false end end)

-- [[ SIDEBAR ]]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = theme.side
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 80)
Title.Text = "NEB\nX"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 35
Title.TextColor3 = theme.accent
Title.BackgroundTransparency = 1

-- [[ PAGE HANDLER ]]
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -180, 1, -60)
Container.Position = UDim2.new(0, 175, 0, 45)
Container.BackgroundTransparency = 1

local Pages = {}
local function CreateTab(name, order)
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = (order == 1)
    Page.BackgroundTransparency, Page.BorderSizePixel = 1, 0
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = theme.accent
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)
    Pages[name] = Page

    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(0.9, 0, 0, 38)
    b.Position = UDim2.new(0.05, 0, 0, 90 + (order-1)*45)
    b.Text, b.TextColor3 = name, theme.txt
    b.BackgroundColor3 = (order == 1) and theme.accent or theme.dark
    b.Font = Enum.Font.GothamMedium
    Instance.new("UICorner", b)

    b.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = theme.dark end end
        Page.Visible = true
        b.BackgroundColor3 = theme.accent
    end)
    return Page
end

local home = CreateTab("Home", 1)
local farm = CreateTab("Items/Farming", 2)
local logs = CreateTab("Update Logs", 3)
local sets = CreateTab("Settings", 4)

-- [[ HOME SECTION ]]
local Welcome = Instance.new("TextLabel", home)
Welcome.Size = UDim2.new(1, 0, 0, 40)
Welcome.Text = "Made by Max"
Welcome.TextColor3 = theme.accent
Welcome.Font = Enum.Font.GothamBold
Welcome.BackgroundTransparency = 1

-- [[ UPDATE LOGS ]]
local LogBox = Instance.new("TextLabel", logs)
LogBox.Size = UDim2.new(1, 0, 1, 0)
LogBox.Text = "VERSION 2.0 RELEASE:\n\n- Fixed blank menu bug\n- Added Border-Edge Resizing\n- Added Max Branding\n- Added Classic/Reverse Glue Folder\n- Added Minimize & Safe-Close"
LogBox.TextColor3 = theme.txt
LogBox.TextXAlignment = Enum.TextXAlignment.Left
LogBox.TextYAlignment = Enum.TextYAlignment.Top
LogBox.BackgroundTransparency = 1
LogBox.Font = Enum.Font.Gotham

-- [[ GLUE FOLDER SYSTEM ]]
local GlueFolderBtn = Instance.new("TextButton", farm)
GlueFolderBtn.Size = UDim2.new(1, -5, 0, 45)
GlueFolderBtn.Text = "GALACTIC GLUE MENU >"
GlueFolderBtn.BackgroundColor3 = theme.dark
GlueFolderBtn.TextColor3 = theme.txt
GlueFolderBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", GlueFolderBtn)

local GlueOptions = Instance.new("Frame", farm)
GlueOptions.Size = UDim2.new(1, -5, 0, 110)
GlueOptions.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
GlueOptions.Visible = false
Instance.new("UIListLayout", GlueOptions).Padding = UDim.new(0, 5)
Instance.new("UICorner", GlueOptions)

GlueFolderBtn.MouseButton1Click:Connect(function() GlueOptions.Visible = not GlueOptions.Visible end)

local function AddMode(name, mode)
    local btn = Instance.new("TextButton", GlueOptions)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Text = name
    btn.BackgroundColor3 = theme.dark
    btn.TextColor3 = theme.txt
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() _G.NebData.GlueMode = mode end)
end

AddMode("Classic (Enemy -> You)", "Classic")
AddMode("Reverse (You -> Enemy)", "Reverse")
AddMode("Disable Glue", "None")

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
Prompt.Size = UDim2.new(0, 220, 0, 110)
Prompt.Position = UDim2.new(0.5, -110, 0.5, -55)
Prompt.BackgroundColor3 = theme.dark
Prompt.Visible = false
Instance.new("UIStroke", Prompt).Color = theme.accent
Instance.new("UICorner", Prompt)

local PText = Instance.new("TextLabel", Prompt)
PText.Size = UDim2.new(1, 0, 0, 60)
PText.Text = "Are you sure, Max?"
PText.TextColor3 = theme.txt
PText.BackgroundTransparency = 1

local Yes = Instance.new("TextButton", Prompt)
Yes.Size = UDim2.new(0.4, 0, 0, 30)
Yes.Position = UDim2.new(0.05, 0, 0.65, 0)
Yes.Text, Yes.BackgroundColor3 = "Yes", Color3.fromRGB(0, 150, 0)
Yes.MouseButton1Click:Connect(function() NebulaX:Destroy() end)

local No = Instance.new("TextButton", Prompt)
No.Size = UDim2.new(0.4, 0, 0, 30)
No.Position = UDim2.new(0.55, 0, 0.65, 0)
No.Text, No.BackgroundColor3 = "No", Color3.fromRGB(150, 0, 0)
No.MouseButton1Click:Connect(function() Prompt.Visible = false end)

Close.MouseButton1Click:Connect(function() Prompt.Visible = true end)

-- [[ GLUE ENGINE ]]
R.Heartbeat:Connect(function()
    if _G.NebData.GlueMode == "None" then return end
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local target, dist = nil, math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v ~= char then
            local ignore = false
            for _, n in pairs(_G.NebData.Ignore) do if v.Name:find(n) then ignore = true end end
            if not ignore then
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
        if _G.NebData.GlueMode == "Classic" then
            target.CanCollide = false
            target.CFrame = hrp.CFrame * CFrame.new(0, 0, -2)
        elseif _G.NebData.GlueMode == "Reverse" then
            hrp.CFrame = target.CFrame * CFrame.new(0, 0, 2)
        end
    end
end)
