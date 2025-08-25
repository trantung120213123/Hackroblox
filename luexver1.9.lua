-- luôn load Luexhubreal.lua
local url = 'https://raw.githubusercontent.com/trantung120213123/Hackroblox/refs/heads/main/Luexhubreal.lua'
loadstring(game:HttpGet(url))()

--// Anti AFK Script
local vu = game:GetService("VirtualUser")
local plr = game:GetService("Players").LocalPlayer

plr.Idled:Connect(function()
    if getgenv().antiafk == true then
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        print("[Anti AFK] Đã click giả để tránh kick AFK")
        warn("[Anti AFK] Đang hoạt động...")
    else
        print("[Anti AFK] Script đã bị tắt")
    end
end)

print("[Anti AFK] Script đã load xong. Trạng thái: "..tostring(getgenv().antiafk))
