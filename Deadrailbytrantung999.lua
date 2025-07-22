--[[ Script GUI by Tien Tung
Rayfield UI + ESP + Lock NPC + Teleport + Speed + NoClip
Key: hhx44xhh
Mobile-Friendly + Notification
]]

-- Load Rayfield UI
loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local ESP_ON = false
local ESP_NPC_ON = false
local LockNPC = false
local savedPoints = {}
local noclip = false
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

-- GUI Init
local Window = Rayfield:CreateWindow({
Name = "Shit hub💩 by TranTung999",
LoadingTitle = "💩 Loading...",
LoadingSubtitle = "By TranTung999",
ConfigurationSaving = {
Enabled = false
},
KeySystem = true,
KeySettings = {
Title = "Shit hub💩",
Subtitle = "Key System",
Note = "Key = Nhập lại key vừa nãy đã nhập",
FileName = "TranTungUIKey",
SaveKey = true,
GrabKeyFromSite = false,
Key = "hhx44xhh"
}
})

------------------ MAIN TAB -------------------
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSlider({
Name = "Speed",
Range = {16, 200},
Increment = 1,
CurrentValue = 16,
Callback = function(Value)
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
Rayfield:Notify("Speed", "Đã chỉnh tốc độ!", 2)
end
})

MainTab:CreateToggle({
Name = "NoClip",
CurrentValue = false,
Callback = function(Value)
noclip = Value
Rayfield:Notify("NoClip", Value and "Bật" or "Tắt", 2)
end
})

MainTab:CreateToggle({
Name = "ESP người chơi",
CurrentValue = false,
Callback = function(Value)
ESP_ON = Value
Rayfield:Notify("ESP", Value and "Bật" or "Tắt", 2)
end
})

------------------ TELEPORT TAB -------------------
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

local savedPoints = {}
local pointButtons = {}
local teleportSection = TeleportTab:CreateSection("Saved Points")

TeleportTab:CreateButton({
    Name = "Save Point",
    Callback = function()
        local pos = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if pos then
            local cf = pos.CFrame
            table.insert(savedPoints, cf)

            -- Tạo button mới để teleport đến điểm vừa lưu
            local index = #savedPoints
            local newButton = TeleportTab:CreateButton({
                Name = "Teleport to Point " .. index,
                Callback = function()
                    local char = game.Players.LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.CFrame = savedPoints[index]
                    end
                end,
            })

            table.insert(pointButtons, newButton)
        end
    end,
})

------------------ PLAYER TAB -------------------
local PlayerTab = Window:CreateTab("Players", 4483362458)

local function LoadPlayers()
for _, p in pairs(players:GetPlayers()) do
if p ~= localPlayer then
PlayerTab:CreateButton({
Name = "TP đến: " .. p.Name,
Callback = function()
if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
localPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
end
end
})
end
end
end

PlayerTab:CreateButton({
Name = "🔁 Load lại danh sách",
Callback = LoadPlayers
})

LoadPlayers()

------------------ NPC TAB -------------------
local NPCTab = Window:CreateTab("NPC", 4483362458)

NPCTab:CreateToggle({
Name = "ESP NPC",
CurrentValue = false,
Callback = function(Value)
ESP_NPC_ON = Value
Rayfield:Notify("ESP NPC", Value and "Bật" or "Tắt", 2)
end
})

NPCTab:CreateToggle({
Name = "Lock NPC gần nhất",
CurrentValue = false,
Callback = function(Value)
LockNPC = Value
Rayfield:Notify("Lock NPC", Value and "Bật" or "Tắt", 2)
end
})

----------------------- Skin ----------------------
local SkinTab = Window:CreateTab("Skin", 4483362458)

SkinTab:CreateButton({
	Name = "Xoá toàn bộ Skin",
	Callback = function()
		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()

		for _, item in pairs(character:GetChildren()) do
			if item:IsA("Accessory") or item:IsA("Clothing") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") or item:IsA("BodyColors") or item:IsA("CharacterMesh") or item:IsA("Decal") or item:IsA("HumanoidDescription") then
				item:Destroy()
			end
		end

		Rayfield:Notify({
			Title = "Skin",
			Content = "Đã xoá toàn bộ Skin, tóc, mặt...",
			Duration = 3,
			Image = 123456, -- thay bằng ID ảnh nếu muốn
		})
	end,
})

local userIdToClone = nil

-- Nhập tên người chơi (tự lấy UserId)
SkinTab:CreateInput({
    Name = "Tên người chơi",
    PlaceholderText = "Nhập tên người chơi...",
    RemoveTextAfterFocusLost = false,
    Callback = function(input)
        local success, result = pcall(function()
            return game.Players:GetUserIdFromNameAsync(input)
        end)
        if success then
            userIdToClone = result
            setclipboard(tostring(result))
            Rayfield:Notify({
                Title = "Đã sao chép ID",
                Content = "UserId: " .. tostring(result),
                Duration = 3,
            })
        else
            Rayfield:Notify({
                Title = "Lỗi",
                Content = "Không tìm thấy người chơi!",
                Duration = 3,
            })
        end
    end
})

-- Nhập trực tiếp UserId
SkinTab:CreateInput({
    Name = "Hoặc nhập UserId trực tiếp",
    PlaceholderText = "Nhập UserId...",
    RemoveTextAfterFocusLost = false,
    Callback = function(input)
        local id = tonumber(input)
        if id then
            userIdToClone = id
            setclipboard(input)
            Rayfield:Notify({
                Title = "Đã nhận ID",
                Content = "UserId: " .. input,
                Duration = 3,
            })
        else
            Rayfield:Notify({
                Title = "Lỗi",
                Content = "ID không hợp lệ!",
                Duration = 3,
            })
        end
    end
})

-- Nút clone skin
SkinTab:CreateButton({
    Name = "Clone Skin từ ID",
    Callback = function()
        if not userIdToClone then
            Rayfield:Notify({
                Title = "Thiếu UserId!",
                Content = "Vui lòng nhập tên hoặc ID trước.",
                Duration = 3,
            })
            return
        end

        local success, appearance = pcall(function()
            return game.Players:GetCharacterAppearanceAsync(userIdToClone)
        end)

        if success and appearance then
            local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()

            -- Xoá skin cũ
            for _, v in pairs(char:GetChildren()) do
                if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") or v:IsA("BodyColors") then
                    v:Destroy()
                end
            end

            -- Clone skin mới
            for _, v in ipairs(appearance:GetChildren()) do
                if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") or v:IsA("BodyColors") then
                    v:Clone().Parent = char
                end
            end

            Rayfield:Notify({
                Title = "Thành công",
                Content = "Đã clone skin!",
                Duration = 3,
            })
        else
            Rayfield:Notify({
                Title = "Lỗi clone",
                Content = "Không thể lấy trang phục!",
                Duration = 3,
            })
        end
    end
})

------------------ LOOP: ESP + LockNPC + NoClip -------------------
game:GetService("RunService").RenderStepped:Connect(function()
-- ✅ Sửa NoClip chuẩn:
if noclip and localPlayer.Character then
    for _, part in pairs(localPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide == true then
            part.CanCollide = false
        end
    end
end

-- ESP Player
if ESP_ON then
for _, plr in pairs(players:GetPlayers()) do
if plr ~= localPlayer and plr.Character and plr.Character:FindFirstChild("Head") and not plr.Character.Head:FindFirstChild("ESP") then
local box = Instance.new("BillboardGui", plr.Character.Head)
box.Name = "ESP"
box.Size = UDim2.new(2, 0, 2, 0)
box.AlwaysOnTop = true
local frame = Instance.new("Frame", box)
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundColor3 = Color3.new(1, 0, 0)
frame.BackgroundTransparency = 0.5
end
end
end

-- ESP NPC
if ESP_NPC_ON then
for _, npc in pairs(workspace:GetDescendants()) do
if npc:IsA("Model") and not players:GetPlayerFromCharacter(npc) and npc:FindFirstChild("Head") and not npc.Head:FindFirstChild("ESP") then
local esp = Instance.new("BillboardGui", npc.Head)
esp.Name = "ESP"
esp.Size = UDim2.new(2, 0, 2, 0)
esp.AlwaysOnTop = true
local frame = Instance.new("Frame", esp)
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundColor3 = Color3.new(0, 1, 0)
frame.BackgroundTransparency = 0.5
end
end
end

-- Lock NPC
if LockNPC then
local closest = nil
local minDist = math.huge
for _, npc in pairs(workspace:GetDescendants()) do
if npc:IsA("Model") and not players:GetPlayerFromCharacter(npc) and npc:FindFirstChild("Head") then
local dist = (npc.Head.Position - camera.CFrame.Position).Magnitude
if dist < minDist then
closest = npc
minDist = dist
end
end
end
if closest and closest:FindFirstChild("Head") then
camera.CFrame = CFrame.new(camera.CFrame.Position, closest.Head.Position)
end
end
end)

---------------- hỗ trợ chơi -----------------
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local StatsService = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Cấu hình
local SETTINGS = {
    UpdateInterval = 0.5, -- Giây
    HighPingThreshold = 300, -- ms
    LowFpsThreshold = 30, -- FPS
    WarningCooldown = 10 -- Giây
}

-- Tạo giao diện
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GamePerformanceMonitor"
screenGui.Parent = PlayerGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 180)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundTransparency = 0.8
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Text = "GAME PERFORMANCE MONITOR"
title.Font = Enum.Font.Code
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Parent = mainFrame

local content = Instance.new("TextLabel")
content.Size = UDim2.new(1, -10, 1, -30)
content.Position = UDim2.new(0, 5, 0, 30)
content.Font = Enum.Font.Code
content.TextSize = 14
content.TextColor3 = Color3.fromRGB(220, 220, 220)
content.TextXAlignment = Enum.TextXAlignment.Left
content.TextYAlignment = Enum.TextYAlignment.Top
content.BackgroundTransparency = 1
content.Text = "Đang tải dữ liệu..."
content.Parent = mainFrame

-- Biến hệ thống
local lastUpdate = 0
local frameCount = 0
local lastWarningTime = 0

-- Hàm tiện ích
local function formatMem(mb)
    return string.format("%.1fMB", mb)
end

local function formatSpeed(kbps)
    return string.format("%.1f", kbps)
end

local function getColor(value, thresholds)
    if value < thresholds.good then
        return Color3.fromRGB(100, 255, 100) -- Xanh lá
    elseif value < thresholds.medium then
        return Color3.fromRGB(255, 255, 100) -- Vàng
    else
        return Color3.fromRGB(255, 100, 100) -- Đỏ
    end
end

-- Hàm lấy thông tin
local function getNetworkInfo()
    local stats = StatsService.Network.ServerStatsItem
    return {
        ping = stats["Data Ping"]:GetValue(),
        packetLoss = stats["Data Packet Loss"]:GetValue(),
        incoming = stats["Incoming KBits/Sec"]:GetValue(),
        outgoing = stats["Outgoing KBits/Sec"]:GetValue()
    }
end

local function getPerformanceStats()
    local stats = StatsService
    return {
        fps = 0, -- Sẽ được tính sau
        memory = stats:GetMemoryUsageMbForTag(Enum.DeveloperMemoryTag.Engine),
        physics = stats.Physics.PhysicsSenderStatsItem["Step Count"]:GetValue(),
        render = stats.Render.RenderStatsItem["Render Count"]:GetValue()
    }
end

local function getOptimizationTips(fps, ping)
    local tips = {}
    
    if fps < SETTINGS.LowFpsThreshold then
        table.insert(tips, "🔹 Giảm chất lượng đồ họa trong Settings")
        table.insert(tips, "🔹 Đóng ứng dụng nền không cần thiết")
        table.insert(tips, "🔹 Giảm khoảng cách nhìn (Render Distance)")
    end
    
    if ping > SETTINGS.HighPingThreshold then
        table.insert(tips, "🔸 Kiểm tra kết nối mạng")
        table.insert(tips, "🔸 Chọn server gần hơn nếu có thể")
        table.insert(tips, "🔸 Tránh tải file khi đang chơi")
    end
    
    return #tips > 0 and table.concat(tips, "\n") or "✔ Hiệu suất tốt"
end

-- Hàm chính cập nhật thông tin
local function updateMonitor()
    frameCount = frameCount + 1
    local now = os.clock()
    
    if now - lastUpdate >= SETTINGS.UpdateInterval then
        -- Tính toán các thông số
        local perfStats = getPerformanceStats()
        perfStats.fps = math.floor(frameCount / (now - lastUpdate))
        frameCount = 0
        lastUpdate = now
        
        local netInfo = getNetworkInfo()
        local tips = getOptimizationTips(perfStats.fps, netInfo.ping)
        
        -- Cảnh báo nếu cần
        if netInfo.ping > SETTINGS.HighPingThreshold and now - lastWarningTime > SETTINGS.WarningCooldown then
            lastWarningTime = now
            warn("[CẢNH BÁO] Ping cao: "..netInfo.ping.."ms")
        end
        
        -- Tạo báo cáo
        local report = string.format(
            "🖥️ FPS: %d (%.1fms)\n"..
            "📶 Ping: %dms | Mất gói: %.1f%%\n"..
            "🔽 %s Kbps | 🔼 %s Kbps\n"..
            "💾 Bộ nhớ: %s\n\n"..
            "📌 GỢI Ý:\n%s",
            perfStats.fps, 1000/perfStats.fps,
            netInfo.ping, netInfo.packetLoss,
            formatSpeed(netInfo.incoming), formatSpeed(netInfo.outgoing),
            formatMem(perfStats.memory),
            tips
        )
        
        -- Cập nhật giao diện
        content.Text = report
        
        -- Đổi màu title theo tình trạng
        if perfStats.fps < 20 or netInfo.ping > 500 then
            title.TextColor3 = Color3.fromRGB(255, 50, 50)
        elseif perfStats.fps < 30 or netInfo.ping > 300 then
            title.TextColor3 = Color3.fromRGB(255, 200, 50)
        else
            title.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
    end
end

-- Bắt đầu hệ thống
RunService.RenderStepped:Connect(updateMonitor)

-- Nút tắt/mở (bấm vào khung để ẩn/hiện)
local visible = true
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        visible = not visible
        mainFrame.Visible = visible
    end
end)

print("Game Performance Monitor đã được kích hoạt!")



