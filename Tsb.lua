-- Full KK Hub Integration: Key GUI + Intro Animation + Persistent Logo
-- Paste into executor (client). Note: some executors block HttpGet/loadstring.

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Config
local VALID_KEY = "kkhubabcxyzjerkoff" -- đổi key nếu cần
local GET_KEY_LINK = "https://loodest.org/s?7eh25JTa"
local KK_V1_URL = "https://raw.githubusercontent.com/trantung120213123/Hackroblox/refs/heads/main/%C3%81io%20D%C3%AC%20m%E1%BA%A1%20z%E1%BA%A1%20d%C3%AD.lua"
local KK_V2_URL = "https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Trashcan%20Man"

-- Assets
local CLICK_SOUND_ID = "rbxassetid://2668781453"
local HALO_ID = "rbxassetid://4996891970"
local SPARKLE_ID = "rbxassetid://6035067836"
local DECO1_ID = "rbxassetid://7507672"
local DECO2_ID = "rbxassetid://5180300644"

-- Tween helper
local function tweenObject(obj, props, time, style, dir)
    local info = TweenInfo.new(time or 0.18, Enum.EasingStyle[style or "Quad"], Enum.EasingDirection[dir or "Out"])
    return TweenService:Create(obj, info, props)
end

-- Clean up existing GUIs
pcall(function()
    if player:FindFirstChildOfClass("PlayerGui") then
        for _, gui in ipairs({"TsbKeyGui", "KK_Chooser", "KKIntroGui", "KKPersistentLogo"}) do
            local existing = player.PlayerGui:FindFirstChild(gui)
            if existing then existing:Destroy() end
        end
    end
end)

-- Intro animation
local function showIntro()
    if not player or not player.Parent then return end
    local PlayerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KKIntroGui"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = PlayerGui

    -- Background shadow
    local bg = Instance.new("Frame", screenGui)
    bg.Size = UDim2.new(1,0,1,0)
    bg.Position = UDim2.new(0,0,0,0)
    bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
    bg.BackgroundTransparency = 0
    bg.ZIndex = 10

    -- Logo container
    local logoFrame = Instance.new("Frame", screenGui)
    logoFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    logoFrame.Position = UDim2.new(0.5, 0.5, 0.5, 0)
    logoFrame.Size = UDim2.new(0, 300, 0, 300)
    logoFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    logoFrame.BorderSizePixel = 0
    logoFrame.ZIndex = 50
    Instance.new("UICorner", logoFrame).CornerRadius = UDim.new(0, 28)

    -- Gradient
    local logoGrad = Instance.new("UIGradient", logoFrame)
    logoGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(120,60,200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60,200,200))
    }
    logoGrad.Rotation = 45

    -- Logo text
    local logoInner = Instance.new("TextLabel", logoFrame)
    logoInner.Size = UDim2.new(1, -36, 1, -36)
    logoInner.Position = UDim2.new(0,18,0,18)
    logoInner.BackgroundTransparency = 1
    logoInner.Text = "KK"
    logoInner.Font = Enum.Font.GothamBold
    logoInner.TextSize = 96
    logoInner.TextColor3 = Color3.fromRGB(245,245,245)
    logoInner.ZIndex = 52
    logoInner.TextXAlignment = Enum.TextXAlignment.Center
    logoInner.TextYAlignment = Enum.TextYAlignment.Center

    -- Small dot
    local logoDot = Instance.new("Frame", logoFrame)
    logoDot.Size = UDim2.new(0,18,0,18)
    logoDot.Position = UDim2.new(1, -36, 0, 18)
    logoDot.BackgroundColor3 = Color3.fromRGB(255,240,120)
    logoDot.BorderSizePixel = 0
    logoDot.ZIndex = 53
    Instance.new("UICorner", logoDot).CornerRadius = UDim.new(1,0)

    -- Glow effect
    local logoGlow = Instance.new("ImageLabel", logoFrame)
    logoGlow.Size = UDim2.new(1.8,0,1.8,0)
    logoGlow.Position = UDim2.new(-0.4,0,-0.4,0)
    logoGlow.BackgroundTransparency = 1
    logoGlow.Image = HALO_ID
    logoGlow.ImageTransparency = 0.88
    logoGlow.ZIndex = 49
    logoGlow.ScaleType = Enum.ScaleType.Slice
    logoGlow.SliceCenter = Rect.new(10,10,118,118)

    -- Shadow
    local logoShadow = Instance.new("Frame", screenGui)
    logoShadow.AnchorPoint = Vector2.new(0.5,0.5)
    logoShadow.Position = logoFrame.Position
    logoShadow.Size = UDim2.new(0, 340, 0, 340)
    logoShadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
    logoShadow.BackgroundTransparency = 0.85
    logoShadow.ZIndex = 48
    logoShadow.BorderSizePixel = 0
    Instance.new("UICorner", logoShadow).CornerRadius = UDim.new(0, 28)

    -- Pulse effect
    local alive = true
    spawn(function()
        while alive and logoFrame.Parent do
            tweenObject(logoFrame, {Size = UDim2.new(0, 320, 0, 320)}, 0.45, "Sine"):Play()
            tweenObject(logoInner, {TextSize = 104}, 0.45, "Sine"):Play()
            tweenObject(logoShadow, {Size = UDim2.new(0, 360, 0, 360)}, 0.45, "Sine"):Play()
            task.wait(0.45)
            
            tweenObject(logoFrame, {Size = UDim2.new(0, 300, 0, 300)}, 0.45, "Sine"):Play()
            tweenObject(logoInner, {TextSize = 96}, 0.45, "Sine"):Play()
            tweenObject(logoShadow, {Size = UDim2.new(0, 340, 0, 340)}, 0.45, "Sine"):Play()
            task.wait(0.45)
        end
    end)

    -- Sparkle orbit
    local sparkle = Instance.new("ImageLabel", screenGui)
    sparkle.Size = UDim2.new(0,18,0,18)
    sparkle.BackgroundTransparency = 1
    sparkle.Image = SPARKLE_ID
    sparkle.ZIndex = 51
    sparkle.Visible = true

    spawn(function()
        local angle = 0
        while alive and sparkle.Parent do
            local cx = logoFrame.AbsolutePosition.X + logoFrame.AbsoluteSize.X/2
            local cy = logoFrame.AbsolutePosition.Y + logoFrame.AbsoluteSize.Y/2
            angle = (angle + 8) % 360
            local r = math.clamp(logoFrame.AbsoluteSize.X * 1.7, 40, 90)
            local rad = math.rad(angle)
            local sx = cx + math.cos(rad) * r - (sparkle.AbsoluteSize.X/2)
            local sy = cy + math.sin(rad) * r - (sparkle.AbsoluteSize.Y/2)
            sparkle.Position = UDim2.new(0, sx, 0, sy)
            sparkle.Rotation = (sparkle.Rotation + 9) % 360
            task.wait(0.03)
        end
    end)

    -- Wait and fade out
    task.wait(2)
    alive = false
    
    local fadeTime = 0.8
    tweenObject(logoGlow, {ImageTransparency = 1}, fadeTime):Play()
    tweenObject(logoInner, {TextTransparency = 1}, fadeTime):Play()
    tweenObject(logoFrame, {BackgroundTransparency = 1}, fadeTime):Play()
    tweenObject(logoDot, {BackgroundTransparency = 1}, fadeTime):Play()
    tweenObject(logoShadow, {BackgroundTransparency = 1}, fadeTime):Play()
    tweenObject(bg, {BackgroundTransparency = 1}, fadeTime):Play()
    
    task.wait(fadeTime)
    screenGui:Destroy()
end

-- Persistent logo (bottom right)
local function createPersistentLogo()
    if not player or not player.Parent then return end
    local PlayerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KKPersistentLogo"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui
    
    local logo = Instance.new("ImageButton", screenGui)
    logo.Name = "Logo"
    logo.Size = UDim2.new(0, 50, 0, 50)
    logo.Position = UDim2.new(1, -60, 1, -60)
    logo.BackgroundColor3 = Color3.fromRGB(30,30,30)
    logo.BorderSizePixel = 0
    logo.ZIndex = 20
    Instance.new("UICorner", logo).CornerRadius = UDim.new(0.5,0)
    
    -- Gradient effect
    local grad = Instance.new("UIGradient", logo)
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(120,60,200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60,200,200))
    }
    grad.Rotation = 45
    
    -- Logo text
    local logoText = Instance.new("TextLabel", logo)
    logoText.Size = UDim2.new(1,0,1,0)
    logoText.BackgroundTransparency = 1
    logoText.Text = "KK"
    logoText.Font = Enum.Font.GothamSemibold
    logoText.TextSize = 20
    logoText.TextColor3 = Color3.fromRGB(245,245,245)
    logoText.ZIndex = 21
    
    -- Sparkle effect
    local sparkle = Instance.new("ImageLabel", logo)
    sparkle.Name = "Sparkle"
    sparkle.Size = UDim2.new(1.5,0,1.5,0)
    sparkle.Position = UDim2.new(-0.25,0,-0.25,0)
    sparkle.BackgroundTransparency = 1
    sparkle.Image = SPARKLE_ID
    sparkle.ImageTransparency = 0.7
    sparkle.ZIndex = 19
    
    -- Glow effect
    local glow = Instance.new("ImageLabel", logo)
    glow.Size = UDim2.new(1.8,0,1.8,0)
    glow.Position = UDim2.new(-0.4,0,-0.4,0)
    glow.BackgroundTransparency = 1
    glow.Image = HALO_ID
    glow.ImageTransparency = 0.88
    glow.ZIndex = 18
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(10,10,118,118)
    
    -- Animation loop
    spawn(function()
        while logo and logo.Parent do
            tweenObject(logo, {Rotation = 5}, 1, "Sine", "Out"):Play()
            tweenObject(sparkle, {Rotation = 45}, 1, "Sine", "Out"):Play()
            task.wait(1)
            tweenObject(logo, {Rotation = -5}, 1, "Sine", "Out"):Play()
            tweenObject(sparkle, {Rotation = -45}, 1, "Sine", "Out"):Play()
            task.wait(1)
        end
    end)
    
    -- Click to show version chooser
    logo.MouseButton1Click:Connect(function()
        spawn(function() loadstring(game:HttpGet(KK_V1_URL, true))() end)
    end)
end

-- Version chooser GUI
local function showVersionChooser()
    if not player or not player.Parent then return end
    local PlayerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KK_Chooser"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui

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

    -- Header
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

    -- Sparkle effect
    local sparkle = Instance.new("ImageLabel", screenGui)
    sparkle.Name = "SparkleOrbit"
    sparkle.Size = UDim2.new(0,18,0,18)
    sparkle.BackgroundTransparency = 1
    sparkle.Image = SPARKLE_ID
    sparkle.ZIndex = 12
    sparkle.Visible = true

    -- Buttons
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

    -- Button handlers
    v1.MouseButton1Click:Connect(function()
        snd:Play()
        spawn(function()
            loadstring(game:HttpGet(KK_V1_URL, true))()
        end)
        screenGui:Destroy()
    end)

    v2.MouseButton1Click:Connect(function()
        snd:Play()
        spawn(function()
            loadstring(game:HttpGet(KK_V2_URL, true))()
        end)
        screenGui:Destroy()
    end)

    -- Entrance animation
    panel.Size = UDim2.new(0,420,0,0)
    tweenObject(panel, {Size = UDim2.new(0,420,0,140)}, 0.18, "Back"):Play()

    -- Sparkle orbit animation
    spawn(function()
        local angle = 0
        while panel.Parent and sparkle.Parent do
            local cx = logo.AbsolutePosition.X + logo.AbsoluteSize.X/2
            local cy = logo.AbsolutePosition.Y + logo.AbsoluteSize.Y/2
            angle = (angle + 8) % 360
            local r = math.clamp(logo.AbsoluteSize.X * 1.7, 40, 90)
            local rad = math.rad(angle)
            local sx = cx + math.cos(rad) * r - (sparkle.AbsoluteSize.X/2)
            local sy = cy + math.sin(rad) * r - (sparkle.AbsoluteSize.Y/2)
            sparkle.Position = UDim2.new(0, sx, 0, sy)
            sparkle.Rotation = (sparkle.Rotation + 9) % 360
            task.wait(0.03)
        end
    end)
end

-- Key GUI (main)
local function createKeyGui()
    if not player or not player.Parent then return end
    local PlayerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TsbKeyGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui

    local panel = Instance.new("Frame", screenGui)
    panel.Size = UDim2.new(0,380,0,150)
    panel.Position = UDim2.new(0.5,0,0.5,0)
    panel.AnchorPoint = Vector2.new(0.5,0.5)
    panel.BackgroundColor3 = Color3.fromRGB(18,18,18)
    panel.BorderSizePixel = 0
    panel.ZIndex = 10
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0,12)
    local pst = Instance.new("UIStroke", panel); pst.Transparency = 0.85; pst.Thickness = 1

    -- Header with logo
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

    -- Key input
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

    -- Get Key button
    getKeyBtn.MouseButton1Click:Connect(function()
        clickSound:Play()
        local ok, err = pcall(function() setclipboard(GET_KEY_LINK) end)
        if ok then
            info.Text = "Key link copied to clipboard."
        else
            info.Text = "Copy not supported. Link: "..GET_KEY_LINK
        end
        task.delay(3, function() info.Text = "" end)
    end)

    -- Submit logic
    local function onSubmit()
        local entered = tostring(keyBox.Text or ""):gsub("%s+","")
        if entered == "" then
            info.Text = "Please enter a key."
            task.delay(2, function() info.Text = "" end)
            return
        end
        clickSound:Play()
        tweenObject(submitBtn, {BackgroundTransparency = 0.4}, 0.08):Play()
        task.delay(0.1, function() tweenObject(submitBtn, {BackgroundTransparency = 0}, 0.12):Play() end)

        if entered == VALID_KEY then
            info.Text = "Key valid. Opening chooser..."
            task.delay(0.25, function()
                screenGui:Destroy()
                showVersionChooser()
                createPersistentLogo()
            end)
        else
            info.Text = "Key invalid."
            task.delay(1.5, function() info.Text = "" end)
            -- Shake effect
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

    -- Entrance animation
    panel.Size = UDim2.new(0,380,0,0)
    tweenObject(panel, {Size = UDim2.new(0,380,0,150)}, 0.18, "Back"):Play()
end

-- Main flow
showIntro()
task.wait(2.8) -- Wait for intro to finish
createKeyGui()
