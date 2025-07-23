-- Loader với kiểm tra key và lưu key
local key = "trantung999shithub"
local url = "https://yeumoney.com/uVk6nM"
local scriptUrl = "https://raw.githubusercontent.com/trantung120213123/Hackroblox/main/Deadrailbytrantung999.lua"

-- Tạo DataStore để lưu key (nếu game hỗ trợ)
local DataStoreService = game:GetService("DataStoreService")
local keyStore = DataStoreService:GetDataStore("KeyStorage")

-- Biến lưu key tạm thời
local savedKey = nil

-- Hàm thông báo
local Notification = function(text)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Key System Pro",
        Text = text,
        Duration = 5
    })
end

-- Hàm lưu key vào DataStore
local function saveKeyToDataStore(userId, key)
    pcall(function()
        keyStore:SetAsync(tostring(userId), key)
    end)
end

-- Hàm lấy key từ DataStore
local function getKeyFromDataStore(userId)
    local success, result = pcall(function()
        return keyStore:GetAsync(tostring(userId))
    end)
    return success and result or nil
end

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local UICorner = Instance.new("UICorner", Frame)
local TextBox = Instance.new("TextBox", Frame)
local GetKeyButton = Instance.new("TextButton", Frame)
local CheckButton = Instance.new("TextButton", Frame)
local SaveKeyCheckbox = Instance.new("TextButton", Frame)
local RememberLabel = Instance.new("TextLabel", Frame)

ScreenGui.Name = "KeySystemPro"
Frame.Size = UDim2.new(0, 300, 0, 180) -- Tăng chiều cao để thêm checkbox
Frame.Position = UDim2.new(0.5, -150, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

UICorner.CornerRadius = UDim.new(0, 8)

TextBox.Size = UDim2.new(0.9, 0, 0, 30)
TextBox.Position = UDim2.new(0.05, 0, 0.2, 0)
TextBox.PlaceholderText = "Enter Key"
TextBox.Text = ""
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextBox.TextColor3 = Color3.new(1, 1, 1)
TextBox.ClearTextOnFocus = false

GetKeyButton.Size = UDim2.new(0.42, 0, 0, 30)
GetKeyButton.Position = UDim2.new(0.05, 0, 0.6, 0)
GetKeyButton.Text = "Get Key"
GetKeyButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
GetKeyButton.TextColor3 = Color3.new(1, 1, 1)

CheckButton.Size = UDim2.new(0.42, 0, 0, 30)
CheckButton.Position = UDim2.new(0.53, 0, 0.6, 0)
CheckButton.Text = "Submit"
CheckButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
CheckButton.TextColor3 = Color3.new(1, 1, 1)

-- Thêm checkbox lưu key
SaveKeyCheckbox.Size = UDim2.new(0, 20, 0, 20)
SaveKeyCheckbox.Position = UDim2.new(0.05, 0, 0.8, 0)
SaveKeyCheckbox.Text = ""
SaveKeyCheckbox.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
local checkboxMark = Instance.new("TextLabel", SaveKeyCheckbox)
checkboxMark.Size = UDim2.new(1, 0, 1, 0)
checkboxMark.Text = "✓"
checkboxMark.TextColor3 = Color3.new(0, 1, 0)
checkboxMark.TextScaled = true
checkboxMark.Visible = false
checkboxMark.BackgroundTransparency = 1

RememberLabel.Size = UDim2.new(0, 200, 0, 20)
RememberLabel.Position = UDim2.new(0.15, 0, 0.8, 0)
RememberLabel.Text = "Remember my key"
RememberLabel.TextColor3 = Color3.new(1, 1, 1)
RememberLabel.TextXAlignment = Enum.TextXAlignment.Left
RememberLabel.BackgroundTransparency = 1

-- Biến kiểm tra trạng thái lưu key
local saveKeyEnabled = false

-- Kiểm tra key đã lưu khi khởi động
local function checkSavedKey()
    local userId = game.Players.LocalPlayer.UserId
    savedKey = getKeyFromDataStore(userId)
    
    if savedKey then
        TextBox.Text = savedKey
        checkboxMark.Visible = true
        saveKeyEnabled = true
    end
end

-- Sự kiện click checkbox
SaveKeyCheckbox.MouseButton1Click:Connect(function()
    saveKeyEnabled = not saveKeyEnabled
    checkboxMark.Visible = saveKeyEnabled
end)

-- Sự kiện nút Get Key
GetKeyButton.MouseButton1Click:Connect(function()
    setclipboard(url)
    Notification("Đã copy link lấy key!")
end)

-- Sự kiện nút Check Key
CheckButton.MouseButton1Click:Connect(function()
    if TextBox.Text == key then
        Notification("Đúng key!")
        
        -- Lưu key nếu được chọn
        if saveKeyEnabled then
            local userId = game.Players.LocalPlayer.UserId
            saveKeyToDataStore(userId, key)
            Notification("Đã lưu key!")
        end
        
        ScreenGui:Destroy()
        loadstring(game:HttpGet(scriptUrl))()
    else
        Notification("Sai key, thử lại!")
    end
end)

-- Kiểm tra key đã lưu khi khởi chạy
checkSavedKey()

-- Tự động submit nếu có key đúng
if savedKey == key then
    wait(1) -- Đợi 1 giây để tránh conflict
    CheckButton:Activate()
end
