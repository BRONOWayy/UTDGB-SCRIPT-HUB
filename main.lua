local P, R, UIS = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService")
local lp = P.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Cleanup
if CoreGui:FindFirstChild("NebulaX_Elite_Final") then CoreGui.NebulaX_Elite_Final:Destroy() end

local NebulaX = Instance.new("ScreenGui", CoreGui)
NebulaX.Name = "NebulaX_Elite_Final"

-- [[ CONFIG ]]
_G.NebData = {
    GlueMode = "None", -- "Classic", "Reverse", "None"
    Version = "v1.1",
    Ignore = {"FROM_THE_FOUNTAIN", "Rig", "Model", "Bone"}
}

local theme = {
    bg = Color3.fromRGB(15, 12, 25),
    side = Color3.fromRGB(8, 5, 15),
    accent = Color3.fromRGB(160, 80, 255),
    txt = Color3.fromRGB(255, 255, 255),
    dark = Color3.fromRGB(25, 20, 45)
}

-- [[ MAIN UI ]]
local Main = Instance.new("Frame", NebulaX)
Main.Size = UDim2.new(0, 560, 0, 390)
Main.Position = UDim2.new(0.5, -280, 0.5, -195)
Main.BackgroundColor3 = theme.bg
Main.Active, Main.Draggable = true, true
Instance.new("UICorner", Main)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color, MainStroke.Thickness = theme.accent, 1.5

-- [[ RESIZE LOGIC ]]
local Resize = Instance.new("TextLabel", Main)
Resize.Size = UDim2.new(0, 20, 0, 20)
Resize.Position = UDim2.new(1, -20, 1, -20)
Resize.Text = "◢"
Resize.TextColor3 = theme.accent
Resize.BackgroundTransparency = 1
Resize.ZIndex = 5

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

local Nav = Instance.new("Frame", Main)
Nav.Size = UDim2.new(1, -180, 1, -20)
Nav.Position = UDim2.new(0, 170, 0, 10)
Nav.BackgroundTransparency = 1

local Pages = {}
local function NewTab(name, order)
    local Page = Instance.new("ScrollingFrame", Nav)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = (order == 1)
    Page.BackgroundTransparency, Page.BorderSizePixel = 1, 0
    Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    Pages[name] = Page

    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(0.9, 0, 0, 38)
    b.Position = UDim2.new(0.05, 0, 0, 100 + (order-1)*45)
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

local farm = NewTab("Items/Farming", 1)
NewTab("Flight", 2)
NewTab("Settings", 3)
NewTab("Updates", 4)

-- [[ GLUE FOLDER SYSTEM ]]
local GlueMainFrame = Instance.new("Frame", farm)
GlueMainFrame.Size = UDim2.new(1, -10, 0, 50)
GlueMainFrame.BackgroundColor3 = theme.dark
Instance.new("UICorner", GlueMainFrame)

local OpenGlue = Instance.new("TextButton", GlueMainFrame)
OpenGlue.Size = UDim2.new(1, 0, 1, 0)
OpenGlue.Text = "GALACTIC GLUE MENU >"
OpenGlue.TextColor3 = theme.txt
OpenGlue.Font = Enum.Font.GothamBold
OpenGlue.BackgroundTransparency = 1

local GlueFolder = Instance.new("Frame", farm)
GlueFolder.Size = UDim2.new(1, -10, 0, 160)
GlueFolder.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
GlueFolder.Visible = false
Instance.new("UICorner", GlueFolder)
Instance.new("UIListLayout", GlueFolder).Padding = UDim.new(0, 5)

OpenGlue.MouseButton1Click:Connect(function() GlueFolder.Visible = not GlueFolder.Visible end)

local function AddGlueOption(txt, mode)
    local b = Instance.new("TextButton", GlueFolder)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.Text = txt
    b.BackgroundColor3 = theme.dark
    b.TextColor3 = theme.txt
    b.Font = Enum.Font.GothamMedium
    Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        _G.NebData.GlueMode = (_G.NebData.GlueMode == mode) and "None" or mode
        for _, opt in pairs(GlueFolder:GetChildren()) do 
            if opt:IsA("TextButton") then opt.BackgroundColor3 = theme.dark end 
        end
        if _G.NebData.GlueMode ~= "None" then b.BackgroundColor3 = theme.accent end
    end)
end

AddGlueOption("Classic (Enemy -> You)", "Classic")
AddGlueOption("Reverse (You -> Enemy)", "Reverse")
AddGlueOption("Disable All", "None")

-- [[ GLUE ENGINE ]]
R.Heartbeat:Connect(function()
    if _G.NebData.GlueMode == "None" then return end
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local target, dist = nil, math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v ~= char then
            local ignored = false
            for _, n in pairs(_G.NebData.Ignore) do if v.Name:find(n) then ignored = true end end
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
        if _G.NebData.GlueMode == "Classic" then
            target.CanCollide = false
            target.CFrame = hrp.CFrame * CFrame.new(0, 0, -2)
        elseif _G.NebData.GlueMode == "Reverse" then
            hrp.CFrame = target.CFrame * CFrame.new(0, 0, 2)
        end
    end
end)

-- [[ CLOSE ]]
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.Text, Close.TextColor3 = "X", Color3.new(1,0,0)
Close.BackgroundTransparency = 1
Close.MouseButton1Click:Connect(function() NebulaX:Destroy() end)
