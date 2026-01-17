--====================================================
-- AUTO REJOIN PRO | PREMIUM EDITION v3.0
-- Advanced Event System + Rich Embeds + Analytics
-- By ngố
--====================================================

if getgenv().AUTO_REJOIN_V3_RUNNING then return end
getgenv().AUTO_REJOIN_V3_RUNNING = true

repeat task.wait() until game:IsLoaded()

-- ===== HTTP AUTO =====
local http_request =
    http_request or request or
    (syn and syn.request) or
    (fluxus and fluxus.request) or
    (krnl and krnl.request)

-- ===== SERVICES =====
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

-- ===== CONFIG =====
local CONFIG = {
    WEBHOOK_URL = "https://discord.com/api/webhooks/1462052174891585752/Uzfid7IsNdsTfyEM1ao0uOcqGKqvmA0Ca7FFmxkSCx3IE0C5lJFNiQwTIBlbgTCE7uEc",
    REJOIN_DELAY = 2,
    SAVE_INTERVAL = 60,
    ENABLE_ANALYTICS = true,
    ENABLE_PERFORMANCE_MONITORING = true
}

-- ===== FILE SYSTEM =====
local FOLDER = "AutoRejoinPRO"
local FILES = {
    DATA = FOLDER.."/data.json",
    SESSION = FOLDER.."/session.json",
    LOGS = FOLDER.."/logs.json"
}

if not isfolder(FOLDER) then makefolder(FOLDER) end

-- ===== DATA MANAGER =====
local DataManager = {}

function DataManager:Load(file, default)
    if not isfile(file) then return default end
    local success, result = pcall(function()
        return HttpService:JSONDecode(readfile(file))
    end)
    return success and result or default
end

function DataManager:Save(file, data)
    local success = pcall(function()
        writefile(file, HttpService:JSONEncode(data))
    end)
    return success
end

-- ===== INIT DATA =====
local SessionData = {
    kicks = 0,
    totalTime = 0,
    sessions = {},
    analytics = {
        totalKicks = 0,
        totalRejoins = 0,
        totalDeaths = 0,
        avgPing = 0,
        avgFps = 0,
        kickReasons = {},
        serverHops = 0
    }
}

local CurrentSession = {
    startTime = os.time(),
    startTick = tick(),
    kicks = 0,
    deaths = 0,
    rejoins = 0,
    performance = {
        avgPing = 0,
        avgFps = 0,
        peakMemory = 0
    }
}

-- Load saved data
local savedData = DataManager:Load(FILES.DATA, SessionData)
SessionData = savedData

-- ===== UTILITY =====
local Utils = {}

function Utils.TimeStampVN()
    return os.date("!%Y-%m-%dT%H:%M:%SZ", os.time() + 7*3600)
end

function Utils.FormatTime(sec)
    local d = math.floor(sec/86400)
    local h = math.floor((sec%86400)/3600)
    local m = math.floor((sec%3600)/60)
    local s = sec%60
    
    if d > 0 then
        return string.format("%dd %02dh %02dm", d,h,m)
    else
        return string.format("%02dh %02dm %02ds", h,m,s)
    end
end

function Utils.GetPing()
    return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
end

function Utils.GetFPS()
    return math.floor(1/RunService.RenderStepped:Wait())
end

function Utils.GetMemory()
    return math.floor(Stats:GetTotalMemoryUsageMb())
end

function Utils.GetServerInfo()
    return {
        placeId = game.PlaceId,
        jobId = game.JobId,
        placeName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
        players = #Players:GetPlayers(),
        maxPlayers = Players.MaxPlayers
    }
end

-- ===== PERFORMANCE MONITOR =====
local PerformanceMonitor = {}
local perfData = {pingSum=0, fpsSum=0, samples=0}

function PerformanceMonitor:Update()
    local ping = Utils.GetPing()
    local fps = Utils.GetFPS()
    
    perfData.pingSum = perfData.pingSum + ping
    perfData.fpsSum = perfData.fpsSum + fps
    perfData.samples = perfData.samples + 1
    
    CurrentSession.performance.avgPing = math.floor(perfData.pingSum/perfData.samples)
    CurrentSession.performance.avgFps = math.floor(perfData.fpsSum/perfData.samples)
    CurrentSession.performance.peakMemory = math.max(
        CurrentSession.performance.peakMemory,
        Utils.GetMemory()
    )
end

task.spawn(function()
    while CONFIG.ENABLE_PERFORMANCE_MONITORING do
        PerformanceMonitor:Update()
        task.wait(5)
    end
end)

-- ===== WEBHOOK SYSTEM v3 =====
local WebhookManager = {}

function WebhookManager:Send(config)
    if not http_request or CONFIG.WEBHOOK_URL == "" or CONFIG.WEBHOOK_URL == "PASTE_WEBHOOK_HERE" then 
        return 
    end

    local embed = {
        title = config.title or "Event",
        description = config.description or "",
        color = config.color or 5814783,
        fields = config.fields or {},
        timestamp = Utils.TimeStampVN(),
        footer = {
            text = "Auto Rejoin PRO v3.0 | Premium Edition",
            icon_url = "https://files.catbox.moe/ssppa2.webp"
        }
    }
    
    if config.thumbnail then
        embed.thumbnail = {url = config.thumbnail}
    end
    
    if config.image then
        embed.image = {url = config.image}
    end

    local payload = {
        username = "🤖 Auto Rejoin PRO",
        avatar_url = "https://files.catbox.moe/ssppa2.webp",
        embeds = {embed}
    }

    pcall(function()
        http_request({
            Url = CONFIG.WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"]="application/json"},
            Body = HttpService:JSONEncode(payload)
        })
    end)
end

-- ===== EVENTS =====
Events = {}

function Events.Start()
    local serverInfo = Utils.GetServerInfo()
    WebhookManager:Send({
        title = "🟢 SESSION STARTED",
        description = "**Script được khởi động thành công**",
        color = 65280,
        thumbnail = "https://files.catbox.moe/ssppa2.webp",
        fields = {
            {name="👤 Player", value="```"..LocalPlayer.Name.."```", inline=true},
            {name="🎮 Game", value="```"..serverInfo.placeName.."```", inline=true},
            {name="🌐 Server Info", value="```Players: "..serverInfo.players.."/"..serverInfo.maxPlayers.."```", inline=true},
            {name="🆔 Place ID", value="```"..serverInfo.placeId.."```", inline=true},
            {name="🔑 Job ID", value="```"..serverInfo.jobId.."```", inline=false},
            {name="📊 Statistics", value=
                "```"..
                "Total Kicks: "..SessionData.analytics.totalKicks.."\n"..
                "Total Sessions: "..#SessionData.sessions.."\n"..
                "Total Playtime: "..Utils.FormatTime(SessionData.totalTime)..
                "```", 
                inline=false
            }
        }
    })
end

function Events.Kick(reason, uptime)
    SessionData.analytics.totalKicks = SessionData.analytics.totalKicks + 1
    SessionData.analytics.kickReasons[reason] = (SessionData.analytics.kickReasons[reason] or 0) + 1
    
    WebhookManager:Send({
        title = "🔴 PLAYER KICKED",
        description = "**Phát hiện bị kick – Chuẩn bị rejoin server**",
        color = 16711680,
        thumbnail = "https://files.catbox.moe/ssppa2.webp",
        fields = {
            {name="👤 Player", value="```"..LocalPlayer.Name.."```", inline=true},
            {name="💀 Kick Count", value="```#"..(SessionData.analytics.totalKicks).."```", inline=true},
            {name="⏱️ Session Time", value="```"..Utils.FormatTime(uptime).."```", inline=true},
            {name="📊 Performance", value=
                "```"..
                "Avg Ping: "..CurrentSession.performance.avgPing.."ms\n"..
                "Avg FPS: "..CurrentSession.performance.avgFps.."\n"..
                "Memory: "..CurrentSession.performance.peakMemory.."MB"..
                "```",
                inline=true
            },
            {name="❌ Kick Reason", value="```"..reason.."```", inline=false},
            {name="🆔 Server", value="```"..game.JobId.."```", inline=false}
        }
    })
end

function Events.Rejoin()
    SessionData.analytics.totalRejoins = SessionData.analytics.totalRejoins + 1
    CurrentSession.rejoins = CurrentSession.rejoins + 1
    
    WebhookManager:Send({
        title = "🔄 REJOINING SERVER",
        description = "**Đang tìm và join server mới...**",
        color = 16744192,
        thumbnail = "https://files.catbox.moe/ssppa2.webp",
        fields = {
            {name="👤 Player", value="```"..LocalPlayer.Name.."```", inline=true},
            {name="🔄 Rejoin Count", value="```#"..SessionData.analytics.totalRejoins.."```", inline=true},
            {name="🎮 Target Place", value="```"..game.PlaceId.."```", inline=false}
        }
    })
end

function Events.Death()
    SessionData.analytics.totalDeaths = SessionData.analytics.totalDeaths + 1
    CurrentSession.deaths = CurrentSession.deaths + 1
    
    WebhookManager:Send({
        title = "☠️ PLAYER DIED",
        description = "**Nhân vật đã chết trong game**",
        color = 10038562,
        thumbnail = "https://files.catbox.moe/ssppa2.webp",
        fields = {
            {name="👤 Player", value="```"..LocalPlayer.Name.."```", inline=true},
            {name="💀 Death Count", value="```#"..SessionData.analytics.totalDeaths.."```", inline=true},
            {name="⏱️ Uptime", value="```"..Utils.FormatTime(os.time()-CurrentSession.startTime).."```", inline=true}
        }
    })
end

function Events.Stop()
    local sessionTime = os.time() - CurrentSession.startTime
    
    -- Save session
    table.insert(SessionData.sessions, {
        startTime = CurrentSession.startTime,
        duration = sessionTime,
        kicks = CurrentSession.kicks,
        deaths = CurrentSession.deaths,
        performance = CurrentSession.performance
    })
    
    SessionData.totalTime = SessionData.totalTime + sessionTime
    DataManager:Save(FILES.DATA, SessionData)
    
    WebhookManager:Send({
        title = "⛔ SCRIPT STOPPED",
        description = "**Script đã được tắt bởi người dùng**",
        color = 8421504,
        thumbnail = "https://files.catbox.moe/ssppa2.webp",
        fields = {
            {name="📊 Session Stats", value=
                "```"..
                "Duration: "..Utils.FormatTime(sessionTime).."\n"..
                "Kicks: "..CurrentSession.kicks.."\n"..
                "Deaths: "..CurrentSession.deaths.."\n"..
                "Rejoins: "..CurrentSession.rejoins..
                "```",
                inline=true
            },
            {name="🎯 Performance", value=
                "```"..
                "Avg Ping: "..CurrentSession.performance.avgPing.."ms\n"..
                "Avg FPS: "..CurrentSession.performance.avgFps.."\n"..
                "Peak Memory: "..CurrentSession.performance.peakMemory.."MB"..
                "```",
                inline=true
            },
            {name="📈 Total Stats", value=
                "```"..
                "Total Kicks: "..SessionData.analytics.totalKicks.."\n"..
                "Total Deaths: "..SessionData.analytics.totalDeaths.."\n"..
                "Total Time: "..Utils.FormatTime(SessionData.totalTime)..
                "```",
                inline=false
            }
        }
    })
end

function Events.TeleportFail()
    WebhookManager:Send({
        title = "❌ TELEPORT FAILED",
        description = "**Teleport thất bại – Thử lại...**",
        color = 16711680,
        thumbnail = "https://files.catbox.moe/ssppa2.webp",
        fields = {
            {name="🎮 Place ID", value="```"..game.PlaceId.."```", inline=true}
        }
    })
end

-- ===== SERVER FINDER =====
local ServerFinder = {}

function ServerFinder:Find()
    local success, servers = pcall(function()
        local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    
    if not success then return nil end
    
    -- Sort by player count (prefer fuller servers)
    table.sort(servers.data, function(a,b)
        return a.playing > b.playing
    end)
    
    for _, server in pairs(servers.data) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            return server.id
        end
    end
    
    return nil
end

-- ===== REJOIN MANAGER =====
RejoinManager = {}

function RejoinManager:Rejoin(reason)
    task.wait(CONFIG.REJOIN_DELAY)
    
    CurrentSession.kicks = CurrentSession.kicks + 1
    SessionData.kicks = SessionData.kicks + 1
    
    local uptime = os.time() - CurrentSession.startTime
    
    Events.Kick(reason or "Unknown", uptime)
    Events.Rejoin()
    
    task.wait(1)
    
    local serverId = ServerFinder:Find()
    if serverId then
        SessionData.analytics.serverHops = SessionData.analytics.serverHops + 1
        TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, LocalPlayer)
    else
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
end

-- ===== PREMIUM GUI =====
pcall(function() CoreGui.AutoRejoinGUI_V3:Destroy() end)

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "AutoRejoinGUI_V3"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,400,0,340)
frame.Position = UDim2.new(0.5,-200,0.5,-170)
frame.BackgroundColor3 = Color3.fromRGB(20,20,28)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0,20)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(100,100,180)
stroke.Thickness = 3
stroke.Transparency = 0.3

local gradient = Instance.new("UIGradient", stroke)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(138,43,226)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(75,0,130)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(138,43,226))
}

task.spawn(function()
    while gui.Parent do
        gradient.Rotation += 1
        if gradient.Rotation >= 360 then gradient.Rotation = 0 end
        task.wait(0.05)
    end
end)

-- Header with Avatar
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1,0,0,80)
header.BackgroundColor3 = Color3.fromRGB(30,30,42)
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0,20)

local headerGradient = Instance.new("UIGradient", header)
headerGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25,25,35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40,40,55))
}
headerGradient.Rotation = 90

-- Avatar
local avatar = Instance.new("ImageLabel", header)
avatar.Size = UDim2.new(0,60,0,60)
avatar.Position = UDim2.new(0,10,0.5,-30)
avatar.BackgroundTransparency = 1
avatar.Image = "https://files.catbox.moe/ssppa2.webp"
Instance.new("UICorner", avatar).CornerRadius = UDim.new(1,0)

local avatarStroke = Instance.new("UIStroke", avatar)
avatarStroke.Color = Color3.fromRGB(138,43,226)
avatarStroke.Thickness = 3

-- Title
local title = Instance.new("TextLabel", header)
title.Position = UDim2.new(0,80,0,10)
title.Size = UDim2.new(1,-90,0,30)
title.BackgroundTransparency = 1
title.Text = "AUTO REJOIN PRO"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(138,43,226)
title.TextXAlignment = Enum.TextXAlignment.Left

local subtitle = Instance.new("TextLabel", header)
subtitle.Position = UDim2.new(0,80,0,40)
subtitle.Size = UDim2.new(1,-90,0,25)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Premium Edition v3.0"
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 13
subtitle.TextColor3 = Color3.fromRGB(150,150,200)
subtitle.TextXAlignment = Enum.TextXAlignment.Left

-- Stats Container
local function CreateStatCard(yPos, icon, name, color, defaultValue)
    local card = Instance.new("Frame", frame)
    card.Position = UDim2.new(0.05,0,0,yPos)
    card.Size = UDim2.new(0.9,0,0,45)
    card.BackgroundColor3 = Color3.fromRGB(28,28,40)
    card.BorderSizePixel = 0
    
    local cardCorner = Instance.new("UICorner", card)
    cardCorner.CornerRadius = UDim.new(0,12)
    
    local cardStroke = Instance.new("UIStroke", card)
    cardStroke.Color = color
    cardStroke.Thickness = 1.5
    cardStroke.Transparency = 0.7
    
    local iconLabel = Instance.new("TextLabel", card)
    iconLabel.Size = UDim2.new(0,40,1,0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 24
    iconLabel.TextColor3 = color
    
    local nameLabel = Instance.new("TextLabel", card)
    nameLabel.Position = UDim2.new(0,45,0,0)
    nameLabel.Size = UDim2.new(0.5,-50,1,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.Font = Enum.Font.GothamMedium
    nameLabel.TextSize = 14
    nameLabel.TextColor3 = Color3.fromRGB(200,200,220)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local valueLabel = Instance.new("TextLabel", card)
    valueLabel.Position = UDim2.new(0.5,0,0,0)
    valueLabel.Size = UDim2.new(0.5,0,1,0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = defaultValue or "0"
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 16
    valueLabel.TextColor3 = color
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local padding = Instance.new("UIPadding", valueLabel)
    padding.PaddingRight = UDim.new(0,15)
    
    return valueLabel
end

local kickLabel = CreateStatCard(95, "💀", "Total Kicks", Color3.fromRGB(255,100,120), "0")
local timeLabel = CreateStatCard(150, "⏱️", "Session Time", Color3.fromRGB(100,200,255), "00h 00m 00s")
local deathLabel = CreateStatCard(205, "☠️", "Deaths", Color3.fromRGB(200,100,255), "0")
local pingLabel = CreateStatCard(260, "📡", "Avg Ping", Color3.fromRGB(100,255,150), "0ms")

-- Stop Button
local stopBtn = Instance.new("TextButton", frame)
stopBtn.Position = UDim2.new(0.1,0,0,310)
stopBtn.Size = UDim2.new(0.8,0,0,50)
stopBtn.Text = ""
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 16
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.BackgroundColor3 = Color3.fromRGB(220,50,70)
stopBtn.BorderSizePixel = 0
stopBtn.AutoButtonColor = false

local btnCorner = Instance.new("UICorner", stopBtn)
btnCorner.CornerRadius = UDim.new(0,12)

local btnLabel = Instance.new("TextLabel", stopBtn)
btnLabel.Size = UDim2.new(1,0,1,0)
btnLabel.BackgroundTransparency = 1
btnLabel.Text = "⛔ STOP SCRIPT"
btnLabel.Font = Enum.Font.GothamBold
btnLabel.TextSize = 16
btnLabel.TextColor3 = Color3.new(1,1,1)

-- Button hover effect
stopBtn.MouseEnter:Connect(function()
    stopBtn.BackgroundColor3 = Color3.fromRGB(255,70,90)
end)

stopBtn.MouseLeave:Connect(function()
    stopBtn.BackgroundColor3 = Color3.fromRGB(220,50,70)
end)

-- Update GUI
task.spawn(function()
    while task.wait(1) do
        local currentTime = os.time() - CurrentSession.startTime
        kickLabel.Text = tostring(SessionData.analytics.totalKicks)
        timeLabel.Text = Utils.FormatTime(currentTime)
        deathLabel.Text = tostring(CurrentSession.deaths)
        pingLabel.Text = CurrentSession.performance.avgPing.."ms"
    end
end)

-- ===== EVENT HANDLERS =====
GuiService.ErrorMessageChanged:Connect(function(msg)
    if msg ~= "" then
        RejoinManager:Rejoin(msg)
    end
end)

LocalPlayer.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Failed then
        Events.TeleportFail()
        task.wait(2)
        RejoinManager:Rejoin("Teleport Failed")
    end
end)

-- Death detection
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").Died:Connect(function()
        Events.Death()
    end)
end)

-- Stop button
stopBtn.MouseButton1Click:Connect(function()
    Events.Stop()
    gui:Destroy()
    getgenv().AUTO_REJOIN_V3_RUNNING = false
end)

-- Auto save
task.spawn(function()
    while getgenv().AUTO_REJOIN_V3_RUNNING do
        task.wait(CONFIG.SAVE_INTERVAL)
        SessionData.totalTime = SessionData.totalTime + CONFIG.SAVE_INTERVAL
        DataManager:Save(FILES.DATA, SessionData)
    end
end)

-- Cleanup on game close
game:BindToClose(function()
    local sessionTime = os.time() - CurrentSession.startTime
    SessionData.totalTime = SessionData.totalTime + sessionTime
    DataManager:Save(FILES.DATA, SessionData)
end)

-- Start
Events.Start()
print("[AUTO REJOIN PRO v3] Loaded Successfully!")
print("═══════════════════════════════════════")
print("Premium Edition | Advanced Analytics")
print("Author: ngố | Version: 3.0")
print("═══════════════════════════════════════")
