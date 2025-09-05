local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local userId = tostring(player.UserId)
local username = player.Name

-- URL server Render
local serverURL = "https://qqwq-7.onrender.com"
local websiteURL = "content://ru.zdevs.zarchiver.external/storage/emulated/0/Download/getkey.html" -- Thay bằng website thực tế của bạn
getgenv().LuexKey = "prenium"
getgenv().antiafk = true

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumKeySystem"
ScreenGui.Parent = player.PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 400)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔐 KEY SYSTEM - UserID: " .. userId
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 45, 0, 45)
CloseButton.Position = UDim2.new(1, -45, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "×"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 26
CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseButton.Parent = TopBar

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -45)
Content.Position = UDim2.new(0, 0, 0, 45)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local Description = Instance.new("TextLabel")
Description.Size = UDim2.new(1, -40, 0, 60)
Description.Position = UDim2.new(0, 20, 0, 20)
Description.BackgroundTransparency = 1
Description.Text = "Xin chào " .. username .. "! Vui lòng nhập key để kích hoạt tính năng premium. Key có hiệu lực trong 24 giờ."
Description.Font = Enum.Font.Gotham
Description.TextSize = 14
Description.TextColor3 = Color3.fromRGB(200, 200, 200)
Description.TextWrapped = true
Description.TextXAlignment = Enum.TextXAlignment.Left
Description.Parent = Content

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -40, 0, 45)
KeyBox.Position = UDim2.new(0, 20, 0, 90)
KeyBox.PlaceholderText = "Dán key của bạn vào đây..."
KeyBox.Text = ""
KeyBox.TextSize = 16
KeyBox.Font = Enum.Font.Gotham
KeyBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = Content

local UICornerTextBox = Instance.new("UICorner")
UICornerTextBox.CornerRadius = UDim.new(0, 8)
UICornerTextBox.Parent = KeyBox

local CheckButton = Instance.new("TextButton")
CheckButton.Size = UDim2.new(1, -40, 0, 45)
CheckButton.Position = UDim2.new(0, 20, 0, 145)
CheckButton.Text = "✅ XÁC THỰC KEY"
CheckButton.TextSize = 16
CheckButton.Font = Enum.Font.GothamBold
CheckButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
CheckButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckButton.Parent = Content

local UICornerButton = Instance.new("UICorner")
UICornerButton.CornerRadius = UDim.new(0, 8)
UICornerButton.Parent = CheckButton

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -40, 0, 70)
StatusLabel.Position = UDim2.new(0, 20, 0, 200)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.TextWrapped = true
StatusLabel.Parent = Content

local CopyUrlButton = Instance.new("TextButton")
CopyUrlButton.Size = UDim2.new(1, -40, 0, 45)
CopyUrlButton.Position = UDim2.new(0, 20, 0, 280)
CopyUrlButton.Text = "📋 Lấy Key Tại Đây"
CopyUrlButton.TextSize = 14
CopyUrlButton.Font = Enum.Font.GothamBold
CopyUrlButton.BackgroundColor3 = Color3.fromRGB(60, 160, 100)
CopyUrlButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyUrlButton.Parent = Content

local UICornerCopyUrl = Instance.new("UICorner")
UICornerCopyUrl.CornerRadius = UDim.new(0, 8)
UICornerCopyUrl.Parent = CopyUrlButton

-- Hiệu ứng hover
local function createHoverEffect(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
    end)
end

createHoverEffect(CheckButton, Color3.fromRGB(88, 101, 242), Color3.fromRGB(105, 116, 245))
createHoverEffect(CopyUrlButton, Color3.fromRGB(60, 160, 100), Color3.fromRGB(70, 180, 120))

-- Hàm kiểm tra key với server (dùng http_request trên KRNL)
local function checkKey(key)
    local payload = {
        key = key,
        user_id = userId
    }

    local jsonData = HttpService:JSONEncode(payload)

    local response
    local success, err = pcall(function()
        response = http_request({
            Url = serverURL .. "/verify-key",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
    end)

    if not success or not response or not response.Body then
        return { valid = false, reason = "Không kết nối được đến server" }
    end

    local data
    local ok, decodeError = pcall(function()
        data = HttpService:JSONDecode(response.Body)
    end)

    if not ok then
        return { valid = false, reason = "Lỗi khi đọc phản hồi server" }
    end

    return data
end

-- Hàm sao chép URL
local function copyUrlToClipboard()
    local url = websiteURL
    
    local success, _ = pcall(function()
        if setclipboard then
            setclipboard(url)
            return true
        elseif Clipboard then
            Clipboard:SetAsync(url)
            return true
        end
        return false
    end)
    
    if success then
        StatusLabel.Text = "✅ Đã sao chép URL vào clipboard!\nTruy cập website để lấy key."
        StatusLabel.TextColor3 = Color3.fromRGB(87, 242, 135)
        CopyUrlButton.Text = "✅ ĐÃ SAO CHÉP"
        delay(3, function()
            CopyUrlButton.Text = "📋 Lấy Key Tại Đây"
        end)
    else
        StatusLabel.Text = "🌐 Truy cập: " .. url .. "\nCopy thủ công nếu cần."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 150)
    end
end

-- Hiển thị thông báo
local function showMessage(message, color, duration)
    StatusLabel.Text = message
    StatusLabel.TextColor3 = color
    if duration then
        delay(duration, function()
            if StatusLabel.Text == message then
                StatusLabel.Text = ""
            end
        end)
    end
end

-- Sự kiện nút đóng
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Sự kiện nút xác thực
CheckButton.MouseButton1Click:Connect(function()
    local key = KeyBox.Text:gsub("%s+", "")
    
    if key == "" then
        showMessage("❌ Vui lòng nhập key!", Color3.fromRGB(237, 66, 69), 2)
        return
    end

    CheckButton.Text = "⏳ ĐANG KIỂM TRA..."
    CheckButton.AutoButtonColor = false

    local result = checkKey(key)
    if result and result.valid then
        showMessage("✅ Key hợp lệ! Đang kích hoạt...", Color3.fromRGB(87, 242, 135))
        
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.8), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        })
        tween:Play()
        
        tween.Completed:Connect(function()
            ScreenGui:Destroy()
            print("🎯 Key verified! Loading main script...")
             loadstring(game:HttpGet("https://raw.githubusercontent.com/trantung120213123/Hackroblox/refs/heads/main/luexver1.9.lua"))()
        end)
    else
        local reason = result and result.reason or "Lỗi không xác định"
        showMessage("❌ " .. reason, Color3.fromRGB(237, 66, 69))
        CheckButton.Text = "✅ XÁC THỰC KEY"
        CheckButton.AutoButtonColor = true
    end
end)

-- Sự kiện nút lấy key
CopyUrlButton.MouseButton1Click:Connect(function()
    copyUrlToClipboard()
end)

-- Kéo di chuyển GUI
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Tự động focus
wait(0.5)
KeyBox:CaptureFocus()

-- Hiển thị hướng dẫn
showMessage("👋 Chào " .. username .. "! Nhấn nút 'Lấy Key Tại Đây' để nhận key.", Color3.fromRGB(255, 255, 150), 5)

-- Test kết nối server
spawn(function()
    local success = pcall(function()
        response = http_request(serverURL .. "/health", false)
        print("✅ Kết nối server thành công!")
    end)
    
    if not success then
        showMessage("⚠️ Không thể kết nối server. Vui lòng thử lại sau.", Color3.fromRGB(255, 165, 0), 5)
    end
end)
