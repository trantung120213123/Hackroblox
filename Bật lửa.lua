local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Tạo tool bật lửa
local lighterTool = Instance.new("Tool")
lighterTool.Name = "BậtLửaPremium"
lighterTool.ToolTip = "Bật lửa cao cấp - Hiệu ứng cháy đen"
lighterTool.RequiresHandle = true

-- Tạo handle
local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(0.3, 0.5, 0.3)
handle.Material = Enum.Material.Metal
handle.Color = Color3.fromRGB(200, 200, 200)
handle.Parent = lighterTool

-- Hiệu ứng lửa chính
local mainFire = Instance.new("Fire")
mainFire.Enabled = false
mainFire.Size = 0
mainFire.Heat = 0
mainFire.Color = Color3.fromRGB(255, 100, 0)
mainFire.SecondaryColor = Color3.fromRGB(255, 200, 50)
mainFire.Parent = handle

-- Hiệu ứng khói chính
local mainSmoke = Instance.new("Smoke")
mainSmoke.Enabled = false
mainSmoke.Size = 0.1
mainSmoke.Opacity = 0.5
mainSmoke.Color = Color3.fromRGB(50, 50, 50)
mainSmoke.RiseVelocity = 2
mainSmoke.Parent = handle

-- Biến trạng thái
local isLit = false
local burnCooldown = {}
local spreadChance = 0.1 -- 10% cháy lan

-- Âm thanh
local soundFolder = Instance.new("Folder")
soundFolder.Name = "LighterSounds"
soundFolder.Parent = handle

local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://131147719" -- Âm bật lửa
clickSound.Volume = 0.5
clickSound.Parent = soundFolder

local flameSound = Instance.new("Sound")
flameSound.SoundId = "rbxassetid://138186576" -- Âm lửa cháy
flameSound.Looped = true
flameSound.Volume = 0.4
flameSound.Parent = soundFolder

-- Kết nối sự kiện click
lighterTool.Activated:Connect(function()
    isLit = not isLit
    
    if isLit then
        -- Bật hiệu ứng
        mainFire.Enabled = true
        mainSmoke.Enabled = true
        
        -- Animation bật lửa
        local tweenIn = TweenService:Create(mainFire, TweenInfo.new(0.5), {
            Size = 5,
            Heat = 15
        })
        tweenIn:Play()
        
        local smokeTween = TweenService:Create(mainSmoke, TweenInfo.new(0.5), {
            Size = 0.3,
            Opacity = 0.8
        })
        smokeTween:Play()
        
        -- Đổi màu handle
        handle.Material = Enum.Material.Neon
        handle.Color = Color3.fromRGB(255, 120, 0)
        
        -- Âm thanh
        clickSound:Play()
        flameSound:Play()
    else
        -- Tắt hiệu ứng
        local tweenOut = TweenService:Create(mainFire, TweenInfo.new(0.5), {
            Size = 0,
            Heat = 0
        })
        tweenOut:Play()
        
        local smokeTweenOut = TweenService:Create(mainSmoke, TweenInfo.new(0.5), {
            Size = 0.1,
            Opacity = 0
        })
        smokeTweenOut:Play()
        
        -- Đổi lại handle
        handle.Material = Enum.Material.Metal
        handle.Color = Color3.fromRGB(200, 200, 200)
        
        -- Âm thanh
        flameSound:Stop()
    end
end)

-- Tạo hiệu ứng cháy đen trước khi biến mất
local function createBurnEffect(target)
    -- Lưu màu gốc
    local originalColor = target.Color
    local originalMaterial = target.Material
    
    -- Tạo hiệu ứng cháy
    local fire = Instance.new("Fire")
    fire.Size = 7
    fire.Heat = 12
    fire.Color = Color3.fromRGB(255, 80, 0)
    fire.SecondaryColor = Color3.fromRGB(255, 180, 30)
    fire.Parent = target
    
    local smoke = Instance.new("Smoke")
    smoke.Size = 0.4
    smoke.Opacity = 0.7
    smoke.Color = Color3.fromRGB(40, 40, 40)
    smoke.RiseVelocity = 5
    smoke.Parent = target
    
    -- Hiệu ứng cháy đen
    coroutine.wrap(function()
        -- Giai đoạn 1: Cháy bình thường (5 giây)
        for i = 1, 50 do
            if not target or not target.Parent then break end
            wait(0.1)
        end
        
        -- Giai đoạn 2: Bắt đầu cháy đen (3 giây)
        if target and target.Parent then
            local burnTween = TweenService:Create(target, TweenInfo.new(3), {
                Color = Color3.fromRGB(30, 30, 30),
                Material = Enum.Material.CorrodedMetal
            })
            burnTween:Play()
            
            -- Điều chỉnh lửa và khói khi cháy đen
            local fireTween = TweenService:Create(fire, TweenInfo.new(3), {
                Color = Color3.fromRGB(50, 50, 50),
                SecondaryColor = Color3.fromRGB(20, 20, 20),
                Size = 3
            })
            fireTween:Play()
            
            local smokeTween = TweenService:Create(smoke, TweenInfo.new(3), {
                Color = Color3.fromRGB(20, 20, 20),
                Opacity = 0.9,
                Size = 0.6
            })
            smokeTween:Play()
            
            wait(3)
        end
        
        -- Giai đoạn 3: Biến mất
        if target and target.Parent then
            target:Destroy()
        end
    end)()
    
    return {Fire = fire, Smoke = smoke}
end

-- Cơ chế cháy lan 10%
local function spreadFire(originPart)
    local nearbyParts = workspace:FindPartsInRadius(
        originPart.Position,
        8, -- Khoảng cách cháy lan
        nil,
        nil
    )
    
    for _, part in pairs(nearbyParts) do
        if part ~= originPart 
            and part.Parent 
            and not part:IsDescendantOf(character) 
            and not burnCooldown[part] 
            and math.random() < spreadChance then
            
            burnCooldown[part] = true
            local effects = createBurnEffect(part)
            
            -- Xóa hiệu ứng sau khi hoàn thành
            delay(8, function()
                if effects.Fire then effects.Fire:Destroy() end
                if effects.Smoke then effects.Smoke:Destroy() end
            end)
            
            -- Tiếp tục cháy lan sau delay
            delay(math.random(2, 3), function()
                spreadFire(part)
            end)
        end
    end
end

-- Chức năng đốt cháy chính
lighterTool.Equipped:Connect(function()
    handle.Touched:Connect(function(hit)
        if isLit and hit.Parent and not hit:IsDescendantOf(character) and not burnCooldown[hit] then
            burnCooldown[hit] = true
            local effects = createBurnEffect(hit)
            
            -- Xóa hiệu ứng sau khi hoàn thành
            delay(8, function()
                if effects.Fire then effects.Fire:Destroy() end
                if effects.Smoke then effects.Smoke:Destroy() end
            end)
            
            -- Cháy lan
            spreadFire(hit)
        end
    end)
end)

-- Reset cooldown sau 30s
RunService.Heartbeat:Connect(function()
    for part, time in pairs(burnCooldown) do
        if time and os.clock() - time > 30 then
            burnCooldown[part] = nil
        end
    end
end)

-- Thêm tool vào kho đồ
lighterTool.Parent = player.Backpack

print("Bật lửa Premium đã sẵn sàng với hiệu ứng cháy đen!")
