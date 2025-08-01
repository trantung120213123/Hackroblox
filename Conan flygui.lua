-- Phần 1: Thiết lập GUI Conan Fly (Màu xanh nước biển, kéo được, thu mở mượt)
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Tạo ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "ConanFlyGUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- Nút toggle (Conan Fly)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(0, 100, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
toggleBtn.Text = "Conan Fly"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.TextScaled = true
toggleBtn.BackgroundTransparency = 0.3
toggleBtn.BorderSizePixel = 0
toggleBtn.ZIndex = 10
toggleBtn.Parent = gui
local corner1 = Instance.new("UICorner", toggleBtn)
corner1.CornerRadius = UDim.new(0, 8)

-- Khung chính (Main Frame)
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0, 10, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
frame.BackgroundTransparency = 0.4
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
flyBtn.Text = "Toggle Fly: OFF"
flyBtn.TextColor3 = Color3.new(1, 1, 1)
flyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
flyBtn.BackgroundTransparency = 0.3
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
speedBox.Text = "16"
speedBox.PlaceholderText = "Fly Speed"
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
speedBox.BackgroundTransparency = 0.3
speedBox.BorderSizePixel = 0
speedBox.ClearTextOnFocus = false
speedBox.TextScaled = true
speedBox.Parent = frame
local corner4 = Instance.new("UICorner", speedBox)
corner4.CornerRadius = UDim.new(0, 8)

-- Nút đóng khung
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.BackgroundTransparency = 0.3
closeBtn.BorderSizePixel = 0
closeBtn.TextScaled = true
closeBtn.Parent = frame
local corner5 = Instance.new("UICorner", closeBtn)
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

-- Animation thu mở cho frame
toggleBtn.MouseButton1Click:Connect(function()
	if frame.Visible then
		-- Thu nhỏ trước khi ẩn
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tween = TweenService:Create(frame, tweenInfo, {
			Size = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0, 110, 0, 125) -- Thu về tâm của frame
		})
		tween:Play()
		tween.Completed:Connect(function()
			frame.Visible = false
		end)
	else
		-- Hiện và phóng to
		frame.Visible = true
		frame.Size = UDim2.new(0, 0, 0, 0) -- Bắt đầu từ kích thước 0
		frame.Position = UDim2.new(0, 110, 0, 125) -- Vị trí tâm
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tween = TweenService:Create(frame, tweenInfo, {
			Size = UDim2.new(0, 200, 0, 150),
			Position = UDim2.new(0, 10, 0, 50)
		})
		tween:Play()
	end
end)

-- Đóng khung bằng nút X
closeBtn.MouseButton1Click:Connect(function()
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(frame, tweenInfo, {
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0, 110, 0, 125) -- Thu về tâm
	})
	tween:Play()
	tween.Completed:Connect(function()
		frame.Visible = false
	end)
end)

-- Phần 2: Logic bay cho Conan Fly GUI
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Biến trạng thái bay
local flying = false
local velocity = Instance.new("BodyVelocity")
velocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
velocity.P = 1000
velocity.Velocity = Vector3.zero

-- Hàm cập nhật vận tốc bay
local function updateVelocity()
	local speed = tonumber(speedBox.Text) or 16
	local cam = workspace.CurrentCamera
	local moveDir = Vector3.zero

	if UserInputService:IsKeyDown(Enum.KeyCode.W) then
		moveDir = moveDir + cam.CFrame.LookVector
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then
		moveDir = moveDir - cam.CFrame.LookVector
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then
		moveDir = moveDir - cam.CFrame.RightVector
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then
		moveDir = moveDir + cam.CFrame.RightVector
	end

	if moveDir.Magnitude > 0 then
		velocity.Velocity = moveDir.Unit * speed
	else
		velocity.Velocity = Vector3.zero
	end
end

-- Kết nối sự kiện Heartbeat để cập nhật khi bay
RunService.Heartbeat:Connect(function()
	if flying then
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			pcall(updateVelocity)
		else
			flying = false
			velocity.Parent = nil
			flyBtn.Text = "Toggle Fly: OFF"
		end
	end
end)

-- Xử lý sự kiện bật/tắt bay
flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyBtn.Text = "Toggle Fly: " .. (flying and "ON" or "OFF")
	flyBtn.BackgroundColor3 = flying and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(0, 150, 255)
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		if flying then
			velocity.Parent = char.HumanoidRootPart
		else
			velocity.Parent = nil
		end
	end
end)

-- Xử lý khi nhân vật reset hoặc tái sinh
player.CharacterAdded:Connect(function(newChar)
	local hrp = newChar:WaitForChild("HumanoidRootPart")
	flying = false
	velocity.Parent = nil
	flyBtn.Text = "Toggle Fly: OFF"
	flyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
end)

-- Phần 3: Hiệu ứng ảo ảnh, phím tắt, và tối ưu cho Conan Fly GUI
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Tạo hiệu ứng ảo ảnh (Trail)
local function createTrail(character)
	local hrp = character:WaitForChild("HumanoidRootPart")
	local trail = Instance.new("Trail")
	trail.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
	})
	trail.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.3),
		NumberSequenceKeypoint.new(1, 1)
	})
	trail.Lifetime = 0.5
	trail.WidthScale = NumberSequence.new(0.5)
	trail.Attachment0 = Instance.new("Attachment", hrp)
	trail.Attachment1 = Instance.new("Attachment", hrp)
	trail.Attachment1.Position = Vector3.new(0, 0, -0.5)
	trail.Parent = hrp
	return trail
end

-- Biến lưu trạng thái và hiệu ứng
local trailEffect = nil

-- Cập nhật hiệu ứng ảo ảnh khi bay
local function updateTrail()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		if flying and not trailEffect then
			trailEffect = createTrail(char)
		elseif not flying and trailEffect then
			trailEffect:Destroy()
			trailEffect = nil
		end
	end
end

-- Thêm phím tắt (phím E) để bật/tắt bay
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.E then
		flying = not flying
		flyBtn.Text = "Toggle Fly: " .. (flying and "ON" or "OFF")
		flyBtn.BackgroundColor3 = flying and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(0, 150, 255)
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			if flying then
				velocity.Parent = char.HumanoidRootPart
			else
				velocity.Parent = nil
			end
		end
		updateTrail()
	end
end)

-- Lưu tốc độ bay (biến tạm, có thể thay bằng DataStore)
local defaultSpeed = 16
speedBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local speed = tonumber(speedBox.Text)
		if speed and speed > 0 then
			defaultSpeed = speed
		else
			speedBox.Text = tostring(defaultSpeed)
		end
	end
end)

-- Tối ưu khi nhân vật tái sinh
player.CharacterAdded:Connect(function(newChar)
	local hrp = newChar:WaitForChild("HumanoidRootPart")
	flying = false
	velocity.Parent = nil
	if trailEffect then
		trailEffect:Destroy()
		trailEffect = nil
	end
	flyBtn.Text = "Toggle Fly: OFF"
	flyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
	-- Khôi phục tốc độ đã lưu
	speedBox.Text = tostring(defaultSpeed)
end)

-- Cập nhật trail trong Heartbeat
RunService.Heartbeat:Connect(function()
	updateTrail()
end)
