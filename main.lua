local LP = game.Players.LocalPlayer
task.wait(0.5)

local PlayerGui = LP:WaitForChild("PlayerGui", 15)
if PlayerGui:FindFirstChild("DeltaMasterUI") then PlayerGui.DeltaMasterUI:Destroy() end

-- Helper function to find real item instances inside game storage instead of text strings
local function findStorageObject(folderName, objectName)
   local folder = game.ReplicatedStorage:FindFirstChild(folderName)
   if folder then
      -- Finds the actual object reference inside the game's assets
      return folder:FindFirstChild(objectName)
   end
   return nil
end

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
   Scroll.CanvasSize = UDim2.new(0, 0, 0, 550) -- Dedicated scroll wheel capability
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
-- 👋 MOBILE TOUCH & PC DRAG ENGINE
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
-- ⚙️ ELEMENT UI BUILDERS
-- ============================================================================
local function addInputBox(parentScroll, placeholderText)
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
-- 📊 TAB 1: SERVER-SIDE STATS & GOLD (PROPER INSTANCE ARGUMENTS)
-- ============================================================================
local goldInput = addInputBox(StatsScroll, "Enter Permanent Gold Amount...")
addButton(StatsScroll, "GIVE SERVER GOLD", function()
   local amt = tonumber(goldInput.Text) or 10000
   if game.ReplicatedStorage:FindFirstChild("SendServer") and game.ReplicatedStorage.SendServer:FindFirstChild("GiveStat") then
      -- Passes the target name alongside the value argument directly
      game.ReplicatedStorage.SendServer.GiveStat:FireServer("Gold", amt)
   end
end)

local loveInput = addInputBox(StatsScroll, "Enter Permanent Love (LV) Level...")
addButton(StatsScroll, "GIVE SERVER LOVE LEVELS", function()
   local amt = tonumber(loveInput.Text) or 20
   if game.ReplicatedStorage:FindFirstChild("SendServer") and game.ReplicatedStorage.SendServer:FindFirstChild("GiveStat") then
      game.ReplicatedStorage.SendServer.GiveStat:FireServer("Love", amt)
   end
end)

-- ============================================================================
-- ⚔️ TAB 2: WEAPONS & CARDS (OBJECT INJECTIONS)
-- ============================================================================
local weaponNameInput = addInputBox(WeaponsScroll, "Enter Weapon Name (e.g., Toy Knife)...")
addButton(WeaponsScroll, "FORCE UNLOCK WEAPON (SERVER)", function()
   local wName = weaponNameInput.Text
   local targetObj = findStorageObject("Items", wName) or findStorageObject("Weapons", wName)
   
   if targetObj and game.ReplicatedStorage.SendServer:FindFirstChild("BuyWeapon") then
      -- CRITICAL FIX: Passes the real Object Instance instead of an invalid text string
      game.ReplicatedStorage.SendServer.BuyWeapon:FireServer(targetObj, 0)
   end
end)

local cardNameInput = addInputBox(WeaponsScroll, "Enter Card Name...")
addButton(WeaponsScroll, "FORCE UNLOCK CARD / SPELL", function()
   local cName = cardNameInput.Text
   local targetObj = findStorageObject("Cards", cName)
   
   if targetObj and game.ReplicatedStorage.SendServer:FindFirstChild("BuyCard") then
      game.ReplicatedStorage.SendServer.BuyCard:FireServer(targetObj, 0)
   end
end)

-- ============================================================================
-- 🛡️ TAB 3: ARMOR
-- ============================================================================
local armorNameInput = addInputBox(ArmorScroll, "Enter Armor Name (e.g., Locket)...")
addButton(ArmorScroll, "FORCE UNLOCK ARMOR (SERVER)", function()
   local aName = armorNameInput.Text
   local targetObj = findStorageObject("Armor", aName)
   
   if targetObj and game.ReplicatedStorage.SendServer:FindFirstChild("BuyArmor") then
      game.ReplicatedStorage.SendServer.BuyArmor:FireServer(targetObj, 0)
   end
end)

-- ============================================================================
-- 🧪 TAB 4: ITEMS & TICKETS (REAL GIVETHING INJECTION)
-- ============================================================================
local itemInput = addInputBox(ItemsScroll, "Enter Item or Ticket Name...")
local itemAmtInput = addInputBox(ItemsScroll, "Enter Quantity Amount...")
addButton(ItemsScroll, "GIVE REAL PERMANENT ITEM", function()
   local itemName = itemInput.Text
   local amt = tonumber(itemAmtInput.Text) or 1
   local targetObj = findStorageObject("Items", itemName)
   
   if targetObj and game.ReplicatedStorage.SendServer:FindFirstChild("GiveThing") then
      -- Correctly matches properties structure: passes the asset model and stack count
      game.ReplicatedStorage.SendServer.GiveThing:FireServer(targetObj, amt)
   end
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
