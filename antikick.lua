--====================================================
-- AUTO REJOIN PRO (NO SELF QUEUE)
-- Save Kick + Runtime + Server Hop
-- By ngố
--====================================================

-- ===== ANTI DOUBLE LOAD =====
if getgenv().AUTO_REJOIN_RUNNING then return end
getgenv().AUTO_REJOIN_RUNNING = true

repeat task.wait() until game:IsLoaded()

-- ===== SERVICES =====
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ===== FILE =====
local FOLDER = "AutoRejoin"
local FILE = FOLDER .. "/data.txt"

if not isfolder(FOLDER) then
    makefolder(FOLDER)
end

local function LoadData()
    if not isfile(FILE) then
        return {Kick = 0, Time = 0}
    end
    local k, t = readfile(FILE):match("Kick:(%d+)%s+Time:(%d+)")
    return {
        Kick = tonumber(k) or 0,
        Time = tonumber(t) or 0
    }
end

local function SaveData(k, t)
    writefile(FILE, "Kick:"..k.."\nTime:"..t)
end

-- ===== DATA =====
local data = LoadData()
local KickCount = data.Kick
local TotalTime = data.Time
local StartTick = os.time()

-- ===== CONFIG =====
local REJOIN_DELAY = 2

-- ===== GUI =====
pcall(function()
    CoreGui.AutoRejoinGUI:Destroy()
end)

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "AutoRejoinGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0, 20, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local function Label(y, txt, col)
    local l = Instance.new("TextLabel", frame)
    l.Position = UDim2.new(0, 0, 0, y)
    l.Size = UDim2.new(1, 0, 0, 24)
    l.Text = txt
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.TextColor3 = col
    l.BackgroundTransparency = 1
    return l
end

Label(5, "🔁 AUTO REJOIN", Color3.fromRGB(255,80,80)).Font = Enum.Font.GothamBold
local kickLbl = Label(35, "", Color3.fromRGB(255,120,120))
local timeLbl = Label(60, "", Color3.fromRGB(120,200,255))

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Position = UDim2.new(0.1, 0, 0, 95)
stopBtn.Size = UDim2.new(0.8, 0, 0, 45)
stopBtn.Text = "⛔ TẮT SCRIPT"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 14
stopBtn.TextColor3 = Color3.fromRGB(255,255,255)
stopBtn.BackgroundColor3 = Color3.fromRGB(120,30,30)
stopBtn.BorderSizePixel = 0
Instance.new("UICorner", stopBtn)

-- ===== TIME FORMAT =====
local function fmt(t)
    local h = math.floor(t/3600)
    local m = math.floor((t%3600)/60)
    local s = t%60
    return string.format("%02dh %02dm %02ds", h, m, s)
end

-- ===== UI LOOP =====
task.spawn(function()
    while true do
        kickLbl.Text = "💀 Kick: "..KickCount
        timeLbl.Text = "⏱ Time: "..fmt(TotalTime + (os.time() - StartTick))
        task.wait(1)
    end
end)

-- ===== FIND SERVER =====
local function FindServer()
    local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"
    local data = HttpService:JSONDecode(game:HttpGet(url))
    for _, s in pairs(data.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            return s.id
        end
    end
end

-- ===== REJOIN =====
local function Rejoin(newServer)
    task.wait(REJOIN_DELAY)
    KickCount += 1
    SaveData(KickCount, TotalTime + (os.time() - StartTick))

    if newServer then
        local id = FindServer()
        if id then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, id, LocalPlayer)
            return
        end
    end

    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end

-- ===== STOP =====
stopBtn.MouseButton1Click:Connect(function()
    TotalTime += os.time() - StartTick
    SaveData(KickCount, TotalTime)
    gui:Destroy()
    script:Destroy()
end)

-- ===== EVENTS =====
GuiService.ErrorMessageChanged:Connect(function()
    Rejoin(true)
end)

LocalPlayer.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Failed then
        Rejoin(true)
    end
end)

game:BindToClose(function()
    TotalTime += os.time() - StartTick
    SaveData(KickCount, TotalTime)
end)

print("[AUTO REJOIN] Loaded (no self-queue)")
