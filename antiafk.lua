-- Script Anti-AFK cho Roblox với Notification
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Biến cấu hình
local AFK_TIME = 600 -- 10 phút = 600 giây
local lastAntiAFKTime = 0

-- Hàm hiển thị notification
local function showNotification(message)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Anti-AFK System",
        Text = message,
        Duration = 5,
        Icon = "rbxassetid://4483345998"
    })
end

-- Hàm mô phỏng nhấn phím
local function simulateKeyPress(keyCode)
    VirtualInputManager:SendKeyEvent(true, keyCode, false, nil)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, keyCode, false, nil)
end

-- Hàm mô phỏng di chuyển chuột
local function simulateMouseMovement()
    local currentPos = Vector2.new(200, 200) -- Vị trí giả định
    local newPos = Vector2.new(
        currentPos.X + math.random(-20, 20),
        currentPos.Y + math.random(-20, 20)
    )
    VirtualInputManager:SendMouseMoveEvent(newPos.X, newPos.Y, game:GetService("Workspace"))
end

-- Hàm thực hiện hành động chống AFK
local function performAntiAFK()
    -- Ngẫu nhiên chọn hành động
    local actions = {
        function() simulateKeyPress(Enum.KeyCode.W) end,
        function() simulateKeyPress(Enum.KeyCode.A) end,
        function() simulateKeyPress(Enum.KeyCode.S) end,
        function() simulateKeyPress(Enum.KeyCode.D) end,
        function() simulateKeyPress(Enum.KeyCode.Space) end,
        function() simulateMouseMovement() end
    }
    
    -- Thực hiện 2-3 hành động ngẫu nhiên
    for i = 1, math.random(2, 3) do
        actions[math.random(1, #actions)]()
        task.wait(0.2)
    end
    
    -- Cập nhật thời gian và hiển thị thông báo
    lastAntiAFKTime = time()
    showNotification("Đã thực hiện chống AFK lúc " .. os.date("%H:%M:%S"))
end

-- Kết nối sự kiện khi player idle
LocalPlayer.Idled:Connect(function()
    showNotification("Phát hiện AFK! Đang kích hoạt chống AFK...")
    performAntiAFK()
end)

-- Vòng lặp chính chống AFK định kỳ
while true do
    local currentTime = time()
    
    -- Kiểm tra nếu đã đến lúc chống AFK (mỗi 10 phút)
    if currentTime - lastAntiAFKTime >= AFK_TIME then
        showNotification("Chuẩn bị chống AFK định kỳ...")
        performAntiAFK()
    end
    
    -- Chờ 30 giây trước khi kiểm tra lại
    task.wait(30)
end

-- Hiển thị thông báo khi script khởi động
showNotification("Anti-AFK System đã được kích hoạt! Hoạt động mỗi 10 phút.")
print("Anti-AFK System đang chạy...")
