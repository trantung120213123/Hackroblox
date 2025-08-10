-- KeySystemGUI (gốc) + nhiều halo/ring/soft assets + draggable + logo pulse + run remote script on correct key
-- Dán vào executor. WARNING: một số executor chặn setclipboard / loadstring / HttpGet -> fallback & thông báo được xử lý.
-- Khi nhập key = "kk123" GUI sẽ cố gắng tải và chạy script từ URL (raw GitHub) mà bạn cung cấp.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- CONFIG
local VALID_KEY = "kk123"
local COPY_LINK = "https://yeumoney.com/0HD6w"
local REMOTE_SCRIPT_URL = "https://raw.githubusercontent.com/trantung120213123/Hackroblox/refs/heads/main/%C3%81io%20D%C3%AC%20m%E1%BA%A1%20z%E1%BA%A1%20d%C3%AD.lua"

-- Assets collection (put all suggestions here; đổi ID nếu muốn)
local ASSETS = {
    HALO_BIG        = "rbxassetid://4996891970",   -- big soft glow
    SPARKLE_RING    = "rbxassetid://6035067836",   -- sparkle/ring
    SOFT_AESTHETIC  = "rbxassetid://5180300644",  -- soft aesthetic (optional)
    HALO_HELMET     = "rbxassetid://75076726"     -- halo-like icon (optional)
}

-- Remove old GUI
local EXIST = player:FindFirstChildOfClass("PlayerGui") and player.PlayerGui:FindFirstChild("KeySystemGUI")
if EXIST then EXIST:Destroy() end

-- helper tween
local function tween(obj, props, t, style, dir)
    local info = TweenInfo.new(t or 0.18, Enum.EasingStyle[style or "Quad"], Enum.EasingDirection[dir or "Out"])
    local ok, tobj = pcall(function() return TweenService:Create(obj, info, props) end)
    if ok and tobj then pcall(function() tobj:Play() end) end
    return tobj
end

-- create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeySystemGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- big halo behind GUI (visible glow)
local halo = Instance.new("ImageLabel", screenGui)
halo.Name = "HaloBig"
halo.AnchorPoint = Vector2.new(0.5, 0.5)
halo.BackgroundTransparency = 1
halo.Image = ASSETS.HALO_BIG
halo.ImageTransparency = 0.65
halo.ZIndex = 1
halo.Size = UDim2.new(0, 520, 0, 520)

-- main frame
local main = Instance.new("Frame", screenGui)
main.Name = "Main"
main.Size = UDim2.new(0, 420, 0, 220)
main.Position = UDim2.new(0, 20, 0, 80)
main.BackgroundColor3 = Color3.fromRGB(12,12,12)
main.BackgroundTransparency = 0.10
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.ZIndex = 2

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0,12)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255,255,255)
stroke.Transparency = 0.92
stroke.Thickness = 1
local grad = Instance.new("UIGradient", main)
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18,18,18)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(28,28,28))
}
grad.Rotation = 270

-- header + make draggable
local header = Instance.new("Frame", main)
header.Name = "Header"
header.Size = UDim2.new(1,0,0,56)
header.BackgroundTransparency = 1
header.ZIndex = 3

-- make main followable by halo (update)
local function updateHalo()
    local absPos = main.AbsolutePosition
    local absSize = main.AbsoluteSize
    halo.Position = UDim2.new(0, absPos.X + absSize.X/2, 0, absPos.Y + absSize.Y/2)
    local maxSide = math.max(absSize.X, absSize.Y)
    local haloSize = math.clamp(maxSide * 1.9, 300, 1000)
    halo.Size = UDim2.new(0, haloSize, 0, haloSize)
end
main:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateHalo)
main:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateHalo)
task.defer(updateHalo)

-- logo block
local logoFrame = Instance.new("Frame", header)
logoFrame.Name = "LogoFrame"
logoFrame.Size = UDim2.new(0,52,0,52)
logoFrame.Position = UDim2.new(0,12,0,2)
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

-- little dot
local logoDot = Instance.new("Frame", logoFrame)
logoDot.Size = UDim2.new(0,8,0,8)
logoDot.Position = UDim2.new(1,-14,0,6)
logoDot.BackgroundColor3 = Color3.fromRGB(255,240,120)
logoDot.BorderSizePixel = 0
local dotCorner = Instance.new("UICorner", logoDot)
dotCorner.CornerRadius = UDim.new(1,0)
logoDot.ZIndex = 7

-- glow image (faint) behind logo
local logoGlow = Instance.new("ImageLabel", logoFrame)
logoGlow.Name = "LogoGlow"
logoGlow.Size = UDim2.new(1.8,0,1.8,0)
logoGlow.Position = UDim2.new(-0.4,0,-0.4,0)
logoGlow.BackgroundTransparency = 1
logoGlow.Image = ASSETS.HALO_BIG
logoGlow.ImageTransparency = 0.88
logoGlow.ZIndex = 3
logoGlow.ScaleType = Enum.ScaleType.Slice
logoGlow.SliceCenter = Rect.new(10,10,118,118)

-- sparkle orbit (image that orbits logo)
local sparkle = Instance.new("ImageLabel", main)
sparkle.Name = "SparkleOrbit"
sparkle.Size = UDim2.new(0, 18, 0, 18)
sparkle.BackgroundTransparency = 1
sparkle.Image = ASSETS.SPARKLE_RING
sparkle.ZIndex = 6
sparkle.Visible = true

-- title + close button
local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-168,1,0)
title.Position = UDim2.new(0,76,0,0)
title.BackgroundTransparency = 1
title.Text = "Enter Key"
title.Font = Enum.Font.GothamSemibold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(235,235,235)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 5

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0,64,0,36)
closeBtn.Position = UDim2.new(1,-80,0,10)
closeBtn.BackgroundColor3 = Color3.fromRGB(28,28,28)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0,8)
local closeStroke = Instance.new("UIStroke", closeBtn)
closeStroke.Transparency = 0.8
closeStroke.Thickness = 1
closeBtn.ZIndex = 6

-- content area
local content = Instance.new("Frame", main)
content.Position = UDim2.new(0,0,0,56)
content.Size = UDim2.new(1,0,1,-56)
content.BackgroundTransparency = 1
content.ZIndex = 5

-- key UI elements
local keyLbl = Instance.new("TextLabel", content)
keyLbl.Size = UDim2.new(0,60,0,20)
keyLbl.Position = UDim2.new(0,16,0,8)
keyLbl.BackgroundTransparency = 1
keyLbl.Text = "Key:"
keyLbl.Font = Enum.Font.GothamSemibold
keyLbl.TextSize = 14
keyLbl.TextColor3 = Color3.fromRGB(200,200,200)
keyLbl.TextXAlignment = Enum.TextXAlignment.Left
keyLbl.ZIndex = 6

local keyBox = Instance.new("TextBox", content)
keyBox.Size = UDim2.new(0,300,0,36)
keyBox.Position = UDim2.new(0,16,0,36)
keyBox.BackgroundColor3 = Color3.fromRGB(18,18,18)
keyBox.BorderSizePixel = 0
keyBox.PlaceholderText = "Nhập key ở đây"
keyBox.Text = ""
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 16
keyBox.TextColor3 = Color3.fromRGB(230,230,230)
local keyCorner = Instance.new("UICorner", keyBox)
keyCorner.CornerRadius = UDim.new(0,8)
local keyStroke = Instance.new("UIStroke", keyBox)
keyStroke.Transparency = 0.85
keyStroke.Thickness = 1
keyBox.ZIndex = 6

local getBtn = Instance.new("TextButton", content)
getBtn.Size = UDim2.new(0,100,0,36)
getBtn.Position = UDim2.new(0,328,0,36)
getBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
getBtn.BorderSizePixel = 0
getBtn.Text = "Get Key"
getBtn.Font = Enum.Font.Gotham
getBtn.TextSize = 14
getBtn.TextColor3 = Color3.fromRGB(245,245,245)
local getCorner = Instance.new("UICorner", getBtn)
getCorner.CornerRadius = UDim.new(0,8)
local getStroke = Instance.new("UIStroke", getBtn)
getStroke.Transparency = 0.85
getBtn.ZIndex = 6

local submitBtn = Instance.new("TextButton", content)
submitBtn.Size = UDim2.new(0,200,0,44)
submitBtn.Position = UDim2.new(0,16,1,-16)
submitBtn.AnchorPoint = Vector2.new(0,1)
submitBtn.BackgroundColor3 = Color3.fromRGB(20,120,20)
submitBtn.BorderSizePixel = 0
submitBtn.Text = "Submit Key"
submitBtn.Font = Enum.Font.Gotham
submitBtn.TextSize = 16
submitBtn.TextColor3 = Color3.fromRGB(245,245,245)
local submitCorner = Instance.new("UICorner", submitBtn)
submitCorner.CornerRadius = UDim.new(0,8)
submitBtn.ZIndex = 6

local hint = Instance.new("TextLabel", content)
hint.Size = UDim2.new(0,360,0,24)
hint.Position = UDim2.new(0,16,0,84)
hint.BackgroundTransparency = 1
hint.Text = "Nếu không có key, bấm Get Key để sao chép link."
hint.Font = Enum.Font.Gotham
hint.TextSize = 13
hint.TextColor3 = Color3.fromRGB(170,170,170)
hint.TextXAlignment = Enum.TextXAlignment.Left
hint.ZIndex = 6

-- notification container
local notif = Instance.new("Frame", main)
notif.Size = UDim2.new(0, 320, 0, 40)
notif.Position = UDim2.new(0.5, -160, 0, -48)
notif.BackgroundTransparency = 1
notif.ZIndex = 12
local notifLbl = Instance.new("TextLabel", notif)
notifLbl.Size = UDim2.new(1,0,1,0)
notifLbl.BackgroundTransparency = 1
notifLbl.Text = ""
notifLbl.Font = Enum.Font.GothamBold
notifLbl.TextSize = 14
notifLbl.TextColor3 = Color3.fromRGB(255,255,255)
notifLbl.TextXAlignment = Enum.TextXAlignment.Center
notifLbl.ZIndex = 13

local function showNotification(text, color)
    notifLbl.Text = text
    notifLbl.TextColor3 = color or Color3.fromRGB(255,255,255)
    notif.Visible = true
    notif.Position = UDim2.new(0.5, -160, 0, -48)
    tween(notif, {Position = UDim2.new(0.5, -160, 0, 12)}, 0.28, "Back"):Play()
    task.wait(1.6)
    tween(notif, {Position = UDim2.new(0.5, -160, 0, -48)}, 0.22, "Quad"):Play()
    task.delay(0.25, function() notif.Visible = false end)
end

-- hover effects
local function addHoverSimple(btn)
    btn.MouseEnter:Connect(function() pcall(function() tween(btn, {BackgroundTransparency = 0.06}, 0.12):Play() end) end)
    btn.MouseLeave:Connect(function() pcall(function() tween(btn, {BackgroundTransparency = 0.4}, 0.12):Play() end) end)
end
getBtn.BackgroundTransparency = 0.4
addHoverSimple(getBtn)
addHoverSimple(submitBtn)
addHoverSimple(closeBtn)

-- close behavior
closeBtn.MouseButton1Click:Connect(function()
    pcall(function() screenGui:Destroy() end)
end)

-- Get Key (copy link)
getBtn.MouseButton1Click:Connect(function()
    local ok = false
    pcall(function()
        if setclipboard then
            setclipboard(COPY_LINK)
            ok = true
        else
            ok = false
        end
    end)
    if ok then
        showNotification("Link copied to clipboard!", Color3.fromRGB(80,200,120))
    else
        showNotification("Không thể copy — link đã in ra console.", Color3.fromRGB(230,180,80))
        warn("Copy link:", COPY_LINK)
    end
end)

-- draggable (header)
do
    local dragging = false
    local dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInput.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            updateHalo()
        end
    end)
end

-- sparkle orbit update (spawn)
spawn(function()
    local angle = 0
    while screenGui.Parent do
        local ok, logoAbs = pcall(function() return logoFrame.AbsolutePosition end)
        local ok2, mainAbs = pcall(function() return main.AbsolutePosition end)
        local ok3, logoSize = pcall(function() return logoFrame.AbsoluteSize end)
        if ok and ok2 and ok3 then
            local radius = math.clamp(logoSize.X * 1.7, 40, 90)
            angle = (angle + 8) % 360
            local radians = math.rad(angle)
            local cx = (logoAbs.X - mainAbs.X) + logoSize.X/2
            local cy = (logoAbs.Y - mainAbs.Y) + logoSize.Y/2
            local x = cx + math.cos(radians) * radius - (sparkle.AbsoluteSize.X/2)
            local y = cy + math.sin(radians) * radius - (sparkle.AbsoluteSize.Y/2)
            pcall(function()
                sparkle.Position = UDim2.new(0, x, 0, y)
                sparkle.Rotation = (sparkle.Rotation + 9) % 360
            end)
        end
        task.wait(0.03)
    end
end)

-- halo rotate + pulse
spawn(function()
    while screenGui.Parent do
        pcall(function() tween(halo, {Rotation = (halo.Rotation + 90) % 360}, 6, "Linear"):Play() end)
        local orig = halo.Size
        pcall(function() tween(halo, {Size = UDim2.new(orig.X.Scale, orig.X.Offset * 1.03, orig.Y.Scale, orig.Y.Offset * 1.03)}, 2.5, "Sine"):Play() end)
        task.wait(2.5)
        pcall(function() tween(halo, {Size = orig}, 2.5, "Sine"):Play() end)
        task.wait(2.5)
    end
end)

-- logo pulse (to/nhỏ)
spawn(function()
    while screenGui.Parent do
        pcall(function() tween(logoFrame, {Size = UDim2.new(0,60,0,60)}, 0.45, "Sine"):Play() end)
        pcall(function() tween(logoInner, {TextSize = 22}, 0.45, "Sine"):Play() end)
        task.wait(0.45)
        pcall(function() tween(logoFrame, {Size = UDim2.new(0,52,0,52)}, 0.45, "Sine"):Play() end)
        pcall(function() tween(logoInner, {TextSize = 20}, 0.45, "Sine"):Play() end)
        task.wait(0.45)
    end
end)

-- submit handler (run remote script on success)
local function run_remote_script(url)
    showNotification("Đang tải script...", Color3.fromRGB(200,200,60))
    -- try to fetch via game:HttpGet
    local ok, body = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok or not body or body == "" then
        -- try HttpService:GetAsync (some envs)
        local ok2, body2 = pcall(function()
            local HttpService = game:GetService("HttpService")
            return HttpService:GetAsync(url)
        end)
        ok, body = ok2, body2
    end
    if not ok or not body or body == "" then
        showNotification("Không thể tải script từ URL.", Color3.fromRGB(240,100,100))
        warn("Failed to download remote script:", url)
        return
    end

    -- try loadstring / load
    local loaded, err
    if loadstring then
        loaded, err = pcall(function() local f = loadstring(body); return f and f() end)
    else
        local ok3, f = pcall(function() return load(body) end)
        if ok3 and f then
            loaded, err = pcall(f)
        else
            loaded, err = false, "no loader available"
        end
    end

    if loaded then
        showNotification("Script đã chạy thành công.", Color3.fromRGB(80,200,120))
    else
        showNotification("Chạy script thất bại: "..tostring(err), Color3.fromRGB(240,100,100))
        warn("Execute error:", err)
    end
end

local function submitKey()
    local entered = tostring(keyBox.Text or ""):gsub("%s+","")
    if entered == "" then
        showNotification("Vui lòng nhập key.", Color3.fromRGB(240,120,120))
        return
    end
    if entered == VALID_KEY then
        showNotification("Key hợp lệ! Đang chạy...", Color3.fromRGB(80,200,120))
        task.delay(0.4, function()
            -- destroy UI then run remote (or keep UI if you want)
            pcall(function() screenGui:Destroy() end)
            -- run remote script
            run_remote_script(REMOTE_SCRIPT_URL)
        end)
    else
        showNotification("Key không hợp lệ.", Color3.fromRGB(240,100,100))
    end
end

submitBtn.MouseButton1Click:Connect(submitKey)
keyBox.FocusLost:Connect(function(enterPressed) if enterPressed then submitKey() end end)

-- initial focus
task.defer(function() keyBox:CaptureFocus() end)

print("[KeySystemGUI] Loaded with multi-halo, logo pulse, draggable. On correct key it will fetch & execute remote script:", REMOTE_SCRIPT_URL)
