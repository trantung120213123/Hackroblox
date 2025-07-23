-- Phiên bản RayField UI đã được cải tiến
local key = "trantung999shithub"
local url = "https://yeumoney.com/uVk6nM"
local scriptUrl = "https://raw.githubusercontent.com/trantung120213123/Hackroblox/main/Deadrailbytrantung999.lua"

-- Load thư viện RayField
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Tạo cửa sổ chính
local Window = Rayfield:CreateWindow({
    Name = "Hệ Thống Key Pro",
    LoadingTitle = "Đang tải hệ thống key...",
    LoadingSubtitle = "by trantung999",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "KeySystemConfig",
        FileName = "Settings"
    },
})

-- Tạo tab chính
local MainTab = Window:CreateTab("Key System", 4483362458) -- Icon ID

-- Ô nhập key
local KeyInput = MainTab:CreateInputGroup("Nhập Key Của Bạn", false, "Dán key vào đây...")
local TextBox = KeyInput.Input

-- Nút lấy key
MainTab:CreateButton({
    Name = "Lấy Key",
    Callback = function()
        setclipboard(url)
        Rayfield:Notify({
            Title = "Thông Báo",
            Content = "Đã copy link lấy key!",
            Duration = 6.5,
            Image = 4483362458,
        })
    end,
})

-- Nút kiểm tra key
MainTab:CreateButton({
    Name = "Kiểm Tra Key",
    Callback = function()
        if TextBox.Text == key then
            Rayfield:Notify({
                Title = "Thành Công",
                Content = "Key chính xác! Đang tải script...",
                Duration = 6.5,
                Image = 4483362458,
            })
            loadstring(game:HttpGet(scriptUrl))()
            Window:Destroy()
        else
            Rayfield:Notify({
                Title = "Lỗi",
                Content = "Key không đúng! Vui lòng thử lại.",
                Duration = 6.5,
                Image = 4483362458,
            })
        end
    end,
})

-- Tùy chọn lưu key
local SaveToggle = MainTab:CreateToggle({
    Name = "Nhớ key của tôi",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            writefile("KeySystemConfig/key.txt", TextBox.Text)
        else
            delfile("KeySystemConfig/key.txt")
        end
    end,
})

-- Tự động điền key nếu đã lưu
if isfile("KeySystemConfig/key.txt") then
    TextBox.Text = readfile("KeySystemConfig/key.txt")
    SaveToggle:Set(true)
end
