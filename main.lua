local P = game:GetService("Players")
local lp = P.LocalPlayer
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Cleanup
if CoreGui:FindFirstChild("NebulaX_Elite") then CoreGui.NebulaX_Elite:Destroy() end

local NebulaX = Instance.new("ScreenGui", CoreGui)
NebulaX.Name = "NebulaX_Elite"

-- [[ THEME COLOR PALETTE ]]
local bg_main = Color3.fromRGB(15, 15, 20)
local bg_secondary = Color3.fromRGB(22, 22, 30)
local accent = Color3.fromRGB(0, 170, 255) -- Deep Sky Blue
local text_main = Color3.fromRGB(255, 255, 255)
local text_dim = Color3.fromRGB(180, 180, 180)

-- [[ HELPER: SMOOTH HOVER ]]
local function AddHover(btn, normal, hover)
	btn.MouseEnter:Connect(function()
		TS:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = hover}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TS:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = normal}):Play()
	end)
end

-- [[ MAIN HUB ]]
local Main = Instance.new("Frame", NebulaX)
Main.Size = UDim2.new(0, 480, 0, 320)
Main.Position = UDim2.new(0.5, -240, 0.5, -160)
Main.BackgroundColor3 = bg_main
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 12)

-- Blue Glow Border (Solid)
local Border = Instance.new("UIStroke", Main)
Border.Thickness = 2
Border.Color = accent
Border.Transparency = 0.4

-- [[ SIDEBAR ]]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = bg_secondary
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "NEBULAX"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = accent
Title.BackgroundTransparency = 1

-- [[ NAVIGATION SYSTEM ]]
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -160, 1, -40)
Container.Position = UDim2.new(0, 150, 0, 20)
Container.BackgroundTransparency = 1

local Pages = {}
local function CreateTab(name, order)
	local Page = Instance.new("ScrollingFrame", Container)
	Page.Size = UDim2.new(1, 0, 1, 0)
	Page.Visible = (order == 1)
	Page.BackgroundTransparency = 1
	Page.ScrollBarThickness = 2
	Page.ScrollBarImageColor3 = accent
	local Layout = Instance.new("UIListLayout", Page)
	Layout.Padding = UDim.new(0, 8)
	Pages[name] = Page

	local TabBtn = Instance.new("TextButton", Sidebar)
	TabBtn.Size = UDim2.new(0.85, 0, 0, 35)
	TabBtn.Position = UDim2.new(0.075, 0, 0, 70 + (order-1)*42)
	TabBtn.Text = name
	TabBtn.Font = Enum.Font.GothamSemibold
	TabBtn.TextSize = 14
	TabBtn.TextColor3 = (order == 1) and text_main or text_dim
	TabBtn.BackgroundColor3 = (order == 1) and accent or Color3.fromRGB(30, 30, 40)
	Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

	TabBtn.MouseButton1Click:Connect(function()
		for _, p in pairs(Pages) do p.Visible = false end
		for _, b in pairs(Sidebar:GetChildren()) do
			if b:IsA("TextButton") then
				TS:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 40), TextColor3 = text_dim}):Play()
			end
		end
		Page.Visible = true
		TS:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = accent, TextColor3 = text_main}):Play()
	end)
end

local tabs = {"Home", "Combat", "Farming", "Visuals", "Settings"}
for i, v in ipairs(tabs) do CreateTab(v, i) end

-- [[ COMPONENT: BUTTON ]]
local function CreateButton(parent, text, callback)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(1, -10, 0, 40)
	b.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
	b.Text = text
	b.Font = Enum.Font.GothamMedium
	b.TextColor3 = text_main
	b.TextSize = 14
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	local s = Instance.new("UIStroke", b)
	s.Thickness = 1
	s.Color = accent
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	
	b.MouseButton1Click:Connect(callback)
	AddHover(b, Color3.fromRGB(35, 35, 45), Color3.fromRGB(45, 45, 55))
end

-- Example usage in Farming Tab
CreateButton(Pages["Farming"], "[ GALACTIC GLUE ]", function()
	print("Galactic Glue Activated")
end)

-- [[ WIDGET / MINIMIZE ]]
local Widget = Instance.new("ImageButton", NebulaX)
Widget.Size = UDim2.new(0, 55, 0, 55)
Widget.Position = UDim2.new(0, 20, 0.5, -27)
Widget.BackgroundColor3 = bg_main
Widget.Image = "rbxassetid://13835032549" -- Ninja Icon
Widget.Visible = false
Widget.Draggable = true
Instance.new("UICorner", Widget).CornerRadius = UDim.new(0, 10)
local ws = Instance.new("UIStroke", Widget)
ws.Thickness = 2
ws.Color = accent

-- [[ WINDOW CONTROLS ]]
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "×"
CloseBtn.TextSize = 24
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.BackgroundTransparency = 1

local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -65, 0, 5)
MinBtn.Text = "-"
MinBtn.TextSize = 24
MinBtn.TextColor3 = text_main
MinBtn.BackgroundTransparency = 1

-- Logic
CloseBtn.MouseButton1Click:Connect(function() NebulaX:Destroy() end)
MinBtn.MouseButton1Click:Connect(function()
	Main.Visible = false
	Widget.Visible = true
end)
Widget.MouseButton1Click:Connect(function()
	Main.Visible = true
	Widget.Visible = false
end)
