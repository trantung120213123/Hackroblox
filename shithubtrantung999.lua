-- Rayfield Key System + Load Script
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

Rayfield:LoadConfiguration()

local Window = Rayfield:CreateWindow({
	Name = "Deadrail Hub by Trần Tùng",
	LoadingTitle = "Đang khởi động...",
	LoadingSubtitle = "by Trần Tùng",
	ConfigurationSaving = {
		Enabled = false,
	},
	KeySystem = true,
	KeySettings = {
		Title = "Deadrail Key System",
		Subtitle = "Key cần để kích hoạt script",
		Note = "Lấy key tại: https://yeumoney.com/uVk6nM",
		SaveKey = true,
		GrabKeyFromSite = false,
		Key = "trantung999shithub"
	}
})

-- Sau khi nhập đúng key
local MainTab = Window:CreateTab("Kích Hoạt", 4483362458)

MainTab:CreateButton({
	Name = "Kích hoạt Script",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/trantung120213123/Hackroblox/refs/heads/main/Deadrailbytrantung999.lua"))()
	end,
})
