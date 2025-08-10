-- AutoTrashKill (Rayfield-style flat Lua)
-- Features:
--  - Dropdown chọn target
--  - Tìm tất cả Trash Can (theo tên chứa keywords)
--  - Mỗi lần "về trash" chọn random trash can
--  - Phase: 1s ở sau trash -> 1s OUT phase (teleport sau lưng target mỗi 0.3s) -> lặp
--  - GUI có minimize / maximize, draggable
-- WARNING: Một số game chặn việc thay đổi CFrame hoặc anti-cheat. Dùng tự chịu.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer

-- ======= Cấu hình =======
local BEHIND_STUDS = 5               -- sau lưng target 5 studs
local TRASH_OFFSET_BACK = 2          -- sau trash chút xíu
local TELEPORT_OUT_INTERVAL = 0.3    -- teleport out mỗi 0.3s trong OUT phase
local OUT_PHASE_DURATION = 1.0       -- thời lượng OUT phase (1s)
local TRASH_PHASE_DURATION = 1.0     -- thời lượng ở sau trash (1s)
local GUI_NAME = "AutoTrashKill_RayfieldLike"
-- =========================

-- Xóa GUI cũ nếu có
if localPlayer:FindFirstChildOfClass("PlayerGui") then
    local old = localPlayer.PlayerGui:FindFirstChild(GUI_NAME)
    if old then old:Destroy() end
end

-- Utility: get HRP
local function getHRP(p)
    if not p then return nil end
    local ch = p.Character
    if not ch then return nil end
    return ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("Torso") or ch:FindFirstChild("UpperTorso")
end

-- Utility: find all trash cans in workspace (returns list of BaseParts)
local function findAllTrashCans()
    local keywords = {"trash", "trashcan", "trash can", "garbage", "bin"}
    local results = {}
    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("UnionOperation") or obj:IsA("MeshPart") or obj:IsA("Part") or obj:IsA("Model") then
            local name = tostring(obj.Name or "")
            local lname = string.lower(name)
            for _,k in ipairs(keywords) do
                if string.find(lname, k, 1, true) then
                    -- if model, get primary part
                    if obj:IsA("Model") then
                        local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                        if primary then
                            table.insert(results, primary)
                        end
                    else
                        table.insert(results, obj)
                    end
                    break
                end
            end
        end
    end
    return results
end

-- Helper: safe teleport local player to cframe
local function tpToCFrame(cf)
    local hrp = getHRP(localPlayer)
    if not hrp then return false end
    pcall(function() hrp.CFrame = cf end)
    return true
end

-- Helper: cframe lookAt
local function cframeLookAt(fromPos, targetPos)
    return CFrame.new(fromPos, targetPos)
end

-- ========= BUILD GUI (Rayfield-style look but flat) =========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = GUI_NAME
screenGui.ResetOnSpawn = false
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- small toggle (minimized)
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

-- main frame
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0,380,0,260)
main.Position = UDim2.new(0,80,0,80)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.BorderSizePixel = 0
main.Parent = screenGui
main.Active = true

-- header
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,36)
header.BackgroundColor3 = Color3.fromRGB(35,35,35)
header.BorderSizePixel = 0

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-80,1,0)
title.Position = UDim2.new(0,8,0,0)
title.BackgroundTransparency = 1
title.Text = "AutoTrashKill"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(220,220,220)
title.TextXAlignment = Enum.TextXAlignment.Left

local minBtn = Instance.new("TextButton", header)
minBtn.Size = UDim2.new(0,64,1,0)
minBtn.Position = UDim2.new(1,-64,0,0)
minBtn.BackgroundColor3 = Color3.fromRGB(28,28,28)
minBtn.BorderSizePixel = 0
minBtn.Text = "—"
minBtn.Font = Enum.Font.SourceSansBold
minBtn.TextSize = 20
minBtn.TextColor3 = Color3.fromRGB(255,255,255)

-- left column: dropdown player list
local left = Instance.new("Frame", main)
left.Size = UDim2.new(0,170,0,200)
left.Position = UDim2.new(0,8,0,44)
left.BackgroundColor3 = Color3.fromRGB(15,15,15)
left.BorderSizePixel = 0

local playersLabel = Instance.new("TextLabel", left)
playersLabel.Size = UDim2.new(1,-12,0,20)
playersLabel.Position = UDim2.new(0,6,0,6)
playersLabel.BackgroundTransparency = 1
playersLabel.Text = "Target"
playersLabel.Font = Enum.Font.SourceSansBold
playersLabel.TextSize = 14
playersLabel.TextColor3 = Color3.fromRGB(200,200,200)
playersLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Dropdown (custom)
local dropdownBtn = Instance.new("TextButton", left)
dropdownBtn.Size = UDim2.new(1,-12,0,32)
dropdownBtn.Position = UDim2.new(0,6,0,30)
dropdownBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
dropdownBtn.BorderSizePixel = 0
dropdownBtn.Text = "Chọn target..."
dropdownBtn.Font = Enum.Font.SourceSans
dropdownBtn.TextSize = 14
dropdownBtn.TextColor3 = Color3.fromRGB(230,230,230)

local dropdownFrame = Instance.new("Frame", left)
dropdownFrame.Size = UDim2.new(1,-12,0,110)
dropdownFrame.Position = UDim2.new(0,6,0,66)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(18,18,18)
dropdownFrame.BorderSizePixel = 0
dropdownFrame.Visible = false

local dropdownLayout = Instance.new("UIListLayout", dropdownFrame)
dropdownLayout.Padding = UDim.new(0,4)

local refreshBtn = Instance.new("TextButton", left)
refreshBtn.Size = UDim2.new(0,64,0,22)
refreshBtn.Position = UDim2.new(1,-70,0,4)
refreshBtn.Text = "Refresh"
refreshBtn.Font = Enum.Font.SourceSans
refreshBtn.TextSize = 12

-- right column: controls
local right = Instance.new("Frame", main)
right.Size = UDim2.new(0,190,0,200)
right.Position = UDim2.new(0,190,0,44)
right.BackgroundColor3 = Color3.fromRGB(15,15,15)
right.BorderSizePixel = 0

local toggleBtn = Instance.new("TextButton", right)
toggleBtn.Size = UDim2.new(0,140,0,36)
toggleBtn.Position = UDim2.new(0,6,0,6)
toggleBtn.Text = "AutoKill: OFF"
toggleBtn.Font = Enum.Font.SourceSans
toggleBtn.TextSize = 14
toggleBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
toggleBtn.BorderSizePixel = 0

local studsLabel = Instance.new("TextLabel", right)
studsLabel.Size = UDim2.new(1,-12,0,18)
studsLabel.Position = UDim2.new(0,6,0,52)
studsLabel.BackgroundTransparency = 1
studsLabel.Text = "Behind studs: "..tostring(BEHIND_STUDS)
studsLabel.Font = Enum.Font.SourceSans
studsLabel.TextSize = 14
studsLabel.TextColor3 = Color3.fromRGB(200,200,200)
studsLabel.TextXAlignment = Enum.TextXAlignment.Left

local decBtn = Instance.new("TextButton", right)
decBtn.Size = UDim2.new(0,28,0,20)
decBtn.Position = UDim2.new(1,-70,0,50)
decBtn.Text = "-"
decBtn.Font = Enum.Font.SourceSansBold
decBtn.TextSize = 14
decBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)

local incBtn = Instance.new("TextButton", right)
incBtn.Size = UDim2.new(0,28,0,20)
incBtn.Position = UDim2.new(1,-36,0,50)
incBtn.Text = "+"
incBtn.Font = Enum.Font.SourceSansBold
incBtn.TextSize = 14
incBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)

local statusLabel = Instance.new("TextLabel", right)
statusLabel.Size = UDim2.new(1,-12,0,40)
statusLabel.Position = UDim2.new(0,6,0,84)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Idle"
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 13
statusLabel.TextColor3 = Color3.fromRGB(200,200,200)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

local note = Instance.new("TextLabel", right)
note.Size = UDim2.new(1,-12,0,40)
note.Position = UDim2.new(0,6,0,130)
note.BackgroundTransparency = 1
note.Text = "Each OUT phase teleports every "..tostring(TELEPORT_OUT_INTERVAL).."s for "..tostring(OUT_PHASE_DURATION).."s."
note.Font = Enum.Font.SourceSans
note.TextSize = 12
note.TextColor3 = Color3.fromRGB(150,150,150)
note.TextXAlignment = Enum.TextXAlignment.Left

-- draggable helper
local function makeDraggable(gui)
    local dragging = false
    local dragStart
    local startPos
    local dragInput

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

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(main)
makeDraggable(smallBtn)

-- ========= Dropdown logic =========
local dropdownOpen = false
local selectedTarget = nil
local playerButtons = {}

local function clearDropdown()
    for _,v in ipairs(dropdownFrame:GetChildren()) do
        if v ~= dropdownLayout then v:Destroy() end
    end
    playerButtons = {}
end

local function updateDropdown()
    clearDropdown()
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer then
            local btn = Instance.new("TextButton", dropdownFrame)
            btn.Size = UDim2.new(1,-8,0,28)
            btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
            btn.BorderSizePixel = 0
            btn.Text = p.Name
            btn.Font = Enum.Font.SourceSans
            btn.TextSize = 14
            btn.TextColor3 = Color3.fromRGB(230,230,230)
            btn.MouseButton1Click:Connect(function()
                selectedTarget = p
                dropdownBtn.Text = "Target: "..p.Name
                dropdownFrame.Visible = false
                dropdownOpen = false
            end)
            table.insert(playerButtons, btn)
        end
    end
end

dropdownBtn.MouseButton1Click:Connect(function()
    dropdownOpen = not dropdownOpen
    dropdownFrame.Visible = dropdownOpen
    if dropdownOpen then
        updateDropdown()
    end
end)

refreshBtn.MouseButton1Click:Connect(function()
    updateDropdown()
end)

-- auto update on join/leave
Players.PlayerAdded:Connect(function()
    updateDropdown()
end)
Players.PlayerRemoving:Connect(function()
    updateDropdown()
    if selectedTarget and not Players:FindFirstChild(selectedTarget.Name) then
        selectedTarget = nil
        dropdownBtn.Text = "Chọn target..."
    end
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

-- minimize / maximize
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

-- toggle running
local isRunning = false
toggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        toggleBtn.Text = "AutoKill: ON"
        statusLabel.Text = "Status: Running..."
    else
        toggleBtn.Text = "AutoKill: OFF"
        statusLabel.Text = "Status: Idle"
    end
end)

-- header drag via header frame
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local start = input.Position
        local sPos = main.Position
        local conn
        conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                conn:Disconnect()
            end
        end)
        -- drag loop
        local dragging = true
        local moveConn
        moveConn = UserInputService.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                local delta = i.Position - start
                main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
            end
        end)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                moveConn:Disconnect()
            end
        end)
    end
end)

-- ========= Main Auto Loop =========
math.randomseed(tick())
spawn(function()
    while true do
        if isRunning then
            -- find all trash cans
            local trashList = findAllTrashCans()
            if #trashList == 0 then
                statusLabel.Text = "Status: Không tìm thấy trash can"
                wait(1)
            else
                if not selectedTarget or not selectedTarget.Parent then
                    statusLabel.Text = "Status: Chưa chọn target hợp lệ"
                    wait(0.5)
                else
                    local targetHRP = getHRP(selectedTarget)
                    if not targetHRP then
                        statusLabel.Text = "Status: Target chưa spawn"
                        wait(0.5)
                    else
                        -- chọn random trash can
                        local trashPart = trashList[math.random(1,#trashList)]
                        local trashPos = trashPart.Position
                        local trashBack = trashPart.CFrame.Position - (trashPart.CFrame.LookVector * TRASH_OFFSET_BACK)
                        local trashCf = cframeLookAt(trashBack, trashPos)

                        -- Phase 1: teleport đến sau trash và hướng mặt -> đứng TRASH_PHASE_DURATION
                        tpToCFrame(trashCf)
                        statusLabel.Text = "Phase: At trash ("..tostring(TRASH_PHASE_DURATION).."s)"
                        local t0 = tick()
                        while tick() - t0 < TRASH_PHASE_DURATION and isRunning do
                            pcall(function()
                                local hrp = getHRP(localPlayer)
                                if hrp then hrp.CFrame = cframeLookAt(trashBack, trashPos) end
                            end)
                            RunService.Heartbeat:Wait()
                        end

                        if not isRunning then break end

                        -- Phase 2: OUT phase -> trong OUT_PHASE_DURATION, mỗi TELEPORT_OUT_INTERVAL teleport sau lưng target và hướng mặt
                        statusLabel.Text = "Phase: OUT -> attacking "..selectedTarget.Name
                        local outStart = tick()
                        while tick() - outStart < OUT_PHASE_DURATION and isRunning do
                            targetHRP = getHRP(selectedTarget)
                            if not targetHRP then break end
                            local tPos = targetHRP.Position
                            local behindPos = tPos - (targetHRP.CFrame.LookVector * BEHIND_STUDS)
                            behindPos = Vector3.new(behindPos.X, tPos.Y, behindPos.Z)
                            local cf = cframeLookAt(behindPos, tPos)
                            tpToCFrame(cf)
                            -- maintain facing for TELEPORT_OUT_INTERVAL
                            local waited = 0
                            while waited < TELEPORT_OUT_INTERVAL and isRunning do
                                pcall(function()
                                    local hrp = getHRP(localPlayer)
                                    local targetNow = getHRP(selectedTarget)
                                    if hrp and targetNow then hrp.CFrame = cframeLookAt(hrp.Position, targetNow.Position) end
                                end)
                                local dt = RunService.Heartbeat:Wait()
                                waited = waited + dt
                            end
                        end

                        if not isRunning then break end

                        -- Phase 3: teleport lại (vòng lặp tiếp tục) -> chọn trash can khác ngẫu nhiên ở đầu vòng
                        -- nhỏ delay để tránh loop quá nhanh
                        wait(0.03)
                    end
                end
            end
        else
            RunService.Heartbeat:Wait()
        end
        RunService.Heartbeat:Wait()
    end
end)

-- finale
updateDropdown()
main.Parent = screenGui
main.Visible = true
smallBtn.Visible = false

print("[AutoTrashKill] Loaded (Rayfield-like GUI).")
