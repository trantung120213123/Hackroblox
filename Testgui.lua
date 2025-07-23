local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")

-- Tạo GUI
local gui = Instance.new("ScreenGui")
gui.Name = "HugEscapeGUI"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0.5, -110, 0.7, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Text = "THOÁT ÔM (Nhấn E)"
title.Size = UDim2.new(1, 0, 0.3, 0)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = frame

local status = Instance.new("TextLabel")
status.Text = "Trạng thái: Đang chờ"
status.Position = UDim2.new(0, 0, 0.3, 0)
status.Size = UDim2.new(1, 0, 0.3, 0)
status.TextColor3 = Color3.new(1, 1, 1)
status.Parent = frame

local btn = Instance.new("TextButton")
btn.Text = "THỬ THOÁT NGAY"
btn.Position = UDim2.new(0.1, 0, 0.6, 0)
btn.Size = UDim2.new(0.8, 0, 0.3, 0)
btn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
btn.Parent = frame

-- Tìm RemoteEvent chính xác
local function findRemote()
    for _,v in pairs(RS:GetDescendants()) do
        if v:IsA("RemoteEvent") and (v.Name:lower():find("hug") or v.Name:lower():find("escape")) then
            return v
        end
    end
    return nil
end

-- Chức năng chính
local function tryEscape()
    local remote = findRemote()
    
    if remote then
        status.Text = "Đang thử thoát..."
        remote:FireServer()
        task.wait(1)
        status.Text = remote.Name.." đã kích hoạt!"
        task.wait(2)
        status.Text = "Trạng thái: Đang chờ"
    else
        status.Text = "Không tìm thấy lệnh thoát!"
        task.wait(2)
        status.Text = "Trạng thái: Lỗi"
    end
end

-- Kết nối sự kiện
btn.MouseButton1Click:Connect(tryEscape)
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        tryEscape()
    end
end)

-- Tự động phát hiện
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Freefall then
            status.Text = "Phát hiện bị ôm!"
            task.wait(0.5)
            tryEscape()
        end
    end)
end)
