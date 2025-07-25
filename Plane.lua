-- GUI Script by Tien Tung (ngố) - ULTIMATE VERSION
loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "🏆 Auto Sword ULTIMATE",
   LoadingTitle = "Auto Sword ULTIMATE - Red vs Blue",
   LoadingSubtitle = "by Tien Tung | TP + Auto Cầm Kiếm",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false,
   },
   KeySystem = false,
})

local MainTab = Window:CreateTab("Chiến Đấu", 4483362458)
local AutoKillRunning = false
local Team = game.Players.LocalPlayer.Team
local CurrentTarget = nil

-- Cấu hình
local SETTINGS = {
    TP_INTERVAL = 0.05,
    TP_DISTANCE = 2,
    HITBOX_RANGE = 20,  -- Tăng hitbox lên 20 studs
    ATTACK_DELAY = 0.1
}

-- Tìm kiếm kiếm trong túi đồ và trên người
local function findSword()
    for _, container in ipairs({game.Players.LocalPlayer.Character, game.Players.LocalPlayer.Backpack}) do
        if container then
            for _, tool in ipairs(container:GetChildren()) do
                if tool:IsA("Tool") and (tool.Name:lower():find("sword") or tool.Name:lower():find("kiếm") or tool.Name:lower():find("katana") or tool.Name:lower():find("blade")) then
                    return tool
                end
            end
        end
    end
    return nil
end

-- Tự động cầm kiếm nếu chưa cầm
local function equipSword()
    local sword = findSword()
    if sword and sword.Parent ~= game.Players.LocalPlayer.Character then
        sword.Parent = game.Players.LocalPlayer.Character
        return true
    end
    return sword ~= nil
end

-- Tìm kẻ địch gần nhất còn sống
local function getBestEnemy()
    local closestDistance = math.huge
    local bestEnemy = nil
    local myPos = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    
    if not myPos then return nil end
    
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Team ~= Team and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            
            if humanoidRootPart and humanoid and humanoid.Health > 0 then
                local distance = (humanoidRootPart.Position - myPos).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    bestEnemy = player.Character
                end
            end
        end
    end
    
    return bestEnemy
end

-- Vòng lặp chiến đấu chính
local function combatLoop()
    while AutoKillRunning do
        -- Kiểm tra nhân vật
        local char = game.Players.LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            task.wait(0.5)
            continue
        end

        -- Tự động cầm kiếm
        if not equipSword() then
            task.wait(1)
            continue
        end

        -- Tìm mục tiêu mới nếu cần
        if not CurrentTarget or not CurrentTarget.Parent or not CurrentTarget:FindFirstChild("HumanoidRootPart") or CurrentTarget.Humanoid.Health <= 0 then
            CurrentTarget = getBestEnemy()
            
            -- Nếu không có địch thì chờ
            if not CurrentTarget then
                task.wait(1)
                continue
            end
        end

        -- Thực hiện TP và tấn công
        if CurrentTarget and CurrentTarget:FindFirstChild("HumanoidRootPart") then
            local targetHRP = CurrentTarget.HumanoidRootPart
            local myHRP = char.HumanoidRootPart
            
            -- TP đến phía sau địch và hướng mặt vào địch
            local backPosition = targetHRP.Position - (targetHRP.CFrame.LookVector * SETTINGS.TP_DISTANCE)
            myHRP.CFrame = CFrame.new(backPosition, targetHRP.Position)
            
            -- Tạo hitbox mở rộng
            local fakeHitbox = Instance.new("Part")
            fakeHitbox.Size = Vector3.new(SETTINGS.HITBOX_RANGE, SETTINGS.HITBOX_RANGE, SETTINGS.HITBOX_RANGE)
            fakeHitbox.Transparency = 1
            fakeHitbox.CanCollide = false
            fakeHitbox.Anchored = true
            fakeHitbox.Position = targetHRP.Position
            fakeHitbox.Parent = workspace
            
            -- Tấn công
            local sword = char:FindFirstChildOfClass("Tool")
            if sword then
                for _ = 1, 3 do
                    sword:Activate()
                    task.wait(SETTINGS.ATTACK_DELAY)
                end
            end
            
            -- Xóa hitbox
            fakeHitbox:Destroy()
        end
        
        task.wait(SETTINGS.TP_INTERVAL)
    end
end

-- Nút bật/tắt
local toggleState = false
local ToggleBtn = MainTab:CreateButton({
    Name = "⚔️ BẬT/TẮT AUTO KIẾM",
    Callback = function()
        toggleState = not toggleState
        AutoKillRunning = toggleState
        
        if toggleState then
            Team = game.Players.LocalPlayer.Team
            if not findSword() then
                Rayfield:Notify({
                    Title = "❌ KHÔNG CÓ KIẾM",
                    Content = "Vui lòng trang bị kiếm trước!",
                    Duration = 3,
                })
                toggleState = false
                AutoKillRunning = false
                return
            end
            
            Rayfield:Notify({
                Title = "⚔️ ĐÃ BẬT",
                Content = "Auto Sword đang hoạt động",
                Duration = 2,
            })
            coroutine.wrap(combatLoop)()
        else
            CurrentTarget = nil
            Rayfield:Notify({
                Title = "ĐÃ TẮT",
                Content = "Auto Sword đã dừng",
                Duration = 1.5,
            })
        end
    end
})

-- Tab thông tin
local InfoTab = Window:CreateTab("Thông Tin", 7733960981)
InfoTab:CreateLabel("Cách hoạt động:")
InfoTab:CreateLabel("- Tự động TP sau lưng địch")
InfoTab:CreateLabel("- Luôn hướng mặt vào mục tiêu")
InfoTab:CreateLabel("- Hitbox mở rộng: "..SETTINGS.HITBOX_RANGE.." studs")
InfoTab:CreateLabel("- Tự động cầm kiếm khi cần")
InfoTab:CreateLabel("- Chờ địch hồi sinh nếu không có mục tiêu")
InfoTab:CreateLabel("- lưu ý khi đổi team phải tắt đi bật lại")
