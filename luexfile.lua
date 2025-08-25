-- luôn load Luexhubreal.lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/trantung120213123/Hackroblox/refs/heads/main/Luexhubreal.lua"))()

-- chỉ load antiafk.lua nếu bật
if getgenv().antiafk == "true" then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/trantung120213123/Hackroblox/refs/heads/main/antiafk.lua"))()
    print("[✅] Anti-AFK đã bật")
else
    print("[ℹ️] Luexhubreal đã load, Anti-AFK đang tắt")
end
