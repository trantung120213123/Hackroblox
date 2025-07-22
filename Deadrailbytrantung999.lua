--[[ Script GUI by Tien Tung
Rayfield UI + ESP + Lock NPC + Teleport + Speed + NoClip
Key: hhx44xhh
Mobile-Friendly + Notification
]]

-- Load Rayfield UI
loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local ESP_ON = false
local ESP_NPC_ON = false
local LockNPC = false
local savedPoints = {}
local noclip = false
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

-- GUI Init
local Window = Rayfield:CreateWindow({
Name = "Shit hub💩 by TranTung999",
LoadingTitle = "💩 Loading...",
LoadingSubtitle = "By TranTung999",
ConfigurationSaving = {
Enabled = false
},
KeySystem = true,
KeySettings = {
Title = "Shit hub💩",
Subtitle = "Key System",
Note = "Key = Nhập lại key vừa nãy đã nhập",
FileName = "TranTungUIKey",
SaveKey = true,
GrabKeyFromSite = false,
Key = "hhx44xhh"
}
})

------------------ MAIN TAB -------------------
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSlider({
Name = "Speed",
Range = {16, 200},
Increment = 1,
CurrentValue = 16,
Callback = function(Value)
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
Rayfield:Notify("Speed", "Đã chỉnh tốc độ!", 2)
end
})

MainTab:CreateToggle({
Name = "NoClip",
CurrentValue = false,
Callback = function(Value)
noclip = Value
Rayfield:Notify("NoClip", Value and "Bật" or "Tắt", 2)
end
})

MainTab:CreateToggle({
Name = "ESP người chơi",
CurrentValue = false,
Callback = function(Value)
ESP_ON = Value
Rayfield:Notify("ESP", Value and "Bật" or "Tắt", 2)
end
})

------------------ TELEPORT TAB -------------------
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

local savedPoints = {}
local maxPoints = 10
local pointFolder = TeleportTab:CreateSection("Saved Points")

TeleportTab:CreateButton({
    Name = "Save Point",
    Callback = function()
        if #savedPoints >= maxPoints then
            Rayfield:Notify({
                Title = "Thông báo",
                Content = "Đã đạt giới hạn 10 điểm!",
                Duration = 3,
                Image = 4483362458
            })
            return
        end

        local pos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        table.insert(savedPoints, pos)

        pointFolder:CreateButton({
            Name = "Point " .. #savedPoints,
            Callback = function()
                local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(pos)
                    Rayfield:Notify({
                        Title = "Dịch chuyển",
                        Content = "Đã dịch đến Point " .. #savedPoints,
                        Duration = 2,
                        Image = 4483362458
                    })
                end
            end,
        })
    end
})

------------------ PLAYER TAB -------------------
local PlayerTab = Window:CreateTab("Players", 4483362458)

local function LoadPlayers()
for _, p in pairs(players:GetPlayers()) do
if p ~= localPlayer then
PlayerTab:CreateButton({
Name = "TP đến: " .. p.Name,
Callback = function()
if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
localPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
end
end
})
end
end
end

PlayerTab:CreateButton({
Name = "🔁 Load lại danh sách",
Callback = LoadPlayers
})

LoadPlayers()

------------------ NPC TAB -------------------
local NPCTab = Window:CreateTab("NPC", 4483362458)

NPCTab:CreateToggle({
Name = "ESP NPC",
CurrentValue = false,
Callback = function(Value)
ESP_NPC_ON = Value
Rayfield:Notify("ESP NPC", Value and "Bật" or "Tắt", 2)
end
})

NPCTab:CreateToggle({
Name = "Lock NPC gần nhất",
CurrentValue = false,
Callback = function(Value)
LockNPC = Value
Rayfield:Notify("Lock NPC", Value and "Bật" or "Tắt", 2)
end
})

local SkinTab = Window:CreateTab("Skin", 4483362458)

local selectedTarget = nil

-- Dropdown chọn người chơi
local playerList = {}
for i, v in pairs(game.Players:GetPlayers()) do
    if v ~= game.Players.LocalPlayer then
        table.insert(playerList, v.Name)
    end
end

SkinTab:CreateDropdown({
    Name = "Chọn người để clone",
    Options = playerList,
    CurrentOption = "",
    Callback = function(Value)
        selectedTarget = game.Players:FindFirstChild(Value)
        Rayfield:Notify({
            Title = "Clone Skin",
            Content = "Đã chọn: " .. Value,
            Duration = 3
        })
    end,
})

-- Nút Clone Skin
SkinTab:CreateButton({
    Name = "👕 Clone Skin",
    Callback = function()
        if not selectedTarget then
            Rayfield:Notify({
                Title = "Lỗi",
                Content = "Bạn chưa chọn người chơi!",
                Duration = 3
            })
            return
        end

        local lp = game.Players.LocalPlayer
        local targetChar = selectedTarget.Character
        local myChar = lp.Character

        if targetChar and myChar then
            -- Xoá phụ kiện cũ
            for _, v in pairs(myChar:GetChildren()) do
                if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors") or v:IsA("ShirtGraphic") then
                    v:Destroy()
                end
            end

            -- Clone phụ kiện và quần áo
            for _, v in pairs(targetChar:GetChildren()) do
                if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors") or v:IsA("ShirtGraphic") then
                    local clone = v:Clone()
                    clone.Parent = myChar
                end
            end

            Rayfield:Notify({
                Title = "Clone Skin",
                Content = "Đã clone toàn bộ skin từ " .. selectedTarget.Name,
                Duration = 3
            })
        end
    end,
})

------------------ LOOP: ESP + LockNPC + NoClip -------------------
game:GetService("RunService").RenderStepped:Connect(function()
-- ✅ Sửa NoClip chuẩn:
if noclip and localPlayer.Character then
    for _, part in pairs(localPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide == true then
            part.CanCollide = false
        end
    end
end

-- ESP Player
if ESP_ON then
for _, plr in pairs(players:GetPlayers()) do
if plr ~= localPlayer and plr.Character and plr.Character:FindFirstChild("Head") and not plr.Character.Head:FindFirstChild("ESP") then
local box = Instance.new("BillboardGui", plr.Character.Head)
box.Name = "ESP"
box.Size = UDim2.new(2, 0, 2, 0)
box.AlwaysOnTop = true
local frame = Instance.new("Frame", box)
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundColor3 = Color3.new(1, 0, 0)
frame.BackgroundTransparency = 0.5
end
end
end

-- ESP NPC
if ESP_NPC_ON then
for _, npc in pairs(workspace:GetDescendants()) do
if npc:IsA("Model") and not players:GetPlayerFromCharacter(npc) and npc:FindFirstChild("Head") and not npc.Head:FindFirstChild("ESP") then
local esp = Instance.new("BillboardGui", npc.Head)
esp.Name = "ESP"
esp.Size = UDim2.new(2, 0, 2, 0)
esp.AlwaysOnTop = true
local frame = Instance.new("Frame", esp)
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundColor3 = Color3.new(0, 1, 0)
frame.BackgroundTransparency = 0.5
end
end
end

-- Lock NPC
if LockNPC then
local closest = nil
local minDist = math.huge
for _, npc in pairs(workspace:GetDescendants()) do
if npc:IsA("Model") and not players:GetPlayerFromCharacter(npc) and npc:FindFirstChild("Head") then
local dist = (npc.Head.Position - camera.CFrame.Position).Magnitude
if dist < minDist then
closest = npc
minDist = dist
end
end
end
if closest and closest:FindFirstChild("Head") then
camera.CFrame = CFrame.new(camera.CFrame.Position, closest.Head.Position)
end
end
end)
