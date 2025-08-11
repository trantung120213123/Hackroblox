-- Full Key GUI + Version Chooser (based on Tsb.lua style)
-- Paste into executor (client). Note: some executors block HttpGet/loadstring.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Config
local VALID_KEY = "kk123" -- đổi key nếu cần
local GET_KEY_LINK = "https://pastefy.app/zJzNKM8Z"
local KK_V1_URL = "https://raw.githubusercontent.com/trantung120213123/Hackroblox/refs/heads/main/%C3%81io%20D%C3%AC%20m%E1%BA%A1%20z%E1%BA%A1%20d%C3%AD.lua"
local KK_V2_URL = "https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Trashcan%20Man"

-- Assets
local CLICK_SOUND_ID = "rbxassetid://2668781453"
local HALO_ID = "rbxassetid://4996891970"
local SPARKLE_ID = "rbxassetid://6035067836"
local DECO1_ID = "rbxassetid://7507672"
local DECO2_ID = "rbxassetid://5180300644"

-- safe destroy
pcall(function()
    if player:FindFirstChildOfClass("PlayerGui") and player.PlayerGui:FindFirstChild("TsbKeyGui") then
        player.PlayerGui.TsbKeyGui:Destroy()
    end
    if player:FindFirstChildOfClass("PlayerGui") and player.PlayerGui:FindFirstChild("KK_Chooser") then
        player.PlayerGui.KK_Chooser:Destroy()
    end
end)

-- tween helper
local function tweenObject(obj, props, time, style, dir)
    local info = TweenInfo.new(time or 0.18, Enum.EasingStyle[style or "Quad"], Enum.EasingDirection[dir or "Out"])
    return TweenService:Create(obj, info, props)
end

-- Version chooser GUI
local function showVersionChooser()
    if not player or not player.Parent then return end
    if player.PlayerGui:FindFirstChild("KK_Chooser") then
        player.PlayerGui.KK_Chooser:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KK_Chooser"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local back = Instance.new("Frame", screenGui)
    back.Size = UDim2.new(1,0,1,0)
    back.Position = UDim2.new(0,0,0,0)
    back.BackgroundColor3 = Color3.fromRGB(0,0,0)
    back.BackgroundTransparency = 0.55
    back.BorderSizePixel = 0
    back.ZIndex = 10

    local panel = Instance.new("Frame", screenGui)
    panel.Name = "Panel"
    panel.Size = UDim2.new(0,420,0,140)
    panel.Position = UDim2.new(0.5,0,0.5,0)
    panel.AnchorPoint = Vector2.new(0.5,0.5)
    panel.BackgroundColor3 = Color3.fromRGB(20,20,22)
    panel.BorderSizePixel = 0
    panel.ZIndex = 11
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0,12)
    local pstroke = Instance.new("UIStroke", panel); pstroke.Transparency = 0.85; pstroke.Thickness = 1

    -- header + logo (Tsb style)
    local header = Instance.new("Frame", panel)
    header.Size = UDim2.new(1,0,0,52)
    header.Position = UDim2.new(0,0,0,0)
    header.BackgroundTransparency = 1
    header.ZIndex = 12

    local logo = Instance.new("Frame", header)
    logo.Size = UDim2.new(0,52,0,52)
    logo.Position = UDim2.new(0,12,0,0)
    logo.BackgroundColor3 = Color3.fromRGB(30,30,30)
    logo.BorderSizePixel = 0
    logo.ZIndex = 13
    Instance.new("UICorner", logo).CornerRadius = UDim.new(0,12)
    local lgrad = Instance.new("UIGradient", logo)
    lgrad.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, Color3.fromRGB(120,60,200)), ColorSequenceKeypoint.new(1, Color3.fromRGB(60,200,200)) }
    lgrad.Rotation = 45
    local ltxt = Instance.new("TextLabel", logo)
    ltxt.Size = UDim2.new(1,-8,1,-8); ltxt.Position = UDim2.new(0,4,0,4)
    ltxt.BackgroundTransparency = 1; ltxt.Text = "KK"; ltxt.Font = Enum.Font.GothamSemibold; ltxt.TextSize = 20
    ltxt.TextColor3 = Color3.fromRGB(245,245,245); ltxt.TextXAlignment = Enum.TextXAlignment.Center; ltxt.TextYAlignment = Enum.TextYAlignment.Center
    local ydot = Instance.new("Frame", logo); ydot.Size = UDim2.new(0,8,0,8); ydot.Position = UDim2.new(1,-14,0,6); ydot.BackgroundColor3 = Color3.fromRGB(255,240,120); ydot.BorderSizePixel = 0; Instance.new("UICorner", ydot).CornerRadius = UDim.new(1,0)
    local glow = Instance.new("ImageLabel", logo); glow.Size = UDim2.new(1.8,0,1.8,0); glow.Position = UDim2.new(-0.4,0,-0.4,0); glow.BackgroundTransparency = 1; glow.Image = HALO_ID; glow.ImageTransparency = 0.88; glow.ZIndex = 12; glow.ScaleType = Enum.ScaleType.Slice; glow.SliceCenter = Rect.new(10,10,118,118)

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1,0,1,0); title.Position = UDim2.new(0,0,0,0)
    title.BackgroundTransparency = 1; title.Text = "Choose kk hub version"; title.Font = Enum.Font.GothamSemibold; title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(240,240,240); title.TextXAlignment = Enum.TextXAlignment.Center; title.ZIndex = 14

    -- sparkle (absolute)
    local sparkle = Instance.new("ImageLabel", screenGui)
    sparkle.Name = "SparkleOrbit"
    sparkle.Size = UDim2.new(0,18,0,18)
    sparkle.BackgroundTransparency = 1
    sparkle.Image = SPARKLE_ID
    sparkle.ZIndex = 12
    sparkle.Visible = true

    -- two buttons
    local btnW = 170
    local gap = 20
    local startX = (420 - (btnW*2) - gap) / 2

    local v1 = Instance.new("TextButton", panel)
    v1.Size = UDim2.new(0, btnW, 0, 56)
    v1.Position = UDim2.new(0, startX, 0, 68)
    v1.BackgroundColor3 = Color3.fromRGB(28,28,28)
    v1.BorderSizePixel = 0
    v1.Font = Enum.Font.Gotham
    v1.Text = "kk hub v1"
    v1.TextSize = 18
    v1.TextColor3 = Color3.fromRGB(230,230,230)
    v1.ZIndex = 14
    Instance.new("UICorner", v1).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", v1).Transparency = 0.8

    local v2 = Instance.new("TextButton", panel)
    v2.Size = UDim2.new(0, btnW, 0, 56)
    v2.Position = UDim2.new(0, startX + btnW + gap, 0, 68)
    v2.BackgroundColor3 = Color3.fromRGB(28,28,28)
    v2.BorderSizePixel = 0
    v2.Font = Enum.Font.Gotham
    v2.Text = "kk hub v2"
    v2.TextSize = 18
    v2.TextColor3 = Color3.fromRGB(230,230,230)
    v2.ZIndex = 14
    Instance.new("UICorner", v2).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", v2).Transparency = 0.8

    local snd = Instance.new("Sound", panel)
    snd.SoundId = CLICK_SOUND_ID
    snd.Volume = 0.6

    -- handlers
    v1.MouseButton1Click:Connect(function()
        pcall(function() snd:Play() end)
        spawn(function()
            local ok, err = pcall(function()
                loadstring(game:HttpGet(KK_V1_URL, true))()
            end)
            if not ok then warn("kk v1 failed:", err) end
        end)
        pcall(function() screenGui:Destroy() end)
    end)

    v2.MouseButton1Click:Connect(function()
        pcall(function() snd:Play() end)
        spawn(function()
            local ok, err = pcall(function()
                loadstring(game:HttpGet(KK_V2_URL, true))()
            end)
            if not ok then warn("kk v2 failed:", err) end
        end)
        pcall(function() screenGui:Destroy() end)
    end)

    -- entrance animation
    panel.Size = UDim2.new(0,420,0,0)
    tweenObject(panel, {Size = UDim2.new(0,420,0,140)}, 0.18, "Back"):Play()

    -- sparkle orbit loop
    spawn(function()
        local angle = 0
        while panel.Parent and sparkle.Parent do
            local ok, ax, ay, aw, ah = pcall(function()
                return logo.AbsolutePosition.X, logo.AbsolutePosition.Y, logo.AbsoluteSize.X, logo.AbsoluteSize.Y
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
end

-- Key GUI (main)
local function createKeyGui()
    if not player or not player.Parent then return end
    if player.PlayerGui:FindFirstChild("TsbKeyGui") then
        player.PlayerGui.TsbKeyGui:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TsbKeyGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local panel = Instance.new("Frame", screenGui)
    panel.Size = UDim2.new(0,380,0,150)
    panel.Position = UDim2.new(0.5,0,0.5,0)
    panel.AnchorPoint = Vector2.new(0.5,0.5)
    panel.BackgroundColor3 = Color3.fromRGB(18,18,18)
    panel.BorderSizePixel = 0
    panel.ZIndex = 10
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0,12)
    local pst = Instance.new("UIStroke", panel); pst.Transparency = 0.85; pst.Thickness = 1

    -- header area with logo + "Key System" text + Get Key button
    local header = Instance.new("Frame", panel)
    header.Size = UDim2.new(1,0,0,56)
    header.Position = UDim2.new(0,0,0,0)
    header.BackgroundTransparency = 1
    header.ZIndex = 11

    local logo = Instance.new("Frame", header)
    logo.Size = UDim2.new(0,48,0,48)
    logo.Position = UDim2.new(0,10,0,4)
    logo.BackgroundColor3 = Color3.fromRGB(30,30,30)
    logo.BorderSizePixel = 0
    Instance.new("UICorner", logo).CornerRadius = UDim.new(0,10)
    local lg = Instance.new("UIGradient", logo); lg.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(120,60,200)), ColorSequenceKeypoint.new(1, Color3.fromRGB(60,200,200))}; lg.Rotation = 45
    local ltxt = Instance.new("TextLabel", logo); ltxt.Size = UDim2.new(1,-6,1,-6); ltxt.Position = UDim2.new(0,3,0,3); ltxt.BackgroundTransparency = 1; ltxt.Text = "KK"; ltxt.Font = Enum.Font.GothamSemibold; ltxt.TextSize = 16; ltxt.TextColor3 = Color3.fromRGB(245,245,245)
    local glow = Instance.new("ImageLabel", logo); glow.Size = UDim2.new(1.6,0,1.6,0); glow.Position = UDim2.new(-0.3,0,-0.3,0); glow.BackgroundTransparency = 1; glow.Image = HALO_ID; glow.ImageTransparency = 0.9; glow.ZIndex = 9

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -120, 1, 0)
    title.Position = UDim2.new(0,72,0,0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamSemibold
    title.Text = "Key System"
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(240,240,240)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 11

    local getKeyBtn = Instance.new("TextButton", header)
    getKeyBtn.Size = UDim2.new(0,96,0,32)
    getKeyBtn.Position = UDim2.new(1,-108,0,12)
    getKeyBtn.AnchorPoint = Vector2.new(0,0)
    getKeyBtn.BackgroundColor3 = Color3.fromRGB(28,28,28)
    getKeyBtn.BorderSizePixel = 0
    getKeyBtn.Text = "Get Key"
    getKeyBtn.Font = Enum.Font.Gotham
    getKeyBtn.TextSize = 14
    getKeyBtn.TextColor3 = Color3.fromRGB(230,230,230)
    getKeyBtn.ZIndex = 11
    Instance.new("UICorner", getKeyBtn).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", getKeyBtn).Transparency = 0.85

    local clickSound = Instance.new("Sound", panel); clickSound.SoundId = CLICK_SOUND_ID; clickSound.Volume = 0.6

    -- input + submit
    local keyBox = Instance.new("TextBox", panel)
    keyBox.Size = UDim2.new(0,240,0,36)
    keyBox.Position = UDim2.new(0,16,0,72)
    keyBox.BackgroundColor3 = Color3.fromRGB(26,26,26)
    keyBox.BorderSizePixel = 0
    keyBox.Font = Enum.Font.Gotham
    keyBox.TextSize = 16
    keyBox.TextColor3 = Color3.fromRGB(230,230,230)
    keyBox.PlaceholderText = "Enter key..."
    keyBox.ZIndex = 11
    Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", keyBox).Transparency = 0.9

    local submitBtn = Instance.new("TextButton", panel)
    submitBtn.Size = UDim2.new(0,96,0,36)
    submitBtn.Position = UDim2.new(0,272,0,72)
    submitBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    submitBtn.BorderSizePixel = 0
    submitBtn.Text = "Submit"
    submitBtn.Font = Enum.Font.Gotham
    submitBtn.TextSize = 14
    submitBtn.TextColor3 = Color3.fromRGB(230,230,230)
    submitBtn.ZIndex = 11
    Instance.new("UICorner", submitBtn).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", submitBtn).Transparency = 0.85

    local info = Instance.new("TextLabel", panel)
    info.Size = UDim2.new(1,-32,0,16)
    info.Position = UDim2.new(0,16,0,116)
    info.BackgroundTransparency = 1
    info.Text = ""
    info.Font = Enum.Font.Gotham
    info.TextSize = 12
    info.TextColor3 = Color3.fromRGB(200,200,200)
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.ZIndex = 11

    -- Get Key behavior: copy link to clipboard if available, else show link in info
    getKeyBtn.MouseButton1Click:Connect(function()
        pcall(function() clickSound:Play() end)
        local ok, err = pcall(function() setclipboard(GET_KEY_LINK) end)
        if ok then
            info.Text = "Key link copied to clipboard."
        else
            info.Text = "Copy not supported. Link: "..GET_KEY_LINK
        end
        task.delay(3, function() if info and info.Parent then info.Text = "" end end)
    end)

    -- submit logic
    local function onSubmit()
        local entered = tostring(keyBox.Text or ""):gsub("%s+","")
        if entered == "" then
            info.Text = "Please enter a key."
            task.delay(2, function() if info and info.Parent then info.Text = "" end end)
            return
        end
        pcall(function() clickSound:Play() end)
        tweenObject(submitBtn, {BackgroundTransparency = 0.4}, 0.08):Play()
        task.delay(0.1, function() tweenObject(submitBtn, {BackgroundTransparency = 0}, 0.12):Play() end)

        if entered == VALID_KEY then
            info.Text = "Key valid. Opening chooser..."
            task.delay(0.25, function()
                pcall(function() screenGui:Destroy() end)
                showVersionChooser()
            end)
        else
            info.Text = "Key invalid."
            task.delay(1.5, function() if info and info.Parent then info.Text = "" end end)
            -- slight shake
            spawn(function()
                local orig = panel.Position
                tweenObject(panel, {Position = UDim2.new(orig.X.Scale, orig.X.Offset - 6, orig.Y.Scale, orig.Y.Offset)}, 0.04, "Linear"):Play()
                task.wait(0.04)
                tweenObject(panel, {Position = UDim2.new(orig.X.Scale, orig.X.Offset + 6, orig.Y.Scale, orig.Y.Offset)}, 0.04, "Linear"):Play()
                task.wait(0.04)
                tweenObject(panel, {Position = orig}, 0.04, "Linear"):Play()
            end)
        end
    end

    submitBtn.MouseButton1Click:Connect(onSubmit)
    keyBox.FocusLost:Connect(function(enter) if enter then onSubmit() end end)

    -- pop in panel
    panel.Size = UDim2.new(0,380,0,0)
    tweenObject(panel, {Size = UDim2.new(0,380,0,150)}, 0.18, "Back"):Play()
end

-- start
createKeyGui()
