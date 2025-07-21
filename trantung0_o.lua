-- Tải Rayfield
loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Tạo GUI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "💀 tung hub",
   LoadingTitle = "tung hub",
   LoadingSubtitle = "bởi trantung",
   ConfigurationSaving = {
      Enabled = false,
   },
   Discord = {
      Enabled = false,
   },
   KeySystem = false
})

local MainTab = Window:CreateTab("🏃 Fly / Speed / NoClip", 4483362458)
local TeleTab = Window:CreateTab("📍 Teleport", 4483362458)
local PlayerTab = Window:CreateTab("👥 Player TP", 4483362458)
local EspTab = Window:CreateTab("👁 ESP", 4483362458)

-- Fly Toggle
MainTab:CreateToggle({
   Name = "✈️ Fly",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
      end
   end,
})

-- NoClip
MainTab:CreateToggle({
   Name = "🚧 NoClip",
   CurrentValue = false,
   Callback = function(v)
      noclip = v
      game:GetService("RunService").Stepped:Connect(function()
         if noclip then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
               if v:IsA("BasePart") then
                  v.CanCollide = false
               end
            end
         end
      end)
   end,
})

-- Speed Slider
MainTab:CreateSlider({
   Name = "🏃 WalkSpeed",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(val)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
   end,
})

-- ESP
EspTab:CreateButton({
   Name = "👁 Bật ESP người chơi",
   Callback = function()
      loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
   end
})

-- Teleport lưu điểm
local savedPoints = {}

TeleTab:CreateButton({
   Name = "💾 Lưu vị trí hiện tại",
   Callback = function()
      local pos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
      table.insert(savedPoints, pos)
      Rayfield:Notify("Đã lưu!", "Vị trí số " .. tostring(#savedPoints) .. " được lưu!")
   end
})

for i = 1, 5 do
   TeleTab:CreateButton({
      Name = "📍 TP đến điểm " .. i,
      Callback = function()
         local pos = savedPoints[i]
         if pos then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
         else
            Rayfield:Notify("Lỗi", "Chưa lưu vị trí số " .. i)
         end
      end
   })
end

-- Teleport đến người chơi
PlayerTab:CreateInput({
   Name = "Nhập tên người chơi",
   PlaceholderText = "Ví dụ: ngotung",
   RemoveTextAfterFocusLost = true,
   Callback = function(txt)
      local target = game.Players:FindFirstChild(txt)
      if target and target.Character then
         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
            target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
      else
         Rayfield:Notify("Không tìm thấy", "Tên người chơi không tồn tại")
      end
   end,
})
