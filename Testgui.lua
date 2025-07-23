-- Load Venyx UI
local Venyx = loadstring(game:HttpGet("https://raw.githubusercontent.com/monkey-codes/VenyxUI/main/main.lua"))()
local venyx = Venyx.new("Tien Tung Hub 💀", 5013109572)

-- Tabs
local main = venyx:addPage("Main", 5012544693)
local teleport = venyx:addPage("Teleport", 5012544693)
local players = venyx:addPage("Players", 5012544693)
local misc = venyx:addPage("Misc", 5012544693)

local mainSection = main:addSection("Main Functions")

-- Speed slider
mainSection:addSlider("Speed", 16, 16, 200, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

-- NoClip toggle
local noclip = false
mainSection:addToggle("NoClip", false, function(value)
    noclip = value
    game:GetService("RunService").Stepped:Connect(function()
        if noclip then
            for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end)
end)

-- ESP toggle
mainSection:addToggle("ESP", false, function(state)
    if state then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                local esp = Instance.new("Highlight", player.Character)
                esp.Name = "ESP_Highlight"
                esp.FillColor = Color3.fromRGB(255, 0, 0)
                esp.OutlineColor = Color3.fromRGB(255, 255, 255)
                esp.FillTransparency = 0.5
                esp.OutlineTransparency = 0
            end
        end
    else
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("ESP_Highlight") then
                player.Character.ESP_Highlight:Destroy()
            end
        end
    end
end)

local TeleportPage = venyx:addPage("Teleport", 5012544693)
local TeleportSection = TeleportPage:addSection("Save & Teleport")

local savedPoints = {}

TeleportSection:addButton("Save Point", function()
    local pos = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    if pos then
        table.insert(savedPoints, pos)
        venyx:Notify("Teleport", "Đã lưu điểm: " .. tostring(#savedPoints), 2)
    end
end)

TeleportSection:addButton("Teleport to Point 1", function()
    if savedPoints[1] then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(savedPoints[1])
    end
end)

TeleportSection:addButton("Teleport to Point 2", function()
    if savedPoints[2] then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(savedPoints[2])
    end
end)

TeleportSection:addButton("Teleport to Point 3", function()
    if savedPoints[3] then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(savedPoints[3])
    end
end)

Players = venyx:CreateTab("Players", 5012544693)
local playerSection = Players:CreateSection("Player Teleport")

Players:CreateButton({
    Title = "Load Player List",
    Callback = function()
        local playerList = {}
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Name ~= game.Players.LocalPlayer.Name then
                table.insert(playerList, player.Name)
            end
        end
        venyx:Notify("Đã load danh sách", "Số người chơi: "..#playerList)
    end
})

Players:CreateTextbox({
    Title = "Tên người chơi",
    Text = "",
    Callback = function(playerName)
        local target = game.Players:FindFirstChild(playerName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position)
            venyx:Notify("Đã dịch chuyển", "Tới người chơi: " .. playerName)
        else
            venyx:Notify("Không tìm thấy", "Người chơi không hợp lệ hoặc chưa tải xong")
        end
    end
})
