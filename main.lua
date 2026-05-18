local LP = game.Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("DeltaCustomUI") then PlayerGui.DeltaCustomUI:Destroy() end

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

local Main = Instance.new("Frame")
Main.Name = "MainWindow"
Main.Size = UDim2.new(0, 480, 0, 300)
Main.Position = UDim2.new(0.5, -240, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Main.BorderSizePixel = 1
Main.BorderColor3 = Color3.fromRGB(70, 70, 75)
Main.Active = true
Main.Parent = ScreenGui

local Nav = Instance.new("Frame")
Nav.Size = UDim2.new(0, 110, 1, 0)
Nav.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Nav.BorderSizePixel = 0
Nav.Parent = Main

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -120, 1, -10)
Content.Position = UDim2.new(0, 115, 0, 5)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- Active View Tab Tracking Table
local TabFrames = {}

-- Function to safely generate a scrolling canvas layout for each tab layer
local function createTabFrame(name)
   local Scroll = Instance.new("ScrollingFrame")
   Scroll.Size = UDim2.new(1, 0, 1, 0)
   Scroll.BackgroundTransparency = 1
   Scroll.BorderSizePixel = 0
   Scroll.CanvasSize = UDim2.new(0, 0, 0, 500)
   Scroll.ScrollBarThickness = 6
   Scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 105)
   Scroll.Visible = false
   Scroll.Parent = Content

   local Layout = Instance.new("UIListLayout")
   Layout.Padding = UDim.new(0, 6)
   Layout.SortOrder = Enum.SortOrder.LayoutOrder
   Layout.Parent = Scroll
   
   TabFrames[name] = Scroll
   return Scroll
end

local StatsScroll = createTabFrame("Stats")
local WeaponsScroll = createTabFrame("Weapons")
local ArmorScroll = createTabFrame("Armor")
local ItemsScroll = createTabFrame("Items")

-- ==========================================
-- 👋 ACTIVE DRAG HANDLER SCRIPT
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
         if input.UserInputState == Enum.UserInputState.End then dragging = false end
      end)
   end
end)

Main.InputChanged:Connect(function(input)
   if input.UserInputType == Enum.UserInputType.MouseBehavior or input.UserInputType == Enum.UserInputType.Touch then
      dragInput = input
   end
end)

UserInputService.InputChanged:Connect(function(input)
   if input == dragInput and dragging then update(input) end
end)

-- ==========================================
-- 🛠️ BUTTON ELEMENT CONSTRUCTORS
-- ==========================================
local function addToggle(parentScroll, text, callback)
   local btn = Instance.new("TextButton")
   btn.Size = UDim2.new(1, -10, 0, 40)
   btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
   btn.TextColor3 = Color3.fromRGB(220, 60, 60)
   btn.Text = text .. " [OFF]"
   btn.Font = Enum.Font.SourceSansBold
   btn.TextSize = 15
   btn.BorderSizePixel = 0
   btn.Parent = parentScroll
   
   local state = false
   btn.MouseButton1Click:Connect(function()
      state = not state
      btn.Text = text .. (state and " [ON]" or " [OFF]")
      btn.TextColor3 = state and Color3.fromRGB(60, 220, 60) or Color3.fromRGB(220, 60, 60)
      callback(state)
   end)
end

local function addButton(parentScroll, text, callback)
   local btn = Instance.new("TextButton")
   btn.Size = UDim2.new(1, -10, 0, 40)
   btn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
   btn.TextColor3 = Color3.fromRGB(255, 255, 255)
   btn.Text = text
   btn.Font = Enum.Font.SourceSans
   btn.TextSize = 14
   btn.BorderSizePixel = 0
   btn.Parent = parentScroll
   btn.MouseButton1Click:Connect(callback)
end

local function showTab(tabName)
   for name, frame in pairs(TabFrames) do
      frame.Visible = (name == tabName)
   end
end

-- ==========================================
-- 📊 TAB 1: STATS & GOLD CONTROLS
-- ==========================================
addToggle(StatsScroll, "Auto Farm Love", function(state)
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

addButton(StatsScroll, "Instantly Max XP Bar", function()
   local stats = getStats()
   if stats and stats:FindFirstChild("XP") and stats:FindFirstChild("Max") then
      stats.XP.Value = stats.Max.Value
   end
end)

-- The Gold generation functions you requested
addButton(StatsScroll, "Spoof Max Gold (Local-Visual)", function()
   local stats = getStats()
   if stats then
      for _, val in pairs(stats:GetChildren()) do
         local n = string.lower(val.Name)
         if n:find("gold") or n:find("money") or n:find("cash") or n:find("g") then
            val.Value = 999999
         end
      end
   end
end)

-- ==========================================
-- ⚔️ TAB 2: WEAPONS CONTROLS
-- ==========================================
addButton(WeaponsScroll, "Unlock All Weapons", function()
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

addButton(WeaponsScroll, "Sell Cards/Spells for Gold", function()
   local inv = LP:FindFirstChild("Cards")
   if inv and #inv:GetChildren() > 0 then
      game.ReplicatedStorage.SendServer.Sell:FireServer(inv:GetChildren(), "Cards")
   end
end)

-- ==========================================
-- 🛡️ TAB 3: ARMOR CONTROLS
-- ==========================================
addButton(ArmorScroll, "Unlock All Armor Types", function()
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

addButton(ArmorScroll, "Sell Armor for Gold", function()
   local inv = LP:FindFirstChild("Armor")
   if inv and #inv:GetChildren() > 0 then
      game.ReplicatedStorage.SendServer.Sell:FireServer(inv:GetChildren(), "Armor")
   end
end)

-- ==========================================
-- 🧪 TAB 4: ITEMS CONTROLS
-- ==========================================
addButton(ItemsScroll, "Unlock All Consumables & Tickets", function()
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
-- 🗂️ RENDER NAVIGATION CONTROLLER TABS
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

showTab("Stats")
