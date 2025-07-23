-- Loader với kiểm tra key và lưu key hoạt động
local key = "trantung999shithub"
local url = "https://yeumoney.com/uVk6nM"
local scriptUrl = "https://raw.githubusercontent.com/trantung120213123/Hackroblox/main/Deadrailbytrantung999.lua"

-- Sử dụng DataStoreService để lưu key
local DataStoreService = game:GetService("DataStoreService")
local keyStore = DataStoreService:GetDataStore("KeyStorage_"..game.PlaceId)

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeySystemPro"
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 180)
Frame.Position = UDim2.new(0.5, -150, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.9, 0, 0, 30)
TextBox.Position = UDim2.new(0.05, 0, 0.2, 0)
TextBox.PlaceholderText = "Enter Key"
TextBox.Text = ""
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextBox.TextColor3 = Color3.new(1, 1, 1)
TextBox.ClearTextOnFocus = false
TextBox.Parent = Frame

local GetKeyButton = Instance.new("TextButton")
GetKeyButton.Size = UDim2.new(0.42, 0, 0, 30)
GetKeyButton.Position = UDim2.new(0.05, 0, 0.6, 0)
GetKeyButton.Text = "Get Key"
GetKeyButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
GetKeyButton.TextColor3 = Color3.new(1, 1, 1)
GetKeyButton.Parent = Frame

local CheckButton = Instance.new("TextButton")
CheckButton.Size = UDim2.new(0.42, 0, 0, 30)
CheckButton.Position = UDim2.new(0.53, 0, 0.6, 0)
CheckButton.Text = "Submit"
CheckButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
CheckButton.TextColor3 = Color3.new(1, 1, 1)
CheckButton.Parent = Frame

local SaveKeyCheckbox = Instance.new("TextButton")
SaveKeyCheckbox.Size = UDim2.new(0, 20, 0, 20)
SaveKeyCheckbox.Position = UDim2.new(0.05, 0, 0.8, 0)
SaveKeyCheckbox.Text = ""
SaveKeyCheckbox.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
SaveKeyCheckbox.Parent = Frame

local checkboxMark = Instance.new("TextLabel")
checkboxMark.Size = UDim2.new(1, 0, 1, 0)
checkboxMark.Text = "✓"
checkboxMark.TextColor3 = Color3.new(0, 1, 0)
checkboxMark.TextScaled = true
checkboxMark.Visible = false
checkboxMark.BackgroundTransparency = 1
checkboxMark.Parent = SaveKeyCheckbox

local RememberLabel = Instance.new("TextLabel")
RememberLabel.Size = UDim2.new(0, 200, 0, 20)
RememberLabel.Position = UDim2.new(0.15, 0, 0.8, 0)
RememberLabel.Text = "Remember my key"
RememberLabel.TextColor3 = Color3.new(1, 1, 1)
RememberLabel.TextXAlignment = Enum.TextXAlignment.Left
RememberLabel.BackgroundTransparency = 1
RememberLabel.Parent = Frame

-- Hàm thông báo
local Notification = function(text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Key System Pro",
        Text = text,
        Duration = 5
    })
end

-- Hàm lưu key
local function saveKey(userId, keyValue)
    pcall(function()
        keyStore:SetAsync(tostring(userId), keyValue)
        Notification("Key đã được lưu!")
    end)
end

-- Hàm kiểm tra key đã lưu
local function loadSavedKey(userId)
    local success, savedKey = pcall(function()
        return keyStore:GetAsync(tostring(userId))
    end)
    
    if success and savedKey then
        TextBox.Text = savedKey
        checkboxMark.Visible = true
        return true
    end
    return false
end

-- Kiểm tra key đã lưu khi khởi động
local userId = game.Players.LocalPlayer.UserId
loadSavedKey(userId)

-- Sự kiện click checkbox
SaveKeyCheckbox.MouseButton1Click:Connect(function()
    checkboxMark.Visible = not checkboxMark.Visible
    Notification(checkboxMark.Visible and "Đã bật lưu key" or "Đã tắt lưu key")
end)

-- Sự kiện nút Get Key
GetKeyButton.MouseButton1Click:Connect(function()
    setclipboard(url)
    Notification("Đã copy link lấy key!")
end)

-- Sự kiện nút Check Key
CheckButton.MouseButton1Click:Connect(function()
    if TextBox.Text == key then
        -- Lưu key nếu được chọn
        if checkboxMark.Visible then
            saveKey(userId, key)
        end
        
        Notification("Đúng key! Đang khởi chạy...")
        ScreenGui:Destroy()
        loadstring(game:HttpGet(scriptUrl))()
    else
        Notification("Sai key, thử lại!")
    end
end)

print("Hệ thống key đã sẵn sàng! Key mới: "..key)
