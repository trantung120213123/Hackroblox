local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Configuration
local CORRECT_KEY = "kk123"
local SCRIPT_URL = "https://raw.githubusercontent.com/trantung120213123/Hackroblox/refs/heads/main/%C3%81io%20D%C3%AC%20m%E1%BA%A1%20z%E1%BA%A1%20d%C3%AD.lua"
local SAVE_KEY = "TSB_KeySystem_SavedKey"

-- GUI Setup (Steam Dark Theme)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SteamKeySystem"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 280)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
MainFrame.BackgroundTransparency = 0.15
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
TopBar.Parent = MainFrame

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 8)
UICorner2.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "TSB PREMIUM ACCESS"
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 40, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 40, 1, 0)
CloseButton.Position = UDim2.new(1, -40, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.Parent = TopBar

local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.new(0, 80, 0, 80)
Logo.Position = UDim2.new(0.5, -40, 0.15, 0)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://7072717362" -- Steam logo or your custom image
Logo.Parent = MainFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Name = "KeyBox"
KeyBox.Size = UDim2.new(0.8, 0, 0, 40)
KeyBox.Position = UDim2.new(0.1, 0, 0.5, -20)
KeyBox.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
KeyBox.PlaceholderText = "Enter your key..."
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(200, 200, 200)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
KeyBox.Parent = MainFrame

local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 4)
UICorner3.Parent = KeyBox

local SubmitButton = Instance.new("TextButton")
SubmitButton.Name = "SubmitButton"
SubmitButton.Size = UDim2.new(0.5, 0, 0, 40)
SubmitButton.Position = UDim2.new(0.25, 0, 0.7, 0)
SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
SubmitButton.Text = "SUBMIT KEY"
SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitButton.Font = Enum.Font.GothamBold
SubmitButton.TextSize = 14
SubmitButton.Parent = MainFrame

local UICorner4 = Instance.new("UICorner")
UICorner4.CornerRadius = UDim.new(0, 4)
UICorner4.Parent = SubmitButton

local RememberCheckbox = Instance.new("TextButton")
RememberCheckbox.Name = "RememberCheckbox"
RememberCheckbox.Size = UDim2.new(0, 20, 0, 20)
RememberCheckbox.Position = UDim2.new(0.1, 0, 0.85, -10)
RememberCheckbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
RememberCheckbox.Text = ""
RememberCheckbox.Parent = MainFrame

local UICorner5 = Instance.new("UICorner")
UICorner5.CornerRadius = UDim.new(0, 2)
UICorner5.Parent = RememberCheckbox

local Checkmark = Instance.new("TextLabel")
Checkmark.Name = "Checkmark"
Checkmark.Size = UDim2.new(1, 0, 1, 0)
Checkmark.Position = UDim2.new(0, 0, 0, 0)
Checkmark.BackgroundTransparency = 1
Checkmark.Text = "✓"
Checkmark.TextColor3 = Color3.fromRGB(0, 200, 0)
Checkmark.Font = Enum.Font.GothamBold
Checkmark.TextSize = 16
Checkmark.Visible = false
Checkmark.Parent = RememberCheckbox

local RememberLabel = Instance.new("TextLabel")
RememberLabel.Name = "RememberLabel"
RememberLabel.Size = UDim2.new(0, 200, 0, 20)
RememberLabel.Position = UDim2.new(0.1, 25, 0.85, -10)
RememberLabel.BackgroundTransparency = 1
RememberLabel.Text = "Remember my key"
RememberLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
RememberLabel.Font = Enum.Font.Gotham
RememberLabel.TextSize = 12
RememberLabel.TextXAlignment = Enum.TextXAlignment.Left
RememberLabel.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(0.8, 0, 0, 20)
StatusLabel.Position = UDim2.new(0.1, 0, 0.6, 10)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.Parent = MainFrame

-- Load saved key if exists
local function LoadKey()
    local success, saved = pcall(function()
        return HttpService:JSONDecode(readfile(SAVE_KEY))
    end)
    
    if success and saved and saved.key == CORRECT_KEY then
        KeyBox.Text = saved.key
        RememberCheckbox.Checkmark.Visible = true
        return true
    end
    return false
end

-- Save key to file
local function SaveKey(key)
    local data = {
        key = key,
        timestamp = os.time()
    }
    
    pcall(function()
        writefile(SAVE_KEY, HttpService:JSONEncode(data))
    end)
end

-- Delete saved key
local function DeleteKey()
    pcall(function()
        delfile(SAVE_KEY)
    end)
end

-- Animation functions
local function Pulse(obj, intensity)
    local tweenInfo = TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.InOut,
        -1,
        true
    )
    
    local goal = {}
    goal.BackgroundTransparency = intensity
    local tween = TweenService:Create(obj, tweenInfo, goal)
    tween:Play()
    return tween
end

local function Shake(obj)
    local startPos = obj.Position
    local shakeOffset = UDim2.new(0, math.random(-5, 5), 0, math.random(-5, 5))
    
    local tween = TweenService:Create(obj, TweenInfo.new(0.1), {Position = startPos + shakeOffset})
    tween:Play()
    
    tween.Completed:Connect(function()
        local returnTween = TweenService:Create(obj, TweenInfo.new(0.2), {Position = startPos})
        returnTween:Play()
    end)
end

-- Check key and load script
local function CheckKey(key)
    if key == CORRECT_KEY then
        StatusLabel.Text = "✓ Key accepted! Loading script..."
        StatusLabel.TextColor3 = Color3.fromRGB(0, 200, 0)
        
        -- Save key if checkbox is checked
        if RememberCheckbox.Checkmark.Visible then
            SaveKey(key)
        else
            DeleteKey()
        end
        
        -- Load remote script
        local success, err = pcall(function()
            local script = game:HttpGet(SCRIPT_URL)
            loadstring(script)()
        end)
        
        if not success then
            StatusLabel.Text = "Error loading script: " .. err
            StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
        
        -- Close GUI after delay
        delay(2, function()
            ScreenGui:Destroy()
        end)
    else
        StatusLabel.Text = "✗ Invalid key! Try again."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        Shake(KeyBox)
    end
end

-- Connect events
RememberCheckbox.MouseButton1Click:Connect(function()
    RememberCheckbox.Checkmark.Visible = not RememberCheckbox.Checkmark.Visible
end)

SubmitButton.MouseButton1Click:Connect(function()
    CheckKey(KeyBox.Text)
end)

KeyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        CheckKey(KeyBox.Text)
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Pulse animation for submit button
Pulse(SubmitButton, 0.3)

-- Try to load saved key
if LoadKey() then
    CheckKey(CORRECT_KEY)
end
