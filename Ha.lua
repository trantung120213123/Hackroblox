local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "QuestionGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 380, 0, 160)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BackgroundTransparency = 0.45
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 10)

local questionLabel = Instance.new("TextLabel", frame)
questionLabel.Size = UDim2.new(1, -20, 0, 40)
questionLabel.Position = UDim2.new(0, 10, 0, 10)
questionLabel.BackgroundTransparency = 1
questionLabel.Font = Enum.Font.GothamBold
questionLabel.TextSize = 22
questionLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
questionLabel.Text = "Câu hỏi: 123 + 1e82828 = ?"
questionLabel.TextXAlignment = Enum.TextXAlignment.Center

local answerBox = Instance.new("TextBox", frame)
answerBox.Size = UDim2.new(1, -20, 0, 40)
answerBox.Position = UDim2.new(0, 10, 0, 60)
answerBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
answerBox.TextColor3 = Color3.fromRGB(230, 230, 230)
answerBox.Font = Enum.Font.Gotham
answerBox.TextSize = 18
answerBox.ClearTextOnFocus = false
answerBox.PlaceholderText = "Nhập đáp án..."
answerBox.TextXAlignment = Enum.TextXAlignment.Center
answerBox.BorderSizePixel = 0
local boxCorner = Instance.new("UICorner", answerBox)
boxCorner.CornerRadius = UDim.new(0, 8)

local submitBtn = Instance.new("TextButton", frame)
submitBtn.Size = UDim2.new(0, 100, 0, 36)
submitBtn.Position = UDim2.new(0.5, -50, 0, 110)
submitBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
submitBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
submitBtn.Font = Enum.Font.GothamBold
submitBtn.TextSize = 18
submitBtn.Text = "Submit"
submitBtn.BorderSizePixel = 0
local btnCorner = Instance.new("UICorner", submitBtn)
btnCorner.CornerRadius = UDim.new(0, 10)

local feedbackLabel = Instance.new("TextLabel", screenGui)
feedbackLabel.Size = UDim2.new(0, 300, 0, 40)
feedbackLabel.Position = UDim2.new(0.5, 0, 0.3, 0)
feedbackLabel.AnchorPoint = Vector2.new(0.5, 0.5)
feedbackLabel.BackgroundTransparency = 1
feedbackLabel.Font = Enum.Font.GothamBold
feedbackLabel.TextSize = 28
feedbackLabel.TextColor3 = Color3.fromRGB(255, 70, 70)
feedbackLabel.Text = ""
feedbackLabel.Visible = false
feedbackLabel.ZIndex = 20

local blurEffect
local function createBlur()
    local blur = Instance.new("BlurEffect")
    blur.Name = "QuestionBlurEffect"
    blur.Size = 0
    blur.Parent = game:GetService("Lighting")
    return blur
end

local function showCorrectEffect()
    feedbackLabel.TextColor3 = Color3.fromRGB(160, 255, 160)
    feedbackLabel.Text = "shit hub hello"
    feedbackLabel.Visible = true
    feedbackLabel.Position = UDim2.new(0.5, 0, 0.3, 0)
    if not blurEffect then blurEffect = createBlur() end
    local tweenBlurIn = TweenService:Create(blurEffect, TweenInfo.new(1), {Size = 24})
    tweenBlurIn:Play()
    tweenBlurIn.Completed:Wait()
    local tweenTextIn = TweenService:Create(feedbackLabel, TweenInfo.new(1), {TextTransparency = 0})
    feedbackLabel.TextTransparency = 1
    tweenTextIn:Play()
    tweenTextIn.Completed:Wait()
    task.wait(1)
    local tweenTextOut = TweenService:Create(feedbackLabel, TweenInfo.new(1), {TextTransparency = 1})
    tweenTextOut:Play()
    tweenTextOut.Completed:Wait()
    local tweenBlurOut = TweenService:Create(blurEffect, TweenInfo.new(1), {Size = 0})
    tweenBlurOut:Play()
    tweenBlurOut.Completed:Wait()
    feedbackLabel.Visible = false
end

local function showWrong()
    feedbackLabel.TextColor3 = Color3.fromRGB(255, 70, 70)
    feedbackLabel.Text = "Cay chưa dốt v."
    feedbackLabel.Visible = true
    feedbackLabel.TextTransparency = 0
    delay(2, function()
        if feedbackLabel then
            local tweenOut = TweenService:Create(feedbackLabel, TweenInfo.new(0.6), {TextTransparency = 1})
            tweenOut:Play()
            tweenOut.Completed:Wait()
            feedbackLabel.Visible = false
        end
    end)
end

local function runCorrectScript()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/trantung120213123/Hackroblox/refs/heads/main/shithubtrantung999.lua", true))()
    end)
    if not success then
        warn("Lỗi khi chạy script đúng:", err)
    end
end

local function checkAnswer()
    local answer = answerBox.Text:lower():gsub("%s", "")
    if answer == "ngumoitraloi" then
        showCorrectEffect()
        runCorrectScript()
    else
        showWrong()
    end
end

submitBtn.MouseButton1Click:Connect(checkAnswer)
answerBox.FocusLost:Connect(function(enter)
    if enter then checkAnswer() end
end)
