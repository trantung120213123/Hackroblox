-- Tải Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- UI Window
local Window = Rayfield:CreateWindow({
   Name = "Tung Script Hub",
   LoadingTitle = "TranTungxChatGpt",
   ConfigurationSaving = {
      Enabled = false,
   },
})

-- 💀 Toggle Button
Window:ToggleWindow()

-- Tab: Main
local MainTab = Window:CreateTab("Main")

-- Speed Slider
MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 100},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

-- NoClip Toggle
local noclip = false
MainTab:CreateToggle({
   Name = "NoClip",
   CurrentValue = false,
   Callback = function(state)
      noclip = state
      Rayfield:Notify({Title="NoClip", Content=state and "Bật" or "Tắt", Duration=2.5})
   end,
})

game:GetService("RunService").Stepped:Connect(function()
   if noclip then
      for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
         if v:IsA("BasePart") then
            v.CanCollide = false
         end
      end
   end
end)

-- ESP (Players + NPC)
local function createESP(part, name)
   local esp = Instance.new("BillboardGui", part)
   esp.Size = UDim2.new(0,100,0,40)
   esp.Adornee = part
   esp.AlwaysOnTop = true
   local text = Instance.new("TextLabel", esp)
   text.Size = UDim2.new(1,0,1,0)
   text.BackgroundTransparency = 1
   text.TextColor3 = Color3.new(1,0,0)
   text.Text = name
   text.TextScaled = true
end

MainTab:CreateButton({
   Name = "Bật ESP",
   Callback = function()
      for _,v in pairs(game:GetDescendants()) do
         if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("Head") then
            if v ~= game.Players.LocalPlayer.Character then
               createESP(v.Head, v.Name)
            end
         end
      end
      Rayfield:Notify({Title="ESP", Content="Đã bật ESP cho NPC & người chơi", Duration=2.5})
   end,
})

-- Auto Aim Lock to Nearest NPC Head
local aiming = false
MainTab:CreateToggle({
   Name = "Lock NPC (Auto Aim)",
   CurrentValue = false,
   Callback = function(state)
      aiming = state
      Rayfield:Notify({Title="Lock NPC", Content=state and "Đang Ghim Tâm" or "Tắt Ghim", Duration=2.5})
   end,
})

-- Aim Lock Code
local camera = game.Workspace.CurrentCamera
game:GetService("RunService").RenderStepped:Connect(function()
   if aiming then
      local nearest, shortest = nil, math.huge
      for _,v in pairs(game:GetDescendants()) do
         if v:IsA("Model") and v:FindFirstChild("Head") and v:FindFirstChild("Humanoid") and v ~= game.Players.LocalPlayer.Character then
            local headPos = camera:WorldToViewportPoint(v.Head.Position)
            local distance = (Vector2.new(headPos.X, headPos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
            if distance < shortest then
               shortest = distance
               nearest = v.Head
            end
         end
      end
      if nearest then
         camera.CFrame = CFrame.new(camera.CFrame.Position, nearest.Position)
      end
   end
end)

-- Tab: Teleport
local TeleTab = Window:CreateTab("Teleport")
local savedPoints = {}

TeleTab:CreateButton({
   Name = "Save Point",
   Callback = function()
      local char = game.Players.LocalPlayer.Character
      if char then
         local pos = char.HumanoidRootPart.Position
         table.insert(savedPoints, pos)
         TeleTab:CreateButton({
            Name = "TP Point "..#savedPoints,
            Callback = function()
               char:MoveTo(pos)
               Rayfield:Notify({Title="Teleport", Content="Đã dịch chuyển về điểm đã lưu", Duration=2})
            end,
         })
      end
   end,
})

-- Tab: Players
local PlayerTab = Window:CreateTab("Players")
local dropdown
local selectedPlayer = nil

dropdown = PlayerTab:CreateDropdown({
   Name = "Chọn người chơi",
   Options = {},
   CurrentOption = "",
   Callback = function(Value)
      selectedPlayer = game.Players:FindFirstChild(Value)
   end,
})

PlayerTab:CreateButton({
   Name = "Tải lại danh sách người chơi",
   Callback = function()
      local names = {}
      for _,p in pairs(game.Players:GetPlayers()) do
         if p.Name ~= game.Players.LocalPlayer.Name then
            table.insert(names, p.Name)
         end
      end
      dropdown:SetOptions(names)
   end,
})

PlayerTab:CreateButton({
   Name = "Teleport đến người chơi",
   Callback = function()
      if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
         game.Players.LocalPlayer.Character:MoveTo(selectedPlayer.Character.HumanoidRootPart.Position)
         Rayfield:Notify({Title="Teleport", Content="Đã dịch chuyển đến người chơi", Duration=2})
      end
   end,
})

-- Tab: Misc
local MiscTab = Window:CreateTab("Misc")
MiscTab:CreateParagraph({Title="Script by", Content="TranTungxChatGpt"})

Rayfield:Notify({
   Title = "Tung Script Hub",
   Content = "Đã khởi động script thành công!",
   Duration = 3
})
