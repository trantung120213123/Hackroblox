-- Hệ thống key với GUI hiển thị chắc chắn
local key = "trantung999shithub"
local url = "https://yeumoney.com/uVk6nM"
local scriptUrl = "https://raw.githubusercontent.com/trantung120213123/Hackroblox/main/Deadrailbytrantung999.lua"

-- Đảm bảo CoreGui tồn tại
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Tạo GUI mới
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeySystemPremium"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui") -- Sử dụng CoreGui thay vì StarterGui

-- Tạo frame chính
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 180)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Bo góc
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "KEY SYSTEM v2.0"
Title.Size = UDim2.new(0.9, 0, 0, 30)
Title.Position = UDim2.new(0.05, 0, 0.05, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Ô nhập key
local KeyBox = Instance.new("TextBox")
KeyBox.Name = "KeyBox"
KeyBox.Size = UDim2.new(0.9, 0, 0, 35)
KeyBox.Position = UDim2.new(0.05, 0, 0.3, 0)
KeyBox.PlaceholderText = "Nhập key vào đây..."
KeyBox.Text = ""
KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
KeyBox.Parent = MainFrame

-- Nút lấy key
local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Name = "GetKeyBtn"
GetKeyBtn.Size = UDim2.new(0.42, 0, 0, 35)
GetKeyBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
GetKeyBtn.Text = "LẤY KEY"
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextSize = 14
GetKeyBtn.Parent = MainFrame

-- Nút xác nhận
local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Name = "SubmitBtn"
SubmitBtn.Size = UDim2.new(0.42, 0, 0, 35)
SubmitBtn.Position = UDim2.new(0.53, 0, 0.6, 0)
SubmitBtn.Text = "XÁC NHẬN"
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 14
SubmitBtn.Parent = MainFrame

-- Checkbox lưu key
local SaveKeyBox = Instance.new("TextButton")
SaveKeyBox.Name = "SaveKeyBox"
SaveKeyBox.Size = UDim2.new(0, 20, 0, 20)
SaveKeyBox.Position = UDim2.new(0.05, 0, 0.8, 0)
SaveKeyBox.Text = ""
SaveKeyBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SaveKeyBox.Parent = MainFrame

local CheckMark = Instance.new("TextLabel")
CheckMark.Name = "CheckMark"
CheckMark.Size = UDim2.new(1, 0, 1, 0)
CheckMark.Text = "✓"
CheckMark.TextColor3 = Color3.fromRGB(0, 255, 0)
CheckMark.TextSize = 18
CheckMark.BackgroundTransparency = 1
CheckMark.Visible = false
CheckMark.Parent = SaveKeyBox

local SaveLabel = Instance.new("TextLabel")
SaveLabel.Name = "SaveLabel"
SaveLabel.Size = UDim2.new(0, 200, 0, 20)
SaveLabel.Position = UDim2.new(0.15, 0, 0.8, 0)
SaveLabel.Text = "Lưu key cho lần sau"
SaveLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SaveLabel.TextXAlignment = Enum.TextXAlignment.Left
SaveLabel.BackgroundTransparency = 1
SaveLabel.Font = Enum.Font.Gotham
SaveLabel.TextSize = 14
SaveLabel.Parent = MainFrame

-- Hàm thông báo
local function Notify(msg)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "HỆ THỐNG KEY",
        Text = msg,
        Duration = 5
    })
end

-- Sự kiện nút lấy key
GetKeyBtn.MouseButton1Click:Connect(function()
    setclipboard(url)
    Notify("Đã copy link lấy key: "..url)
end)

-- Sự kiện checkbox
local RememberKey = false
SaveKeyBox.MouseButton1Click:Connect(function()
    RememberKey = not RememberKey
    CheckMark.Visible = RememberKey
    Notify(RememberKey and "Đã bật lưu key" or "Đã tắt lưu key")
end)

-- Sự kiện nút xác nhận
SubmitBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == key then
        Notify("KEY CHÍNH XÁC! Đang khởi chạy...")
        ScreenGui:Destroy()
        loadstring(game:HttpGet(scriptUrl))()
    else
        Notify("KEY SAI! Vui lòng thử lại")
        KeyBox.Text = ""
        KeyBox:CaptureFocus()
    end
end)

-- Tự động focus vào ô nhập key
game:GetService("RunService").RenderStepped:Connect(function()
    if not KeyBox:IsFocused() and KeyBox.Text == "" then
        KeyBox:CaptureFocus()
    end
end)

Notify("Hệ thống key đã sẵn sàng!")
print("Hệ thống key đã khởi động thành công")
