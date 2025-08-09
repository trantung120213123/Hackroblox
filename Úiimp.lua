local library = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

function library:CreateWindow(title)
    -- Tạo ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PinkWhiteUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    -- Main Frame (window chính)
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 450, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(255, 240, 245) -- Hồng trắng nhạt
    MainFrame.BackgroundTransparency = 0.15 -- trong suốt nhẹ
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.Active = true -- cho Input hoạt động

    -- Bóng mờ viền (UIStroke) hồng nhẹ cho đẹp
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 105, 180) -- hồng nóng
    stroke.Thickness = 2
    stroke.Parent = MainFrame

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.BackgroundColor3 = Color3.fromRGB(255, 182, 193) -- hồng pastel
    TitleBar.BackgroundTransparency = 0.2
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -70, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 20
    TitleLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
    TitleLabel.Text = title or "Pink White UI"
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    -- Nút Thu nhỏ / Phóng to
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 50, 0, 30)
    MinimizeBtn.Position = UDim2.new(1, -60, 0, 2)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    MinimizeBtn.TextColor3 = Color3.new(1,1,1)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 20
    MinimizeBtn.Text = "—"
    MinimizeBtn.AutoButtonColor = false
    MinimizeBtn.Parent = TitleBar

    -- Nút Đóng UI
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 50, 0, 30)
    CloseBtn.Position = UDim2.new(1, -105, 0, 2)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 20
    CloseBtn.Text = "×"
    CloseBtn.AutoButtonColor = false
    CloseBtn.Parent = TitleBar

    -- Container chính để chứa Tab buttons bên trái và Content bên phải
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 1, -35)
    Container.Position = UDim2.new(0, 0, 0, 35)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame

    -- Tab Buttons Frame (bên trái)
    local TabButtonsFrame = Instance.new("ScrollingFrame")
    TabButtonsFrame.Size = UDim2.new(0, 120, 1, 0)
    TabButtonsFrame.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
    TabButtonsFrame.BackgroundTransparency = 0.15
    TabButtonsFrame.BorderSizePixel = 0
    TabButtonsFrame.ScrollBarThickness = 5
    TabButtonsFrame.Parent = Container

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 10)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Parent = TabButtonsFrame

    TabButtonsFrame.CanvasSize = UDim2.new(0,0,0,0)
    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabButtonsFrame.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 10)
    end)

    -- Content Frame (bên phải)
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -120, 1, 0)
    ContentFrame.Position = UDim2.new(0, 120, 0, 0)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(255, 240, 245)
    ContentFrame.BackgroundTransparency = 0.25
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ScrollBarThickness = 6
    ContentFrame.Parent = Container

    local ContentListLayout = Instance.new("UIListLayout")
    ContentListLayout.Padding = UDim.new(0, 12)
    ContentListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentListLayout.Parent = ContentFrame

    ContentFrame.CanvasSize = UDim2.new(0,0,0,0)
    ContentListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentListLayout.AbsoluteContentSize.Y + 15)
    end)

    -- Các biến quản lý tab
    local tabs = {}
    local currentTab = nil

    -- Kéo thả cửa sổ MainFrame
    do
        local dragging = false
        local dragInput, dragStart, startPos

        TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        TitleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    -- Thu nhỏ / phóng to GUI
    local minimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        if minimized then
            MainFrame.Size = UDim2.new(0, 450, 0, 350)
            ContentFrame.Visible = true
            TabButtonsFrame.Visible = true
            minimized = false
            MinimizeBtn.Text = "—"
        else
            MainFrame.Size = UDim2.new(0, 200, 0, 40)
            ContentFrame.Visible = false
            TabButtonsFrame.Visible = false
            minimized = true
            MinimizeBtn.Text = "+"
        end
    end)

    -- Đóng GUI
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Hàm tạo tab
    function library:AddTab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, -20, 0, 40)
        tabButton.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
        tabButton.TextColor3 = Color3.new(1,1,1)
        tabButton.Font = Enum.Font.GothamBold
        tabButton.TextSize = 18
        tabButton.Text = name
        tabButton.BorderSizePixel = 0
        tabButton.Parent = TabButtonsFrame

        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = ContentFrame

        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 10)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = tabContent

        table.insert(tabs, {button = tabButton, content = tabContent})

        if #tabs == 1 then
            tabButton.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
            tabContent.Visible = true
            currentTab = tabContent
        end

        tabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(tabs) do
                t.button.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
                t.content.Visible = false
            end
            tabButton.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
            tabContent.Visible = true
            currentTab = tabContent
        end)

        return tabContent
    end

    -- Trả về các thành phần chính để dùng tiếp
    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        AddTab = library.AddTab,
        ContentFrame = ContentFrame,
        TabButtonsFrame = TabButtonsFrame,
        _tabs = tabs
    }
end

return library

local libraryControls = {}

local TweenService = game:GetService("TweenService")

-- Tạo Button
function libraryControls:CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    btn.Text = text or "Button"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.fromRGB(255, 105, 180)
    btn.AutoButtonColor = false
    btn.Parent = parent

    local function tweenColor(toColor, toTransparency)
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = toColor, BackgroundTransparency = toTransparency}):Play()
    end

    btn.MouseEnter:Connect(function()
        tweenColor(Color3.fromRGB(255, 105, 180), 0)
    end)

    btn.MouseLeave:Connect(function()
        tweenColor(Color3.fromRGB(255, 182, 193), 0.2)
    end)

    btn.MouseButton1Click:Connect(function()
        tweenColor(Color3.fromRGB(255, 70, 140), 0)
        wait(0.1)
        tweenColor(Color3.fromRGB(255, 182, 193), 0.2)
        if callback then
            pcall(callback)
        end
    end)

    return btn
end

-- Tạo Toggle
function libraryControls:CreateToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = text or "Toggle"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextColor3 = Color3.fromRGB(255, 105, 180)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.8, 0, 1, 0)
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

    local function updateToggle()
        if toggled then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        end
        if callback then
            pcall(callback, toggled)
        end
    end

    toggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        updateToggle()
    end)

    updateToggle()

    return frame
end

-- Tạo Slider
function libraryControls:CreateSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = (text or "Slider") .. ": " .. tostring(default)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(255, 105, 180)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 20)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, 0, 0, 10)
    sliderBar.Position = UDim2.new(0, 0, 0, 30)
    sliderBar.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = frame

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar

    local dragging = false

    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local pos = input.Position.X - sliderBar.AbsolutePosition.X
            local val = math.clamp(pos / sliderBar.AbsoluteSize.X, 0, 1)
            sliderFill.Size = UDim2.new(val, 0, 1, 0)
            local value = min + val * (max - min)
            label.Text = (text or "Slider") .. ": " .. string.format("%.2f", value)
            if callback then pcall(callback, value) end
        end
    end)

    sliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    sliderBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = input.Position.X - sliderBar.AbsolutePosition.X
            local val = math.clamp(pos / sliderBar.AbsoluteSize.X, 0, 1)
            sliderFill.Size = UDim2.new(val, 0, 1, 0)
            local value = min + val * (max - min)
            label.Text = (text or "Slider") .. ": " .. string.format("%.2f", value)
            if callback then pcall(callback, value) end
        end
    end)

    return frame
end

-- Tạo Dropdown
function libraryControls:CreateDropdown(parent, text, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = text or "Dropdown"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextColor3 = Color3.fromRGB(255, 105, 180)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local selectedText = Instance.new("TextButton")
    selectedText.Size = UDim2.new(0.5, -10, 1, 0)
    selectedText.Position = UDim2.new(0.5, 10, 0, 0)
    selectedText.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
    selectedText.BackgroundTransparency = 0.2
    selectedText.BorderSizePixel = 0
    selectedText.Text = default or (options[1] or "")
    selectedText.Font = Enum.Font.GothamBold
    selectedText.TextSize = 16
    selectedText.TextColor3 = Color3.fromRGB(255, 105, 180)
    selectedText.Parent = frame
    selectedText.AutoButtonColor = false

    local dropdownOpen = false
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(0, selectedText.AbsoluteSize.X, 0, #options * 30)
    dropdownFrame.Position = UDim2.new(0.5, 10, 1, 5)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
    dropdownFrame.BackgroundTransparency = 0.15
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.ClipsDescendants = true
    dropdownFrame.Visible = false
    dropdownFrame.Parent = frame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = dropdownFrame

    for i, option in ipairs(options) do
        local optionBtn = Instance.new("TextButton")
        optionBtn.Size = UDim2.new(1, 0, 0, 25)
        optionBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
        optionBtn.BackgroundTransparency = 0.15
        optionBtn.BorderSizePixel = 0
        optionBtn.Text = option
        optionBtn.TextColor3 = Color3.new(1,1,1)
        optionBtn.Font = Enum.Font.GothamBold
        optionBtn.TextSize = 16
        optionBtn.Parent = dropdownFrame
        optionBtn.AutoButtonColor = false

        optionBtn.MouseEnter:Connect(function()
            optionBtn.BackgroundTransparency = 0
        end)
        optionBtn.MouseLeave:Connect(function()
            optionBtn.BackgroundTransparency = 0.15
        end)

        optionBtn.MouseButton1Click:Connect(function()
            selectedText.Text = option
            dropdownFrame.Visible = false
            dropdownOpen = false
            if callback then
                pcall(callback, option)
            end
        end)
    end

    selectedText.MouseButton1Click:Connect(function()
        dropdownOpen = not dropdownOpen
        dropdownFrame.Visible = dropdownOpen
    end)

    return frame
end

-- Tạo Textbox
function libraryControls:CreateTextbox(parent, text, placeholder, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = text or "Textbox"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextColor3 = Color3.fromRGB(255, 105, 180)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.3, 0, 1, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local textbox = Instance.new("TextBox")
    textbox.Size = UDim2.new(0.65, 0, 1, 0)
    textbox.Position = UDim2.new(0.35, 10, 0, 0)
    textbox.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
    textbox.BackgroundTransparency = 0.2
    textbox.TextColor3 = Color3.fromRGB(255, 105, 180)
    textbox.Font = Enum.Font.GothamBold
    textbox.TextSize = 16
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

return libraryControls
