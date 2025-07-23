local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player:WaitForChild("CharacterAdded"):Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Tạo tool bật lửa
local lighterTool = Instance.new("Tool")
lighterTool.Name = "BậtLửaNguyHiểm"
lighterTool.ToolTip = "10% cháy lan - Mất máu từ từ + 20% sau 10s"
lighterTool.RequiresHandle = true

-- Tạo handle
local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(0.3, 0.5, 0.3)
handle.Material = Enum.Material.Metal
handle.Color = Color3.fromRGB(200, 200, 200)
handle.Parent = lighterTool

-- Hiệu ứng lửa
local fire = Instance.new("Fire")
fire.Enabled = false
fire.Size = 0
fire.Heat = 0
fire.Color = Color3.fromRGB(255, 80, 0)
fire.SecondaryColor = Color3.fromRGB(255, 180, 30)
fire.Parent = handle

-- Hiệu ứng khói
local smoke = Instance.new("Smoke")
smoke.Enabled = false
smoke.Size = 0.1
smoke.Opacity = 0.5
smoke.Color = Color3.fromRGB(50, 50, 50)
smoke.RiseVelocity = 2
smoke.Parent = handle

-- Cấu hình
local isLit = false
local burnCooldown = {}
local spreadChance = 0.1 -- 10% cháy lan

-- Cơ chế mất máu
local gradualDrainRate = 0.003 -- Mất 0.3% máu mỗi giây (từ từ)
local burstDamageAfter10s = 0.2 -- Mất 20% máu sau 10s
local healthDrainInterval = 0.1 -- Cập nhật mỗi 0.1 giây
local useTimer = 0
local warningThreshold = 8 -- Cảnh báo sau 8s
local isDrainingHealth = false

-- Kết nối sự kiện click
lighterTool.Activated:Connect(function()
    isLit = not isLit
    
    if isLit then
        -- Bật hiệu ứng
        fire.Enabled = true
        smoke.Enabled = true
        local tween = TweenService:Create(fire, TweenInfo.new(0.5), {Size = 5, Heat = 15})
        tween:Play()
        
        -- Bắt đầu đếm thời gian sử dụng
        useTimer = 0
        isDrainingHealth = true
        
        -- Coroutine mất máu từ từ
        coroutine.wrap(function()
            while isLit and isDrainingHealth and humanoid.Health > 0 do
                humanoid:TakeDamage(humanoid.MaxHealth * gradualDrainRate * healthDrainInterval)
                wait(healthDrainInterval)
            end
        end)()
        
        -- Coroutine đếm thời gian cho cơ chế 10s
        coroutine.wrap(function()
            while isLit and humanoid.Health > 0 do
                useTimer = useTimer + 1
                wait(1)
                
                -- Cảnh báo khi gần đến 10s
                if useTimer == warningThreshold then
                    print("CẢNH BÁO: Sắp mất 20% máu!")
                end
                
                -- Trừ máu sau 10s
                if useTimer >= 10 then
                    humanoid:TakeDamage(humanoid.MaxHealth * burstDamageAfter10s)
                    print("Bạn đã mất 20% máu do sử dụng bật lửa quá lâu!")
                    break
                end
            end
        end)()
    else
        -- Tắt hiệu ứng
        local tween = TweenService:Create(fire, TweenInfo.new(0.5), {Size = 0, Heat = 0})
        tween:Play()
        smoke.Enabled = false
        isDrainingHealth = false
        useTimer = 0 -- Reset timer khi tắt
    end
end)

-- Tạo hiệu ứng cháy
local function createBurnEffect(target)
    local newFire = Instance.new("Fire")
    newFire.Size = 6
    newFire.Heat = 10
    newFire.Color = Color3.fromRGB(255, 70, 0)
    newFire.Parent = target
    
    local newSmoke = Instance.new("Smoke")
    newSmoke.Size = 0.3
    newSmoke.Opacity = 0.6
    newSmoke.Color = Color3.fromRGB(40, 40, 40)
    newSmoke.Parent = target
    
    return {Fire = newFire, Smoke = newSmoke}
end

-- Cơ chế cháy lan 10%
local function spreadFire(originPart)
    local nearbyParts = workspace:FindPartsInRadius(
        originPart.Position,
        7, -- Khoảng cách cháy lan
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
            Debris:AddItem(part, math.random(8, 12))
            
            delay(math.random(3, 5), function()
                spreadFire(part)
            end)
            
            for _, effect in pairs(effects) do
                Debris:AddItem(effect, math.random(6, 10))
            end
        end
    end
end

-- Kết nối va chạm
handle.Touched:Connect(function(hit)
    if isLit and hit.Parent and not hit:IsDescendantOf(character) and not burnCooldown[hit] then
        burnCooldown[hit] = true
        local effects = createBurnEffect(hit)
        Debris:AddItem(hit, math.random(10, 15))
        spreadFire(hit)
        
        for _, effect in pairs(effects) do
            Debris:AddItem(effect, math.random(8, 12))
        end
    end
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

print("Bật lửa nguy hiểm đã sẵn sàng! (10% cháy lan, mất máu từ từ + 20% sau 10s)")
