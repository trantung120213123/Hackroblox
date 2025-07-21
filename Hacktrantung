-- Gui được viết bởi ChatGPT cho Tùng
-- Chức năng: Fly, ESP, Teleport, Lưu điểm TP, Teleport đến người chơi

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local teleportPoints = {}
local savedPositions = {}

-- Tải thư viện GUI
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
	Name = "💀 GUI của Tùng",
	LoadingTitle = "Đợi xíu...",
	LoadingSubtitle = "Đang khởi động GUI",
	ConfigurationSaving = {
		Enabled = false,
	},
	KeySystem = false
})

-- TAB CHÍNH
local Tab = Window:CreateTab("👟 Di chuyển", 4483362458)

-- Fly Toggle
local flying = false
local speed = 50
local bv, bg = nil, nil

local function startFly()
	local character = LocalPlayer.Character
	if not character then return end
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	bv = Instance.new("BodyVelocity")
	bv.Velocity = Vector3.new(0, 0, 0)
	bv.MaxForce = Vector3.new(1, 1, 1) * math.huge
	bv.Parent = root

	bg = Instance.new("BodyGyro")
	bg.CFrame = root.CFrame
	bg.D = 10
	bg.P = 10000
	bg.MaxTorque = Vector3.new(1, 1, 1) * math.huge
	bg.Parent = root

	RunService:BindToRenderStep("Fly", Enum.RenderPriority.Camera.Value, function()
		local moveVec = Vector3.new()
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + workspace.CurrentCamera.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - workspace.CurrentCamera.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - workspace.CurrentCamera.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + workspace.CurrentCamera.CFrame.RightVector end
		bv.Velocity = moveVec.Unit * speed
		bg.CFrame = workspace.CurrentCamera.CFrame
	end)
end

local function stopFly()
	RunService:UnbindFromRenderStep("Fly")
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
end

Tab:CreateToggle({
	Name = "✈️ Bật/Tắt Fly",
	CurrentValue = false,
	Callback = function(Value)
		flying = Value
		if flying then
			startFly()
		else
			stopFly()
		end
	end,
})

Tab:CreateSlider({
	Name = "⚙️ Tốc độ bay",
	Range = {10, 200},
	Increment = 10,
	CurrentValue = 50,
	Callback = function(Value)
		speed = Value
	end,
})

-- ESP
local ESPEnabled = false
local function toggleESP(state)
	if state then
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and not player.Character:FindFirstChild("ESPBox") then
				local box = Instance.new("Highlight")
				box.Name = "ESPBox"
				box.FillColor = Color3.fromRGB(255, 0, 0)
				box.OutlineColor = Color3.new(1, 1, 1)
				box.OutlineTransparency = 0
				box.Parent = player.Character
			end
		end
	else
		for _, player in pairs(Players:GetPlayers()) do
			if player.Character:FindFirstChild("ESPBox") then
				player.Character.ESPBox:Destroy()
			end
		end
	end
end

Tab:CreateToggle({
	Name = "👁️ Bật ESP người chơi",
	CurrentValue = false,
	Callback = function(Value)
		ESPEnabled = Value
		toggleESP(ESPEnabled)
	end,
})

-- Lưu điểm TP
Tab:CreateButton({
	Name = "📍 Lưu điểm hiện tại",
	Callback = function()
		local pos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if pos then
			table.insert(savedPositions, pos.Position)
			Rayfield:Notify({
				Title = "Đã lưu điểm!",
				Content = "Đã lưu vị trí số " .. tostring(#savedPositions),
				Duration = 3,
			})
		end
	end,
})

-- Hiển thị nút teleport
local tpTab = Window:CreateTab("🚀 Teleport", 4483362458)

tpTab:CreateParagraph({Title="Điểm đã lưu", Content="Nhấn để dịch chuyển"})

for i = 1, 5 do
	tpTab:CreateButton({
		Name = "🔢 TP đến điểm " .. i,
		Callback = function()
			if savedPositions[i] then
				LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(savedPositions[i])
			else
				Rayfield:Notify({
					Title = "Chưa lưu!",
					Content = "Chưa có điểm số " .. i,
					Duration = 3,
				})
			end
		end,
	})
end

-- Teleport đến người chơi
local playersList = Players:GetPlayers()
for _, plr in pairs(playersList) do
	if plr ~= LocalPlayer then
		tpTab:CreateButton({
			Name = "📦 Dịch đến: " .. plr.Name,
			Callback = function()
				if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
					LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
				end
			end
		})
	end
end
