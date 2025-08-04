local Library = {}

function Library:CreateWindow(config)
    local title = config.Title or "RedHub"
    local toggleKey = config.ToggleKey or Enum.KeyCode.RightControl

    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    ScreenGui.Name = "RedHub_GUI"

    local DragFrame = Instance.new("Frame", ScreenGui)
    DragFrame.Size = UDim2.new(0, 400, 0, 300)
    DragFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    DragFrame.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    DragFrame.BackgroundTransparency = 0.3
    DragFrame.BorderSizePixel = 0
    DragFrame.Active = true
    DragFrame.Draggable = true
    DragFrame.Name = "MainFrame"

    local Title = Instance.new("TextLabel", DragFrame)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 20
    Title.Name = "Title"

    local ToggleButton = Instance.new("TextButton", ScreenGui)
    ToggleButton.Size = UDim2.new(0, 50, 0, 50)
    ToggleButton.Position = UDim2.new(0, 20, 0.5, -25)
    ToggleButton.Text = "💀"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.TextColor3 = Color3.new(1, 0, 0)
    ToggleButton.TextScaled = true
    ToggleButton.Draggable = true
    ToggleButton.Active = true
    ToggleButton.Name = "ToggleBtn"

    local isVisible = true

    ToggleButton.MouseButton1Click:Connect(function()
        isVisible = not isVisible
        DragFrame.Visible = isVisible
    end)

    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.KeyCode == toggleKey then
            isVisible = not isVisible
            DragFrame.Visible = isVisible
        end
    end)

    return {
        Main = DragFrame,
        Toggle = ToggleButton
    }
end

return Library

-- AddTab(): tạo tab + khung nội dung tương ứng
function Library:AddTab(window, tabName)
    -- 🔍 Kiểm tra hoặc tạo SideBar chứa các nút tab
    local SideBar = window.Main:FindFirstChild("SideBar")
    if not SideBar then
        SideBar = Instance.new("Frame", window.Main)
        SideBar.Name = "SideBar"
        SideBar.Size = UDim2.new(0, 100, 1, -30) -- Chiều rộng 100, trừ tiêu đề 30
        SideBar.Position = UDim2.new(0, 0, 0, 30)
        SideBar.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
        SideBar.BackgroundTransparency = 0.3

        -- Sắp xếp tab theo hàng dọc
        local ListLayout = Instance.new("UIListLayout", SideBar)
        ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ListLayout.Padding = UDim.new(0, 4)
    end

    -- 🔘 Tạo nút tab (bên trái)
    local TabButton = Instance.new("TextButton", SideBar)
    TabButton.Size = UDim2.new(1, 0, 0, 30)
    TabButton.Text = tabName
    TabButton.BackgroundColor3 = Color3.fromRGB(90, 0, 0)
    TabButton.TextColor3 = Color3.new(1, 1, 1)
    TabButton.BorderSizePixel = 0
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 14
    TabButton.Name = "Tab_" .. tabName

    -- 📦 Tạo khung nội dung tương ứng cho tab
    local ContentFrame = Instance.new("ScrollingFrame", window.Main)
    ContentFrame.Size = UDim2.new(1, -100, 1, -30) -- Trừ phần tab bên trái và tiêu đề
    ContentFrame.Position = UDim2.new(0, 100, 0, 30)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    ContentFrame.BackgroundTransparency = 0.4
    ContentFrame.Name = "Content_" .. tabName
    ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.Visible = false -- ẩn ban đầu

    -- 📜 Tạo layout sắp xếp item trong nội dung
    local UIList = Instance.new("UIListLayout", ContentFrame)
    UIList.Padding = UDim.new(0, 6)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder

    -- ✅ Hiện tab đầu tiên mặc định
    local currentTabs = 0
    for _, child in ipairs(SideBar:GetChildren()) do
        if child:IsA("TextButton") then
            currentTabs += 1
        end
    end
    if currentTabs == 1 then
        ContentFrame.Visible = true
    end

    -- 🎯 Khi bấm tab thì hiện đúng nội dung
    TabButton.MouseButton1Click:Connect(function()
        for _, v in pairs(window.Main:GetChildren()) do
            if v:IsA("ScrollingFrame") and v.Name:match("^Content_") then
                v.Visible = false
            end
        end
        ContentFrame.Visible = true
    end)

    -- 📤 Trả về content frame để add button/toggle sau này
    return ContentFrame
end
