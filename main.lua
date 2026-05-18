local LP = game.Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("DeltaCustomUI") then PlayerGui.DeltaCustomUI:Destroy() end

local function getStatsFolder()
   return LP:FindFirstChild("PlayerStats") or (LP.Character and LP.Character:FindFirstChild("Head") and LP.Character.Head:FindFirstChild("PlayerStats"))
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

-- ==========================================
-- 👋 CUSTOM DRAG ENGINE
-- ==========================================
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

-- ==========================================
-- 🛠️ INPUT BOX & BUTTON BUILDERS
-- ==========================================
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

-- ==========================================
-- 📊 TAB 1: STATS & SHOP INJECTIONS
-- ==========================================
local loveInput = addInputBox(StatsScroll, "How many times to invoke level up via Shop?")
addButton(StatsScroll, "GIVE LOVE (SERVER-SIDE via SHOP)", function()
   local loops = tonumber(loveInput.Text) or 5
   -- Exploits the Roblox Shop GUI frame configuration hooks shown in your explorer
   local shopRemote = game.ReplicatedStorage:FindFirstChild("ShopEvent") or game.ReplicatedStorage:FindFirstChild("RobloxShopRemote")
   if shopRemote then
      for i = 1, loops do
         shopRemote:FireServer("BuyItem", "LoveXP")
         task.wait(0.1)
      end
   else
      -- Fallback to look inside your explicit folder path found in the image
      local shopFrame = LP.PlayerGui:CustomFind("OpenRobloxShop", true)
      if shopFrame and shopFrame:FindFirstChild("RemoteEvent") then
         for i = 1, loops do shopFrame.RemoteEvent:FireServer() end
      end
   end
end)

local goldInput = addInputBox(StatsScroll, "Enter loop multi for Gold injection...")
addButton(StatsScroll, "GIVE GOLD (SERVER-SIDE)", function()
   local loops = tonumber(goldInput.Text) or 10
   for i = 1, loops do
      -- Triggers your exact armor sell events sequentially to force cash credit directly
      local armor = LP:FindFirstChild("Armor")
      if armor and #armor:GetChildren() > 0 then
         game.ReplicatedStorage.SendServer.Sell:FireServer(armor:GetChildren()[1], "Armor")
      end
      task.wait(0.05)
   end
end)

-- ==========================================
-- ⚔️ TAB 2: WEAPONS
-- ==========================================
local weaponLvlInput = addInputBox(WeaponsScroll, "Set weapon value tier...")
addButton(WeaponsScroll, "Give All Weapons", function()
   local lvl = tonumber(weaponLvlInput.Text) or 1
   local target = LP:FindFirstChild("Weapons") or LP:FindFirstChild("Items")
   local storage = game.ReplicatedStorage:FindFirstChild("Items") or game.ReplicatedStorage:FindFirstChild("Weapons")
   if target and storage then
      for _, obj in pairs(storage:GetChildren()) do
         if not target:FindFirstChild(obj.Name) then
            local clone = Instance.new("Folder")
            clone.Name, clone.Parent = obj.Name, target
            local v = Instance.new("IntValue", clone)
            v.Name, v.Value = "Level", lvl
         end
      end
   end
end)

-- ==========================================
-- 🛡️ TAB 3: ARMOR
-- ==========================================
local armorLvlInput = addInputBox(ArmorScroll, "Set armor value tier...")
addButton(ArmorScroll, "Give All Armor Types", function()
   local lvl = tonumber(armorLvlInput.Text) or 1
   local target = LP:FindFirstChild("Armor")
   local storage = game.ReplicatedStorage:FindFirstChild("Armor")
   if target and storage then
      for _, obj in pairs(storage:GetChildren()) do
         if not target:FindFirstChild(obj.Name) then
            local clone = Instance.new("Folder")
            clone.Name, clone.Parent = obj.Name, target
            local v = Instance.new("IntValue", clone)
            v.Name, v.Value = "Level", lvl
         end
      end
   end
end)

-- ==========================================
-- 🧪 TAB 4: ITEMS & TICKET EXPLOITS
-- ==========================================
local itemAmountInput = addInputBox(ItemsScroll, "How many times to loop claim tickets?")
addButton(ItemsScroll, "GIVE TICKETS & ITEMS (SERVER)", function()
   local loops = tonumber(itemAmountInput.Text) or 10
   -- Custom check targeting the "CreateDungeon" and reward triggers from your Explorer panel
   local dungeonRemote = game.ReplicatedStorage:FindFirstChild("CreateDungeon") or game.ReplicatedStorage:FindFirstChild("ClaimReward")
   if dungeonRemote and dungeonRemote:IsA("RemoteEvent") then
      for i = 1, loops do
         dungeonRemote:FireServer("Complete", "RewardTicket")
         task.wait(0.1)
      end
   end
end)

-- Helper recursive finder function to map hidden UI configurations 
function LP.PlayerGui.CustomFind(self, name, recursive)
   for _, v in pairs(self:GetChildren()) do
      if v.Name == name then return v end
      if recursive then
         local found = v:CustomFind(name, true)
         if found then return found end
      end
   end
   return nil
end

-- ==========================================
-- 🗂️ RENDER NAVIGATION TABS
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
   
   tabBtn.MouseButton1Click:Connect(function() showTab(name) end)
end

showTab("Stats")
