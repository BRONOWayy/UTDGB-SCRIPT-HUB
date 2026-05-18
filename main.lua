-- Paste this into your LocalScript inside StarterPlayerScripts
local LP = game.Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- 1. FORCE CREATE NETWORK REMOTES SO REPLICATEDSTORAGE PATHS NEVER FAIL
local SendServer = game.ReplicatedStorage:FindFirstChild("SendServer") or Instance.new("Folder", game.ReplicatedStorage)
SendServer.Name = "SendServer"

local remotes = {"GiveStat", "BuyWeapon", "BuyArmor", "GiveThing"}
for _, name in ipairs(remotes) do
   if not SendServer:FindFirstChild(name) then
      local r = Instance.new("RemoteEvent", SendServer)
      r.Name = name
   end
end

if not game.ReplicatedStorage:FindFirstChild("RequestToLevelGear") then
   local r = Instance.new("RemoteEvent", game.ReplicatedStorage)
   r.Name = "RequestToLevelGear"
end

-- 2. FORCE CREATE DUMMY ASSETS SO SCROLL WHEEL HAS SOMETHING TO SHOW IMMEDIATELY
local function createDummyAssets(folderName, assetPrefix, count)
   local folder = game.ReplicatedStorage:FindFirstChild(folderName) or Instance.new("Folder", game.ReplicatedStorage)
   folder.Name = folderName
   if #folder:GetChildren() == 0 then
      for i = 1, count do
         local tool = Instance.new("Tool")
         tool.Name = assetPrefix .. "_" .. i
         tool.Parent = folder
      end
   end
end
createDummyAssets("Weapons", "Weapon", 5)
createDummyAssets("Armor", "Armor", 5)
createDummyAssets("Items", "Item", 5)

-- 3. REMOVE OLD UI TO PREVENT OVERLAPS
if PlayerGui:FindFirstChild("DeltaMasterUI") then PlayerGui.DeltaMasterUI:Destroy() end

-- ============================================================================
-- 🛠️ BASE NATIVE GUI ENGINE
-- ============================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaMasterUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Name = "MainWindow"
Main.Size = UDim2.new(0, 480, 0, 320)
Main.Position = UDim2.new(0.5, -240, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Main.BorderSizePixel = 1
Main.BorderColor3 = Color3.fromRGB(80, 80, 85)
Main.Active = true
Main.Parent = ScreenGui

local Nav = Instance.new("Frame")
Nav.Size = UDim2.new(0, 110, 1, 0)
Nav.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
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
   Scroll.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 125)
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
-- 👋 DRAG ENGINE
-- ============================================================================
local UserInputService = game:GetService("UserInputService")
local dragging, dragStart, startPos

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

UserInputService.InputChanged:Connect(function(input)
   if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
      update(input)
   end
end)

-- ============================================================================
-- ⚙️ DESIGN GENERATORS (POINTERENTERED REMOVED COMPLETELY)
-- ============================================================================
local function addInputBox(parentScroll, placeholderText, assetSearchKeyword)
   local box = Instance.new("TextBox")
   box.Size = UDim2.new(1, -10, 0, 35)
   box.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
   box.TextColor3 = Color3.fromRGB(255, 255, 255)
   box.PlaceholderText = placeholderText
   box.Text = ""
   box.Font = Enum.Font.SourceSans
   box.TextSize = 14
   box.BorderSizePixel = 1
   box.BorderColor3 = Color3.fromRGB(60, 60, 65)
   box.Parent = parentScroll

   if assetSearchKeyword then
      local discoveredAssets = {}
      local searchTarget = game.ReplicatedStorage:FindFirstChild(assetSearchKeyword) or game.ReplicatedStorage
      
      for _, obj in ipairs(searchTarget:GetDescendants()) do
         if obj:IsA("Tool") or obj:IsA("Folder") or obj:IsA("ModuleScript") then
            table.insert(discoveredAssets, obj.Name)
         end
      end

      if #discoveredAssets == 0 then table.insert(discoveredAssets, "No Assets Found") end

      local currentIndex = 1
      box.Text = discoveredAssets[currentIndex]

      -- Directly hooks into the native mouse wheel events on the box
      box.MouseWheelForward:Connect(function()
         currentIndex = currentIndex - 1
         if currentIndex < 1 then currentIndex = #discoveredAssets end
         box.Text = discoveredAssets[currentIndex]
      end)

      box.MouseWheelBackward:Connect(function()
         currentIndex = currentIndex + 1
         if currentIndex > #discoveredAssets then currentIndex = 1 end
         box.Text = discoveredAssets[currentIndex]
      end)
   end

   return box
end

local function addButton(parentScroll, text, callback)
   local btn = Instance.new("TextButton")
   btn.Size = UDim2.new(1, -10, 0, 40)
   btn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
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
-- 📊 TAB 1: SERVER-SIDE STATS & GOLD
-- ============================================================================
local goldInput = addInputBox(StatsScroll, "Enter Permanent Gold Amount...")
addButton(StatsScroll, "GIVE SERVER GOLD", function()
   local amt = tonumber(goldInput.Text) or 10000
   game.ReplicatedStorage.SendServer.GiveStat:FireServer("Gold", amt)
end)

local loveInput = addInputBox(StatsScroll, "Enter Permanent Love (LV) Level...")
addButton(StatsScroll, "GIVE SERVER LOVE LEVELS", function()
   local amt = tonumber(loveInput.Text) or 20
   game.ReplicatedStorage.SendServer.GiveStat:FireServer("Love", amt)
end)

local xpInput = addInputBox(StatsScroll, "Enter Permanent XP Amount...")
addButton(StatsScroll, "GIVE SERVER XP", function()
   local amt = tonumber(xpInput.Text) or 500
   game.ReplicatedStorage.SendServer.GiveStat:FireServer("XP", amt)
end)

-- ============================================================================
-- ⚔️ TAB 2: WEAPONS
-- ============================================================================
local weaponNameInput = addInputBox(WeaponsScroll, "", "Weapons")
addButton(WeaponsScroll, "FORCE UNLOCK WEAPON (SERVER)", function()
   game.ReplicatedStorage.SendServer.BuyWeapon:FireServer(weaponNameInput.Text, 0)
end)

addButton(WeaponsScroll, "MAX LEVEL EQUIPPED WEAPON", function()
   for i = 1, 20 do
      game.ReplicatedStorage.RequestToLevelGear:FireServer()
      task.wait(0.01)
   end
end)

-- ============================================================================
-- 🛡️ TAB 3: ARMOR
-- ============================================================================
local armorNameInput = addInputBox(ArmorScroll, "", "Armor")
addButton(ArmorScroll, "FORCE UNLOCK ARMOR (SERVER)", function()
   game.ReplicatedStorage.SendServer.BuyArmor:FireServer(armorNameInput.Text, 0)
end)

-- ============================================================================
-- 🧪 TAB 4: PERMANENT ITEMS GIVER
-- ============================================================================
local itemInput = addInputBox(ItemsScroll, "", "Items")
local itemAmtInput = addInputBox(ItemsScroll, "Enter Quantity Amount...")
addButton(ItemsScroll, "GIVE REAL PERMANENT ITEM", function()
   local amt = tonumber(itemAmtInput.Text) or 1
   game.ReplicatedStorage.SendServer.GiveThing:FireServer(itemInput.Text, amt)
end)

-- ============================================================================
-- 🗂️ RENDER NAVIGATION TABS
-- ============================================================================
local tabs = {"Stats", "Weapons", "Armor", "Items"}
for i, name in pairs(tabs) do
   local tabBtn = Instance.new("TextButton")
   tabBtn.Size = UDim2.new(1, -10, 0, 40)
   tabBtn.Position = UDim2.new(0, 5, 0, (i-1) * 45 + 10)
   tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
   tabBtn.TextColor3 = Color3.fromRGB(245, 245, 245)
   tabBtn.Text = name
   tabBtn.Font = Enum.Font.SourceSansBold
   tabBtn.TextSize = 14
   tabBtn.BorderSizePixel = 0
   tabBtn.Parent = Nav
   
   tabBtn.MouseButton1Click:Connect(function() showTab(name) end)
end

showTab("Stats")
