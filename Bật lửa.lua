local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Tạo tool bật lửa
local lighterTool = Instance.new("Tool")
lighterTool.Name = "BậtLửaPro"
lighterTool.ToolTip = "Bật lửa cao cấp - Đầy đủ hiệu ứng"
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
local spreadChance = 0.1 -- Đã giảm xuống 10% cháy lan (thay đổi duy nhất)

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

-- Tạo hiệu ứng cháy trên vật thể
local function createBurnEffect(target)
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
    
    -- Tia lửa nhỏ
    local sparkles = Instance.new("Sparkles")
    sparkles.SparkleColor = Color3.fromRGB(255, 150, 50)
    sparkles.Parent = target
    
    return {Fire = fire, Smoke = smoke, Sparkles = sparkles}
end

-- Cơ chế cháy lan (đã điều chỉnh xuống 10%)
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
            and math.random() < spreadChance then -- Chỉ 10% cơ hội cháy lan
            
            burnCooldown[part] = true
            
            -- Tạo hiệu ứng cháy
            local effects = createBurnEffect(part)
            
            -- Vật thể biến mất sau 10-15s
            Debris:AddItem(part, math.random(10, 15))
            
            -- Tiếp tục cháy lan sau delay
            delay(math.random(2, 3), function()
                spreadFire(part)
            end)
            
            -- Xóa hiệu ứng khi vật thể biến mất
            for _, effect in pairs(effects) do
                Debris:AddItem(effect, math.random(8, 12))
            end
        end
    end
end

-- Chức năng đốt cháy chính
lighterTool.Equipped:Connect(function()
    handle.Touched:Connect(function(hit)
        if isLit and hit.Parent and not hit:IsDescendantOf(character) and not burnCooldown[hit] then
            burnCooldown[hit] = true
            
            -- Tạo hiệu ứng cháy
            local effects = createBurnEffect(hit)
            
            -- Vật thể biến mất
            Debris:AddItem(hit, math.random(12, 18))
            
            -- Cháy lan
            spreadFire(hit)
            
            -- Xóa hiệu ứng
            for _, effect in pairs(effects) do
                Debris:AddItem(effect, math.random(10, 15))
            end
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

print("Bật lửa Pro đã sẵn sàng với đầy đủ hiệu ứng lửa và khói! (10% cháy lan)")
