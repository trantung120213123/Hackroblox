--[[ Script GUI by Tien Tung
Rayfield UI + ESP + Lock NPC + Teleport + Speed + NoClip
Key: shithub999
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
Key = "shithub999"
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

SkinTab:CreateButton({
    Name = "Bật Clone Avatar (Name)",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/refs/heads/main/Copy%20Avatar'))()
    end,
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

-- Biến toàn cục để quản lý GUI
local performanceGUI = nil
local connection = nil

local function createPerformanceDisplay()
    -- Xóa GUI cũ nếu tồn tại
    if performanceGUI then
        performanceGUI:Destroy()
        performanceGUI = nil
    end
    
    -- Ngắt kết nối cũ
    if connection then
        connection:Disconnect()
        connection = nil
    end

    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    -- Tạo GUI mới
    performanceGUI = Instance.new("ScreenGui")
    performanceGUI.Name = "PerformanceMonitor"
    performanceGUI.ResetOnSpawn = false
    performanceGUI.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 150, 0, 40)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundTransparency = 0.7
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.Parent = performanceGUI

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "FPS: -\nPing: -"
    label.Font = Enum.Font.Code
    label.TextSize = 14
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    -- Biến đếm FPS
    local lastUpdate = os.clock()
    local frameCount = 0

    -- Kết nối sự kiện RenderStepped
    connection = RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local currentTime = os.clock()
        
        if currentTime - lastUpdate >= 0.5 then
            local fps = math.floor(frameCount / (currentTime - lastUpdate))
            local ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
            
            label.Text = string.format("FPS: %d\nPing: %dms", fps, ping)
            
            -- Đổi màu theo hiệu suất
            if fps < 25 or ping > 300 then
                label.TextColor3 = Color3.new(1, 0.3, 0.3)
            else
                label.TextColor3 = Color3.new(1, 1, 1)
            end
            
            frameCount = 0
            lastUpdate = currentTime
        end
    end)
end

-- Xử lý khi respawn
local function onCharacterAdded()
    wait(0.5) -- Đợi PlayerGui sẵn sàng
    createPerformanceDisplay()
end

-- Kết nối sự kiện
Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- Khởi tạo lần đầu
createPerformanceDisplay()

local TabGiamLag = Window:CreateTab("🚀 Giảm Lag", 4483362458) -- Icon rocket

local autoGiamLag = false
local loopGiamLag = nil

TabGiamLag:CreateToggle({
    Name = "Tự động giảm lag (5 giây/lần)",
    CurrentValue = false,
    Callback = function(Value)
        autoGiamLag = Value
        
        if autoGiamLag then
            Rayfield:Notify({
                Title = "Đã bật tự động giảm lag",
                Content = "Hệ thống sẽ tự động tối ưu mỗi 5 giây",
                Duration = 3,
                Image = 6023426915
            })
            
            -- Tạo vòng lặp
            loopGiamLag = task.spawn(function()
                while autoGiamLag and task.wait(5) do
                    -- Danh sách tối ưu
                    local optimizations = {
                        function() 
                            for _, v in pairs(workspace:GetDescendants()) do
                                if v:IsA("ParticleEmitter") or v:IsA("Trail") then
                                    v:Destroy()
                                end
                            end
                        end,
                        
                        function()
                            settings().Rendering.QualityLevel = 1
                            game:GetService("Lighting").GlobalShadows = false
                            game:GetService("Lighting").FantasySky:Destroy()
                        end,
                        
                        function()
                            for _, player in pairs(game.Players:GetPlayers()) do
                                if player ~= game.Players.LocalPlayer then
                                    player.Character:WaitForChild("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                                end
                            end
                        end
                    }
                    
                    -- Chạy ngẫu nhiên 2 trong 3 tối ưu mỗi lần
                    for i = 1, 2 do
                        local randomOpt = optimizations[math.random(1, #optimizations)]
                        pcall(randomOpt)
                    end
                end
            end)
        else
            if loopGiamLag then
                task.cancel(loopGiamLag)
            end
            Rayfield:Notify({
                Title = "Đã tắt tự động giảm lag",
                Content = "Hệ thống ngừng tối ưu",
                Duration = 3,
                Image = 6023426923
            })
        end
    end
})

TabGiamLag:CreateButton({
    Name = "Giảm lag ngay lập tức",
    Callback = function()
        -- Giảm lag mạnh tức thì
        pcall(function()
            -- 1. Xóa hiệu ứng
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                    v:Destroy()
                end
            end
            
            -- 2. Tối ưu lighting
            local lighting = game:GetService("Lighting")
            lighting.GlobalShadows = false
            lighting.FogEnd = 999999
            lighting.Brightness = 1
            
            -- 3. Tắt âm thanh không cần thiết
            for _, sound in pairs(workspace:GetDescendants()) do
                if sound:IsA("Sound") then
                    sound:Destroy()
                end
            end
            
            Rayfield:Notify({
                Title = "Giảm lag thành công",
                Content = "Đã áp dụng tối ưu tức thì",
                Duration = 3,
                Image = 6023426908
            })
        end)
    end
})

----------------- Game -----------------

-- Tạo Tab "Ink Game"
local InkTab = Window:CreateTab("Ink Game", 4483362458)
InkTab:CreateButton({
    Name = "Ringta",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/wefwef127382/inkgames.github.io/refs/heads/main/ringta.lua"))()
        Rayfield:Notify({Title = "Ringta", Content = "Script loaded!", Duration = 3})
    end,
})

-- Tạo Tab "Grow A Garden"
local GrowTab = Window:CreateTab("Grow A Garden", 13014560)
GrowTab:CreateButton({
    Name = "Speed X Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
        Rayfield:Notify({Title = "Speed X Hub", Content = "Script loaded!", Duration = 3})
    end,
})

GrowTab:CreateButton({
    Name = "No Lag",
    Callback = function()
        repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

        local scripts = {
            [126884695634066] = "https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/Garden/Garden-V1.lua",
            [81440632616906] = "https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/DigEarth/V1.lua",
        }

        local url = scripts[game.PlaceId]
        if url then
            loadstring(game:HttpGetAsync(url))()
            loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/untitled.lua"))()
            Rayfield:Notify({Title = "No Lag", Content = "Loaded for this game", Duration = 3})
        else
            Rayfield:Notify({Title = "No Lag", Content = "Game không hỗ trợ!", Duration = 3})
        end
    end,
})

local Tab_BloxFruits = Window:CreateTab("🍌 Blox Fruits", 4483362458) -- icon là emoji chuối

-- Nút 1: Banana Cat Hub
Tab_BloxFruits:CreateButton({
    Name = "Banana Cat Hub 🍌",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Chiriku2013/BananaCatHub/refs/heads/main/BananaCatHub.lua"))()
    end,
})

-- Nút 2: Redz Hub
Tab_BloxFruits:CreateButton({
    Name = "Redz Hub 🔴",
    Callback = function()
        local Settings = {
            JoinTeam = "Pirates", -- hoặc "Marines"
            Translator = true,
        }
        loadstring(game:HttpGet("https://raw.githubusercontent.com/newredz/BloxFruits/refs/heads/main/Source.luau"))(Settings)
    end,
})

local MM2Tab = Window:CreateTab("Murder Mystery 2", 4483362458) -- Icon ID tùy chọn

MM2Tab:CreateButton({
    Name = "Xhub MM2",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Au0yX/Community/main/XhubMM2"))()
    end,
})
