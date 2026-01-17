--====================================================
-- AUTO REJOIN PRO VERSION
-- Save KickCount + Total Runtime
-- By ngố
--====================================================

-- ===== ANTI DOUBLE LOAD =====
if getgenv().AUTO_REJOIN_LOADED then return end
getgenv().AUTO_REJOIN_LOADED = true

repeat task.wait() until game:IsLoaded()

-- ===== SERVICES =====
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ===== FILE CONFIG =====
local FOLDER = "AutoRejoinPro"
local DATA_FILE = FOLDER .. "/data.txt"

-- ===== FILE UTILS =====
if not isfolder(FOLDER) then
    makefolder(FOLDER)
end

local function ReadData()
    if not isfile(DATA_FILE) then
        return {Kick = 0, Time = 0}
    end
    local raw = readfile(DATA_FILE)
    local k, t = raw:match("Kick:(%d+)%s+Time:(%d+)")
    return {
        Kick = tonumber(k) or 0,
        Time = tonumber(t) or 0
    }
end

local function SaveData(kick, time)
    local content =
        "Kick:" .. kick .. "\n" ..
        "Time:" .. time .. "\n"
    writefile(DATA_FILE, content)
end

-- ===== LOAD DATA =====
local data = ReadData()
getgenv().KickCount = data.Kick
getgenv().TotalTime = data.Time

-- ===== FLAGS =====
getgenv().AUTO_REJOIN_ENABLED = true
getgenv().LastJobId = getgenv().LastJobId or game.JobId

-- ===== TIMER =====
local StartTick = os.time()

-- ===== CONFIG =====
local REJOIN_DELAY = 3
local SAVE_JOBID = true

-- ===== SELF QUEUE =====
local function QueueSelf()
    if not getgenv().AUTO_REJOIN_ENABLED then return end
    if syn and syn.queue_on_teleport then
        syn.queue_on_teleport([[loadstring(game:HttpGet(""))()]])
    elseif queue_on_teleport then
        queue_on_teleport([[loadstring(game:HttpGet(""))()]])
    end
end

QueueSelf()

-- ===== GUI =====
pcall(function()
    CoreGui.AutoRejoinGUI:Destroy()
end)

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "AutoRejoinGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 190)
frame.Position = UDim2.new(0, 20, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local function Label(y, text, color)
    local l = Instance.new("TextLabel", frame)
    l.Position = UDim2.new(0, 0, 0, y)
    l.Size = UDim2.new(1, 0, 0, 25)
    l.Text = text
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.TextColor3 = color
    l.BackgroundTransparency = 1
    return l
end

local title = Label(5, "🔁 AUTO REJOIN PRO", Color3.fromRGB(255, 80, 80))
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local status = Label(35, "🟢 Đang hoạt động", Color3.fromRGB(200,200,200))
local kickLabel = Label(60, "", Color3.fromRGB(255,120,120))
local timeLabel = Label(85, "", Color3.fromRGB(120,200,255))

-- ===== DISABLE BUTTON =====
local disableBtn = Instance.new("TextButton", frame)
disableBtn.Position = UDim2.new(0.1, 0, 0, 120)
disableBtn.Size = UDim2.new(0.8, 0, 0, 45)
disableBtn.Text = "⛔ TẮT SCRIPT HOÀN TOÀN"
disableBtn.Font = Enum.Font.GothamBold
disableBtn.TextSize = 14
disableBtn.TextColor3 = Color3.fromRGB(255,255,255)
disableBtn.BackgroundColor3 = Color3.fromRGB(120,30,30)
disableBtn.BorderSizePixel = 0
Instance.new("UICorner", disableBtn).CornerRadius = UDim.new(0, 10)

-- ===== FORMAT TIME =====
local function FormatTime(sec)
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    local s = sec % 60
    return string.format("%02dh %02dm %02ds", h, m, s)
end

-- ===== UI UPDATE LOOP =====
task.spawn(function()
    while getgenv().AUTO_REJOIN_ENABLED do
        local runtime = os.time() - StartTick
        kickLabel.Text = "💀 Kick count: " .. getgenv().KickCount
        timeLabel.Text = "⏱ Runtime: " .. FormatTime(getgenv().TotalTime + runtime)
        task.wait(1)
    end
end)

-- ===== DISABLE LOGIC =====
local function Shutdown()
    local runtime = os.time() - StartTick
    getgenv().TotalTime += runtime
    SaveData(getgenv().KickCount, getgenv().TotalTime)
end

disableBtn.MouseButton1Click:Connect(function()
    getgenv().AUTO_REJOIN_ENABLED = false
    status.Text = "🔴 Đã tắt hoàn toàn"
    Shutdown()
    task.delay(0.5, function()
        gui:Destroy()
    end)
end)

-- ===== REJOIN FUNCTION =====
local function Rejoin()
    if not getgenv().AUTO_REJOIN_ENABLED then return end
    task.wait(REJOIN_DELAY)
    getgenv().KickCount += 1
    SaveData(getgenv().KickCount, getgenv().TotalTime + (os.time() - StartTick))

    if SAVE_JOBID and getgenv().LastJobId then
        TeleportService:TeleportToPlaceInstance(
            game.PlaceId,
            getgenv().LastJobId,
            LocalPlayer
        )
    else
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
end

-- ===== DETECT KICK =====
GuiService.ErrorMessageChanged:Connect(Rejoin)
LocalPlayer.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Failed then
        Rejoin()
    end
end)

game:BindToClose(Shutdown)

print("[AUTO REJOIN PRO] Loaded successfully")
