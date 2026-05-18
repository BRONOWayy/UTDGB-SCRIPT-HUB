local LP = game.Players.LocalPlayer
-- Forced structural thread buffer delay to bypass executor sandbox blocks
task.wait(0.5)
local PlayerGui = LP:WaitForChild("PlayerGui", 10)

if PlayerGui:FindFirstChild("DeltaCustomUI") then PlayerGui.DeltaCustomUI:Destroy() end

-- ============================================================================
-- 🗂️ MASTER STAT DESTINATION SCANNER (ALL LOVE / XP INSTANCES)
-- ============================================================================
local function updateStatValue(statName, valueToSet)
   local targets = {
      LP:FindFirstChild("PlayerStats"),
      LP:FindFirstChild("Hopes and Dreams"),
      LP.Character and LP.Character:FindFirstChild("Head") and LP.Character.Head:FindFirstChild("PlayerStats"),
      LP.Character and LP.Character:FindFirstChild("Head") and LP.Character.Head:FindFirstChild("Hopes and Dreams")
   }
   for _, folder in pairs(targets) do
      if folder and folder:FindFirstChild(statName) then
         folder[statName].Value = valueToSet
      end
   end
end

-- ============================================================================
-- 🛠️ PURE NATIVE ROBLOX GUI GENERATION
-- ============================================================================
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

local TabFrames = {}

local function createTabFrame(name)
   local Scroll = Instance.new("ScrollingFrame")
   Scroll.Size = UDim2.new(1, 0, 1, 0)
   Scroll.BackgroundTransparency = 1
   Scroll.BorderSizePixel = 0
   Scroll.CanvasSize = UDim2.new(0, 0, 0, 550)
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

-- ============================================================================
-- 👋 CUSTOM DRAG LOGIC (COMPATIBLE WITH TOUCH & MOUSE)
-- ============================================================================
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

local function update(input)
   local delta = input.Position - dragStart
   Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Main.InputBegan:Connect(function(input)
   if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      dragging = true; dragStart = input.Position; startPos = Main.Position
      input.Changed:Connect(function()
         if input.UserInputState == Enum.UserInputState.End then dragging = false end
      end)
   end
end)
Main.InputChanged:Connect(function(input)
   if input.UserInputType == Enum.UserInputType.MouseBehavior or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
   if input == dragInput and dragging then update(input) end
end)

-- ============================================================================
-- ⚙️ COMPONENT DESIGN GENERATORS
-- ============================================================================
local function addInputBox(parentScroll, placeholderText)
   local box = Instance.new("TextBox")
   box.Size = UDim2.new(1, -10, 0, 35)
   box.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
   box.TextColor3 = Color3.fromRGB(255, 255, 255)
   box.PlaceholderText = placeholderText
   box.Text = ""
   box.Font = Enum.Font.SourceSans
   box.TextSize = 14
   box.BorderSizePixel = 1
   box.BorderColor3 = Color3.fromRGB(50, 50, 55)
   box.Parent = parentScroll
   return box
end

local function addButton(parentScroll, text, callback)
   local btn = Instance.new("TextButton")
   btn.Size = UDim2.new(1, -10, 0, 40)
   btn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
   btn.TextColor3 = Color3.fromRGB(255, 255, 255)
   btn.Text = text
   btn.Font = Enum.Font.SourceSansBold
   btn.TextSize = 14
   btn.BorderSizePixel = 0
   btn.Parent = parentScroll
   btn.MouseButton1Click:Connect(callback)
end

local function showTab(tabName)
   for name, frame in pairs(TabFrames) do frame.Visible = (name == tabName) end
end

-- ============================================================================
-- 📊 TAB 1: STATS (LOVE, XP, GOLD DEFINITIONS)
-- ============================================================================
local loveInput = addInputBox(StatsScroll, "Type Love (LV) Amount Here...")
addButton(StatsScroll, "Inject Love Level", function()
   local num = tonumber(loveInput.Text) or 1
   updateStatValue("Love", num)
end)

local xpInput = addInputBox(StatsScroll, "Type XP Amount Here...")
addButton(StatsScroll, "Inject XP Value", function()
   local num = tonumber(xpInput.Text) or 0
   updateStatValue("XP", num)
end)

local goldInput = addInputBox(StatsScroll, "Type Gold Amount Here...")
addButton(StatsScroll, "Inject Gold Value", function()
   local num = tonumber(goldInput.Text) or 0
   updateStatValue("Gold", num)
end)

-- ============================================================================
-- ⚔️ TAB 2: WEAPONS
-- ============================================================================
local weaponLvlInput = addInputBox(WeaponsScroll, "Set Weapon Level...")
addButton(WeaponsScroll, "Unlock Weapon Profiles", function()
   local lvl = tonumber(weaponLvlInput.Text) or 1
   local target = LP:FindFirstChild("Weapons") or LP:FindFirstChild("Items")
   local storage = game.ReplicatedStorage:FindFirstChild("Items") or game.ReplicatedStorage:FindFirstChild("Weapons")
   if target and storage then
      for _, obj in pairs(storage:GetChildren()) do
         if not target:FindFirstChild(obj.Name) then
            local clone = Instance.new("Folder")
            clone.Name, clone.Parent = obj.Name, target
            for _, name in pairs({"Upgrades", "UpStrength", "Level"}) do
               local v = Instance.new("IntValue", clone)
               v.Name, v.Value = name, lvl
            end
         end
      end
   end
end)

addButton(WeaponsScroll, "SELL WEAPONS FOR SERVER GOLD", function()
   local inv = LP:FindFirstChild("Cards")
   if inv then
      for _, item in pairs(inv:GetChildren()) do
         game.ReplicatedStorage.SendServer.Sell:FireServer(item, "Cards")
         task.wait(0.05)
      end
   end
end)

-- ============================================================================
-- 🛡️ TAB 3: ARMOR
-- ============================================================================
local armorLvlInput = addInputBox(ArmorScroll, "Set Armor Level...")
addButton(ArmorScroll, "Unlock Armor Profiles", function()
   local lvl = tonumber(armorLvlInput.Text) or 1
   local target = LP:FindFirstChild("Armor")
   local storage = game.ReplicatedStorage:FindFirstChild("Armor")
   if target and storage then
      for _, obj in pairs(storage:GetChildren()) do
         if not target:FindFirstChild(obj.Name) then
            local clone = Instance.new("Folder")
            clone.Name, clone.Parent = obj.Name, target
            for _, name in pairs({"Perfected", "Upgrades", "UpDefense", "UpStrength", "UpMagic", "Level"}) do
               local v = Instance.new(name == "Perfected" and "BoolValue" or "IntValue", clone)
               v.Name = name
               v.Value = (name == "Perfected" and false or lvl)
            end
         end
      end
   end
end)

addButton(ArmorScroll, "SELL ARMOR FOR SERVER GOLD", function()
   local inv = LP:FindFirstChild("Armor")
   if inv then
      for _, item in pairs(inv:GetChildren()) do
         game.ReplicatedStorage.SendServer.Sell:FireServer(item, "Armor")
         task.wait(0.05)
      end
   end
end)

-- ============================================================================
-- 🧪 TAB 4: ITEMS
-- ============================================================================
local itemAmountInput = addInputBox(ItemsScroll, "Set Item/Ticket Quantity...")
addButton(ItemsScroll, "Unlock All Consumables & Tickets", function()
   local amtStr = itemAmountInput.Text ~= "" and itemAmountInput.Text or "99"
   local target = LP:FindFirstChild("Items")
   local storage = game.ReplicatedStorage:FindFirstChild("Items")
   if target and storage then
      for _, obj in pairs(storage:GetChildren()) do
         if not target:FindFirstChild(obj.Name) then
            local clone = Instance.new("StringValue")
            clone.Name, clone.Value, clone.Parent = obj.Name, amtStr, target
         else
            target:FindFirstChild(obj.Name).Value = amtStr
         end
      end
   end
end)

-- ============================================================================
-- 🗂️ RENDER SCRIPT SIDEBAR NAVIGATION SYSTEM
-- ============================================================================
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
   
   tabBtn.MouseButton1Click:Connect(function() showTab(name) end)
end

showTab("Stats")
