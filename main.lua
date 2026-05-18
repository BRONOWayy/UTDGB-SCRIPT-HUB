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
   Scroll.CanvasSize = UDim2.new(0, 0, 0, 1500) -- High canvas size to hold full scrolling item dumps
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

local MasterScroll = createTabFrame("Master Injector")

-- ============================================================================
-- 👋 SMOOTH TOUCH DRAG ENGINE
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

-- Helper design utility
local function addActionButton(parentScroll, text, color, callback)
   local btn = Instance.new("TextButton")
   btn.Size = UDim2.new(1, -10, 0, 40)
   btn.BackgroundColor3 = color or Color3.fromRGB(50, 50, 55)
   btn.TextColor3 = Color3.fromRGB(255, 255, 255)
   btn.Text = text
   btn.Font = Enum.Font.SourceSansBold
   btn.TextSize = 14
   btn.BorderSizePixel = 0
   btn.Parent = parentScroll
   btn.MouseButton1Click:Connect(callback)
end

-- ============================================================================
-- 🔥 CORE EXPLOIT: BULK LOOT AUTO-INJECTOR ENGINE
-- ============================================================================

-- MASTER MASSIVE DROP BUTTON (Attempts to inject everything simultaneously)
addActionButton(MasterScroll, "💥 INJECT ALL GAME ASSETS NOW 💥", Color3.fromRGB(180, 40, 40), function()
   task.spawn(function()
      local folders = {"Items", "Weapons", "Armor", "Cards"}
      for _, fName in pairs(folders) do
         local folder = game.ReplicatedStorage:FindFirstChild(fName)
         if folder then
            for _, asset in pairs(folder:GetChildren()) do
               -- Fire using GiveThing master node
               if game.ReplicatedStorage:FindFirstChild("SendServer") and game.ReplicatedStorage.SendServer:FindFirstChild("GiveThing") then
                  game.ReplicatedStorage.SendServer.GiveThing:FireServer(asset, 99)
               end
               -- Fire using GiveStat master node
               if game.ReplicatedStorage:FindFirstChild("SendServer") and game.ReplicatedStorage.SendServer:FindFirstChild("GiveStat") then
                  game.ReplicatedStorage.SendServer.GiveStat:FireServer(asset.Name, 99)
               end
               task.wait(0.01)
            end
         end
      end
   end)
end)

-- DYNAMIC SCROLLWHEEL DUMP LOGIC (Lists out every item individually)
local foldersToScan = {"Items", "Weapons", "Armor", "Cards"}
for _, fName in pairs(foldersToScan) do
   local targetFolder = game.ReplicatedStorage:FindFirstChild(fName)
   if targetFolder then
      for _, child in pairs(targetFolder:GetChildren()) do
         addActionButton(MasterScroll, "Force Spawn: " .. child.Name .. " ["..fName.."]", Color3.fromRGB(45, 45, 50), function()
            -- 1. Try working GiveThing parameter rule
            if game.ReplicatedStorage:FindFirstChild("SendServer") and game.ReplicatedStorage.SendServer:FindFirstChild("GiveThing") then
               game.ReplicatedStorage.SendServer.GiveThing:FireServer(child, 99)
            end
            
            -- 2. Try secondary GiveStat string bypass
            if game.ReplicatedStorage:FindFirstChild("SendServer") and game.ReplicatedStorage.SendServer:FindFirstChild("GiveStat") then
               game.ReplicatedStorage.SendServer.GiveStat:FireServer(child.Name, 99)
            end
            
            -- 3. Try direct item events if it is a booster/token (Matches your star log)
            if game.ReplicatedStorage:FindFirstChild("ItemEvents") and game.ReplicatedStorage.ItemEvents:FindFirstChild(child.Name) then
               for i = 1, 10 do
                  game.ReplicatedStorage.ItemEvents[child.Name]:FireServer()
               end
            end
         end)
      end
   end
end

-- ============================================================================
-- 🗂️ SINGLE MASTER SIDEBAR RENDER
-- ============================================================================
local tabBtn = Instance.new("TextButton")
tabBtn.Size = UDim2.new(1, -10, 0, 40)
tabBtn.Position = UDim2.new(0, 5, 0, 10)
tabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tabBtn.Text = "All Items"
tabBtn.Font = Enum.Font.SourceSansBold
tabBtn.TextSize = 14
tabBtn.BorderSizePixel = 0
tabBtn.Parent = Nav

MasterScroll.Visible = true
