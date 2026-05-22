if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

---------------------------------------------------------
-- 1. INTERFACE CONSTRUCTOR (Plain Theme)
---------------------------------------------------------
if CoreGui:FindFirstChild("DeltaSelectorPanel") then
    CoreGui.DeltaSelectorPanel:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaSelectorPanel"
ScreenGui.ResetOnSpawn = false

local attached, _ = pcall(function() ScreenGui.Parent = CoreGui end)
if not attached then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 180)
MainFrame.Position = UDim2.new(0.15, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MovingThing = Instance.new("Frame")
MovingThing.Size = UDim2.new(1, 0, 0, 30)
MovingThing.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MovingThing.BorderSizePixel = 1
MovingThing.BorderColor3 = Color3.fromRGB(60, 60, 60)
MovingThing.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Targeted Weapon Modifier"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.Font = Enum.Font.SourceSans
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MovingThing

-- Drag Handler
local dragging, dragInput, dragStart, startPos
MovingThing.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MovingThing.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

---------------------------------------------------------
-- 2. INPUT FIELDS & CONFIGURATION PANELS
---------------------------------------------------------

-- Row 1: Weapon Name Search Input Box
local NameBoxFrame = Instance.new("Frame")
NameBoxFrame.Size = UDim2.new(1, -14, 0, 32)
NameBoxFrame.Position = UDim2.new(0, 7, 0, 40)
NameBoxFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
NameBoxFrame.BorderColor3 = Color3.fromRGB(55, 55, 55)
NameBoxFrame.Parent = MainFrame

local NameLabel = Instance.new("TextLabel")
NameLabel.Size = UDim2.new(0.4, 0, 1, 0)
NameLabel.Position = UDim2.new(0, 8, 0, 0)
NameLabel.BackgroundTransparency = 1
NameLabel.Text = "Weapon Name:"
NameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
NameLabel.Font = Enum.Font.SourceSans
NameLabel.TextSize = 13
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.Parent = NameBoxFrame

local WeaponNameInput = Instance.new("TextBox")
WeaponNameInput.Size = UDim2.new(0.55, 0, 0.75, 0)
WeaponNameInput.Position = UDim2.new(0.42, 0, 0.125, 0)
WeaponNameInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
WeaponNameInput.BorderColor3 = Color3.fromRGB(60, 60, 60)
WeaponNameInput.Text = "The Determination"
WeaponNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
WeaponNameInput.Font = Enum.Font.SourceSans
WeaponNameInput.TextSize = 13
WeaponNameInput.ClearTextOnFocus = false
WeaponNameInput.Parent = NameBoxFrame

-- Row 2: Target Cooldown Input Box
local CooldownBoxFrame = Instance.new("Frame")
CooldownBoxFrame.Size = UDim2.new(1, -14, 0, 32)
CooldownBoxFrame.Position = UDim2.new(0, 7, 0, 78)
CooldownBoxFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CooldownBoxFrame.BorderColor3 = Color3.fromRGB(55, 55, 55)
CooldownBoxFrame.Parent = MainFrame

local CooldownLabel = Instance.new("TextLabel")
CooldownLabel.Size = UDim2.new(0.4, 0, 1, 0)
CooldownLabel.Position = UDim2.new(0, 8, 0, 0)
CooldownLabel.BackgroundTransparency = 1
CooldownLabel.Text = "New Cooldown:"
CooldownLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
CooldownLabel.Font = Enum.Font.SourceSans
CooldownLabel.TextSize = 13
CooldownLabel.TextXAlignment = Enum.TextXAlignment.Left
CooldownLabel.Parent = CooldownBoxFrame

local CooldownValueInput = Instance.new("TextBox")
CooldownValueInput.Size = UDim2.new(0.55, 0, 0.75, 0)
CooldownValueInput.Position = UDim2.new(0.42, 0, 0.125, 0)
CooldownValueInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
CooldownValueInput.BorderColor3 = Color3.fromRGB(60, 60, 60)
CooldownValueInput.Text = "0.01"
CooldownValueInput.TextColor3 = Color3.fromRGB(255, 255, 255)
CooldownValueInput.Font = Enum.Font.SourceSansBold
CooldownValueInput.TextSize = 13
CooldownValueInput.ClearTextOnFocus = false
CooldownValueInput.Parent = CooldownBoxFrame

-- Status Feedback Display Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -14, 0, 20)
StatusLabel.Position = UDim2.new(0, 7, 0, 115)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Ready. Enter name and click Apply."
StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
StatusLabel.Font = Enum.Font.SourceSansItalic
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
StatusLabel.Parent = MainFrame

-- Action Trigger Button
local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Size = UDim2.new(1, -14, 0, 30)
ApplyBtn.Position = UDim2.new(0, 7, 0, 140)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
ApplyBtn.BorderColor3 = Color3.fromRGB(70, 70, 70)
ApplyBtn.Text = "Apply Cooldown to Weapon"
ApplyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyBtn.Font = Enum.Font.SourceSansBold
ApplyBtn.TextSize = 13
ApplyBtn.Parent = MainFrame

---------------------------------------------------------
-- 3. SINGLE PASS SEARCH ACTION LOGIC
---------------------------------------------------------
ApplyBtn.MouseButton1Click:Connect(function()
    local searchName = string.lower(WeaponNameInput.Text)
    local targetNum = tonumber(CooldownValueInput.Text) or 0.01
    local targetTool = nil
    
    -- Check local player inventory locations safely
    local character = Player.Character
    local backpack = Player:FindFirstChildOfClass("Backpack")
    
    if character then
        local tool = character:FindFirstChildOfClass("Tool")
        if tool and string.lower(tool.Name) == searchName then
            targetTool = tool
        end
    end
    
    if not targetTool and backpack then
        local tools = backpack:GetChildren()
        for i = 1, #tools do
            if string.lower(tools[i].Name) == searchName then
                targetTool = tools[i]
                break
            end
        end
    end
    
    -- If not found in inventory, try a targeted sweep in general storage areas
    if not targetTool then
        local locations = {game:GetService("ReplicatedStorage"), game:GetService("Lighting")}
        for _, storage in ipairs(locations) do
            local found = storage:FindFirstChild(WeaponNameInput.Text, true)
            if found and (found:IsA("Tool") or found:IsA("Folder") or found:IsA("Model")) then
                targetTool = found
                break
            end
        end
    end

    -- Update properties if the object target exists
    if targetTool then
        local foundCooldownObjects = 0
        local insideElements = targetTool:GetDescendants()
        
        -- Look inside item branch configurations
        for i = 1, #insideElements do
            local obj = insideElements[i]
            if (obj:IsA("NumberValue") or obj:IsA("DoubleConstrainedValue")) and string.lower(obj.Name) == "cooldown" then
                obj.Value = targetNum
                foundCooldownObjects = foundCooldownObjects + 1
            end
        end
        
        if foundCooldownObjects > 0 then
            StatusLabel.Text = "Success! Updated " .. targetTool.Name .. " Cooldown to " .. tostring(targetNum)
        else
            StatusLabel.Text = "Found '" .. targetTool.Name .. "' but no internal Cooldown variables exist."
        end
    else
        StatusLabel.Text = "Error: Could not locate weapon named '" .. WeaponNameInput.Text .. "'"
    end
end)
