-- Script: Ghi lại hành động bằng CFrame + nút thu nhỏ / phóng to
-- Dán nguyên vào executor (ví dụ Synapse / Krnl / etc.)
-- Lưu ý: một số game chặn thao tác thay đổi CFrame, dùng trong môi trường executor.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart") -- dùng HumanoidRootPart

-- Cấu hình
local SAMPLE_INTERVAL = 1/120 -- giây giữa 2 sample
local LERP_STEPS = 20 -- số bước nội suy giữa 2 frame khi phát lại (cao hơn mượt hơn)
local GUI_NAME = "CFrameRecorderGUI"

-- Xóa GUI cũ nếu có
if player:FindFirstChildOfClass("PlayerGui") then
    local existing = player.PlayerGui:FindFirstChild(GUI_NAME)
    if existing then existing:Destroy() end
end

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = GUI_NAME
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Small toggle button (nút thu nhỏ) - ban đầu ẩn
local smallBtn = Instance.new("TextButton")
smallBtn.Name = "SmallToggle"
smallBtn.Size = UDim2.fromOffset(48,48)
smallBtn.Position = UDim2.new(0,10,0,10) -- góc trái trên, có thể kéo
smallBtn.Text = "💀"
smallBtn.TextScaled = true
smallBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
smallBtn.BorderSizePixel = 0
smallBtn.Visible = false
smallBtn.Parent = screenGui

-- Main GUI frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0,360,0,220)
mainFrame.Position = UDim2.new(0,80,0,80)
mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Header (title + minimize button)
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1,0,0,36)
header.BackgroundColor3 = Color3.fromRGB(35,35,35)
header.BorderSizePixel = 0
header.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-80,1,0)
title.Position = UDim2.new(0,8,0,0)
title.BackgroundTransparency = 1
title.Text = "CFrame Recorder"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(220,220,220)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "Minimize"
minimizeBtn.Size = UDim2.new(0,64,1,0)
minimizeBtn.Position = UDim2.new(1,-64,0,0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(28,28,28)
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Text = "—"
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 20
minimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
minimizeBtn.Parent = header

-- Content area
local content = Instance.new("Frame")
content.Name = "Content"
content.Position = UDim2.new(0,0,0,36)
content.Size = UDim2.new(1,0,1,-36)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- Buttons
local function makeButton(name, text, posY)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Size = UDim2.new(0,100,0,36)
    b.Position = UDim2.new(0,12,0,posY)
    b.BackgroundColor3 = Color3.fromRGB(45,45,45)
    b.BorderSizePixel = 0
    b.Text = text
    b.Font = Enum.Font.SourceSans
    b.TextSize = 16
    b.TextColor3 = Color3.fromRGB(230,230,230)
    b.Parent = content
    return b
end

local recordBtn = makeButton("Record", "Record", 6)
local stopBtn = makeButton("Stop", "Stop", 46)
local playBtn = makeButton("Play", "Play", 86)
local clearBtn = makeButton("Clear", "Clear", 126)
local saveBtn = makeButton("SavePoint", "Save Point", 166)

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0,220,0,36)
statusLabel.Position = UDim2.new(0,128,0,6)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Idle"
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 16
statusLabel.TextColor3 = Color3.fromRGB(200,200,200)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = content

-- Saved points list
local savedPoints = Instance.new("Frame")
savedPoints.Name = "SavedPoints"
savedPoints.Position = UDim2.new(0,128,0,48)
savedPoints.Size = UDim2.new(0,220,0,150)
savedPoints.BackgroundColor3 = Color3.fromRGB(18,18,18)
savedPoints.BorderSizePixel = 0
savedPoints.Parent = content

local uiList = Instance.new("UIListLayout")
uiList.Parent = savedPoints
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0,6)

-- Draggable behaviour for mainFrame and smallBtn
local function makeDraggable(guiElement)
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        guiElement.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                        startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    guiElement.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiElement.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    guiElement.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

makeDraggable(mainFrame)
makeDraggable(smallBtn)

-- Playback / Recording data
local recordings = {} -- list of CFrames
local isRecording = false
local recordConn

-- Record function
local function startRecording()
    if isRecording then return end
    isRecording = true
    recordings = {}
    statusLabel.Text = "Status: Recording..."
    recordBtn.BackgroundColor3 = Color3.fromRGB(80,30,30)
    recordConn = RunService.Heartbeat:Connect(function(dt)
        -- sample theo interval
        -- we'll use tick() to control interval
    end)

    -- use a timer loop separate for better control
    spawn(function()
        local last = tick()
        while isRecording do
            local now = tick()
            if now - last >= SAMPLE_INTERVAL then
                last = now
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    table.insert(recordings, char.HumanoidRootPart.CFrame)
                end
            end
            RunService.Stepped:Wait()
        end
    end)
end

local function stopRecording()
    if not isRecording then return end
    isRecording = false
    if recordConn then recordConn:Disconnect() recordConn = nil end
    statusLabel.Text = "Status: Idle (Recorded ".. tostring(#recordings) .." frames)"
    recordBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
end

-- Playback function (nội suy)
local function playRecording()
    if isRecording then
        statusLabel.Text = "Status: Stop recording trước khi phát lại"
        return
    end
    if #recordings == 0 then
        statusLabel.Text = "Status: Không có bản ghi"
        return
    end

    statusLabel.Text = "Status: Playing..."
    playBtn.BackgroundColor3 = Color3.fromRGB(30,80,30)

    -- đảm bảo character hiện tại
    local char = player.Character or player.CharacterAdded:Wait()
    local hrpPlay = char:FindFirstChild("HumanoidRootPart")
    if not hrpPlay then
        statusLabel.Text = "Status: Không tìm thấy HumanoidRootPart"
        playBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
        return
    end

    -- disable humanoid physics? chúng ta vẫn sẽ đặt CFrame trực tiếp
    -- Phát từng đoạn
    for i = 1, #recordings-1 do
        local a = recordings[i]
        local b = recordings[i+1]
        for step = 1, LERP_STEPS do
            local alpha = step / LERP_STEPS
            local newCFrame = a:Lerp(b, alpha)
            -- đặt CFrame trực tiếp
            if hrpPlay and hrpPlay.Parent then
                pcall(function() hrpPlay.CFrame = newCFrame end)
            end
            RunService.Heartbeat:Wait()
        end
    end

    -- đặt về cuối cùng
    pcall(function() if hrpPlay then hrpPlay.CFrame = recordings[#recordings] end end)

    statusLabel.Text = "Status: Done playing"
    playBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
end

-- Save point (luu vị trí hiện tại)
local function createSavedPoint(cframe)
    local idx = #savedPoints:GetChildren() + 1
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-12,0,28)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(230,230,230)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.Text = "Point ".. tostring(idx)
    btn.Parent = savedPoints

    btn.MouseButton1Click:Connect(function()
        -- teleport đến điểm đã lưu
        local char = player.Character
        local hrpPlay = char and char:FindFirstChild("HumanoidRootPart")
        if hrpPlay then
            pcall(function() hrpPlay.CFrame = cframe end)
        end
    end)
end

-- Button events
recordBtn.MouseButton1Click:Connect(function()
    startRecording()
end)

stopBtn.MouseButton1Click:Connect(function()
    stopRecording()
end)

playBtn.MouseButton1Click:Connect(function()
    spawn(function() playRecording() end)
end)

clearBtn.MouseButton1Click:Connect(function()
    recordings = {}
    -- xóa saved recordings nếu muốn
    statusLabel.Text = "Status: Cleared"
end)

saveBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local cf = char.HumanoidRootPart.CFrame
        createSavedPoint(cf)
        statusLabel.Text = "Saved point ".. tostring(#savedPoints:GetChildren())
    else
        statusLabel.Text = "Không tìm thấy HumanoidRootPart"
    end
end)

-- Minimize / Small button behavior
local minimized = false

local function minimize()
    minimized = true
    mainFrame.Visible = false
    smallBtn.Visible = true
end

local function maximize()
    minimized = false
    mainFrame.Visible = true
    smallBtn.Visible = false
end

minimizeBtn.MouseButton1Click:Connect(function()
    minimize()
end)

smallBtn.MouseButton1Click:Connect(function()
    maximize()
end)

-- Make header draggable only (so user có thể kéo GUI)
header.Active = true
header.Draggable = false -- we'll use custom draggable for mainFrame already

-- Save/Load GUI position when moved? (simple: keep as-is during session)

-- Optional: hotkey M để thu nhỏ / phóng to
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.M then
        if minimized then maximize() else minimize() end
    end
end)

-- Final touch: initial visible
mainFrame.Visible = true
smallBtn.Visible = false

-- Thông báo nhỏ ở console
print("[CFrame Recorder] Loaded. Use the GUI to record and play back.")
