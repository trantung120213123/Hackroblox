local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PinkWhiteUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 480, 0, 360)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 240, 245)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(255, 105, 180)
uiStroke.Thickness = 2
uiStroke.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
titleBar.BackgroundTransparency = 0.25
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
titleLabel.Text = "Pink White UI"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 50, 0, 30)
minimizeBtn.Position = UDim2.new(1, -90, 0, 3)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 25
minimizeBtn.Text = "—"
minimizeBtn.AutoButtonColor = false
minimizeBtn.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 50, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 25
closeBtn.Text = "×"
closeBtn.AutoButtonColor = false
closeBtn.Parent = titleBar

-- Container Frame
local container = Instance.new("Frame")
container.Size = UDim2.new(1, 0, 1, -36)
container.Position = UDim2.new(0, 0, 0, 36)
container.BackgroundTransparency = 1
container.Parent = mainFrame

-- Tab Buttons Frame
local tabButtonsFrame = Instance.new("ScrollingFrame")
tabButtonsFrame.Size = UDim2.new(0, 120, 1, 0)
tabButtonsFrame.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
tabButtonsFrame.BackgroundTransparency = 0.15
tabButtonsFrame.BorderSizePixel = 0
tabButtonsFrame.ScrollBarThickness = 5
tabButtonsFrame.Parent = container

local tabListLayout = Instance.new("UIListLayout")
tabListLayout.Padding = UDim.new(0, 10)
tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabListLayout.Parent = tabButtonsFrame

tabButtonsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
tabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    tabButtonsFrame.CanvasSize = UDim2.new(0, 0, 0, tabListLayout.AbsoluteContentSize.Y + 10)
end)

-- Content Frame
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -120, 1, 0)
contentFrame.Position = UDim2.new(0, 120, 0, 0)
contentFrame.BackgroundColor3 = Color3.fromRGB(255, 240, 245)
contentFrame.BackgroundTransparency = 0.25
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 6
contentFrame.Parent = container

local contentListLayout = Instance.new("UIListLayout")
contentListLayout.Padding = UDim.new(0, 12)
contentListLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentListLayout.Parent = contentFrame

contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentListLayout.AbsoluteContentSize.Y + 15)
end)

-- Tabs management
local tabs = {}
local currentTab = nil

local function createTab(name)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(1, 0, 0, 40)
    tabButton.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
    tabButton.BackgroundTransparency = 0.15
    tabButton.BorderSizePixel = 0
    tabButton.Font = Enum.Font.GothamBold
    tabButton.TextSize = 18
    tabButton.TextColor3 = Color3.fromRGB(255, 105, 180)
    tabButton.Text = name
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.Parent = tabButtonsFrame

    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.Parent = contentFrame

    local tab = {
        button = tabButton,
        content = tabContent
    }
    table.insert(tabs, tab)

    tabButton.MouseButton1Click:Connect(function()
        if currentTab then
            currentTab.content.Visible = false
            currentTab.button.TextColor3 = Color3.fromRGB(255, 105, 180)
        end
        currentTab = tab
        currentTab.content.Visible = true
        currentTab.button.TextColor3 = Color3.fromRGB(255, 182, 193)
    end)

    return tabContent
end

-- Chức năng kéo thả GUI
do
    local dragging = false
    local dragInput, dragStart, startPos

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Nút thu nhỏ
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    if minimized then
        mainFrame.Size = UDim2.new(0, 480, 0, 360)
        container.Visible = true
        minimized = false
    else
        mainFrame.Size = UDim2.new(0, 480, 0, 36)
        container.Visible = false
        minimized = true
    end
end)

-- Nút đóng
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Các Control cơ bản

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    btn.Text = text or "Button"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.fromRGB(255, 105, 180)
    btn.AutoButtonColor = false
    btn.Parent = parent

    btn.MouseEnter:Connect(function()
        btn.BackgroundTransparency = 0
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundTransparency = 0.2
    end)
    btn.MouseButton1Click:Connect(function()
        if callback then pcall(callback) end
    end)

    return btn
end

local function createToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = text or "Toggle"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextColor3 = Color3.fromRGB(255, 105, 180)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 40, 0, 25)
    toggleBtn.Position = UDim2.new(0.85, 0, 0.2, 0)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(255, 105, 180) or Color3.fromRGB(200, 200, 200)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = frame
    toggleBtn.Text = ""

    local toggled = default or false
    local function update()
        if toggled then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        end
        if callback then pcall(callback, toggled) end
    end

    toggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        update()
    end)

    update()
    return frame
end

local function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = (text or "Slider")..": "..tostring(default)
    label.Font = Enum.Font.GothamBold
    label.TextColor3 = Color3.fromRGB(255, 105, 180)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 20)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 20)
    sliderFrame.Position = UDim2.new(0, 0, 0, 25)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
    sliderFrame.BackgroundTransparency = 0.3
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = frame

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderBar.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = sliderFrame

    local dragging = false

    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    sliderFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    sliderFrame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp(input.Position.X - sliderFrame.AbsolutePosition.X, 0, sliderFrame.AbsoluteSize.X)
            local value = min + (relativeX / sliderFrame.AbsoluteSize.X) * (max - min)
            sliderBar.Size = UDim2.new(relativeX / sliderFrame.AbsoluteSize.X, 0, 1, 0)
            label.Text = (text or "Slider")..": "..string.format("%.1f", value)
            if callback then pcall(callback, value) end
        end
    end)

    return frame
end

local function createDropdown(parent, text, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = text or "Dropdown"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextColor3 = Color3.fromRGB(255, 105, 180)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(0.3, -10, 1, 0)
    dropdownBtn.Position = UDim2.new(0.7, 10, 0, 0)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.TextColor3 = Color3.fromRGB(255, 105, 180)
    dropdownBtn.Font = Enum.Font.GothamBold
    dropdownBtn.TextSize = 18
    dropdownBtn.Text = default or options[1] or ""
    dropdownBtn.AutoButtonColor = false
    dropdownBtn.Parent = frame

    local dropdownList = Instance.new("ScrollingFrame")
    dropdownList.Size = UDim2.new(1, 0, 0, 0)
    dropdownList.Position = UDim2.new(0, 0, 1, 0)
    dropdownList.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
    dropdownList.BackgroundTransparency = 0.15
    dropdownList.BorderSizePixel = 0
    dropdownList.Visible = false
    dropdownList.Parent = frame
    dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 4)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = dropdownList

    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        dropdownList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    end)

    local expanded = false

    dropdownBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        dropdownList.Visible = expanded
        if expanded then
            dropdownList.Size = UDim2.new(1, 0, 0, math.min(150, listLayout.AbsoluteContentSize.Y))
        else
            dropdownList.Size = UDim2.new(1, 0, 0, 0)
        end
    end)

    for i, option in ipairs(options) do
        local optionBtn = Instance.new("TextButton")
        optionBtn.Size = UDim2.new(1, 0, 0, 30)
        optionBtn.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
        optionBtn.BackgroundTransparency = 0.2
        optionBtn.BorderSizePixel = 0
        optionBtn.Font = Enum.Font.GothamBold
        optionBtn.TextSize = 18
        optionBtn.TextColor3 = Color3.fromRGB(255, 105, 180)
        optionBtn.Text = option
        optionBtn.AutoButtonColor = false
        optionBtn.Parent = dropdownList

        optionBtn.MouseEnter:Connect(function()
            optionBtn.BackgroundTransparency = 0
        end)
        optionBtn.MouseLeave:Connect(function()
            optionBtn.BackgroundTransparency = 0.2
        end)

        optionBtn.MouseButton1Click:Connect(function()
            dropdownBtn.Text = option
            expanded = false
            dropdownList.Visible = false
            dropdownList.Size = UDim2.new(1, 0, 0, 0)
            if callback then pcall(callback, option) end
        end)
    end

    return frame
end

local function createTextbox(parent, text, placeholder, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = text or "Textbox"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextColor3 = Color3.fromRGB(255, 105, 180)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local textbox = Instance.new("TextBox")
    textbox.Size = UDim2.new(0.3, -10, 1, 0)
    textbox.Position = UDim2.new(0.7, 10, 0, 0)
    textbox.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
    textbox.BorderSizePixel = 0
    textbox.TextColor3 = Color3.fromRGB(255, 105, 180)
    textbox.Font = Enum.Font.GothamBold
    textbox.TextSize = 18
    textbox.PlaceholderText = placeholder or ""
    textbox.ClearTextOnFocus = false
    textbox.Parent = frame

    textbox.FocusLost:Connect(function(enterPressed)
        if enterPressed and callback then
            pcall(callback, textbox.Text)
        end
    end)

    return frame
end

-- Tạo một tab mẫu để test control
local tabTest = createTab("Test Controls")

createButton(tabTest, "Button Example", function()
    print("Button clicked!")
end)

createToggle(tabTest, "Toggle Example", false, function(state)
    print("Toggle state:", state)
end)

createSlider(tabTest, "Slider Example", 0, 100, 50, function(value)
    print("Slider value:", math.floor(value))
end)

createDropdown(tabTest, "Dropdown Example", {"Option 1", "Option 2", "Option 3"}, "Option 1", function(selection)
    print("Dropdown selected:", selection)
end)

createTextbox(tabTest, "Textbox Example", "Type here...", function(text)
    print("Textbox entered:", text)
end)

-- Mặc định chọn tab đầu tiên
tabs[1].button:MouseButton1Click():Wait()
