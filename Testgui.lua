-- Tải Venyx UI
local Venyx = loadstring(game:HttpGet('https://raw.githubusercontent.com/0Ben1/Venyx-UI-Library/main/Venyx.lua'))() -- Thay 'URL_CUA_VENYX_UI' bằng URL thực tế của Venyx UI
local UI = Venyx.new({
    title = "Shit hub💩 by TranTung999"
})

-- Hệ thống Key (Venyx không có sẵn key system nên làm thủ công)
local correctKey = "shithub999"
local inputKey = game:GetService("UserInputService"):Prompt("Nhập key:", "Shit hub💩 Key System")
if inputKey ~= correctKey then
    game.Players.LocalPlayer:Kick("Key sai!")
    return
end

-- Khai báo biến toàn cục
local localPlayer = game.Players.LocalPlayer
local players = game.Players
local savedPoints = {}
local noclip = false
local ESP_ON = false
local ESP_NPC_ON = false
local LockNPC = false
local userIdToClone = nil

-- Tạo các trang (Tabs)
local MainPage = UI:addPage({ title = "Main", icon = 4483362458 })
local TeleportPage = UI:addPage({ title = "Teleport", icon = 4483362458 })
local PlayersPage = UI:addPage({ title = "Players", icon = 4483362458 })
local NPCPage = UI:addPage({ title = "NPC", icon = 4483362458 })
local SkinPage = UI:addPage({ title = "Skin", icon = 4483362458 })
local InkPage = UI:addPage({ title = "Ink Game", icon = 4483362458 })
local GrowPage = UI:addPage({ title = "Grow A Garden", icon = 13014560 })
local BloxFruitsPage = UI:addPage({ title = "🍌 Blox Fruits", icon = 4483362458 })
local MM2Page = UI:addPage({ title = "Murder Mystery 2", icon = 4483362458 })

-- ### Trang Main
MainPage:addSlider({
    text = "Speed",
    min = 16,
    max = 200,
    value = 16,
    callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        UI:notify("Speed", "Đã chỉnh tốc độ!")
    end
})

MainPage:addToggle({
    text = "NoClip",
    value = false,
    callback = function(Value)
        noclip = Value
        UI:notify("NoClip", Value and "Bật" or "Tắt")
    end
})

MainPage:addToggle({
    text = "ESP người chơi",
    value = false,
    callback = function(Value)
        ESP_ON = Value
        UI:notify("ESP", Value and "Bật" or "Tắt")
    end
})

-- ### Trang Teleport
TeleportPage:addButton({
    text = "Save Point",
    callback = function()
        local pos = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if pos then
            local cf = pos.CFrame
            table.insert(savedPoints, cf)
            TeleportPage:addButton({
                text = "Teleport to Point " .. #savedPoints,
                callback = function()
                    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = savedPoints[#savedPoints]
                    end
                end
            })
        end
    end
})

-- ### Trang Players
PlayersPage:addButton({
    text = "🔁 Load lại danh sách",
    callback = function()
        for _, p in pairs(players:GetPlayers()) do
            if p ~= localPlayer then
                PlayersPage:addButton({
                    text = "TP đến: " .. p.Name,
                    callback = function()
                        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            localPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                        end
                    end
                })
            end
        end
    end
})

-- ### Trang NPC
NPCPage:addToggle({
    text = "ESP NPC",
    value = false,
    callback = function(Value)
        ESP_NPC_ON = Value
        UI:notify("ESP NPC", Value and "Bật" or "Tắt")
    end
})

NPCPage:addToggle({
    text = "Lock NPC gần nhất",
    value = false,
    callback = function(Value)
        LockNPC = Value
        UI:notify("Lock NPC", Value and "Bật" or "Tắt")
    end
})

-- ### Trang Skin
SkinPage:addButton({
    text = "Xoá toàn bộ Skin",
    callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        for _, item in pairs(character:GetChildren()) do
            if item:IsA("Accessory") or item:IsA("Clothing") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") or item:IsA("BodyColors") or item:IsA("CharacterMesh") or item:IsA("Decal") or item:IsA("HumanoidDescription") then
                item:Destroy()
            end
        end
        UI:notify("Skin", "Đã xoá toàn bộ Skin, tóc, mặt...")
    end
})

SkinPage:addTextbox({
    text = "Tên người chơi",
    placeholder = "Nhập tên người chơi...",
    callback = function(input)
        local success, result = pcall(function()
            return game.Players:GetUserIdFromNameAsync(input)
        end)
        if success then
            userIdToClone = result
            setclipboard(tostring(result))
            UI:notify("Đã sao chép ID", "UserId: " .. tostring(result))
        else
            UI:notify("Lỗi", "Không tìm thấy người chơi!")
        end
    end
})

SkinPage:addTextbox({
    text = "Hoặc nhập UserId trực tiếp",
    placeholder = "Nhập UserId...",
    callback = function(input)
        local id = tonumber(input)
        if id then
            userIdToClone = id
            setclipboard(input)
            UI:notify("Đã nhận ID", "UserId: " .. input)
        else
            UI:notify("Lỗi", "ID không hợp lệ!")
        end
    end
})

SkinPage:addButton({
    text = "Clone Skin từ ID",
    callback = function()
        if not userIdToClone then
            UI:notify("Thiếu UserId!", "Vui lòng nhập tên hoặc ID trước.")
            return
        end
        local success, appearance = pcall(function()
            return game.Players:GetCharacterAppearanceAsync(userIdToClone)
        end)
        if success and appearance then
            local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
            for _, v in pairs(char:GetChildren()) do
                if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") or v:IsA("BodyColors") then
                    v:Destroy()
                end
            end
            for _, v in ipairs(appearance:GetChildren()) do
                if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") or v:IsA("BodyColors") then
                    v:Clone().Parent = char
                end
            end
            UI:notify("Thành công", "Đã clone skin!")
        else
            UI:notify("Lỗi clone", "Không thể lấy trang phục!")
        end
    end
})

-- ### Trang Ink Game
InkPage:addButton({
    text = "Ringta",
    callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/wefwef127382/inkgames.github.io/refs/heads/main/ringta.lua"))()
        UI:notify("Ringta", "Script loaded!")
    end
})

-- ### Trang Grow A Garden
GrowPage:addButton({
    text = "Speed X Hub",
    callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
        UI:notify("Speed X Hub", "Script loaded!")
    end
})

GrowPage:addButton({
    text = "No Lag",
    callback = function()
        repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
        local scripts = {
            [126884695634066] = "https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/Garden/Garden-V1.lua",
            [81440632616906] = "https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/DigEarth/V1.lua",
        }
        local url = scripts[game.PlaceId]
        if url then
            loadstring(game:HttpGetAsync(url))()
            loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/untitled.lua"))()
            UI:notify("No Lag", "Loaded for this game")
        else
            UI:notify("No Lag", "Game không hỗ trợ!")
        end
    end
})

-- ### Trang Blox Fruits
BloxFruitsPage:addButton({
    text = "Banana Cat Hub 🍌",
    callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Chiriku2013/BananaCatHub/refs/heads/main/BananaCatHub.lua"))()
    end
})

BloxFruitsPage:addButton({
    text = "Redz Hub 🔴",
    callback = function()
        local Settings = {
            JoinTeam = "Pirates",
            Translator = true,
        }
        loadstring(game:HttpGet("https://raw.githubusercontent.com/newredz/BloxFruits/refs/heads/main/Source.luau"))(Settings)
    end
})

-- ### Trang Murder Mystery 2
MM2Page:addButton({
    text = "Xhub MM2",
    callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Au0yX/Community/main/XhubMM2"))()
    end
})

-- ### Logic game (giữ nguyên)
game:GetService("RunService").RenderStepped:Connect(function()
    if noclip and localPlayer.Character then
        for _, part in pairs(localPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    end
    -- Thêm logic khác cho ESP, Lock NPC nếu cần
end)
