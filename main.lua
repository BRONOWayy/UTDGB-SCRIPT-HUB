local LP = game.Players.LocalPlayer
task.wait(0.5)

local PlayerGui = LP:WaitForChild("PlayerGui", 15)
if PlayerGui:FindFirstChild("DeltaMasterUI") then PlayerGui.DeltaMasterUI:Destroy() end

-- ============================================================================
-- 🛠️ BASE SCREEN ENGINE
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
   Scroll.CanvasSize = UDim2.new(0, 0, 0, 1500) -- Massive canvas size to auto-scroll through all listed game items
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
-- 👋 100% FIXED DRAG HANDLER (TOUCH AND MOUSE REPOSITIONING)
-- ============================================================================
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

UserInputService.InputChanged:Connect(function(input)
   if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
      update(input)
   end
end)

-- ============================================================================
-- ⚙️ GENERATION ELEMENT TEMPLATES
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

local function addActionButton(parentScroll, text, color, callback)
   local btn = Instance.new("TextButton")
   btn.Size = UDim2.new(1, -10, 0, 35)
   btn.BackgroundColor3 = color or Color3.fromRGB(50, 50, 55)
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
-- 📊 TAB 1: STATS ENGINE (PERMANENT)
-- ============================================================================
local goldInput = addInputBox(StatsScroll, "Enter Permanent Gold Value...")
addActionButton(StatsScroll, "SET GAME GOLD", Color3.fromRGB(218, 165, 32), function()
   local amt = tonumber(goldInput.Text) or 10000
   if game.ReplicatedStorage:FindFirstChild("SendServer") and game.ReplicatedStorage.SendServer:FindFirstChild("GiveStat") then
      game.ReplicatedStorage.SendServer.GiveStat:FireServer("Gold", amt)
   end
end)

local loveInput = addInputBox(StatsScroll, "Enter Permanent Love (LV)...")
addActionButton(StatsScroll, "SET GAME LOVE LEVEL", Color3.fromRGB(199, 21, 133), function()
   local amt = tonumber(loveInput.Text) or 20
   if game.ReplicatedStorage:FindFirstChild("SendServer") and game.ReplicatedStorage.SendServer:FindFirstChild("GiveStat") then
      game.ReplicatedStorage.SendServer.GiveStat:FireServer("Love", amt)
   end
end)

-- ============================================================================
-- ⚔️ TAB 2 & 3 & 4: DYNAMIC LIST SCANNERS (BUILDS EVERY ASSET SELECTION AUTOMATICALLY)
-- ============================================================================
local globalQuantityInput = addInputBox(ItemsScroll, "Set Give Item Quantity Stack...")

local function populateListTab(parentScroll, storageFolderName, remoteName)
   local folder = game.ReplicatedStorage:FindFirstChild(storageFolderName)
   if folder then
      for _, child in pairs(folder:GetChildren()) do
         -- Generates an individual listing button labeled directly by the object name inside ReplicatedStorage
         addActionButton(parentScroll, "Spawn: " .. child.Name, Color3.fromRGB(45, 45, 50), function()
            local remote = game.ReplicatedStorage:FindFirstChild("SendServer") and game.ReplicatedStorage.SendServer:FindFirstChild(remoteName)
            if remote then
               if remoteName == "GiveThing" then
                  local qty = tonumber(globalQuantityInput.Text) or 1
                  -- Safely passes the real asset file reference found by the list scraper
                  remote:FireServer(child, qty)
               else
                  -- Standard BuyWeapon / BuyArmor exploit execution route (0 cost pass)
                  remote:FireServer(child, 0)
               end
            end
         end)
      end
   end
end

-- Instantly processes and displays the entire directory listings right on your scrollwheel windows
populateListTab(WeaponsScroll, "Weapons", "BuyWeapon")
populateListTab(WeaponsScroll, "Cards", "BuyCard")
populateListTab(ArmorScroll, "Armor", "BuyArmor")
populateListTab(ItemsScroll, "Items", "GiveThing")

-- Adds standard structural utility buttons at the top of listings
addActionButton(WeaponsScroll, "⚡ INSTANT MAX LEVEL EQUIPPED WEAPON ⚡", Color3.fromRGB(70, 130, 180), function()
   if game.ReplicatedStorage:FindFirstChild("RequestToLevelGear") then
      for i = 1, 20 do game.ReplicatedStorage.RequestToLevelGear:FireServer() task.wait(0.02) end
   end
end)

addActionButton(ArmorScroll, "⚡ INSTANT MAX LEVEL EQUIPPED ARMOR ⚡", Color3.fromRGB(70, 130, 180), function()
   if game.ReplicatedStorage:FindFirstChild("SendServer") and game.ReplicatedStorage.SendServer:FindFirstChild("UpgradeArmor") then
      for i = 1, 20 do game.ReplicatedStorage.SendServer.UpgradeArmor:FireServer() task.wait(0.02) end
   end
end)

-- ============================================================================
-- 🗂️ SIDEBAR SELECTION SYSTEM
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
