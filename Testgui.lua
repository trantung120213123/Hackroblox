-- Tải Venyx UI
local Venyx = loadstring(game:HttpGet("https://raw.githubusercontent.com/0Ben1/Venyx-UI-Library/main/Venyx.lua"))()
local UI = Venyx.new({
    title = "Shit hub💩 by TranTung999"
})

-- Hàm thông báo thay thế
function CustomNotify(title, content)
    local gui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
    gui.ResetOnSpawn = false
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 200, 0, 80)
    frame.Position = UDim2.new(0.5, -100, 0.1, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    local titleLabel = Instance.new("TextLabel", frame)
    titleLabel.Size = UDim2.new(1, 0, 0.3, 0)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.BackgroundTransparency = 1
    local contentLabel = Instance.new("TextLabel", frame)
    contentLabel.Size = UDim2.new(1, 0, 0.7, 0)
    contentLabel.Position = UDim2.new(0, 0, 0.3, 0)
    contentLabel.Text = content
    contentLabel.TextColor3 = Color3.new(1, 1, 1)
    contentLabel.BackgroundTransparency = 1
    game:GetService("TweenService"):Create(frame, TweenInfo.new(3), {Transparency = 1}):Play()
    wait(3)
    gui:Destroy()
end

-- Hệ thống Key
local KeyPage = UI:addPage({ title = "Key System", icon = 4483362458 })
local correctKey = "shithub999"
local keyEntered = false

KeyPage:addTextbox({
    text = "Nhập key",
    placeholder = "Key = shithub999",
    callback = function(input)
        if input == correctKey then
            keyEntered = true
            CustomNotify("Key System", "Key đúng! Đã mở khóa giao diện.")
            KeyPage:destroy()
            InitializeMainUI()
        else
            CustomNotify("Key System", "Key sai! Thử lại.")
        end
    end
})

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

-- Hàm khởi tạo các page chính
function InitializeMainUI()
    -- Tab Main
    local MainPage = UI:addPage({ title = "Main", icon = 4483362458 })

    MainPage:addSlider({
        text = "Speed",
        min = 16,
        max = 200,
        value = 16,
        callback = function(Value)
            if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
                localPlayer.Character.Humanoid.WalkSpeed = Value
                CustomNotify("Speed", "Đã chỉnh tốc độ!")
            end
        end
    })

    MainPage:addToggle({
        text = "NoClip",
        value = false,
        callback = function(Value)
            noclip = Value
            CustomNotify("NoClip", Value and "Bật" or "Tắt")
        end
    })

    MainPage:addToggle({
        text = "ESP người chơi",
        value = false,
        callback = function(Value)
            ESP_ON = Value
            CustomNotify("ESP", Value and "Bật" or "Tắt")
        end
    })

    -- Tab Teleport
    local TeleportPage = UI:addPage({ title = "Teleport", icon = 4483362458 })

    TeleportPage:addButton({
        text = "Save Point",
        callback = function()
            local pos = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
            if pos then
                local cf = pos.CFrame
                table.insert(savedPoints, cf)
                TeleportPage:addButton({
                    text = "Teleport to Point " .. #savedPoints,
                    callback = function()
                        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            localPlayer.Character.HumanoidRootPart.CFrame = savedPoints[#savedPoints]
                        end
                    end
                })
            end
        end
    })

    -- Tab Players
    local PlayersPage = UI:addPage({ title = "Players", icon = 4483362458 })

    local function LoadPlayers()
        for _, p in pairs(players:GetPlayers()) do
            if p ~= localPlayer then
                PlayersPage:addButton({
                    text = "TP đến: " .. p.Name,
                    callback = function()
                        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            localPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                        end
                    end
                })
            end
        end
    end

    PlayersPage:addButton({
        text = "🔁 Load lại danh sách",
        callback = LoadPlayers
    })

    LoadPlayers()

    -- Tab NPC
    local NPCPage = UI:addPage({ title = "NPC", icon = 4483362458 })

    NPCPage:addToggle({
        text = "ESP NPC",
        value = false,
        callback = function(Value)
            ESP_NPC_ON = Value
            CustomNotify("ESP NPC", Value and "Bật" or "Tắt")
        end
    })

    NPCPage:addToggle({
        text = "Lock NPC gần nhất",
        value = false,
        callback = function(Value)
            LockNPC = Value
            CustomNotify("Lock NPC", Value and "Bật" or "Tắt")
        end
    })

    -- Tab Skin
    local SkinPage = UI:addPage({ title = "Skin", icon = 4483362458 })

    SkinPage:addButton({
        text = "Xoá toàn bộ Skin",
        callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            for _, item in pairs(character:GetChildren()) do
                if item:IsA("Accessory") or item:IsA("Clothing") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") or item:IsA("BodyColors") or item:IsA("CharacterMesh") or item:IsA("Decal") or item:IsA("HumanoidDescription") then
                    item:Destroy()
                end
            end
            CustomNotify("Skin", "Đã xoá toàn bộ Skin, tóc, mặt...")
        end
    })

    SkinPage:addTextbox({
        text = "Tên người chơi",
        placeholder = "Nhập tên người chơi...",
        callback = function(input)
            local success, result = pcall(function()
                return game.Players:GetUserIdFromNameAsync(input)
            end)
            if success then
                userIdToClone = result
                setclipboard(tostring(result))
                CustomNotify("Đã sao chép ID", "UserId: " .. tostring(result))
            else
                CustomNotify("Lỗi", "Không tìm thấy người chơi!")
            end
        end
    })

    SkinPage:addTextbox({
        text = "Hoặc nhập UserId trực tiếp",
        placeholder = "Nhập UserId...",
        callback = function(input)
            local id = tonumber(input)
            if id then
                userIdToClone = id
                setclipboard(input)
                CustomNotify("Đã nhận ID", "UserId: " .. input)
            else
                CustomNotify("Lỗi", "ID không hợp lệ!")
            end
        end
    })

    SkinPage:addButton({
        text = "Clone Skin từ ID",
        callback = function()
            if not userIdToClone then
                CustomNotify("Thiếu UserId!", "Vui lòng nhập tên hoặc ID trước.")
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
                CustomNotify("Thành công", "Đã clone skin!")
            else
                CustomNotify("Lỗi clone", "Không thể lấy trang phục!")
            end
        end
    })

    SkinPage:addButton({
        text = "Bật Clone Avatar (Name)",
        callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/refs/heads/main/Copy%20Avatar'))()
        end
    })

    -- Tab Ink Game
    local InkPage = UI:addPage({ title = "Ink Game", icon = 4483362458 })

    InkPage:addButton({
        text = "Ringta",
        callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/wefwef127382/inkgames.github.io/refs/heads/main/ringta.lua"))()
            CustomNotify("Ringta", "Script loaded!")
        end
    })

    -- Tab Grow A Garden
    local GrowPage = UI:addPage({ title = "Grow A Garden", icon = 13014560 })

    GrowPage:addButton({
        text = "Speed X Hub",
        callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
            CustomNotify("Speed X Hub", "Script loaded!")
        end
    })

    GrowPage:addButton({
        text = "No Lag",
        callback = function()
            repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
            local scripts = {
                [126884695634066] = "https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/Garden/Garden-V1.lua",
                [81440632616906] = "https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/DigEarth/V1.lua",
            }
            local url = scripts[game.PlaceId]
            if url then
                loadstring(game:HttpGetAsync(url))()
                loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/untitled.lua"))()
                CustomNotify("No Lag", "Loaded for this game")
            else
                CustomNotify("No Lag", "Game không hỗ trợ!")
            end
        end
    })

    -- Tab Blox Fruits
    local BloxFruitsPage = UI:addPage({ title = "🍌 Blox Fruits", icon = 4483362458 })

    BloxFruitsPage:addButton({
        text = "Banana Cat Hub 🍌",
        callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Chiriku2013/BananaCatHub/refs/heads/main/BananaCatHub.lua"))()
        end
    })

    BloxFruitsPage:addButton({
        text = "Redz Hub 🔴",
        callback = function()
            local Settings = {
                JoinTeam = "Pirates",
                Translator = true,
            }
            loadstring(game:HttpGet("https://raw.githubusercontent.com/newredz/BloxFruits/refs/heads/main/Source.luau"))(Settings)
        end
    })

    -- Tab Murder Mystery 2
    local MM2Page = UI:addPage({ title = "Murder Mystery 2", icon = 4483362458 })

    MM2Page:addButton({
        text = "Xhub MM2",
        callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Au0yX/Community/main/XhubMM2"))()
        end
    })
end

-- Logic Game
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

-- Performance Monitor
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
