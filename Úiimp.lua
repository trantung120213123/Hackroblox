-- Auto Kill Thùng Rác (Trash Can) <-> Behind Target 5 studs
-- Flat Lua, dán vào executor (Synapse/krnl/other)
-- Chú ý: một số game chặn thay đổi CFrame -> có thể không chạy.
-- Tác giả: tự động cho mày, chỉnh tiếp nếu cần.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer

-- Cấu hình mặc định
local BEHIND_STUDS = 5          -- khoảng cách sau lưng target (mày set: 5)
local TRASH_OFFSET_BACK = 2     -- offset sau trash can (ứng với "sau trash can 1 xíu")
local TELEPORT_OUT_INTERVAL = 0.3 -- teleport ra sau target mỗi 0.3s (theo yêu cầu)
local OUT_PHASE_DURATION = 1.0  -- thời lượng phase "ra sau target" (1s)
local TRASH_PHASE_DURATION = 1.0 -- thời lượng phase "ở sau trash can" (1s)

-- GUI tên
local GUI_NAME = "AutoTrashKillGUI"

-- Remove GUI cũ nếu có
if localPlayer:FindFirstChildOfClass("PlayerGui") then
    local old = localPlayer.PlayerGui:FindFirstChild(GUI_NAME)
    if old then old:Destroy() end
end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = GUI_NAME
screenGui.ResetOnSpawn = false
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- Small toggle (thu nhỏ)
local smallBtn = Instance.new("TextButton")
smallBtn.Name = "SmallToggle"
smallBtn.Size = UDim2.fromOffset(48,48)
smallBtn.Position = UDim2.new(0,8,0,8)
smallBtn.Text = "💀"
smallBtn.TextScaled = true
smallBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
smallBtn.BorderSizePixel = 0
smallBtn.Visible = false
smallBtn.Parent = screenGui

-- Main Frame
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0,380,0,260)
main.Position = UDim2.new(0,80,0,80)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.BorderSizePixel = 0
main.Parent = screenGui

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,36)
header.Position = UDim2.new(0,0,0,0)
header.BackgroundColor3 = Color3.fromRGB(35,35,35)
header.BorderSizePixel = 0
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-80,1,0)
title.Position = UDim2.new(0,8,0,0)
title.BackgroundTransparency = 1
title.Text = "AutoTrashKill"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(220,220,220)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0,64,1,0)
minBtn.Position = UDim2.new(1,-64,0,0)
minBtn.BackgroundColor3 = Color3.fromRGB(28,28,28)
minBtn.BorderSizePixel = 0
minBtn.Text = "—"
minBtn.Font = Enum.Font.SourceSansBold
minBtn.TextSize = 20
minBtn.TextColor3 = Color3.fromRGB(255,255,255)
minBtn.Parent = header

-- Left: Player list + Refresh
local left = Instance.new("Frame")
left.Size = UDim2.new(0,170,0,220)
left.Position = UDim2.new(0,8,0,40)
left.BackgroundColor3 = Color3.fromRGB(15,15,15)
left.BorderSizePixel = 0
left.Parent = main

local playersLabel = Instance.new("TextLabel")
playersLabel.Size = UDim2.new(1, -12, 0, 20)
playersLabel.Position = UDim2.new(0,6,0,6)
playersLabel.BackgroundTransparency = 1
playersLabel.Text = "Players"
playersLabel.Font = Enum.Font.SourceSansBold
playersLabel.TextSize = 14
playersLabel.TextColor3 = Color3.fromRGB(200,200,200)
playersLabel.TextXAlignment = Enum.TextXAlignment.Left
playersLabel.Parent = left

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0,64,0,22)
refreshBtn.Position = UDim2.new(1,-70,0,3)
refreshBtn.Text = "Refresh"
refreshBtn.Font = Enum.Font.SourceSans
refreshBtn.TextSize = 12
refreshBtn.Parent = left

local playerListFrame = Instance.new("Frame")
playerListFrame.Size = UDim2.new(1,-12,0,170)
playerListFrame.Position = UDim2.new(0,6,0,32)
playerListFrame.BackgroundColor3 = Color3.fromRGB(18,18,18)
playerListFrame.BorderSizePixel = 0
playerListFrame.Parent = left

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0,4)
listLayout.Parent = playerListFrame

-- Right: Controls
local right = Instance.new("Frame")
right.Size = UDim2.new(0,190,0,220)
right.Position = UDim2.new(0,190,0,40)
right.BackgroundColor3 = Color3.fromRGB(15,15,15)
right.BorderSizePixel = 0
right.Parent = main

-- Selected target label
local selLabel = Instance.new("TextLabel")
selLabel.Size = UDim2.new(1,-12,0,24)
selLabel.Position = UDim2.new(0,6,0,6)
selLabel.BackgroundTransparency = 1
selLabel.Text = "Target: (none)"
selLabel.Font = Enum.Font.SourceSansBold
selLabel.TextSize = 14
selLabel.TextColor3 = Color3.fromRGB(220,220,220)
selLabel.TextXAlignment = Enum.TextXAlignment.Left
selLabel.Parent = right

-- Toggle AutoKill
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0,120,0,36)
toggleBtn.Position = UDim2.new(0,6,0,40)
toggleBtn.Text = "AutoKill: OFF"
toggleBtn.Font = Enum.Font.SourceSans
toggleBtn.TextSize = 14
toggleBtn.Parent = right

-- Settings: studs
local studsLabel = Instance.new("TextLabel")
studsLabel.Size = UDim2.new(1,-12,0,18)
studsLabel.Position = UDim2.new(0,6,0,86)
studsLabel.BackgroundTransparency = 1
studsLabel.Text = "Behind studs: "..tostring(BEHIND_STUDS)
studsLabel.Font = Enum.Font.SourceSans
studsLabel.TextSize = 14
studsLabel.TextColor3 = Color3.fromRGB(200,200,200)
studsLabel.TextXAlignment = Enum.TextXAlignment.Left
studsLabel.Parent = right

local incBtn = Instance.new("TextButton")
incBtn.Size = UDim2.new(0,28,0,20)
incBtn.Position = UDim2.new(1,-70,0,82)
incBtn.Text = "+"
incBtn.Font = Enum.Font.SourceSansBold
incBtn.TextSize = 14
incBtn.Parent = right

local decBtn = Instance.new("TextButton")
decBtn.Size = UDim2.new(0,28,0,20)
decBtn.Position = UDim2.new(1,-36,0,82)
decBtn.Text = "-"
decBtn.Font = Enum.Font.SourceSansBold
decBtn.TextSize = 14
decBtn.Parent = right

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,-12,0,36)
status.Position = UDim2.new(0,6,0,112)
status.BackgroundTransparency = 1
status.Text = "Status: Idle"
status.Font = Enum.Font.SourceSans
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(200,200,200)
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = right

-- Footer small note
local note = Instance.new("TextLabel")
note.Size = UDim2.new(1,-12,0,36)
note.Position = UDim2.new(0,6,0,156)
note.BackgroundTransparency = 1
note.Text = "Auto teleport every "..tostring(TELEPORT_OUT_INTERVAL).."s during OUT phase."
note.Font = Enum.Font.SourceSans
note.TextSize = 12
note.TextColor3 = Color3.fromRGB(160,160,160)
note.TextXAlignment = Enum.TextXAlignment.Left
note.Parent = right

-- Make main and small draggable
local UserInput = UserInputService
local function makeDraggable(gui)
    local dragging = false
    local dragStart
    local startPos

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInput.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(main)
makeDraggable(smallBtn)

-- State variables
local selectedTarget = nil
local isRunning = false

-- Utility: find trash can in workspace (search by name keywords)
local function findTrashCan()
    local keywords = {"Trash", "TrashCan", "Trash Can", "Garbage", "Bin"}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") or obj:IsA("UnionOperation") then
            local name = obj.Name or ""
            for _, k in ipairs(keywords) do
                if string.find(string.lower(name), string.lower(k)) then
                    -- If model, try to get primary part / primary bounding part
                    if obj:IsA("Model") then
                        local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                        if primary then
                            return primary
                        end
                    else
                        return obj
                    end
                end
            end
        end
    end
    return nil
end

-- UI: populate player list
local function clearPlayerList()
    for _, v in ipairs(playerListFrame:GetChildren()) do
        if v ~= listLayout then v:Destroy() end
    end
end

local function makePlayerButton(p)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(230,230,230)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.Text = p.Name
    btn.Parent = playerListFrame

    btn.MouseButton1Click:Connect(function()
        selectedTarget = p
        selLabel.Text = "Target: "..p.Name
    end)
end

local function populatePlayers()
    clearPlayerList()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer then
            makePlayerButton(p)
        end
    end
end

refreshBtn.MouseButton1Click:Connect(function()
    populatePlayers()
end)

-- inc/dec studs
incBtn.MouseButton1Click:Connect(function()
    BEHIND_STUDS = BEHIND_STUDS + 1
    studsLabel.Text = "Behind studs: "..tostring(BEHIND_STUDS)
end)
decBtn.MouseButton1Click:Connect(function()
    if BEHIND_STUDS > 1 then BEHIND_STUDS = BEHIND_STUDS - 1 end
    studsLabel.Text = "Behind studs: "..tostring(BEHIND_STUDS)
end)

-- Toggle minimize / maximize
local minimized = false
local function minimize()
    minimized = true
    main.Visible = false
    smallBtn.Visible = true
end
local function maximize()
    minimized = false
    main.Visible = true
    smallBtn.Visible = false
end

minBtn.MouseButton1Click:Connect(minimize)
smallBtn.MouseButton1Click:Connect(maximize)

-- Toggle AutoKill
toggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        toggleBtn.Text = "AutoKill: ON"
        status.Text = "Status: Running..."
    else
        toggleBtn.Text = "AutoKill: OFF"
        status.Text = "Status: Idle"
    end
end)

-- Helper: safe get HRP
local function getHRP(p)
    if not p then return nil end
    local ch = p.Character
    if not ch then return nil end
    local hrp = ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("Torso") or ch:FindFirstChild("UpperTorso")
    return hrp
end

-- Helper: teleport local player to a CFrame (safe pcall)
local function tpTo(cframe)
    local char = localPlayer.Character
    if not char then return end
    local hrp = getHRP(localPlayer)
    if not hrp then return end
    pcall(function()
        hrp.CFrame = cframe
    end)
end

-- Helper: face target from a position (returns CFrame that looks at targetPos)
local function cframeLookAt(fromPos, targetPos)
    return CFrame.new(fromPos, targetPos)
end

-- Main loop coroutine
spawn(function()
    while true do
        if isRunning then
            -- find trash can
            local trashPart = findTrashCan()
            if not trashPart then
                status.Text = "Status: Không tìm thấy Trash Can"
                wait(1)
                -- try again
            else
                local target = selectedTarget
                if not target or not target.Parent then
                    status.Text = "Status: Chưa chọn target hoặc target không hợp lệ"
                    wait(0.5)
                else
                    local targetHRP = getHRP(target)
                    if not targetHRP then
                        status.Text = "Status: Target không có HRP"
                        wait(0.5)
                    else
                        -- Phase 1: teleport đến sau Trash Can và hướng mặt vào trash (ở yên TRASH_PHASE_DURATION)
                        local trashPos = trashPart.Position
                        -- attempt to get "behind" relative to trash's lookVector (use trashPart.CFrame lookVector)
                        local trashBackPos = trashPart.CFrame.Position - (trashPart.CFrame.LookVector * TRASH_OFFSET_BACK)
                        local lookAtTrashCf = cframeLookAt(trashBackPos, trashPos)
                        tpTo(lookAtTrashCf)
                        status.Text = "Phase: At Trash ("..tostring(TRASH_PHASE_DURATION).."s)"
                        -- keep facing trash for duration
                        local t0 = tick()
                        while tick() - t0 < TRASH_PHASE_DURATION and isRunning do
                            -- continuously ensure facing trash (some games may push)
                            pcall(function()
                                local hrp = getHRP(localPlayer)
                                if hrp then hrp.CFrame = cframeLookAt(trashBackPos, trashPos) end
                            end)
                            RunService.Heartbeat:Wait()
                        end

                        if not isRunning then break end

                        -- Phase 2: OUT phase -> trong OUT_PHASE_DURATION, every TELEPORT_OUT_INTERVAL teleport behind target và hướng mặt vào họ
                        status.Text = "Phase: Attacking target "..target.Name
                        local outStart = tick()
                        while tick() - outStart < OUT_PHASE_DURATION and isRunning do
                            -- recompute target HRP (target may move)
                            targetHRP = getHRP(target)
                            if not targetHRP then break end
                            local targetPos = targetHRP.Position
                            -- compute behind position relative to target look vector
                            local behindPos = targetPos - (targetHRP.CFrame.LookVector * BEHIND_STUDS)
                            -- set a small Y offset to match HRP height
                            behindPos = Vector3.new(behindPos.X, targetPos.Y, behindPos.Z)
                            local cf = cframeLookAt(behindPos, targetPos)
                            tpTo(cf)
                            -- wait TELEPORT_OUT_INTERVAL while maintaining facing (split into small waits)
                            local waited = 0
                            while waited < TELEPORT_OUT_INTERVAL and isRunning do
                                -- keep facing target while waiting
                                pcall(function()
                                    local hrp = getHRP(localPlayer)
                                    if hrp and targetHRP and targetHRP.Parent then
                                        hrp.CFrame = cframeLookAt(hrp.Position, targetHRP.Position)
                                    end
                                end)
                                local dt = RunService.Heartbeat:Wait()
                                waited = waited + dt
                            end
                        end

                        if not isRunning then break end

                        -- Phase 3: teleport lại sau Trash Can immediately (loop continues)
                        -- teleport back quickly and continue loop (next iteration will wait in phase)
                        tpTo(cframeLookAt(trashBackPos, trashPos))
                        -- small wait to avoid super tight loop before next iteration
                        wait(0.05)
                    end
                end
            end
        else
            RunService.Heartbeat:Wait()
        end
        RunService.Heartbeat:Wait()
    end
end)

-- Initial populate
populatePlayers()

-- Keyboard M to minimize / maximize
UserInputService.InputBegan:Connect(function(input, g)
    if g then return end
    if input.KeyCode == Enum.KeyCode.M then
        if minimized then maximize() else minimize() end
    end
end)

-- Final visibility
main.Visible = true
smallBtn.Visible = false

print("[AutoTrashKill] Loaded.")
