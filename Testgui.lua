-- Tải Kavo UI
local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Kavo.CreateLib("Shit hub💩 by TranTung999", "DarkTheme")

-- Khai báo biến toàn cục
local localPlayer = game.Players.LocalPlayer
local players = game.Players
local camera = workspace.CurrentCamera
local noclip = false
local ESP_ON = false
local ESP_NPC_ON = false
local LockNPC = false
local savedPoints = {}
local userIdToClone = nil

local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Main Features")

MainSection:NewSlider("Speed", "Chỉnh tốc độ", 200, 16, function(Value)
    if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
        localPlayer.Character.Humanoid.WalkSpeed = Value
    end
end)

MainSection:NewToggle("NoClip", "Bật/tắt NoClip", function(Value)
    noclip = Value
end)

MainSection:NewToggle("ESP người chơi", "Hiển thị người chơi", function(Value)
    ESP_ON = Value
end)

local TeleportTab = Window:NewTab("Teleport")
local TeleportSection = TeleportTab:NewSection("Teleport Features")

TeleportSection:NewButton("Save Point", "Lưu vị trí hiện tại", function()
    local pos = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if pos then
        local cf = pos.CFrame
        table.insert(savedPoints, cf)
        TeleportSection:NewButton("Teleport to Point " .. #savedPoints, "Teleport đến điểm " .. #savedPoints, function()
            if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                localPlayer.Character.HumanoidRootPart.CFrame = savedPoints[#savedPoints]
            end
        end)
    end
end)

local PlayersTab = Window:NewTab("Players")
local PlayersSection = PlayersTab:NewSection("Player Teleport")

local function LoadPlayers()
    for _, p in pairs(players:GetPlayers()) do
        if p ~= localPlayer then
            PlayersSection:NewButton("TP đến: " .. p.Name, "Teleport đến " .. p.Name, function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    localPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                end
            end)
        end
    end
end

PlayersSection:NewButton("🔁 Load lại danh sách", "Làm mới danh sách người chơi", LoadPlayers)
LoadPlayers()

local NPCTab = Window:NewTab("NPC")
local NPCSection = NPCTab:NewSection("NPC Features")

NPCSection:NewToggle("ESP NPC", "Hiển thị NPC", function(Value)
    ESP_NPC_ON = Value
end)

NPCSection:NewToggle("Lock NPC gần nhất", "Khóa camera vào NPC", function(Value)
    LockNPC = Value
end)

local SkinTab = Window:NewTab("Skin")
local SkinSection = SkinTab:NewSection("Skin Features")

SkinSection:NewButton("Xoá toàn bộ Skin", "Xóa skin, tóc, mặt", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Accessory") or item:IsA("Clothing") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") or item:IsA("BodyColors") or item:IsA("CharacterMesh") or item:IsA("Decal") or item:IsA("HumanoidDescription") then
            item:Destroy()
        end
    end
end)

SkinSection:NewTextBox("Tên người chơi", "Nhập tên để lấy UserId", function(input)
    local success, result = pcall(function()
        return game.Players:GetUserIdFromNameAsync(input)
    end)
    if success then
        userIdToClone = result
        setclipboard(tostring(result))
    end
end)

SkinSection:NewTextBox("Hoặc nhập UserId trực tiếp", "Nhập UserId", function(input)
    local id = tonumber(input)
    if id then
        userIdToClone = id
        setclipboard(input)
    end
end)

SkinSection:NewButton("Clone Skin từ ID", "Clone skin từ UserId", function()
    if not userIdToClone then
        return
    end
    local success, appearance = pcall(function()
        return game.Players:GetCharacterAppearanceAsync(userIdToClone)
    end)
    if success and appearance then
        local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") or v:IsA("BodyColors") then
                v:Destroy()
            end
        end
        for _, v in ipairs(appearance:GetChildren()) do
            if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") or v:IsA("BodyColors") then
                v:Clone().Parent = char
            end
        end
    end
end)

SkinSection:NewButton("Bật Clone Avatar (Name)", "Clone avatar từ tên", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/refs/heads/main/Copy%20Avatar'))()
end)

local InkTab = Window:NewTab("Ink Game")
local InkSection = InkTab:NewSection("Ink Game Features")

InkSection:NewButton("Ringta", "Tải script Ringta", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/wefwef127382/inkgames.github.io/refs/heads/main/ringta.lua"))()
end)

local GrowTab = Window:NewTab("Grow A Garden")
local GrowSection = GrowTab:NewSection("Grow A Garden Features")

GrowSection:NewButton("Speed X Hub", "Tải Speed X Hub", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
end)

GrowSection:NewButton("No Lag", "Tải script No Lag", function()
    repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
    local scripts = {
        [126884695634066] = "https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/Garden/Garden-V1.lua",
        [81440632616906] = "https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/DigEarth/V1.lua",
    }
    local url = scripts[game.PlaceId]
    if url then
        loadstring(game:HttpGetAsync(url))()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/untitled.lua"))()
    end
end)

local BloxFruitsTab = Window:NewTab("🍌 Blox Fruits")
local BloxFruitsSection = BloxFruitsTab:NewSection("Blox Fruits Features")

BloxFruitsSection:NewButton("Banana Cat Hub 🍌", "Tải Banana Cat Hub", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Chiriku2013/BananaCatHub/refs/heads/main/BananaCatHub.lua"))()
end)

BloxFruitsSection:NewButton("Redz Hub 🔴", "Tải Redz Hub", function()
    local Settings = {
        JoinTeam = "Pirates",
        Translator = true,
    }
    loadstring(game:HttpGet("https://raw.githubusercontent.com/newredz/BloxFruits/refs/heads/main/Source.luau"))(Settings)
end)

local MM2Tab = Window:NewTab("Murder Mystery 2")
local MM2Section = MM2Tab:NewSection("MM2 Features")

MM2Section:NewButton("Xhub MM2", "Tải Xhub MM2", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Au0yX/Community/main/XhubMM2"))()
end)

game:GetService("RunService").RenderStepped:Connect(function()
    -- Xóa ESP cũ khi toggle tắt
    if not ESP_ON then
        for _, plr in pairs(players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Head") and plr.Character.Head:FindFirstChild("ESP") then
                plr.Character.Head.ESP:Destroy()
            end
        end
    end
    if not ESP_NPC_ON then
        for _, npc in pairs(workspace:GetDescendants()) do
            if npc:IsA("Model") and npc:FindFirstChild("Head") and npc.Head:FindFirstChild("ESP") then
                npc.Head.ESP:Destroy()
            end
        end
    end

    -- NoClip
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

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local StatsService = game:GetService("Stats")

local performanceGUI = nil
local connection = nil

local function createPerformanceDisplay()
    if performanceGUI then
        performanceGUI:Destroy()
        performanceGUI = nil
    end
    if connection then
        connection:Disconnect()
        connection = nil
    end

    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

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

    local lastUpdate = os.clock()
    local frameCount = 0

    connection = RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local currentTime = os.clock()
        if currentTime - lastUpdate >= 0.5 then
            local fps = math.floor(frameCount / (currentTime - lastUpdate))
            local ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
            label.Text = string.format("FPS: %d\nPing: %dms", fps, ping)
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

Players.LocalPlayer.CharacterAdded:Connect(function()
    wait(0.5)
    createPerformanceDisplay()
end)

createPerformanceDisplay()
