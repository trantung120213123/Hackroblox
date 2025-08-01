-- Lưu file này lên GitHub, sau đó dùng loadstring để tải về sử dụng

local ConanLib = {}

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Main GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ConanHub"

-- Toggle Button (💀)
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.Text = "💀"
ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ToggleButton.BackgroundTransparency = 0.3
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.TextScaled = true
ToggleButton.Draggable = true
ToggleButton.Active = true

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true

-- Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Conan Hub"
Title.BackgroundTransparency = 1
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1, 1, 1)

-- Minimize Button (-)
local Minimize = Instance.new("TextButton", MainFrame)
Minimize.Size = UDim2.new(0, 40, 0, 40)
Minimize.Position = UDim2.new(1, -40, 0, 0)
Minimize.Text = "-"
Minimize.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
Minimize.TextColor3 = Color3.new(1, 1, 1)
Minimize.TextScaled = true

-- Hide/Show logic
ToggleButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

Minimize.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
end)

-- Return Lib
ConanLib.MainFrame = MainFrame
ConanLib.ScreenGui = ScreenGui
ConanLib.ToggleButton = ToggleButton

return ConanLib

local ConanLib = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ConanLibUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 280)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- UICorner
local Corner = Instance.new("UICorner", MainFrame)
Corner.CornerRadius = UDim.new(0, 8)

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "Conan Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Parent = MainFrame

-- Nút thu nhỏ
local ToggleButton = Instance.new("TextButton")
ToggleButton.Text = "💀"
ToggleButton.Size = UDim2.new(0, 30, 0, 30)
ToggleButton.Position = UDim2.new(1, -35, 0, 5)
ToggleButton.BackgroundTransparency = 1
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextScaled = true
ToggleButton.Parent = MainFrame

-- Nội dung chính (Container để chứa Tab + Content)
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -20, 1, -40)
Container.Position = UDim2.new(0, 10, 0, 35)
Container.BackgroundTransparency = 1
Container.Name = "Container"
Container.Parent = MainFrame

-- Tabs
local TabList = Instance.new("Frame")
TabList.Size = UDim2.new(0, 100, 1, 0)
TabList.BackgroundTransparency = 0.4
TabList.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
TabList.Parent = Container

local UICorner = Instance.new("UICorner", TabList)
UICorner.CornerRadius = UDim.new(0, 6)

local UIListLayout = Instance.new("UIListLayout", TabList)
UIListLayout.Padding = UDim.new(0, 5)

-- Tab Content Holder
local TabContent = Instance.new("Frame")
TabContent.Name = "TabContent"
TabContent.Size = UDim2.new(1, -110, 1, 0)
TabContent.Position = UDim2.new(0, 110, 0, 0)
TabContent.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
TabContent.BackgroundTransparency = 0.3
TabContent.Parent = Container

local UICorner2 = Instance.new("UICorner", TabContent)
UICorner2.CornerRadius = UDim.new(0, 6)

-- Hàm thêm tab
function ConanLib:CreateTab(name)
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1, -10, 0, 30)
	Button.Text = name
	Button.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
	Button.TextColor3 = Color3.new(1, 1, 1)
	Button.Parent = TabList

	local UICorner = Instance.new("UICorner", Button)
	UICorner.CornerRadius = UDim.new(0, 6)

	local Page = Instance.new("ScrollingFrame")
	Page.Size = UDim2.new(1, 0, 1, 0)
	Page.CanvasSize = UDim2.new(0, 0, 1, 0)
	Page.Visible = false
	Page.BackgroundTransparency = 1
	Page.BorderSizePixel = 0
	Page.Parent = TabContent

	Button.MouseButton1Click:Connect(function()
		for _, v in pairs(TabContent:GetChildren()) do
			if v:IsA("ScrollingFrame") then
				v.Visible = false
			end
		end
		Page.Visible = true
	end)

	return Page
end

-- Toggle thu nhỏ GUI
local Minimized = false
ToggleButton.MouseButton1Click:Connect(function()
	Minimized = not Minimized
	MainFrame:TweenSize(Minimized and UDim2.new(0, 180, 0, 40) or UDim2.new(0, 420, 0, 280), "Out", "Quad", 0.25, true)
	Container.Visible = not Minimized
end)

return ConanLib

local ConanLib = {}
ConanLib.__index = ConanLib

function ConanLib:CreateTab(tabName)
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(1, 0, 0, 35)
	tabBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
	tabBtn.TextColor3 = Color3.new(1,1,1)
	tabBtn.Font = Enum.Font.GothamBold
	tabBtn.Text = "  " .. tabName
	tabBtn.TextXAlignment = Enum.TextXAlignment.Left
	tabBtn.Name = tabName
	tabBtn.BorderSizePixel = 0
	tabBtn.Parent = self.TabList

	local pageFrame = Instance.new("Frame")
	pageFrame.Name = tabName .. "_Page"
	pageFrame.BackgroundTransparency = 1
	pageFrame.Size = UDim2.new(1, 0, 1, 0)
	pageFrame.Visible = false
	pageFrame.Parent = self.PageContainer

	tabBtn.MouseButton1Click:Connect(function()
		for _, v in pairs(self.PageContainer:GetChildren()) do
			if v:IsA("Frame") then
				v.Visible = false
			end
		end
		pageFrame.Visible = true
	end)

	return {
		AddSection = function(_, sectionTitle)
			local section = Instance.new("Frame")
			section.Size = UDim2.new(1, -10, 0, 30)
			section.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
			section.BorderSizePixel = 0
			section.Name = sectionTitle
			section.Parent = pageFrame

			local layout = Instance.new("UIListLayout", section)
			layout.Padding = UDim.new(0, 5)
			layout.FillDirection = Enum.FillDirection.Vertical
			layout.SortOrder = Enum.SortOrder.LayoutOrder

			local sectionLabel = Instance.new("TextLabel")
			sectionLabel.Size = UDim2.new(1, 0, 0, 20)
			sectionLabel.BackgroundTransparency = 1
			sectionLabel.TextColor3 = Color3.new(1, 1, 1)
			sectionLabel.Font = Enum.Font.GothamBold
			sectionLabel.TextSize = 16
			sectionLabel.Text = "   " .. sectionTitle
			sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
			sectionLabel.Parent = section

			return {
				AddButton = function(_, btnText, callback)
					local btn = Instance.new("TextButton")
					btn.Size = UDim2.new(1, -10, 0, 30)
					btn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
					btn.TextColor3 = Color3.new(1,1,1)
					btn.Font = Enum.Font.Gotham
					btn.TextSize = 14
					btn.Text = btnText
					btn.Parent = section
					btn.BorderSizePixel = 0
					btn.MouseButton1Click:Connect(callback)
				end
			}
		end
	}
end

-- TAB BUTTON FUNCTION
local currentTab = nil

local function switchTab(tabName)
	for _, content in pairs(MainFrame:GetChildren()) do
		if content:IsA("Frame") and content.Name ~= "Topbar" and content.Name ~= "Tabs" then
			content.Visible = false
		end
	end

	local selectedTab = MainFrame:FindFirstChild(tabName)
	if selectedTab then
		selectedTab.Visible = true
		currentTab = tabName
	end
end

-- CREATE TAB CONTENT FUNCTION
local function createTabPage(tabName)
	local tabPage = Instance.new("Frame")
	tabPage.Name = tabName
	tabPage.Size = UDim2.new(1, 0, 1, -50)
	tabPage.Position = UDim2.new(0, 0, 0, 50)
	tabPage.BackgroundTransparency = 1
	tabPage.Visible = false
	tabPage.Parent = MainFrame
	return tabPage
end

-- CREATE TAB BUTTON FUNCTION
local function createTab(name)
	local btn = Instance.new("TextButton")
	btn.Text = name
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.Position = UDim2.new(0, 5, 0, #TabHolder:GetChildren() * 45)
	btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	btn.BorderSizePixel = 0
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 16
	btn.AutoButtonColor = true
	btn.Name = "TabButton_" .. name
	btn.Parent = TabHolder

	btn.MouseButton1Click:Connect(function()
		switchTab(name)
	end)

	local content = createTabPage(name)
	return content
end

-- Thêm API vào thư viện ConanHub
function ConanHub:CreateButton(tabName, text, callback)
	local tabFrame = ConanHub.Tabs[tabName]
	if not tabFrame then warn("Tab không tồn tại: " .. tabName) return end

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -20, 0, 36)
	button.Position = UDim2.new(0, 10, 0, #tabFrame:GetChildren() * 40 + 10)
	button.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
	button.BorderSizePixel = 0
	button.Text = text
	button.Font = Enum.Font.GothamBold
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextSize = 16
	button.AutoButtonColor = true
	button.Parent = tabFrame

	button.MouseButton1Click:Connect(callback)
end

function ConanHub:CreateLabel(tabName, text)
	local tabFrame = ConanHub.Tabs[tabName]
	if not tabFrame then warn("Tab không tồn tại: " .. tabName) return end

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 0, 30)
	label.Position = UDim2.new(0, 10, 0, #tabFrame:GetChildren() * 40 + 10)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.Gotham
	label.TextColor3 = Color3.fromRGB(255, 100, 100)
	label.TextSize = 16
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = tabFrame
end

function ConanHub:CreateTextbox(tabName, placeholderText, onEnter)
	local tabFrame = ConanHub.Tabs[tabName]
	if not tabFrame then warn("Tab không tồn tại: " .. tabName) return end

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, -20, 0, 34)
	box.Position = UDim2.new(0, 10, 0, #tabFrame:GetChildren() * 40 + 10)
	box.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
	box.BorderSizePixel = 0
	box.PlaceholderText = placeholderText
	box.Text = ""
	box.Font = Enum.Font.Gotham
	box.TextColor3 = Color3.new(1, 1, 1)
	box.TextSize = 15
	box.ClearTextOnFocus = false
	box.Parent = tabFrame

	box.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			onEnter(box.Text)
		end
	end)
end

-- ⚠️ Phải chạy sau khi tạo `MainGui`, `MainFrame`, và `ContainerFrame` trong các phần trước

-- Khung chứa tab bên trái
local TabList = Instance.new("Frame")
TabList.Name = "TabList"
TabList.Size = UDim2.new(0, 120, 1, 0)
TabList.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
TabList.BackgroundTransparency = 0.4
TabList.Parent = MainFrame

-- Khung chứa nội dung của mỗi tab
local TabContent = Instance.new("Frame")
TabContent.Name = "TabContent"
TabContent.Size = UDim2.new(1, -120, 1, -30)
TabContent.Position = UDim2.new(0, 120, 0, 30)
TabContent.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TabContent.BackgroundTransparency = 0.6
TabContent.Parent = MainFrame

-- Hàm tạo tab
local Tabs = {}

function CreateTab(tabName)
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(1, -10, 0, 30)
	tabBtn.Position = UDim2.new(0, 5, 0, (#Tabs * 35) + 10)
	tabBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
	tabBtn.BackgroundTransparency = 0.3
	tabBtn.BorderSizePixel = 0
	tabBtn.Text = tabName
	tabBtn.Font = Enum.Font.GothamSemibold
	tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	tabBtn.TextSize = 14
	tabBtn.Parent = TabList

	-- Nội dung tab
	local tabPage = Instance.new("ScrollingFrame")
	tabPage.Size = UDim2.new(1, 0, 1, 0)
	tabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabPage.ScrollBarThickness = 6
	tabPage.BackgroundTransparency = 1
	tabPage.Visible = false
	tabPage.Parent = TabContent

	-- Khi bấm vào tab
	tabBtn.MouseButton1Click:Connect(function()
		for i, tab in pairs(Tabs) do
			tab.Page.Visible = false
		end
		tabPage.Visible = true
	end)

	-- Lưu tab
	table.insert(Tabs, {
		Name = tabName,
		Button = tabBtn,
		Page = tabPage,
	})

	return tabPage -- Trả về khung nội dung để thêm nội dung sau này
end

-- Ví dụ tạo 3 tab
local mainTab = CreateTab("Main")
local playerTab = CreateTab("Players")
local teleportTab = CreateTab("Teleport")

-- Hiện tab đầu tiên khi mở
Tabs[1].Page.Visible = true

function Conan:Notify(title, text, duration)
	local dur = duration or 3

	local Notify = Instance.new("Frame")
	Notify.Size = UDim2.new(0, 250, 0, 60)
	Notify.Position = UDim2.new(1, -270, 1, -80)
	Notify.AnchorPoint = Vector2.new(0, 1)
	Notify.BackgroundColor3 = Color3.fromRGB(255, 90, 90)
	Notify.BackgroundTransparency = 0.1
	Notify.BorderSizePixel = 0
	Notify.Name = "Notify"
	Notify.Parent = ScreenGui
	Notify.ClipsDescendants = true
	Notify.ZIndex = 999999

	local UICorner = Instance.new("UICorner", Notify)
	UICorner.CornerRadius = UDim.new(0, 12)

	local Title = Instance.new("TextLabel")
	Title.Parent = Notify
	Title.Size = UDim2.new(1, -20, 0, 20)
	Title.Position = UDim2.new(0, 10, 0, 5)
	Title.BackgroundTransparency = 1
	Title.Text = title or "Thông báo"
	Title.TextSize = 16
	Title.Font = Enum.Font.GothamBold
	Title.TextColor3 = Color3.new(1, 1, 1)
	Title.TextXAlignment = Enum.TextXAlignment.Left

	local Desc = Instance.new("TextLabel")
	Desc.Parent = Notify
	Desc.Size = UDim2.new(1, -20, 0, 30)
	Desc.Position = UDim2.new(0, 10, 0, 25)
	Desc.BackgroundTransparency = 1
	Desc.Text = text or "Đây là nội dung thông báo."
	Desc.TextSize = 14
	Desc.Font = Enum.Font.Gotham
	Desc.TextColor3 = Color3.new(1, 1, 1)
	Desc.TextXAlignment = Enum.TextXAlignment.Left

	Notify.Position = Notify.Position + UDim2.new(0, 300, 0, 0)
	Notify.BackgroundTransparency = 1
	Notify:TweenPosition(UDim2.new(1, -270, 1, -80), "Out", "Quad", 0.4, true)
	Notify:TweenSize(UDim2.new(0, 250, 0, 60), "Out", "Quad", 0.4, true)
	Notify:TweenTransparency(0.1, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.4)

	wait(dur)

	pcall(function()
		Notify:TweenPosition(UDim2.new(1, 300, 1, -80), "In", "Quad", 0.4, true)
		wait(0.4)
		Notify:Destroy()
	end)
end

local function ShowNotification(message, duration)
	duration = duration or 3

	-- Tạo GUI nếu chưa có
	local notifScreen = game.CoreGui:FindFirstChild("NotifScreenGui")
	if not notifScreen then
		notifScreen = Instance.new("ScreenGui", game.CoreGui)
		notifScreen.Name = "NotifScreenGui"
	end

	local notifFrame = Instance.new("Frame")
	notifFrame.Size = UDim2.new(0, 300, 0, 35)
	notifFrame.Position = UDim2.new(0, 10, 1, -50)
	notifFrame.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
	notifFrame.BorderSizePixel = 0
	notifFrame.BackgroundTransparency = 0.1
	notifFrame.Parent = notifScreen
	notifFrame.ClipsDescendants = true

	local notifCorner = Instance.new("UICorner", notifFrame)
	notifCorner.CornerRadius = UDim.new(0, 8)

	local notifLabel = Instance.new("TextLabel")
	notifLabel.Text = message
	notifLabel.TextColor3 = Color3.new(1, 1, 1)
	notifLabel.Font = Enum.Font.Gotham
	notifLabel.TextSize = 14
	notifLabel.Size = UDim2.new(1, -10, 1, 0)
	notifLabel.Position = UDim2.new(0, 5, 0, 0)
	notifLabel.BackgroundTransparency = 1
	notifLabel.TextXAlignment = Enum.TextXAlignment.Left
	notifLabel.Parent = notifFrame

	-- Animate lên
	local TweenService = game:GetService("TweenService")
	local tweenIn = TweenService:Create(notifFrame, TweenInfo.new(0.4), {Position = UDim2.new(0, 10, 1, -80)})
	tweenIn:Play()

	-- Delay rồi tự ẩn
	task.delay(duration, function()
		local tweenOut = TweenService:Create(notifFrame, TweenInfo.new(0.4), {Position = UDim2.new(0, 10, 1, 50)})
		tweenOut:Play()
		tweenOut.Completed:Wait()
		notifFrame:Destroy()
	end)
end

-- 🧪 Ví dụ sử dụng:
-- ShowNotification("ESP đã bật", 2)
-- ShowNotification("NoClip OFF", 3)
