--// Rayfield UI Script Template
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "💀 Fly GUI by tung",
   LoadingTitle = "Loading GUI...",
   LoadingSubtitle = "by trantung",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "FlyGuiConfig"
   },
   Discord = {
      Enabled = false,
   },
   KeySystem = false,
})

local Tab = Window:CreateTab("Main", 4483362458)

-- Speed Slider
Tab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 150},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "WalkSpeedSlider",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

-- NoClip Toggle
Tab:CreateToggle({
   Name = "NoClip",
   CurrentValue = false,
   Flag = "NoClipToggle",
   Callback = function(Value)
      if Value then
         noclip = true
         game:GetService("RunService").Stepped:Connect(function()
            if noclip and game.Players.LocalPlayer.Character then
               for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                  if part:IsA("BasePart") then
                     part.CanCollide = false
                  end
               end
            end
         end)
      else
         noclip = false
      end
   end,
})

-- Fly Toggle (có thể bỏ nếu ko cần)
Tab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(state)
      if state then
         _G.Flying = true
         local player = game.Players.LocalPlayer
         local char = player.Character or player.CharacterAdded:Wait()
         local hrp = char:WaitForChild("HumanoidRootPart")
         local bv = Instance.new("BodyVelocity", hrp)
         bv.Velocity = Vector3.new(0,0,0)
         bv.MaxForce = Vector3.new(100000,100000,100000)
         while _G.Flying do
            task.wait()
            bv.Velocity = player:GetMouse().Hit.LookVector * 50
         end
      else
         _G.Flying = false
         local bv = game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChildOfClass("BodyVelocity")
         if bv then bv:Destroy() end
      end
   end,
})
