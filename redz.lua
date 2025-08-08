local Redz = {}
Redz.__index = Redz

-- Cấu hình mặc định
local DEFAULT_CONFIG = {
    PrimaryColor = Color3.fromRGB(255, 50, 50),
    BackgroundTransparency = 0.7,
    AnimationSpeed = 0.25,
    MinimizeKey = Enum.KeyCode.RightControl
}

function Redz.new(title, config)
    local self = setmetatable({}, Redz)
    self.config = setmetatable(config or {}, {__index = DEFAULT_CONFIG})
    self.title = title or "Redz GUI"
    self.tabs = {}
    self.isMinimized = false
    
    self:CreateMainWindow()
    self:SetupDragging()
    self:SetupMinimize()
    self:SetupResizing()
    
    return self
end

function Redz:CreateMainWindow()
    -- Main container
    self.mainFrame = Instance.new("Frame")
    self.mainFrame.Name = "RedzMainFrame"
    self.mainFrame.BackgroundColor3 = self.config.PrimaryColor
    self.mainFrame.BackgroundTransparency = self.config.BackgroundTransparency
    self.mainFrame.BorderSizePixel = 0
    self.mainFrame.ClipsDescendants = true
    
    -- Title bar
    self.titleBar = Instance.new("Frame")
    self.titleBar.Name = "TitleBar"
    self.titleBar.BackgroundColor3 = self.config.PrimaryColor
    self.titleBar.BackgroundTransparency = 0.5
    self.titleBar.Size = UDim2.new(1, 0, 0, 30)
    
    -- Title text
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = self.title
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Size = UDim2.new(1, -60, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    
    -- Close button
    self.closeButton = Instance.new("TextButton")
    self.closeButton.Text = "X"
    self.closeButton.Size = UDim2.new(0, 30, 1, 0)
    self.closeButton.Position = UDim2.new(1, -30, 0, 0)
    self.closeButton.BackgroundTransparency = 1
    self.closeButton.TextColor3 = Color3.new(1, 1, 1)
    self.closeButton.Font = Enum.Font.GothamBold
    
    -- Assemble
    titleLabel.Parent = self.titleBar
    self.closeButton.Parent = self.titleBar
    self.titleBar.Parent = self.mainFrame
    
    -- Tab container
    self.tabContainer = Instance.new("Frame")
    self.tabContainer.Name = "TabContainer"
    self.tabContainer.BackgroundTransparency = 1
    self.tabContainer.Size = UDim2.new(1, 0, 0, 40)
    self.tabContainer.Position = UDim2.new(0, 0, 0, 30)
    self.tabContainer.Parent = self.mainFrame
    
    -- Content container
    self.contentFrame = Instance.new("Frame")
    self.contentFrame.Name = "ContentFrame"
    self.contentFrame.BackgroundTransparency = 1
    self.contentFrame.Size = UDim2.new(1, 0, 1, -70)
    self.contentFrame.Position = UDim2.new(0, 0, 0, 70)
    self.contentFrame.Parent = self.mainFrame
    
    -- Initial position and size
    self.mainFrame.Size = UDim2.new(0, 500, 0, 400)
    self.mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    self.mainFrame.Parent = game:GetService("CoreGui")
end

function Redz:ToggleMinimize()
    self.isMinimized = not self.isMinimized
    
    local tweenInfo = TweenInfo.new(
        self.config.AnimationSpeed,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    
    if self.isMinimized then
        -- Thu nhỏ chỉ hiển thị thanh tiêu đề
        local tween = game:GetService("TweenService"):Create(
            self.mainFrame,
            tweenInfo,
            {Size = UDim2.new(0, 200, 0, 30)}
        )
        tween:Play()
    else
        -- Phóng to lại kích thước ban đầu
        local tween = game:GetService("TweenService"):Create(
            self.mainFrame,
            tweenInfo,
            {Size = UDim2.new(0, 500, 0, 400)}
        )
        tween:Play()
    end
end

function Redz:SetupDragging()
    local dragging, dragInput, dragStart, startPos
    
    self.titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            self.mainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

function Redz:SetupResizing()
    local resizing, resizeStart, startSize
    
    local resizeHandle = Instance.new("Frame")
    resizeHandle.Name = "ResizeHandle"
    resizeHandle.BackgroundTransparency = 1
    resizeHandle.Size = UDim2.new(0, 20, 0, 20)
    resizeHandle.Position = UDim2.new(1, -20, 1, -20)
    resizeHandle.Parent = self.mainFrame
    
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStart = input.Position
            startSize = self.mainFrame.Size
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                end
            end)
        end
    end)
    
    resizeHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and resizing then
            local delta = input.Position - resizeStart
            local newWidth = math.max(300, startSize.X.Offset + delta.X)
            local newHeight = math.max(200, startSize.Y.Offset + delta.Y)
            
            self.mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)
end

function Redz:CreateTab(name)
    local tab = {}
    tab.name = name
    
    -- Tab button
    tab.button = Instance.new("TextButton")
    tab.button.Text = name
    tab.button.TextColor3 = Color3.new(1, 1, 1)
    tab.button.BackgroundColor3 = self.config.PrimaryColor
    tab.button.BackgroundTransparency = 0.7
    tab.button.Size = UDim2.new(0, 100, 1, 0)
    tab.button.Position = UDim2.new(0, #self.tabs * 100, 0, 0)
    tab.button.Parent = self.tabContainer
    
    -- Tab content
    tab.content = Instance.new("Frame")
    tab.content.Name = name .. "Content"
    tab.content.BackgroundTransparency = 1
    tab.content.Size = UDim2.new(1, 0, 1, 0)
    tab.content.Visible = false
    tab.content.Parent = self.contentFrame
    
    -- Select first tab by default
    if #self.tabs == 0 then
        tab.content.Visible = true
        tab.button.BackgroundTransparency = 0.3
    end
    
    -- Tab selection logic
    tab.button.MouseButton1Click:Connect(function()
        for _, otherTab in pairs(self.tabs) do
            otherTab.content.Visible = false
            otherTab.button.BackgroundTransparency = 0.7
        end
        tab.content.Visible = true
        tab.button.BackgroundTransparency = 0.3
    end)
    
    -- Add controls creation methods
    function tab:CreateButton(props)
        -- Similar to Rayfield button implementation
        -- with red theme and animations
    end
    
    -- Add other control creation methods (Toggle, Slider, etc.)
    
    table.insert(self.tabs, tab)
    return tab
end

