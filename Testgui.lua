local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Tạo GUI có thể di chuyển
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiHugGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.7, 0)
frame.BackgroundTransparency = 0.7
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true  -- Cho phép frame nhận input
frame.Draggable = true  -- Cho phép kéo frame
frame.Selectable = true
frame.Parent = screenGui

-- Thêm title bar để dễ kéo hơn
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0.3, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local title = Instance.new("TextLabel")
title.Text = "Anti-Hug Tool (Kéo để di chuyển)"
title.Size = UDim2.new(1, 0, 1, 0)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.Parent = titleBar

local escapeBtn = Instance.new("TextButton")
escapeBtn.Text = "THOÁT ÔM (E)"
escapeBtn.Size = UDim2.new(0.8, 0, 0.5, 0)
escapeBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
escapeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
escapeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
escapeBtn.Font = Enum.Font.Gotham
escapeBtn.Parent = frame

-- Chức năng thoát ôm
local function escapeHug()
    local remote = ReplicatedStorage:FindFirstChild("FreeHug") or ReplicatedStorage:FindFirstChild("EscapeHug")
    if remote then
        remote:FireServer()
        print("Đã kích hoạt thoát hug!")
    else
        warn("Không tìm thấy remote event để thoát hug!")
    end
end

-- Gán phím tắt và nút bấm
escapeBtn.MouseButton1Click:Connect(escapeHug)

UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.E then
        escapeHug()
    end
end)

-- Tự động thoát khi bị ôm
local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    
    humanoid.StateChanged:Connect(function(oldState, newState)
        if newState == Enum.HumanoidStateType.Freefall then
            task.wait(0.5)
            escapeHug()
        end
    end)
end

player.CharacterAdded:Connect(setupCharacter)
if player.Character then
    setupCharacter(player.Character)
end
