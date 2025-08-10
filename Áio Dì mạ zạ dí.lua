-- AutoTrashCanKill (GUI tự tạo, textbox chọn player, TELEPORT_OUT_INTERVAL = 0.1s)
-- Dán vào executor. WARNING: một số game chặn CFrame/anti-cheat -> tự chịu.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ===== config (chỉnh nếu cần) =====
local BEHIND_STUDS = 5
local TRASH_BEHIND_STUDS = 5
local TELEPORT_OUT_INTERVAL = 0.1   -- <- đã đổi theo yêu cầu
local OUT_PHASE_DURATION = 1.0
local TRASH_PHASE_DURATION = 1.0
-- ===================================

-- Remove old gui
local EXIST = player:FindFirstChildOfClass("PlayerGui") and player.PlayerGui:FindFirstChild("AutoTrashKillGUI")
if EXIST then EXIST:Destroy() end

-- ===== GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoTrashKillGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 340, 0, 200)
main.Position = UDim2.new(0, 80, 0, 80)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.BorderSizePixel = 0
main.Parent = screenGui
main.Active = true

local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,36)
header.BackgroundColor3 = Color3.fromRGB(35,35,35)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-100,1,0)
title.Position = UDim2.new(0,8,0,0)
title.BackgroundTransparency = 1
title.Text = "AutoTrashKill"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(220,220,220)
title.TextXAlignment = Enum.TextXAlignment.Left

local minBtn = Instance.new("TextButton", header)
minBtn.Size = UDim2.new(0,80,1,0)
minBtn.Position = UDim2.new(1,-80,0,0)
minBtn.BackgroundColor3 = Color3.fromRGB(28,28,28)
minBtn.Text = "—"
minBtn.Font = Enum.Font.SourceSansBold
minBtn.TextSize = 20
minBtn.TextColor3 = Color3.fromRGB(255,255,255)

local content = Instance.new("Frame", main)
content.Position = UDim2.new(0,0,0,36)
content.Size = UDim2.new(1,0,1,-36)
content.BackgroundTransparency = 1

-- Target textbox + set button
local lbl = Instance.new("TextLabel", content)
lbl.Size = UDim2.new(0,1,0,20)
lbl.Position = UDim2.new(0,8,0,6)
lbl.BackgroundTransparency = 1
lbl.Text = "Target name:"
lbl.Font = Enum.Font.SourceSans
lbl.TextSize = 14
lbl.TextColor3 = Color3.fromRGB(200,200,200)
lbl.TextXAlignment = Enum.TextXAlignment.Left

local txtBox = Instance.new("TextBox", content)
txtBox.Size = UDim2.new(0,220,0,30)
txtBox.Position = UDim2.new(0,8,0,30)
txtBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
txtBox.TextColor3 = Color3.fromRGB(230,230,230)
txtBox.Text = ""
txtBox.PlaceholderText = "Nhập tên player (case-sensitive)"
txtBox.ClearTextOnFocus = false
txtBox.Font = Enum.Font.SourceSans
txtBox.TextSize = 14

local setBtn = Instance.new("TextButton", content)
setBtn.Size = UDim2.new(0,90,0,30)
setBtn.Position = UDim2.new(0,240,0,30)
setBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
setBtn.Text = "Set"
setBtn.Font = Enum.Font.SourceSans
setBtn.TextSize = 14
setBtn.TextColor3 = Color3.fromRGB(230,230,230)

local infoLabel = Instance.new("TextLabel", content)
infoLabel.Size = UDim2.new(0,1,0,20)
infoLabel.Position = UDim2.new(0,8,0,68)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Target: (none)"
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextSize = 13
infoLabel.TextColor3 = Color3.fromRGB(200,200,200)
infoLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Toggle button
local toggleBtn = Instance.new("TextButton", content)
toggleBtn.Size = UDim2.new(0,160,0,36)
toggleBtn.Position = UDim2.new(0,8,0,100)
toggleBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
toggleBtn.Text = "Bật AutoKill"
toggleBtn.Font = Enum.Font.SourceSans
toggleBtn.TextSize = 14
toggleBtn.TextColor3 = Color3.fromRGB(230,230,230)

-- Status
local status = Instance.new("TextLabel", content)
status.Size = UDim2.new(0,260,0,24)
status.Position = UDim2.new(0,8,0,148)
status.BackgroundTransparency = 1
status.Text = "Status: Idle"
status.Font = Enum.Font.SourceSans
status.TextSize = 13
status.TextColor3 = Color3.fromRGB(200,200,200)
status.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize small button
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

-- draggable helper
local UserInput = game:GetService("UserInputService")
local function makeDraggable(guiElement)
    local dragging = false
    local dragStart, startPos, dragInput

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

    UserInput.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            guiElement.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(main)
makeDraggable(smallBtn)

-- ===== logic =====
local autoKill = false
local isLoopRunning = false
local selectedTarget = nil

-- Find all trash cans (keywords)
local function findAllTrashCans()
    local keywords = {"trash","trashcan","trash can","garbage","bin"}
    local results = {}
    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local name = tostring(obj.Name or "")
            local lname = string.lower(name)
            for _,k in ipairs(keywords) do
                if string.find(lname, k, 1, true) then
                    if obj:IsA("Model") then
                        local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                        if primary then table.insert(results, primary) end
                    elseif obj:IsA("BasePart") then
                        table.insert(results, obj)
                    end
                    break
                end
            end
        end
    end
    return results
end

-- safe HRP getter
local function getHRP(plr)
    if not plr or not plr.Character then return nil end
    local ch = plr.Character
    return ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("Torso") or ch:FindFirstChild("UpperTorso")
end

-- teleport safe
local function tpTo(cf)
    local hrp = getHRP(player)
    if hrp then
        pcall(function() hrp.CFrame = cf end)
    end
end

-- face helper (set HRP to look at targetPos)
local function faceAt(targetPos)
    local hrp = getHRP(player)
    if hrp then
        pcall(function()
            hrp.CFrame = CFrame.new(hrp.Position, targetPos)
        end)
    end
end

-- Set target from textbox
local function setTargetFromText()
    local name = tostring(txtBox.Text or "")
    if name == "" then
        selectedTarget = nil
        infoLabel.Text = "Target: (none)"
        return
    end
    local p = Players:FindFirstChild(name)
    if p then
        selectedTarget = p
        infoLabel.Text = "Target: "..p.Name
    else
        selectedTarget = nil
        infoLabel.Text = "Target: (not found)"
    end
end

setBtn.MouseButton1Click:Connect(function()
    setTargetFromText()
end)

txtBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then setTargetFromText() end
end)

-- Auto loop starter/stopper
local function startLoop()
    if isLoopRunning then return end
    isLoopRunning = true
    task.spawn(function()
        while autoKill do
            -- validate target
            if not selectedTarget or not selectedTarget.Parent then
                status.Text = "Status: Chưa chọn target hợp lệ"
                task.wait(0.4)
                goto continue_outer
            end
            local tHrp = getHRP(selectedTarget)
            if not tHrp then
                status.Text = "Status: Target chưa spawn"
                task.wait(0.4)
                goto continue_outer
            end

            -- find trash cans
            local cans = findAllTrashCans()
            if #cans == 0 then
                status.Text = "Status: Không tìm thấy Trash Can"
                task.wait(1)
                goto continue_outer
            end

            -- choose random trash can
            local trash = cans[math.random(1,#cans)]
            local trashPos = trash.Position
            local trashBack = trash.CFrame.Position - (trash.CFrame.LookVector * TRASH_BEHIND_STUDS)
            local trashCf = CFrame.new(trashBack, trashPos)

            -- TP đến sau trash can, hướng mặt -> stay TRASH_PHASE_DURATION
            tpTo(trashCf)
            status.Text = "Phase: At trash ("..tostring(TRASH_PHASE_DURATION).."s)"
            local t0 = tick()
            while tick() - t0 < TRASH_PHASE_DURATION and autoKill do
                faceAt(trashPos)
                RunService.Heartbeat:Wait()
            end
            if not autoKill then break end

            -- OUT phase: TP sau target repeatedly for OUT_PHASE_DURATION
            status.Text = "Phase: Attacking "..(selectedTarget.Name or "??")
            local outStart = tick()
            while tick() - outStart < OUT_PHASE_DURATION and autoKill do
                local curTargetHrp = getHRP(selectedTarget)
                if not curTargetHrp then break end
                local tpos = curTargetHrp.Position
                local behindPos = tpos - (curTargetHrp.CFrame.LookVector * BEHIND_STUDS)
                behindPos = Vector3.new(behindPos.X, tpos.Y, behindPos.Z)
                local cf = CFrame.new(behindPos, tpos)
                tpTo(cf)
                -- maintain facing for TELEPORT_OUT_INTERVAL
                local waited = 0
                while waited < TELEPORT_OUT_INTERVAL and autoKill do
                    local dt = RunService.Heartbeat:Wait()
                    waited = waited + dt
                    local curT = getHRP(selectedTarget)
                    if curT then faceAt(curT.Position) end
                end
            end
            if not autoKill then break end

            ::continue_outer::
            -- small pause between cycles
            task.wait(0.05)
        end
        isLoopRunning = false
        status.Text = "Status: Idle"
    end)
end

-- Toggle button
toggleBtn.MouseButton1Click:Connect(function()
    autoKill = not autoKill
    if autoKill then
        toggleBtn.Text = "Tắt AutoKill"
        status.Text = "Status: Starting..."
        startLoop()
    else
        toggleBtn.Text = "Bật AutoKill"
        status.Text = "Status: Stopping..."
        -- loop reads autoKill and stops cleanly
    end
end)

-- Minimize / maximize
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = true
    main.Visible = false
    smallBtn.Visible = true
end)
smallBtn.MouseButton1Click:Connect(function()
    minimized = false
    main.Visible = true
    smallBtn.Visible = false
end)

print("[AutoTrashKill] GUI loaded. TELEPORT_OUT_INTERVAL = "..tostring(TELEPORT_OUT_INTERVAL).."s")
