-- Key System GUI (dark rounded, no minimize/resize)
-- Features:
--  - Header "X" button sẽ xóa GUI key
--  - TextBox nhập key; key hợp lệ = "kk123"
--  - "Get Key" copy link https://yeumoney.com/0HD6w (pcall setclipboard)
--  - Animated notifications (success/error/copy)
--  - No minimize/resize; GUI giống style trước (đen, bo tròn)
-- WARNING: setclipboard chỉ hoạt động trên một số executor.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- nếu đã có GUI cũ thì remove
local EXIST = player:FindFirstChildOfClass("PlayerGui") and player.PlayerGui:FindFirstChild("KeySystemGUI")
if EXIST then EXIST:Destroy() end

-- ===== helper: tween shortcut =====
local function tween(obj, props, t, style, dir)
    local info = TweenInfo.new(t or 0.18, Enum.EasingStyle[style or "Quad"], Enum.EasingDirection[dir or "Out"])
    return TweenService:Create(obj, info, props)
end

-- ===== create GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeySystemGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 420, 0, 220)
main.Position = UDim2.new(0, 20, 0, 80)
main.BackgroundColor3 = Color3.fromRGB(12,12,12)
main.BackgroundTransparency = 0.10
main.BorderSizePixel = 0
main.Parent = screenGui
main.Active = true
main.ClipsDescendants = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0,12)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255,255,255)
stroke.Transparency = 0.92
stroke.Thickness = 1
local grad = Instance.new("UIGradient", main)
grad.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, Color3.fromRGB(18,18,18)), ColorSequenceKeypoint.new(1, Color3.fromRGB(28,28,28)) }
grad.Rotation = 270

-- Header
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,48)
header.BackgroundTransparency = 1

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-80,1,0)
title.Position = UDim2.new(0,16,0,0)
title.BackgroundTransparency = 1
title.Text = "Enter Key"
title.Font = Enum.Font.GothamSemibold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(235,235,235)
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0,64,0,32)
closeBtn.Position = UDim2.new(1,-80,0,8)
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

-- Content
local content = Instance.new("Frame", main)
content.Position = UDim2.new(0,0,0,48)
content.Size = UDim2.new(1,0,1,-48)
content.BackgroundTransparency = 1

-- Key input label
local keyLbl = Instance.new("TextLabel", content)
keyLbl.Size = UDim2.new(0,1,0,20)
keyLbl.Position = UDim2.new(0,16,0,8)
keyLbl.BackgroundTransparency = 1
keyLbl.Text = "Key:"
keyLbl.Font = Enum.Font.GothamSemibold
keyLbl.TextSize = 14
keyLbl.TextColor3 = Color3.fromRGB(200,200,200)
keyLbl.TextXAlignment = Enum.TextXAlignment.Left

-- TextBox
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

-- Get Key button (copy link)
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

-- Submit button
local submitBtn = Instance.new("TextButton", content)
submitBtn.Size = UDim2.new(0,200,0,44)
submitBtn.Position = UDim2.new(0,16,1,-16) -- anchored bottom-left style
submitBtn.AnchorPoint = Vector2.new(0,1)
submitBtn.BackgroundColor3 = Color3.fromRGB(20,120,20)
submitBtn.BorderSizePixel = 0
submitBtn.Text = "Submit Key"
submitBtn.Font = Enum.Font.Gotham
submitBtn.TextSize = 16
submitBtn.TextColor3 = Color3.fromRGB(245,245,245)
local submitCorner = Instance.new("UICorner", submitBtn)
submitCorner.CornerRadius = UDim.new(0,8)

-- Small helper text
local hint = Instance.new("TextLabel", content)
hint.Size = UDim2.new(0,360,0,24)
hint.Position = UDim2.new(0,16,0,84)
hint.BackgroundTransparency = 1
hint.Text = "Nếu không có key, bấm Get Key để sao chép link."
hint.Font = Enum.Font.Gotham
hint.TextSize = 13
hint.TextColor3 = Color3.fromRGB(170,170,170)
hint.TextXAlignment = Enum.TextXAlignment.Left

-- Notification container (top of main)
local notif = Instance.new("Frame", main)
notif.Size = UDim2.new(0, 300, 0, 40)
notif.Position = UDim2.new(0.5, -150, 0, -48)
notif.BackgroundTransparency = 1
notif.ZIndex = 6
local notifLbl = Instance.new("TextLabel", notif)
notifLbl.Size = UDim2.new(1,0,1,0)
notifLbl.BackgroundTransparency = 1
notifLbl.Text = ""
notifLbl.Font = Enum.Font.GothamBold
notifLbl.TextSize = 14
notifLbl.TextColor3 = Color3.fromRGB(255,255,255)
notifLbl.TextXAlignment = Enum.TextXAlignment.Center

-- notification function
local function showNotification(text, color)
    notifLbl.Text = text
    notifLbl.TextColor3 = color or Color3.fromRGB(255,255,255)
    notif.BackgroundTransparency = 1
    notif.Visible = true
    -- tween slide down + fade
    notif.Position = UDim2.new(0.5, -150, 0, -48)
    tween(notif, {Position = UDim2.new(0.5, -150, 0, 12)}, 0.28, "Back"):Play()
    wait(1.6)
    tween(notif, {Position = UDim2.new(0.5, -150, 0, -48)}, 0.22, "Quad"):Play()
    task.delay(0.25, function() notif.Visible = false end)
end

-- ===== logic =====
local VALID_KEY = "kk123" -- key hợp lệ
local COPY_LINK = "https://yeumoney.com/0HD6w"

-- close button: destroy key GUI
closeBtn.MouseButton1Click:Connect(function()
    pcall(function() screenGui:Destroy() end)
end)

-- Get Key: copy link to clipboard (pcall)
getBtn.MouseButton1Click:Connect(function()
    local ok, err = pcall(function()
        if setclipboard then
            setclipboard(COPY_LINK)
        elseif queue_on_teleport then
            -- no setclipboard support; fallback to printing link
            error("no setclipboard")
        else
            error("no setclipboard")
        end
    end)
    if ok then
        showNotification("Link copied to clipboard!", Color3.fromRGB(80,200,120))
    else
        showNotification("Không thể copy — link đã in ra console.", Color3.fromRGB(230,180,80))
        warn("Copy link:", COPY_LINK)
    end
end)

-- submit action (button or Enter)
local function submitKey()
    local entered = tostring(keyBox.Text or ""):gsub("%s+", "")
    if entered == "" then
        showNotification("Vui lòng nhập key.", Color3.fromRGB(240,120,120))
        return
    end
    if entered == VALID_KEY then
        showNotification("Key hợp lệ! Access granted.", Color3.fromRGB(80,200,120))
        -- remove key GUI after short delay
        task.delay(0.6, function()
            pcall(function() screenGui:Destroy() end)
        end)
    else
        showNotification("Key không hợp lệ.", Color3.fromRGB(240,100,100))
    end
end

submitBtn.MouseButton1Click:Connect(submitKey)
keyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then submitKey() end
end)

-- hover effects
local function addHoverSimple(btn)
    btn.MouseEnter:Connect(function() pcall(function() tween(btn, {BackgroundTransparency = 0.06}, 0.12):Play() end) end)
    btn.MouseLeave:Connect(function() pcall(function() tween(btn, {BackgroundTransparency = 0.4}, 0.12):Play() end) end)
end
dropdownBtn.BackgroundTransparency = 0.45
getBtn.BackgroundTransparency = 0.4
addHoverSimple(getBtn)
addHoverSimple(submitBtn)
addHoverSimple(closeBtn)

-- initial focus
task.defer(function()
    keyBox:CaptureFocus()
end)

print("[KeySystemGUI] Loaded. Valid key = '"..VALID_KEY.."'.")
