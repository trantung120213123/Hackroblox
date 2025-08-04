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
