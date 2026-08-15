-- [[ KHỞI TẠO CÁC DỊCH VỤ HỆ THỐNG ]]
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local isInvisible = false -- Trạng thái kiểm soát tàng hình
local savedTransparencies = {} -- Nơi lưu độ trong suốt gốc để hồi phục

-- [[ 1. TẠO GIAO DIỆN (UI HÌNH VUÔNG ĐỎ) ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GhostModeSquareUI"
ScreenGui.ResetOnSpawn = false

-- Đưa vào CoreGui để không bị mất khi chết
local success, _ = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = localPlayer:WaitForChild("PlayerGui") end

-- Khung nền chính (Hình vuông 80x80)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 80, 0, 80) -- Kích thước hình vuông cân đối
MainFrame.Position = UDim2.new(0.5, -40, 0.4, 0) -- Ở giữa màn hình khi mới bật
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Viền nền đen mờ
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- Nút bấm vuông (Nằm trọn bên trong khung)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(1, -6, 1, -6) -- Chừa lại 3 pixel làm viền
ToggleButton.Position = UDim2.new(0, 3, 0, 3)
ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 40, 40) -- Màu đỏ tươi góc cạnh
ToggleButton.Text = "TÀNG HÌNH\nTẮT" -- Xuống dòng cho gọn trong ô vuông
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 14
ToggleButton.BorderSizePixel = 0
ToggleButton.Parent = MainFrame

-- [[ 2. TÍNH NĂNG KÉO DI CHUYỂN UI VUÔNG ]]
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    TweenService:Create(MainFrame, TweenInfo.new(0.08), {Position = targetPos}):Play() -- Giảm độ trễ để kéo đi dứt khoát hơn
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- [[ 3. LÔ-GÍC TÀNG HÌNH ]]
local function applyTransparency(character, state)
    if not character then return end
    
    for _, obj in pairs(character:GetDescendants()) do
        -- Xử lý các bộ phận cơ thể
        if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
            if state then
                if not savedTransparencies[obj] then
                    savedTransparencies[obj] = obj.Transparency
                end
                obj.Transparency = 1
            else
                obj.Transparency = savedTransparencies[obj] or 0
            end
        
        -- Xử lý quần áo, áo khoác
        elseif obj:IsA("Clothing") or obj:IsA("ShirtGraphic") then
            if state then
                obj.Enabled = false
            else
                obj.Enabled = true
            end
            
        -- Xử lý khuôn mặt
        elseif obj:IsA("Decal") and obj.Name == "face" then
            if state then
                obj.Transparency = 1
            else
                obj.Transparency = 0
            end

        -- Ẩn tên/thanh máu trên đầu
        elseif obj:IsA("BillboardGui") then
            if state then
                obj.Enabled = false
            else
                obj.Enabled = true
            end
        end
    end
end

-- Sự kiện click nút vuông
ToggleButton.MouseButton1Click:Connect(function()
    isInvisible = not isInvisible
    
    local character = localPlayer.Character
    if character then
        applyTransparency(character, isInvisible)
    end
    
    -- Thay đổi trạng thái UI vuông
    if isInvisible then
        ToggleButton.Text = "TÀNG HÌNH\nBẬT"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 180, 40) -- Biến thành hình vuông xanh khi bật
    else
        ToggleButton.Text = "TÀNG HÌNH\nTẮT"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 40, 40) -- Trở lại hình vuông đỏ khi tắt
        savedTransparencies = {}
    end
end)

-- Tự động ẩn lại khi hồi sinh (Spawn)
localPlayer.CharacterAdded:Connect(function(newCharacter)
    if isInvisible then
        task.wait(1)
        applyTransparency(newCharacter, true)
    end
end)

print("Square UI Loaded! Nhấp chuột vào nút vuông để bật/tắt hoặc giữ chuột để kéo di chuyển.")
