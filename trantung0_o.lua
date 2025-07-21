local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local ESPEnabled = false
local NoClipEnabled = false
local WalkSpeed = 16
local SavedTeleports = {}

local function Notify(title, content)
	Rayfield:Notify({
		Title = title,
		Content = content,
		Duration = 3,
		Actions = {
			Ignore = {
				Name = "OK",
				Callback = function() end
			}
		}
	})
end

local Window = Rayfield:CreateWindow({
	Name = "💀 Tung Hub - Rayfield UI",
	LoadingTitle = "Tung Hub Loading...",
	LoadingSubtitle = "by ngố",
	ConfigurationSaving = {
		Enabled = false
	},
	Discord = {
		Enabled = false
	},
	KeySystem = false
})

local Tab = Window:CreateTab("🏃 Main", 4483362458)

Tab:CreateSlider({
	Name = "Speed",
	Range = {16, 200},
	Increment = 2,
	Default = 16,
	Callback = function(Value)
		WalkSpeed = Value
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
		Notify("Tốc độ", "Đã chỉnh: " .. Value)
	end
})

Tab:CreateToggle({
	Name = "NoClip",
	CurrentValue = false,
	Callback = function(Value)
		NoClipEnabled = Value
		if Value then
			Notify("NoClip", "Đã bật")
		else
			Notify("NoClip", "Đã tắt")
		end
	end
})

game:GetService("RunService").Stepped:Connect(function()
	if NoClipEnabled then
		for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") and part.CanCollide then
				part.CanCollide = false
			end
		end
	end
end)

Tab:CreateToggle({
	Name = "ESP",
	CurrentValue = false,
	Callback = function(Value)
		ESPEnabled = Value
		if Value then
			for _, player in pairs(game.Players:GetPlayers()) do
				if player ~= game.Players.LocalPlayer and player.Character then
					local box = Instance.new("BoxHandleAdornment", player.Character:FindFirstChild("HumanoidRootPart"))
					box.Size = Vector3.new(4, 6, 1)
					box.Color3 = Color3.new(1, 0, 0)
					box.AlwaysOnTop = true
					box.Adornee = player.Character:FindFirstChild("HumanoidRootPart")
					box.ZIndex = 5
					box.Name = "ESPBox"
				end
			end
			Notify("ESP", "Đã bật")
		else
			for _, player in pairs(game.Players:GetPlayers()) do
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local adorn = player.Character.HumanoidRootPart:FindFirstChild("ESPBox")
					if adorn then adorn:Destroy() end
				end
			end
			Notify("ESP", "Đã tắt")
		end
	end
})

Tab:CreateButton({
	Name = "Teleport về Spawn",
	Callback = function()
		local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if root then
			root.CFrame = CFrame.new(0, 10, 0)
			Notify("Teleport", "Đã về điểm Spawn")
		end
	end
})

Tab:CreateButton({
	Name = "Lưu điểm Teleport",
	Callback = function()
		local pos = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position
		table.insert(SavedTeleports, pos)

		local pointNum = #SavedTeleports
		Tab:CreateButton({
			Name = "Điểm TP " .. pointNum,
			Callback = function()
				game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(SavedTeleports[pointNum])
				Notify("Teleport", "Đã tới Điểm TP " .. pointNum)
			end
		})

		Notify("Lưu điểm", "Đã lưu điểm số " .. pointNum)
	end
})

local TpTab = Window:CreateTab("🧍 Teleport", 4483362458)
local PlayerList = {}

local function UpdatePlayerList()
	PlayerList = {}
	for _, player in pairs(game.Players:GetPlayers()) do
		if player ~= game.Players.LocalPlayer then
			table.insert(PlayerList, player.Name)
		end
	end
end

local Dropdown
Dropdown = TpTab:CreateDropdown({
	Name = "Chọn người chơi",
	Options = PlayerList,
	CurrentOption = "",
	Callback = function(Option)
		local plr = game.Players:FindFirstChild(Option)
		if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
			Notify("Teleport", "Đã tới " .. Option)
		end
	end
})

TpTab:CreateButton({
	Name = "🔁 Tải lại danh sách người chơi",
	Callback = function()
		UpdatePlayerList()
		Dropdown:SetOptions(PlayerList)
		Notify("Danh sách", "Đã tải lại người chơi")
	end
})
