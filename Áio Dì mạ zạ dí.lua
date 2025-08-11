-- AutoTrashCanKill (GUI nâng cấp: resize + nút AutoKill fix không bị che)
-- Dán vào executor, chạy ở client. Một số game có anti-cheat -> tự chịu.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- ===== config =====
local BEHIND_STUDS = 5
local TRASH_BEHIND_STUDS = 5
local TELEPORT_OUT_INTERVAL = 0.01
local OUT_PHASE_DURATION = 1.0
local TRASH_PHASE_DURATION = 1.0
-- min/max size for resize
local MIN_W, MIN_H = 300, 180
local MAX_W, MAX_H = 900, 600
-- ===================

math.randomseed(tick())

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
main.Size = UDim2.new(0, 420, 0, 260) -- lớn hơn mặc định
main.Position = UDim2.new(0, 16, 0, 80)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.BackgroundTransparency = 0.12
main.BorderSizePixel = 0
main.Parent = screenGui
main.Active = true
main.ClipsDescendants = true
main.ZIndex = 2

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Color3.fromRGB(255,255,255)
mainStroke.Transparency = 0.92
mainStroke.Thickness = 1

local gradient = Instance.new("UIGradient", main)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18,18,18)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(28,28,28))
}
gradient.Rotation = 270

-- Header
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,48)
header.BackgroundTransparency = 1
header.ZIndex = 3

-- Logo giữa header
local logoFrame = Instance.new("Frame", header)
logoFrame.Name = "LogoFrame"
logoFrame.AnchorPoint = Vector2.new(0.5, 0.5)
logoFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- căn giữa header
logoFrame.Size = UDim2.new(0,52,0,52)
logoFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
logoFrame.BorderSizePixel = 0
logoFrame.ZIndex = 4

local logoCorner = Instance.new("UICorner", logoFrame)
logoCorner.CornerRadius = UDim.new(0,12)

local logoGrad = Instance.new("UIGradient", logoFrame)
logoGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120,60,200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60,200,200))
}
logoGrad.Rotation = 45

local logoInner = Instance.new("TextLabel", logoFrame)
logoInner.Size = UDim2.new(1, -8, 1, -8)
logoInner.Position = UDim2.new(0,4,0,4)
logoInner.BackgroundTransparency = 1
logoInner.Text = "KK"
logoInner.Font = Enum.Font.GothamSemibold
logoInner.TextSize = 20
logoInner.TextColor3 = Color3.fromRGB(245,245,245)
logoInner.ZIndex = 6
logoInner.TextXAlignment = Enum.TextXAlignment.Center
logoInner.TextYAlignment = Enum.TextYAlignment.Center

local logoDot = Instance.new("Frame", logoFrame)
logoDot.Size = UDim2.new(0,8,0,8)
logoDot.Position = UDim2.new(1,-14,0,6)
logoDot.BackgroundColor3 = Color3.fromRGB(255,240,120)
logoDot.BorderSizePixel = 0
local dotCorner = Instance.new("UICorner", logoDot)
dotCorner.CornerRadius = UDim.new(1,0)
logoDot.ZIndex = 7

local logoGlow = Instance.new("ImageLabel", logoFrame)
logoGlow.Name = "LogoGlow"
logoGlow.Size = UDim2.new(1.8,0,1.8,0)
logoGlow.Position = UDim2.new(-0.4,0,-0.4,0)
logoGlow.BackgroundTransparency = 1
logoGlow.Image = "rbxassetid://4996891970"
logoGlow.ImageTransparency = 0.88
logoGlow.ZIndex = 3
logoGlow.ScaleType = Enum.ScaleType.Slice
logoGlow.SliceCenter = Rect.new(10,10,118,118)

-- Hiệu ứng phóng to / thu nhỏ
spawn(function()
    while screenGui.Parent do
        pcall(function()
            tweenObject(logoFrame, {Size = UDim2.new(0,60,0,60)}, 0.45, "Sine"):Play()
            tweenObject(logoInner, {TextSize = 22}, 0.45, "Sine"):Play()
        end)
        task.wait(0.45)
        pcall(function()
            tweenObject(logoFrame, {Size = UDim2.new(0,52,0,52)}, 0.45, "Sine"):Play()
            tweenObject(logoInner, {TextSize = 20}, 0.45, "Sine"):Play()
        end)
        task.wait(0.45)
    end
end)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-140,1,0)
title.Position = UDim2.new(0,16,0,0)
title.BackgroundTransparency = 1
title.Text = "AutoTrashKill"
title.Font = Enum.Font.GothamSemibold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(240,240,240)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3

local minBtn = Instance.new("TextButton", header)
minBtn.Size = UDim2.new(0,100,0,32)
minBtn.Position = UDim2.new(1,-116,0,8)
minBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
minBtn.BorderSizePixel = 0
minBtn.Text = "—"
minBtn.Font = Enum.Font.Gotham
minBtn.TextSize = 20
minBtn.TextColor3 = Color3.fromRGB(255,255,255)
minBtn.ZIndex = 4
local minCorner = Instance.new("UICorner", minBtn)
minCorner.CornerRadius = UDim.new(0,8)
local minStroke = Instance.new("UIStroke", minBtn)
minStroke.Transparency = 0.75
minStroke.Thickness = 1

-- Content area
local content = Instance.new("Frame", main)
content.Position = UDim2.new(0,0,0,48)
content.Size = UDim2.new(1,0,1,-48)
content.BackgroundTransparency = 1
content.ZIndex = 3

-- Label + dropdown button
local lbl = Instance.new("TextLabel", content)
lbl.Size = UDim2.new(0,1,0,18)
lbl.Position = UDim2.new(0,16,0,10)
lbl.BackgroundTransparency = 1
lbl.Text = "Target:"
lbl.Font = Enum.Font.GothamSemibold
lbl.TextSize = 13
lbl.TextColor3 = Color3.fromRGB(200,200,200)
lbl.TextXAlignment = Enum.TextXAlignment.Left
lbl.ZIndex = 3

local dropdownBtn = Instance.new("TextButton", content)
dropdownBtn.Size = UDim2.new(0,300,0,36)
dropdownBtn.Position = UDim2.new(0,16,0,36)
dropdownBtn.BackgroundColor3 = Color3.fromRGB(18,18,18)
dropdownBtn.BorderSizePixel = 0
dropdownBtn.Text = "Chọn player..."
dropdownBtn.Font = Enum.Font.Gotham
dropdownBtn.TextSize = 14
dropdownBtn.TextColor3 = Color3.fromRGB(230,230,230)
dropdownBtn.ZIndex = 3
local ddCorner = Instance.new("UICorner", dropdownBtn)
ddCorner.CornerRadius = UDim.new(0,8)
local ddStroke = Instance.new("UIStroke", dropdownBtn)
ddStroke.Transparency = 0.8
ddStroke.Thickness = 1

-- Dropdown -> ScrollingFrame để kéo được
local dropdownFrame = Instance.new("ScrollingFrame", content)
dropdownFrame.Size = UDim2.new(0,300,0,180)
dropdownFrame.Position = UDim2.new(0,16,0,76)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(16,16,16)
dropdownFrame.BorderSizePixel = 0
dropdownFrame.Visible = false
dropdownFrame.CanvasSize = UDim2.new(0,0,0,0)
dropdownFrame.ScrollBarThickness = 6
dropdownFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
dropdownFrame.ZIndex = 4
local ddCorner2 = Instance.new("UICorner", dropdownFrame)
ddCorner2.CornerRadius = UDim.new(0,8)
local listLayout = Instance.new("UIListLayout", dropdownFrame)
listLayout.Padding = UDim.new(0,6)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
local padding = Instance.new("Frame", dropdownFrame)
padding.Size = UDim2.new(1,0,0,10)
padding.BackgroundTransparency = 1

-- Toggle button (ANCHOR FIXED: anchored to bottom-left so never gets cut)
local toggleBtn = Instance.new("TextButton", content)
toggleBtn.Size = UDim2.new(0,220,0,44)
toggleBtn.AnchorPoint = Vector2.new(0,1)               -- anchor to bottom
toggleBtn.Position = UDim2.new(0,16,1,-16)             -- 16px from left, 16px from bottom
toggleBtn.BackgroundColor3 = Color3.fromRGB(16,120,16)
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "Bật AutoKill"
toggleBtn.Font = Enum.Font.Gotham
toggleBtn.TextSize = 16
toggleBtn.TextColor3 = Color3.fromRGB(245,245,245)
toggleBtn.ZIndex = 3
local togCorner = Instance.new("UICorner", toggleBtn)
togCorner.CornerRadius = UDim.new(0,8)

-- Status label
local status = Instance.new("TextLabel", content)
status.Size = UDim2.new(0,260,0,24)
status.Position = UDim2.new(0,330,0,42)
status.BackgroundTransparency = 1
status.Text = "Status: Idle"
status.Font = Enum.Font.Gotham
status.TextSize = 13
status.TextColor3 = Color3.fromRGB(200,200,200)
status.TextXAlignment = Enum.TextXAlignment.Left
status.ZIndex = 3

-- small minimize button (visible when main hidden)
-- === replace old smallBtn block with this ===
local TweenService = game:GetService("TweenService") -- nếu đã có thì bỏ dòng này
local parentForSmallBtn = screenGui -- <-- đổi thành parent cũ của smallBtn nếu khác

local smallBtn = Instance.new("TextButton")
smallBtn.Name = "SmallToggle"
smallBtn.Size = UDim2.new(0,52,0,52)      -- match header logo size
smallBtn.Position = UDim2.new(0,20,0,22)  -- giữ vị trí góc; muốn giữa header chỉnh phía dưới
smallBtn.AnchorPoint = Vector2.new(0,0)
smallBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
smallBtn.BorderSizePixel = 0
smallBtn.Text = ""
smallBtn.ZIndex = 10
smallBtn.Parent = parentForSmallBtn

-- Rounded
local smallCorner = Instance.new("UICorner", smallBtn)
smallCorner.CornerRadius = UDim.new(0,12)

-- Gradient background (giống header logo)
local logoGrad = Instance.new("UIGradient", smallBtn)
logoGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120,60,200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60,200,200))
}
logoGrad.Rotation = 45

-- Text "KK"
local kkLabel = Instance.new("TextLabel", smallBtn)
kkLabel.Size = UDim2.new(1, -8, 1, -8)
kkLabel.Position = UDim2.new(0,4,0,4)
kkLabel.BackgroundTransparency = 1
kkLabel.Text = "KK"
kkLabel.Font = Enum.Font.GothamSemibold
kkLabel.TextSize = 20
kkLabel.TextColor3 = Color3.fromRGB(245,245,245)
kkLabel.TextXAlignment = Enum.TextXAlignment.Center
kkLabel.TextYAlignment = Enum.TextYAlignment.Center
kkLabel.ZIndex = 11

-- Small yellow dot (same position)
local yellowDot = Instance.new("Frame", smallBtn)
yellowDot.Size = UDim2.new(0,8,0,8)
yellowDot.Position = UDim2.new(1, -14, 0, 6)
yellowDot.BackgroundColor3 = Color3.fromRGB(255,240,120)
yellowDot.BorderSizePixel = 0
local dotCorner = Instance.new("UICorner", yellowDot)
dotCorner.CornerRadius = UDim.new(1,0)
yellowDot.ZIndex = 12

-- Halo glow image
local logoGlow = Instance.new("ImageLabel", smallBtn)
logoGlow.Name = "LogoGlow"
logoGlow.Size = UDim2.new(1.8,0,1.8,0)
logoGlow.Position = UDim2.new(-0.4,0,-0.4,0)
logoGlow.BackgroundTransparency = 1
logoGlow.Image = "rbxassetid://4996891970"
logoGlow.ImageTransparency = 0.88
logoGlow.ZIndex = 9
logoGlow.ScaleType = Enum.ScaleType.Slice
logoGlow.SliceCenter = Rect.new(10,10,118,118)

-- Pulse tween (to/nhỏ + chữ to/nhỏ)
local expandInfo = TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local collapseInfo = TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

spawn(function()
    while smallBtn and smallBtn.Parent do
        pcall(function()
            TweenService:Create(smallBtn, expandInfo, {Size = UDim2.new(0,60,0,60)}):Play()
            TweenService:Create(kkLabel, expandInfo, {TextSize = 22}):Play()
        end)
        task.wait(0.45)
        pcall(function()
            TweenService:Create(smallBtn, collapseInfo, {Size = UDim2.new(0,52,0,52)}):Play()
            TweenService:Create(kkLabel, collapseInfo, {TextSize = 20}):Play()
        end)
        task.wait(0.45)
    end
end)
-- === end block ===

-- resize grip (bottom-right)
local resizeGrip = Instance.new("Frame", main)
resizeGrip.Size = UDim2.new(0,18,0,18)
resizeGrip.Position = UDim2.new(1,-22,1,-22)
resizeGrip.BackgroundColor3 = Color3.fromRGB(40,40,40)
resizeGrip.BorderSizePixel = 0
resizeGrip.ZIndex = 5
local gripCorner = Instance.new("UICorner", resizeGrip)
gripCorner.CornerRadius = UDim.new(0,6)
local gripStroke = Instance.new("UIStroke", resizeGrip)
gripStroke.Transparency = 0.85
for i=1,3 do
    local l = Instance.new("Frame", resizeGrip)
    l.Size = UDim2.new(0, (i*4), 0, 2)
    l.Position = UDim2.new(1, - (i*6), 1, -6)
    l.AnchorPoint = Vector2.new(1,1)
    l.Rotation = -45
    l.BackgroundColor3 = Color3.fromRGB(110,110,110)
    l.BorderSizePixel = 0
    l.ZIndex = 6
end

-- tween helper
local function tweenObject(obj, props, time, style, dir)
    local info = TweenInfo.new(time or 0.18, Enum.EasingStyle[style or "Quad"], Enum.EasingDirection[dir or "Out"])
    return TweenService:Create(obj, info, props)
end

local function addHover(btn)
    btn.MouseEnter:Connect(function()
        pcall(function() tweenObject(btn, {BackgroundTransparency = 0.06}, 0.12, "Quad"):Play() end)
    end)
    btn.MouseLeave:Connect(function()
        pcall(function() tweenObject(btn, {BackgroundTransparency = 0.45}, 0.12, "Quad"):Play() end)
    end)
end

-- apply hover
dropdownBtn.BackgroundTransparency = 0.45
toggleBtn.BackgroundTransparency = 0.12
minBtn.BackgroundTransparency = 0.12
addHover(dropdownBtn)
addHover(toggleBtn)
addHover(minBtn)

-- make header draggable
local function makeDraggable(frame, handle)
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local startPos = input.Position
            local startGuiPos = frame.Position
            local moveConn
            local endConn
            moveConn = UserInput.InputChanged:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                    local delta = i.Position - startPos
                    local newPos = UDim2.new(startGuiPos.X.Scale, startGuiPos.X.Offset + delta.X, startGuiPos.Y.Scale, startGuiPos.Y.Offset + delta.Y)
                    frame.Position = newPos
                end
            end)
            endConn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    moveConn:Disconnect()
                    endConn:Disconnect()
                end
            end)
        end
    end)
end

makeDraggable(main, header)
makeDraggable(smallBtn, smallBtn)

-- resize logic
do
    local resizing = false
    local startInputPos, startSize
    resizeGrip.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            startInputPos = input.Position
            startSize = { X = main.AbsoluteSize.X, Y = main.AbsoluteSize.Y }
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                end
            end)
        end
    end)
    UserInput.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startInputPos
            local newW = math.clamp(startSize.X + delta.X, MIN_W, MAX_W)
            local newH = math.clamp(startSize.Y + delta.Y, MIN_H, MAX_H)
            main.Size = UDim2.new(0, newW, 0, newH)
            -- adjust dropdown & toggle positions/sizes smoothly
            dropdownFrame.Size = UDim2.new(0, math.max(260, newW - 140), 0, math.min(400, newH - 120))
            -- toggle anchored so no need to set Position here
            resizeGrip.Position = UDim2.new(1,-22,1,-22)
        end
    end)
end

-- ===== logic (giữ nguyên) =====
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

-- Dropdown management (scrollable)
local function clearDropdown()
    for _,v in ipairs(dropdownFrame:GetChildren()) do
        if v ~= listLayout and v ~= padding then v:Destroy() end
    end
end

local function updateDropdown()
    clearDropdown()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,-12,0,36)
            btn.Position = UDim2.new(0,6,0,0)
            btn.BackgroundColor3 = Color3.fromRGB(28,28,28)
            btn.BorderSizePixel = 0
            btn.TextColor3 = Color3.fromRGB(220,220,220)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            btn.Text = plr.Name
            btn.AutoButtonColor = true
            btn.Parent = dropdownFrame
            local btnCorner = Instance.new("UICorner", btn)
            btnCorner.CornerRadius = UDim.new(0,8)
            btn.ZIndex = 5
            btn.MouseButton1Click:Connect(function()
                selectedTarget = plr
                dropdownBtn.Text = "Target: "..plr.Name
                tweenObject(dropdownFrame, {BackgroundTransparency = 1}, 0.12):Play()
                tweenObject(dropdownFrame, {Size = UDim2.new(dropdownFrame.Size.X.Scale, dropdownFrame.Size.X.Offset, 0, 0)}, 0.18, "Quad"):Play()
                task.delay(0.18, function()
                    dropdownFrame.Visible = false
                    dropdownFrame.BackgroundTransparency = 0
                    dropdownFrame.Size = UDim2.new(0,300,0,180)
                end)
            end)
        end
    end
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        dropdownFrame.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y + 10)
    end)
    dropdownFrame.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y + 10)
end

dropdownBtn.MouseButton1Click:Connect(function()
    if dropdownFrame.Visible then
        tweenObject(dropdownFrame, {BackgroundTransparency = 1}, 0.12):Play()
        tweenObject(dropdownFrame, {Size = UDim2.new(dropdownFrame.Size.X.Scale, dropdownFrame.Size.X.Offset, 0, 0)}, 0.18, "Quad"):Play()
        task.delay(0.18, function()
            dropdownFrame.Visible = false
            dropdownFrame.BackgroundTransparency = 0
            dropdownFrame.Size = UDim2.new(0,300,0,180)
        end)
    else
        dropdownFrame.Visible = true
        dropdownFrame.BackgroundTransparency = 1
        dropdownFrame.Size = UDim2.new(0,300,0,0)
        tweenObject(dropdownFrame, {BackgroundTransparency = 0}, 0.12):Play()
        tweenObject(dropdownFrame, {Size = UDim2.new(0,300,0,180)}, 0.18, "Quad"):Play()
        updateDropdown()
    end
end)

Players.PlayerAdded:Connect(updateDropdown)
Players.PlayerRemoving:Connect(function()
    updateDropdown()
    if selectedTarget and not Players:FindFirstChild(selectedTarget.Name) then
        selectedTarget = nil
        dropdownBtn.Text = "Chọn player..."
    end
end)

updateDropdown()

-- Animated minimize / maximize (no white patch)
local function minimizeUI()
    if not main.Visible then return end
    tweenObject(main, {Size = UDim2.new(0, 200, 0, 64), BackgroundTransparency = 0.6}, 0.22, "Back"):Play()
    tweenObject(title, {TextTransparency = 1}, 0.22):Play()
    task.delay(0.22, function()
        main.Visible = false
        smallBtn.Visible = true
        smallBtn.Size = UDim2.fromOffset(6,6)
        tweenObject(smallBtn, {Size = UDim2.fromOffset(64,64)}, 0.2, "Back"):Play()
    end)
end

local function maximizeUI()
    if main.Visible then return end
    smallBtn.Visible = false
    main.Visible = true
    main.Size = UDim2.new(0, 420, 0, 260)
    title.TextTransparency = 1
    tweenObject(main, {Size = UDim2.new(0,420,0,260), BackgroundTransparency = 0.12}, 0.22, "Back"):Play()
    tweenObject(title, {TextTransparency = 0}, 0.28):Play()
end

minBtn.MouseButton1Click:Connect(minimizeUI)
smallBtn.MouseButton1Click:Connect(maximizeUI)

-- Auto loop starter/stopper (giữ nguyên logic)
local function startLoop()
    if isLoopRunning then return end
    isLoopRunning = true
    task.spawn(function()
        while autoKill do
            if not selectedTarget or not selectedTarget.Parent then
                status.Text = "Status: Chưa chọn target hợp lệ"
                task.wait(0.5)
            else
                local tHrp = getHRP(selectedTarget)
                if not tHrp then
                    status.Text = "Status: Target chưa spawn"
                    task.wait(0.5)
                else
                    local cans = findAllTrashCans()
                    if #cans == 0 then
                        status.Text = "Status: Không tìm thấy Trash Can"
                        task.wait(1)
                    else
                        local trash = cans[math.random(1,#cans)]
                        local trashPos = trash.Position
                        local trashBack = trash.CFrame.Position - (trash.CFrame.LookVector * TRASH_BEHIND_STUDS)
                        local trashCf = CFrame.new(trashBack, trashPos)

                        tpTo(trashCf)
                        status.Text = "Phase: At trash ("..tostring(TRASH_PHASE_DURATION).."s)"
                        local t0 = tick()
                        while tick() - t0 < TRASH_PHASE_DURATION and autoKill do
                            faceAt(trashPos)
                            RunService.Heartbeat:Wait()
                        end
                        if not autoKill then break end

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
                            local waited = 0
                            while waited < TELEPORT_OUT_INTERVAL and autoKill do
                                local dt = RunService.Heartbeat:Wait()
                                waited = waited + dt
                                local curT = getHRP(selectedTarget)
                                if curT then faceAt(curT.Position) end
                            end
                        end
                        if not autoKill then break end
                    end
                end
            end
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
    end
end)

print("[AutoTrashKill] GUI loaded. TELEPORT_OUT_INTERVAL = "..tostring(TELEPORT_OUT_INTERVAL).."s")
