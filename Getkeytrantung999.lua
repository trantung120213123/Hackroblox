local key = "hhx44xhh"
local url = "https://yeumoney.com/WTsRyATIY"
local scriptUrl = "https://raw.githubusercontent.com/trantung120213123/Hackroblox/main/Deadrailbytrantung999.lua"
local keyFile = "Trantung999Key.txt"

local Notification = function(text)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Key System",
            Text = text,
            Duration = 5
        })
    end)
end

-- Nếu đã có file key, tự động check
if pcall(function() return readfile and isfile and isfile(keyFile) end) then
    local savedKey = readfile(keyFile)
    if savedKey == key then
        Notification("Đã tự động xác minh key!")
        loadstring(game:HttpGet(scriptUrl))()
        return
    end
end

-- Giao diện nhập key
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local UICorner = Instance.new("UICorner", Frame)
local TextBox = Instance.new("TextBox", Frame)
local GetKeyButton = Instance.new("TextButton", Frame)
local CheckButton = Instance.new("TextButton", Frame)

ScreenGui.Name = "KeySystem"
Frame.Size = UDim2.new(0, 280, 0, 140)
Frame.Position = UDim2.new(0.5, -140, 0.5, -70)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

TextBox.Size = UDim2.new(0.9, 0, 0, 30)
TextBox.Position = UDim2.new(0.05, 0, 0.2, 0)
TextBox.PlaceholderText = "Enter Key"
TextBox.Text = ""
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextBox.TextColor3 = Color3.new(1, 1, 1)

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

-- Button: Copy link
GetKeyButton.MouseButton1Click:Connect(function()
    setclipboard(url)
    Notification("Đã copy link lấy key!")
end)

-- Button: Check Key
CheckButton.MouseButton1Click:Connect(function()
    if TextBox.Text == key then
        Notification("Đúng key!")

        -- Lưu key nếu executor hỗ trợ
        pcall(function()
            if writefile then
                writefile(keyFile, key)
            end
        end)

        ScreenGui:Destroy()
        loadstring(game:HttpGet(scriptUrl))()
    else
        Notification("Sai key, thử lại!")
    end
end)
