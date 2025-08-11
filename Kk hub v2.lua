-- KK HUB V2 (Minimize -> Logo KK, Resize grip) — Paste vào executor (client)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- config
local BEHIND_STUDS = 5
local TP_INTERVAL = 0.01
local TRASHCAN_URL = "https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Trashcan%20Man"
local CLICK_SOUND_ID = "rbxassetid://2668781453"

-- remove old gui
if player:FindFirstChildOfClass("PlayerGui") and player.PlayerGui:FindFirstChild("KKHubV2") then
    pcall(function() player.PlayerGui.KKHubV2:Destroy() end)
end

-- helper tween
local function tweenObject(obj, props, time, style, dir)
    local info = TweenInfo.new(time or 0.18, Enum.EasingStyle[style or "Quad"], Enum.EasingDirection[dir or "Out"])
    return TweenService:Create(obj, info, props)
end

-- create gui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KKHubV2"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame", screenGui)
main.Name = "Main"
main.Size = UDim2.new(0,420,0,260)
main.Position = UDim2.new(0,16,0,80)
main.BackgroundColor3 = Color3.fromRGB(10,10,10)
main.BackgroundTransparency = 0.12
main.BorderSizePixel = 0
main.ZIndex = 2
main.Active = true
main.ClipsDescendants = true

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0,14)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Color3.fromRGB(255,255,255)
mainStroke.Transparency = 0.92
mainStroke.Thickness = 1

-- header
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,48)
header.Position = UDim2.new(0,0,0,0)
header.BackgroundTransparency = 1
header.ZIndex = 3

-- left logo (small inside header)
local logoFrame = Instance.new("Frame", header)
logoFrame.Name = "LogoFrame"
logoFrame.Size = UDim2.new(0,52,0,52)
logoFrame.AnchorPoint = Vector2.new(0,0)
logoFrame.Position = UDim2.new(0,12,0,-2)
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
logoInner.TextXAlignment = Enum.TextXAlignment.Center
logoInner.TextYAlignment = Enum.TextYAlignment.Center
logoInner.ZIndex = 6
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

-- centered title
local title = Instance.new("TextLabel", header)
title.Name = "TitleCentered"
title.Size = UDim2.new(0.6,0,1,0)
title.Position = UDim2.new(0.5,0,0,0)
title.AnchorPoint = Vector2.new(0.5,0)
title.BackgroundTransparency = 1
title.Text = "kk hub v2"
title.Font = Enum.Font.GothamSemibold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(240,240,240)
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextYAlignment = Enum.TextYAlignment.Center
title.ZIndex = 5

-- right area: minimize button (—)
local minBtn = Instance.new("TextButton", header)
minBtn.Name = "MinBtn"
minBtn.Size = UDim2.new(0,100,0,32)
minBtn.Position = UDim2.new(1,-116,0,8)
minBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
minBtn.BorderSizePixel = 0
minBtn.Text = "—"
minBtn.Font = Enum.Font.Gotham
minBtn.TextSize = 20
minBtn.TextColor3 = Color3.fromRGB(255,255,255)
minBtn.ZIndex = 6
local minCorner = Instance.new("UICorner", minBtn); minCorner.CornerRadius = UDim.new(0,8)
local minStroke = Instance.new("UIStroke", minBtn); minStroke.Transparency = 0.75; minStroke.Thickness = 1

-- sparkle orbit (absolute parent)
local sparkle = Instance.new("ImageLabel", screenGui)
sparkle.Name = "SparkleOrbit"
sparkle.Size = UDim2.new(0,18,0,18)
sparkle.BackgroundTransparency = 1
sparkle.Image = "rbxassetid://6035067836"
sparkle.ZIndex = 3
sparkle.Visible = true

-- pulse for logoFrame
spawn(function()
    while logoFrame and logoFrame.Parent do
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

spawn(function()
    local angle = 0
    while logoFrame and logoFrame.Parent and sparkle and sparkle.Parent do
        local ok, ax, ay, aw, ah = pcall(function()
            return logoFrame.AbsolutePosition.X, logoFrame.AbsolutePosition.Y, logoFrame.AbsoluteSize.X, logoFrame.AbsoluteSize.Y
        end)
        if ok then
            local cx = ax + aw/2
            local cy = ay + ah/2
            angle = (angle + 8) % 360
            local r = math.clamp(aw * 1.7, 40, 90)
            local rad = math.rad(angle)
            local sx = cx + math.cos(rad) * r - (sparkle.AbsoluteSize.X/2)
            local sy = cy + math.sin(rad) * r - (sparkle.AbsoluteSize.Y/2)
            pcall(function()
                sparkle.Position = UDim2.new(0, sx, 0, sy)
                sparkle.Rotation = (sparkle.Rotation + 9) % 360
            end)
        end
        task.wait(0.03)
    end
    pcall(function() sparkle:Destroy() end)
end)

-- content
local content = Instance.new("Frame", main)
content.Position = UDim2.new(0,0,0,48)
content.Size = UDim2.new(1,0,1,-48)
content.BackgroundTransparency = 1
content.ZIndex = 3

-- hover helper
local function addHover(btn)
    btn.MouseEnter:Connect(function() pcall(function() tweenObject(btn, {BackgroundTransparency = 0.06}, 0.12, "Quad"):Play() end) end)
    btn.MouseLeave:Connect(function() pcall(function() tweenObject(btn, {BackgroundTransparency = 0.45}, 0.12, "Quad"):Play() end) end)
end

-- dropdown label + button
local lbl = Instance.new("TextLabel", content)
lbl.Size = UDim2.new(0,80,0,18)
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
dropdownBtn.Text = "Option1"
dropdownBtn.Font = Enum.Font.Gotham
dropdownBtn.TextSize = 14
dropdownBtn.TextColor3 = Color3.fromRGB(230,230,230)
dropdownBtn.ZIndex = 3
dropdownBtn.AutoButtonColor = true
local ddCorner = Instance.new("UICorner", dropdownBtn); ddCorner.CornerRadius = UDim.new(0,8)
local ddStroke = Instance.new("UIStroke", dropdownBtn); ddStroke.Transparency = 0.8; ddStroke.Thickness = 1
addHover(dropdownBtn)

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
local ddCorner2 = Instance.new("UICorner", dropdownFrame); ddCorner2.CornerRadius = UDim.new(0,8)
local listLayout = Instance.new("UIListLayout", dropdownFrame)
listLayout.Padding = UDim.new(0,6)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
local padding = Instance.new("Frame", dropdownFrame)
padding.Size = UDim2.new(1,0,0,10); padding.BackgroundTransparency = 1

local selectedTarget = nil

-- fill dropdown: Option1 + players
local function refreshDropdown()
    for _,c in ipairs(dropdownFrame:GetChildren()) do
        if c ~= listLayout and c ~= padding then c:Destroy() end
    end
    local opt1 = Instance.new("TextButton", dropdownFrame)
    opt1.Size = UDim2.new(1,-12,0,36)
    opt1.Position = UDim2.new(0,6,0,0)
    opt1.BackgroundColor3 = Color3.fromRGB(28,28,28)
    opt1.BorderSizePixel = 0
    opt1.TextColor3 = Color3.fromRGB(220,220,220)
    opt1.Font = Enum.Font.Gotham
    opt1.TextSize = 14
    opt1.Text = "Option1"
    opt1.AutoButtonColor = true
    local c1 = Instance.new("UICorner", opt1); c1.CornerRadius = UDim.new(0,8)
    opt1.ZIndex = 5
    opt1.MouseButton1Click:Connect(function()
        selectedTarget = "Option1"
        dropdownBtn.Text = "Option1"
        dropdownFrame.Visible = false
    end)
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton", dropdownFrame)
            btn.Size = UDim2.new(1,-12,0,36)
            btn.Position = UDim2.new(0,6,0,0)
            btn.BackgroundColor3 = Color3.fromRGB(28,28,28)
            btn.BorderSizePixel = 0
            btn.TextColor3 = Color3.fromRGB(220,220,220)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            btn.Text = plr.Name
            btn.AutoButtonColor = true
            local bc = Instance.new("UICorner", btn); bc.CornerRadius = UDim.new(0,8)
            btn.ZIndex = 5
            btn.MouseButton1Click:Connect(function()
                selectedTarget = plr
                dropdownBtn.Text = "Target: "..plr.Name
                dropdownFrame.Visible = false
            end)
        end
    end
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        dropdownFrame.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y + 10)
    end)
end

dropdownBtn.MouseButton1Click:Connect(function()
    dropdownFrame.Visible = not dropdownFrame.Visible
    if dropdownFrame.Visible then
        refreshDropdown()
        dropdownFrame.Size = UDim2.new(0,300,0,0)
        tweenObject(dropdownFrame, {Size = UDim2.new(0,300,0,180)}, 0.18, "Quad"):Play()
    else
        tweenObject(dropdownFrame, {Size = UDim2.new(0,300,0,0)}, 0.12, "Quad"):Play()
        task.delay(0.12, function() dropdownFrame.Visible = false end)
    end
end)

Players.PlayerAdded:Connect(function() refreshDropdown() end)
Players.PlayerRemoving:Connect(function()
    if selectedTarget and typeof(selectedTarget) == "Instance" and selectedTarget.Parent == nil then
        selectedTarget = nil
        dropdownBtn.Text = "Option1"
    end
    refreshDropdown()
end)

-- status
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

-- Buttons area
local btnY = 120
local runTrashBtn = Instance.new("TextButton", content)
runTrashBtn.Size = UDim2.new(0,220,0,44)
runTrashBtn.Position = UDim2.new(0,16,0,btnY)
runTrashBtn.BackgroundColor3 = Color3.fromRGB(18,18,18)
runTrashBtn.BorderSizePixel = 0
runTrashBtn.Text = "Trash Can Run"
runTrashBtn.Font = Enum.Font.Gotham
runTrashBtn.TextSize = 16
runTrashBtn.TextColor3 = Color3.fromRGB(230,230,230)
runTrashBtn.ZIndex = 3
local runCorner = Instance.new("UICorner", runTrashBtn); runCorner.CornerRadius = UDim.new(0,8)
local runStroke = Instance.new("UIStroke", runTrashBtn); runStroke.Transparency = 0.8; runStroke.Thickness = 1
addHover(runTrashBtn)

runTrashBtn.MouseButton1Click:Connect(function()
    pcall(function() tweenObject(runTrashBtn, {BackgroundTransparency = 0.2}, 0.08):Play() end)
    spawn(function()
        local ok, err = pcall(function()
            loadstring(game:HttpGet(TRASHCAN_URL, true))()
        end)
        if not ok then
            status.Text = "Status: Trash script failed"
            warn("Trash script error:", err)
            task.delay(2, function() status.Text = "Status: Idle" end)
        end
    end)
end)

local tpBtn = Instance.new("TextButton", content)
tpBtn.Size = UDim2.new(0,220,0,44)
tpBtn.Position = UDim2.new(0,16,0,btnY + 56)
tpBtn.BackgroundColor3 = Color3.fromRGB(20,20,60)
tpBtn.BorderSizePixel = 0
tpBtn.Text = "TP Behind: OFF"
tpBtn.Font = Enum.Font.Gotham
tpBtn.TextSize = 16
tpBtn.TextColor3 = Color3.fromRGB(230,230,230)
tpBtn.ZIndex = 3
local tpCorner = Instance.new("UICorner", tpBtn); tpCorner.CornerRadius = UDim.new(0,8)
local tpStroke = Instance.new("UIStroke", tpBtn); tpStroke.Transparency = 0.8; tpStroke.Thickness = 1
addHover(tpBtn)

local testBtn = Instance.new("TextButton", content)
testBtn.Size = UDim2.new(0,220,0,44)
testBtn.Position = UDim2.new(0,16,0,btnY + 112)
testBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
testBtn.BorderSizePixel = 0
testBtn.Text = "Test Button"
testBtn.Font = Enum.Font.Gotham
testBtn.TextSize = 16
testBtn.TextColor3 = Color3.fromRGB(230,230,230)
testBtn.ZIndex = 3
local tCorner = Instance.new("UICorner", testBtn); tCorner.CornerRadius = UDim.new(0,8)
local tStroke = Instance.new("UIStroke", testBtn); tStroke.Transparency = 0.8; tStroke.Thickness = 1
addHover(testBtn)

testBtn.MouseButton1Click:Connect(function()
    status.Text = "Status: Test pressed"
    tweenObject(testBtn, {BackgroundTransparency = 0.2}, 0.08):Play()
    task.delay(0.12, function() tweenObject(testBtn, {BackgroundTransparency = 0.45}, 0.12):Play() end)
    task.delay(1, function() status.Text = "Status: Idle" end)
end)

-- teleport helpers
local function getHRP(plr)
    if not plr or not plr.Character then return nil end
    return plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("Torso") or plr.Character:FindFirstChild("UpperTorso")
end
local function tpTo(cf)
    local hrp = getHRP(player)
    if hrp then
        pcall(function()
            hrp.CFrame = cf
        end)
    end
end

local tpActive = false
local tpThread = nil

tpBtn.MouseButton1Click:Connect(function()
    tpActive = not tpActive
    if tpActive then
        tpBtn.BackgroundColor3 = Color3.fromRGB(18,120,18)
        tpBtn.Text = "TP Behind: ON"
        status.Text = "Status: TP ON"
        tpThread = task.spawn(function()
            while tpActive do
                if selectedTarget == nil or selectedTarget == "Option1" then
                    status.Text = "Status: No valid target"
                else
                    if typeof(selectedTarget) == "Instance" then
                        local tgtHrp = getHRP(selectedTarget)
                        if tgtHrp then
                            local tpos = tgtHrp.Position
                            local behindPos = tpos - (tgtHrp.CFrame.LookVector * BEHIND_STUDS)
                            local cf = CFrame.new(behindPos, tpos)
                            pcall(function() tpTo(cf) end)
                            status.Text = "Status: Teleporting behind "..(selectedTarget.Name or "??")
                        else
                            status.Text = "Status: Target not spawned"
                        end
                    else
                        status.Text = "Status: Invalid target type"
                    end
                end
                task.wait(TP_INTERVAL)
            end
            status.Text = "Status: Idle"
        end)
    else
        tpBtn.BackgroundColor3 = Color3.fromRGB(20,20,60)
        tpBtn.Text = "TP Behind: OFF"
        tpActive = false
        status.Text = "Status: Idle"
    end
end)

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

-- resize logic
local MIN_W, MIN_H = 300, 180
local MAX_W, MAX_H = 900, 600
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
    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startInputPos
            local newW = math.clamp(startSize.X + delta.X, MIN_W, MAX_W)
            local newH = math.clamp(startSize.Y + delta.Y, MIN_H, MAX_H)
            main.Size = UDim2.new(0, newW, 0, newH)
            -- adjust dropdown frame width if needed
            dropdownFrame.Size = UDim2.new(0, math.max(260, newW - 140), 0, math.min(400, newH - 120))
            resizeGrip.Position = UDim2.new(1,-22,1,-22)
        end
    end)
end

-- make main draggable by header
do
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            dragInput = input
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    header.InputChanged:Connect(function(input)
        if input == dragInput then
            update(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

-- SMALL LOGO BUTTON (appears when main minimized)
local smallBtn = Instance.new("TextButton", screenGui)
smallBtn.Name = "Sm
