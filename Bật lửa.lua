local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Tạo tool bật lửa
local lighterTool = Instance.new("Tool")
lighterTool.Name = "BậtLửaPremium"
lighterTool.ToolTip = "Bật lửa cháy lan cực mạnh"
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
fire.Size = 0
fire.Heat = 0
fire.Color = Color3.fromRGB(255, 80, 0)
fire.SecondaryColor = Color3.fromRGB(255, 200, 0)
fire.Parent = handle

-- Biến trạng thái
local isLit = false
local burnCooldown = {}
local spreadDistance = 15 -- Khoảng cách cháy lan
local spreadChance = 0.6 -- Tỷ lệ cháy lan (60%)

-- Kết nối sự kiện click
lighterTool.Activated:Connect(function()
    isLit = not isLit
    
    if isLit then
        -- Bật lửa
        fire.Size = 6
        handle.Material = Enum.Material.Neon
        handle.Color = Color3.fromRGB(255, 100, 0)
        
        -- Âm thanh
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://131147719"
        sound.Parent = handle
        sound:Play()
        Debris:AddItem(sound, 2)
    else
        -- Tắt lửa
        fire.Size = 0
        handle.Material = Enum.Material.Metal
        handle.Color = Color3.fromRGB(200, 200, 200)
    end
end)

-- Cơ chế cháy lan nâng cao
local function spreadFire(originPart)
    -- Tìm tất cả parts trong phạm vi
    local nearbyParts = workspace:FindPartsInRadius(
        originPart.Position,
        spreadDistance,
        nil, -- Không giới hạn maxParts
        nil -- Không filter
    )
    
    for _, part in pairs(nearbyParts) do
        -- Kiểm tra điều kiện cháy lan
        if part ~= originPart 
            and part.Parent 
            and not part:IsDescendantOf(character) 
            and not burnCooldown[part] 
            and math.random() < spreadChance then
            
            -- Đánh dấu đã cháy
            burnCooldown[part] = true
            
            -- Tạo lửa trên vật mới
            local newFire = Instance.new("Fire")
            newFire.Size = 7
            newFire.Heat = 12
            newFire.Color = Color3.fromRGB(255, 70, 0)
            newFire.SecondaryColor = Color3.fromRGB(255, 180, 0)
            newFire.Parent = part
            
            -- Vật thể biến mất sau thời gian
            Debris:AddItem(part, math.random(8, 15))
            
            -- Tiếp tục cháy lan sau delay
            delay(math.random(1, 3), function()
                spreadFire(part) -- Đệ quy cháy lan
            end)
        end
    end
end

-- Chức năng đốt cháy chính
local function burn(target)
    if not isLit or burnCooldown[target] then return end
    
    -- Đánh dấu đã cháy
    burnCooldown[target] = true
    
    -- Tạo hiệu ứng lửa chính
    local mainFire = Instance.new("Fire")
    mainFire.Size = 9
    mainFire.Heat = 15
    mainFire.Color = Color3.fromRGB(255, 60, 0)
    mainFire.SecondaryColor = Color3.fromRGB(255, 160, 0)
    mainFire.Parent = target
    
    -- Hiệu ứng khói
    local smoke = Instance.new("Smoke")
    smoke.Size = 0.5
    smoke.Opacity = 0.7
    smoke.Color = Color3.fromRGB(50, 50, 50)
    smoke.RiseVelocity = 5
    smoke.Parent = target
    
    -- Vật thể biến mất
    Debris:AddItem(target, math.random(10, 20))
    
    -- Bắt đầu cháy lan
    spreadFire(target)
end

-- Kết nối va chạm
handle.Touched:Connect(function(hit)
    if isLit and hit.Parent and not hit:IsDescendantOf(character) then
        burn(hit)
    end
end)

-- Tự động gỡ cooldown sau 1 phút
RunService.Heartbeat:Connect(function()
    for part, time in pairs(burnCooldown) do
        if time and os.clock() - time > 60 then
            burnCooldown[part] = nil
        end
    end
end)

-- Thêm tool vào kho đồ
lighterTool.Parent = player.Backpack

print("Bật lửa cháy lan đã sẵn sàng!")
