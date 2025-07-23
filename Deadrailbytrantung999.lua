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

------------------ Knife Tab ----------------

local DaoTab = Window:CreateTab("🔪 Dao", 4483362458)

-- Biến hệ thống
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Âm thanh
local slashSound = Instance.new("Sound", LocalPlayer:WaitForChild("PlayerGui"))
slashSound.SoundId = "rbxassetid://12222242" -- tiếng chém
slashSound.Volume = 1

local bloodDripSound = Instance.new("Sound", LocalPlayer.PlayerGui)
bloodDripSound.SoundId = "rbxassetid://9118823109" -- rỉ máu
bloodDripSound.Volume = 0.6

-- Cho máu
if not Character:FindFirstChild("Humanoid") then
    repeat wait() until Character:FindFirstChild("Humanoid")
end

if not Character:FindFirstChild("HumanoidRootPart") then
    repeat wait() until Character:FindFirstChild("HumanoidRootPart")
end

-- Tạo thanh máu
if not Character:FindFirstChild("FakeHealth") then
    local fakeHealth = Instance.new("IntValue")
    fakeHealth.Name = "FakeHealth"
    fakeHealth.Value = 100
    fakeHealth.Parent = Character
end

-- Hiệu ứng máu chảy
local function createBloodEffect(pos)
    local blood = Instance.new("Part")
    blood.Size = Vector3.new(0.2,0.2,0.2)
    blood.Position = pos
    blood.BrickColor = BrickColor.new("Bright red")
    blood.Material = Enum.Material.Neon
    blood.Anchored = true
    blood.CanCollide = false
    blood.Parent = workspace

    game:GetService("Debris"):AddItem(blood, 1)

    local tween = TweenService:Create(blood, TweenInfo.new(0.5), {
        Size = Vector3.new(1,1,1),
        Transparency = 1
    })
    tween:Play()
end

-- Làm rung màn hình
local function shakeCam()
    coroutine.wrap(function()
        local cam = workspace.CurrentCamera
        for i = 1, 10 do
            cam.CFrame = cam.CFrame * CFrame.new(math.random(-1,1)/10, math.random(-1,1)/10, 0)
            wait(0.03)
        end
    end)()
end

-- Chết giả
local function fakeDeath()
    local char = LocalPlayer.Character
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health > 0 then
        humanoid.PlatformStand = true
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local fakeBody = Instance.new("Part", workspace)
            fakeBody.Size = Vector3.new(3,1,2)
            fakeBody.Anchored = true
            fakeBody.Position = hrp.Position - Vector3.new(0,1.5,0)
            fakeBody.BrickColor = BrickColor.new("Brown")
            fakeBody.Material = Enum.Material.Fabric
            fakeBody.Name = "FakeCorpse"
            game:GetService("Debris"):AddItem(fakeBody, 10)
        end
        wait(1)
        humanoid.PlatformStand = false
        Character.FakeHealth.Value = 100 -- hồi máu
    end
end

-- Dao
DaoTab:CreateButton({
    Name = "Lấy Dao Siêu Xịn",
    Callback = function()
        if Character:FindFirstChild("Dao") then Character.Dao:Destroy() end

        local dao = Instance.new("Tool")
        dao.Name = "Dao"
        dao.RequiresHandle = true
        dao.CanBeDropped = false

        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(1, 5, 1)
        handle.BrickColor = BrickColor.new("Really black")
        handle.Material = Enum.Material.Metal
        handle.Shape = Enum.PartType.Block
        handle.Parent = dao

        -- Skin dao
        local mesh = Instance.new("SpecialMesh", handle)
        mesh.MeshId = "rbxassetid://65322375" -- lưỡi dao đẹp
        mesh.TextureId = "rbxassetid://65322386"
        mesh.Scale = Vector3.new(1.5, 1.5, 1.5)

        dao.Activated:Connect(function()
            slashSound:Play()
            bloodDripSound:Play()

            -- Hiệu ứng
            shakeCam()
            local humanoid = Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                Character.FakeHealth.Value -= 10
                if math.random(1,100) == 1 then
                    createBloodEffect(Character.HumanoidRootPart.Position + Vector3.new(0,2,0))
                end

                if Character.FakeHealth.Value <= 0 then
                    fakeDeath()
                end
            end
        end)

        dao.Parent = LocalPlayer.Backpack
    end
})
