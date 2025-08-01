-- Phần 1: Thiết lập GUI Conan Fly (màu xanh nước biển trong suốt, nút thu nhỏ, animation)
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Tạo ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "ConanFlyGUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- Nút toggle (Conan)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(0, 100, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
toggleBtn.Text = "Conan"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.TextScaled = true
toggleBtn.BackgroundTransparency = 0.5
toggleBtn.BorderSizePixel = 0
toggleBtn.ZIndex = 10
toggleBtn.Parent = gui
local corner1 = Instance.new("UICorner", toggleBtn)
corner1.CornerRadius = UDim.new(0, 8)

-- Khung chính (Main Frame)
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 200, 0, 200)
frame.Position = UDim2.new(0, 10, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
frame.BackgroundTransparency = 0.5
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = gui
local corner2 = Instance.new("UICorner", frame)
corner2.CornerRadius = UDim.new(0, 12)

-- Tiêu đề khung
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎯 Conan Fly"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamSemibold
title.TextScaled = true
title.Parent = frame

-- Nút bật/tắt bay
local flyBtn = Instance.new("TextButton")
flyBtn.Name = "FlyBtn"
flyBtn.Size = UDim2.new(0, 180, 0, 30)
flyBtn.Position = UDim2.new(0, 10, 0, 40)
flyBtn.Text = "Fly: OFF"
flyBtn.TextColor3 = Color3.new(1, 1, 1)
flyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
flyBtn.BackgroundTransparency = 0.5
flyBtn.BorderSizePixel = 0
flyBtn.TextScaled = true
flyBtn.Parent = frame
local corner3 = Instance.new("UICorner", flyBtn)
corner3.CornerRadius = UDim.new(0, 8)

-- Hộp nhập tốc độ
local speedBox = Instance.new("TextBox")
speedBox.Name = "SpeedBox"
speedBox.Size = UDim2.new(0, 180, 0, 30)
speedBox.Position = UDim2.new(0, 10, 0, 80)
speedBox.Text = "50"
speedBox.PlaceholderText = "Fly Speed"
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
speedBox.BackgroundTransparency = 0.5
speedBox.BorderSizePixel = 0
speedBox.ClearTextOnFocus = false
speedBox.TextScaled = true
speedBox.Parent = frame
local corner4 = Instance.new("UICorner", speedBox)
corner4.CornerRadius = UDim.new(0, 8)

-- Nút thu nhỏ (Minimize)
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -30, 0, 0)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
minimizeBtn.BackgroundTransparency = 0.5
minimizeBtn.BorderSizePixel = 0
minimizeBtn.TextScaled = true
minimizeBtn.Parent = frame
local corner5 = Instance.new("UICorner", minimizeBtn)
corner5.CornerRadius = UDim.new(0, 8)

-- Cơ chế kéo thả cho frame
local drag = false
local dragInput, mousePos, framePos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		drag = true
		mousePos = input.Position
		framePos = frame.Position
	end
end)

frame.InputChanged:Connect(function(input)
	if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - mousePos
		frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
	end
end)

frame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		drag = false
	end
end)

-- Animation thu nhỏ/phóng to
toggleBtn.MouseButton1Click:Connect(function()
	if frame.Visible then
		-- Thu nhỏ trước khi ẩn
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tween = TweenService:Create(frame, tweenInfo, {
			Size = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0, 110, 0, 150) -- Thu về tâm của frame
		})
		tween:Play()
		tween.Completed:Connect(function()
			frame.Visible = false
		end)
	else
		-- Hiện và phóng to
		frame.Visible = true
		frame.Size = UDim2.new(0, 0, 0, 0) -- Bắt đầu từ kích thước 0
		frame.Position = UDim2.new(0, 110, 0, 150) -- Vị trí tâm
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tween = TweenService:Create(frame, tweenInfo, {
			Size = UDim2.new(0, 200, 0, 200),
			Position = UDim2.new(0, 10, 0, 50)
		})
		tween:Play()
	end
end)

-- Thu nhỏ bằng nút Minimize
minimizeBtn.MouseButton1Click:Connect(function()
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(frame, tweenInfo, {
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0, 110, 0, 150) -- Thu về tâm
	})
	tween:Play()
	tween.Completed:Connect(function()
		frame.Visible = false
	end)
end)

-- Phần 2: Logic bay từ FlyGuiV3 gốc, tích hợp với GUI Conan
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local flying = false
local speed = 50
local maxspeed = 150
local ControlModule = require(player.PlayerScripts.PlayerModule.ControlModule)
local LastSpeed = speed
local BodyVelocity = nil
local BodyGyro = nil
local MobileButton
local Keys = { W = false, A = false, S = false, D = false, E = false, Q = false }

-- Tạo nút ảo cho mobile
local function CreateMobileButton()
	MobileButton = Instance.new("TextButton")
	MobileButton.Position = UDim2.new(0, 10, 0, 100)
	MobileButton.Size = UDim2.new(0, 50, 0, 50)
	MobileButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
	MobileButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	MobileButton.BackgroundTransparency = 0.5
	MobileButton.Text = flying and "OFF" or "ON"
	MobileButton.TextScaled = true
	MobileButton.Parent = gui
	local corner = Instance.new("UICorner", MobileButton)
	corner.CornerRadius = UDim.new(0, 8)
end

-- Cập nhật nút mobile
local function UpdateMobileButton()
	if MobileButton then
		MobileButton.Text = flying and "OFF" or "ON"
	end
end

-- Tắt bay
local function StopFlying()
	flying = false
	if BodyVelocity then
		BodyVelocity:Destroy()
		BodyVelocity = nil
	end
	if BodyGyro then
		BodyGyro:Destroy()
		BodyGyro = nil
	end
	flyBtn.Text = "Fly: OFF"
	flyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
	UpdateMobileButton()
end

-- Bắt đầu bay
local function StartFlying()
	local character = player.Character
	local rootPart = character and character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end
	
	if BodyVelocity then BodyVelocity:Destroy() end
	if BodyGyro then BodyGyro:Destroy() end
	
	BodyVelocity = Instance.new("BodyVelocity")
	BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	BodyVelocity.Velocity = Vector3.new(0, 0, 0)
	BodyVelocity.Parent = rootPart
	
	BodyGyro = Instance.new("BodyGyro")
	BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	BodyGyro.P = 9000
	BodyGyro.D = 500
	BodyGyro.Parent = rootPart
	
	flying = true
	flyBtn.Text = "Fly: ON"
	flyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	UpdateMobileButton()
end

-- Xử lý input bàn phím
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.W then
		Keys.W = true
	elseif input.KeyCode == Enum.KeyCode.A then
		Keys.A = true
	elseif input.KeyCode == Enum.KeyCode.S then
		Keys.S = true
	elseif input.KeyCode == Enum.KeyCode.D then
		Keys.D = true
	elseif input.KeyCode == Enum.KeyCode.E then
		Keys.E = true
	elseif input.KeyCode == Enum.KeyCode.Q then
		Keys.Q = true
	elseif input.KeyCode == Enum.KeyCode.F then
		if flying then
			StopFlying()
		else
			StartFlying()
		end
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode.W then
		Keys.W = false
	elseif input.KeyCode == Enum.KeyCode.A then
		Keys.A = false
	elseif input.KeyCode == Enum.KeyCode.S then
		Keys.S = false
	elseif input.KeyCode == Enum.KeyCode.D then
		Keys.D = false
	elseif input.KeyCode == Enum.KeyCode.E then
		Keys.E = false
	elseif input.KeyCode == Enum.KeyCode.Q then
		Keys.Q = false
	end
end)

-- Cập nhật tốc độ từ speedBox
speedBox.FocusLost:Connect(function(enterPressed)
	if not enterPressed then return end
	local value = tonumber(speedBox.Text)
	if value then
		if value > maxspeed then
			value = maxspeed
			speedBox.Text = tostring(maxspeed)
		end
		speed = value
		LastSpeed = speed
	else
		speedBox.Text = tostring(LastSpeed)
	end
end)

-- Xử lý điều khiển bay
RunService.RenderStepped:Connect(function()
	local character = player.Character
	local rootPart = character and character:FindFirstChild("HumanoidRootPart")
	local camera = workspace.CurrentCamera
	
	if not flying or not rootPart or not camera then return end
	
	local moveDirection = Vector3.new(0, 0, 0)
	if Keys.W then
		moveDirection = moveDirection + camera.CFrame.LookVector
	end
	if Keys.S then
		moveDirection = moveDirection - camera.CFrame.LookVector
	end
	if Keys.A then
		moveDirection = moveDirection - camera.CFrame.RightVector
	end
	if Keys.D then
		moveDirection = moveDirection + camera.CFrame.RightVector
	end
	if Keys.E then
		moveDirection = moveDirection + Vector3.new(0, 1, 0)
	end
	if Keys.Q then
		moveDirection = moveDirection - Vector3.new(0, 1, 0)
	end
	
	if moveDirection.Magnitude > 0 then
		moveDirection = moveDirection.Unit * speed
	end
	
	BodyVelocity.Velocity = moveDirection
	BodyGyro.CFrame = camera.CFrame
end)

-- Xử lý nút flyBtn
flyBtn.MouseButton1Click:Connect(function()
	if flying then
		StopFlying()
	else
		StartFlying()
	end
end)

-- Xử lý nhân vật tái sinh
player.CharacterAdded:Connect(function(character)
	StopFlying()
	local rootPart = character:WaitForChild("HumanoidRootPart")
	if flying then
		StartFlying()
	end
end)

-- Tạo và xử lý nút mobile
CreateMobileButton()
MobileButton.MouseButton1Click:Connect(function()
	if flying then
		StopFlying()
	else
		StartFlying()
	end
end)

-- Xử lý thiết bị mobile
UserInputService.TouchEnabled:Connect(function()
	CreateMobileButton()
	MobileButton.MouseButton1Click:Connect(function()
		if flying then
			StopFlying()
		else
			StartFlying()
		end
	end)
end)
