local LP = game.Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- Clean up any previous instances of this script to avoid visual overlapping
if PlayerGui:FindFirstChild("DeltaCustomUI") then PlayerGui.DeltaCustomUI:Destroy() end

-- Helper function to safely locate PlayerStats wherever the game scripts map it
local function getStats()
   local c = LP.Character
   return (c and c:FindFirstChild("Head") and c.Head:FindFirstChild("PlayerStats")) or LP:FindFirstChild("PlayerStats")
end

-- ==========================================
-- 🛠️ BASE NATIVE GUI ENGINE
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaCustomUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- Main Drag Container Panel (Fixed dimensions, clean theme)
local Main = Instance.new("Frame")
Main.Name = "MainWindow"
Main.Size = UDim2.new(0, 480, 0, 300)
Main.Position = UDim2.new(0.5, -240, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Main.BorderSizePixel = 1
Main.BorderColor3 = Color3.fromRGB(70, 70, 75)
Main.Active = true
Main.Parent = ScreenGui

-- Tab Navigation Sidebar Panel (Left Side)
local Nav = Instance.new("Frame")
Nav.Size = UDim2.new(0, 110, 1, 0)
Nav.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Nav.BorderSizePixel = 0
Nav.Parent = Main

-- Content Output Display Panel (Right Side)
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -120, 1, -10)
Content.Position = UDim2.new(0, 115, 0, 5)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- Scroll Wheel Frame (Handles vertical overflowing)
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, 0, 1, 0)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0, 0, 0, 450) -- Dynamic height capacity
Scroll.ScrollBarThickness = 6
Scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 105)
Scroll.Parent = Content

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Scroll

-- Core interaction tables mapped by tab context
local TabData = {Stats = {}, Weapons = {}, Armor = {}, Items = {}}

-- ==========================================
-- 👋 CUSTOM ACTIVE DRAG HANDLER SCRIPT
-- ==========================================
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

local function update(input)
   local delta = input.Position - dragStart
   Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Main.InputBegan:Connect(function(input)
   if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      dragging = true
      dragStart = input.Position
      startPos = Main.Position
      
      input.Changed:Connect(function()
         if input.UserInputState == Enum.UserInputState.End then
            dragging = false
         end
      end)
   end
end)

Main.InputChanged:Connect(function(input)
   if input.UserInputType == Enum.UserInputType.MouseBehavior or input.UserInputType == Enum.UserInputType.Touch then
      dragInput = input
   end
end)

UserInputService.InputChanged:Connect(function(input)
   if input == dragInput and dragging then
      update(input)
   end
end)

-- ==========================================
-- 🛠️ UI CONTROL MAKERS
-- ==========================================
local function addToggle(tab, text, callback)
   local btn = Instance.new("TextButton")
   btn.Size = UDim2.new(1, -10, 0, 40)
   btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
   btn.TextColor3 = Color3.fromRGB(220, 60, 60)
   btn.Text = text .. " [OFF]"
   btn.Font = Enum.Font.SourceSansBold
   btn.TextSize = 15
   btn.BorderSizePixel = 0
   
   local state = false
   btn.MouseButton1Click:Connect(function()
      state = not state
      btn.Text = text .. (state and " [ON]" or " [OFF]")
      btn.TextColor3 = state and Color3.fromRGB(60, 220, 60) or Color3.fromRGB(220, 60, 60)
      callback(state)
   end)
   table.insert(TabData[tab], btn)
end

local function addButton(tab, text, callback)
   local btn = Instance.new("TextButton")
   btn.Size = UDim2.new(1, -10, 0, 40)
   btn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
   btn.TextColor3 = Color3.fromRGB(255, 255, 255)
   btn.Text = text
   btn.Font = Enum.Font.SourceSans
   btn.TextSize = 14
   btn.BorderSizePixel = 0
   btn.MouseButton1Click:Connect(callback)
   table.insert(TabData[tab], btn)
end

local function showTab(tabName)
   -- Clear layout tree while tracking structural layout anchors
   for _, child in pairs(Scroll:GetChildren()) do
      if child:IsA("TextButton") then child:Destroy() end
   end
   for _, element in pairs(TabData[tabName]) do
      element.Parent = Scroll
   end
end

-- ==========================================
-- 📊 TAB 1: STATS DATA
-- ==========================================
addToggle("Stats", "Auto Farm Love", function(state)
   _G.AutoLoveFarm = state
   task.spawn(function()
      while _G.AutoLoveFarm do
         local stats = getStats()
         if stats and stats:FindFirstChild("Love") then
            stats.Love.Value = stats.Love.Value + 1
         end
         task.wait(0.5)
      end
   end)
end)

addButton("Stats", "Instantly Max XP Bar", function()
   local stats = getStats()
   if stats and stats:FindFirstChild("XP") and stats:FindFirstChild("Max") then
      stats.XP.Value = stats.Max.Value
   end
end)

-- ==========================================
-- ⚔️ TAB 2: WEAPONS DATA
-- ==========================================
addButton("Weapons", "Unlock All Weapons", function()
   local target = LP:FindFirstChild("Weapons") or LP:FindFirstChild("Items")
   local storage = game.ReplicatedStorage:FindFirstChild("Items") or game.ReplicatedStorage:FindFirstChild("Weapons")
   if target and storage then
      for _, obj in pairs(storage:GetChildren()) do
         if not target:FindFirstChild(obj.Name) then
            local clone = Instance.new("Folder")
            clone.Name = obj.Name
            for _, name in pairs({"Upgrades", "UpStrength", "Level"}) do
               local v = Instance.new("IntValue", clone)
               v.Name = name
               v.Value = 1
            end
            clone.Parent = target
         end
      end
   end
end)

addButton("Weapons", "Sell Cards/Spells (Gold)", function()
   local inv = LP:FindFirstChild("Cards")
   if inv and #inv:GetChildren() > 0 then
      game.ReplicatedStorage.SendServer.Sell:FireServer(inv:GetChildren(), "Cards")
   end
end)

-- ==========================================
-- 🛡️ TAB 3: ARMOR DATA
-- ==========================================
addButton("Armor", "Unlock All Armor Types", function()
   local target = LP:FindFirstChild("Armor")
   local storage = game.ReplicatedStorage:FindFirstChild("Armor")
   if target and storage then
      for _, obj in pairs(storage:GetChildren()) do
         if not target:FindFirstChild(obj.Name) then
            local clone = Instance.new("Folder")
            clone.Name = obj.Name
            for _, name in pairs({"Perfected", "Upgrades", "UpDefense", "UpStrength", "UpMagic", "Level"}) do
               local v = Instance.new(name == "Perfected" and "BoolValue" or "IntValue", clone)
               v.Name = name
               if name ~= "Perfected" then v.Value = 1 end
            end
            clone.Parent = target
         end
      end
   end
end)

addButton("Armor", "Sell Armor Inventory (Gold)", function()
   local inv = LP:FindFirstChild("Armor")
   if inv and #inv:GetChildren() > 0 then
      game.ReplicatedStorage.SendServer.Sell:FireServer(inv:GetChildren(), "Armor")
   end
end)

-- ==========================================
-- 🧪 TAB 4: ITEMS DATA
-- ==========================================
addButton("Items", "Unlock All Consumables & Tickets", function()
   local target = LP:FindFirstChild("Items")
   local storage = game.ReplicatedStorage:FindFirstChild("Items")
   if target and storage then
      for _, obj in pairs(storage:GetChildren()) do
         if not target:FindFirstChild(obj.Name) then
            local clone = Instance.new("StringValue")
            clone.Name = obj.Name
            clone.Value = "99"
            clone.Parent = target
         end
      end
   end
end)

-- ==========================================
-- 🗂️ DRAW NAVIGATION TABS
-- ==========================================
local tabs = {"Stats", "Weapons", "Armor", "Items"}
for i, name in pairs(tabs) do
   local tabBtn = Instance.new("TextButton")
   tabBtn.Size = UDim2.new(1, -10, 0, 40)
   tabBtn.Position = UDim2.new(0, 5, 0, (i-1) * 45 + 10)
   tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
   tabBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
   tabBtn.Text = name
   tabBtn.Font = Enum.Font.SourceSansBold
   tabBtn.TextSize = 14
   tabBtn.BorderSizePixel = 0
   tabBtn.Parent = Nav
   
   tabBtn.MouseButton1Click:Connect(function()
      showTab(name)
   end)
end

-- Force load the default Tab content layout engine
showTab("Stats")
