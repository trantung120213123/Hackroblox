-- Grow a Garden - Hướng Dẫn Cơ Bản (Phần 1)
-- GUI đơn giản, nút 💀 để ẩn/hiện, có thể kéo, hiện nội dung

local gui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "GrowGuide"
local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0, 40, 0, 40)
toggle.Position = UDim2.new(0, 10, 0, 10)
toggle.Text = "💀"
toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.ZIndex = 10

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0, 60, 0, 60)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Visible = true
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🌱 Grow a Garden - Phần 1"
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 16
title.Font = Enum.Font.SourceSansBold

local textBox = Instance.new("TextLabel", frame)
textBox.Position = UDim2.new(0, 0, 0, 30)
textBox.Size = UDim2.new(1, 0, 1, -30)
textBox.TextWrapped = true
textBox.TextYAlignment = Enum.TextYAlignment.Top
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.TextSize = 14
textBox.Font = Enum.Font.SourceSans
textBox.TextColor3 = Color3.new(1, 1, 1)
textBox.BackgroundTransparency = 1
textBox.Text = [[
📌 Hướng dẫn cơ bản:
- Nhiệm vụ chính: trồng cây, tưới nước, thu hoạch, mở rộng vườn.
- Click vào cây để tưới và thu hoạch.
- Dùng tiền để nâng cấp watering can, mua cây mới.
- Ưu tiên nâng cấp nước để nhanh lên cấp.
- Cây càng mắc cho tiền càng nhiều.
]]

toggle.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- Đặt trong StarterGui > LocalScript
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AIHelperGui"
gui.ResetOnSpawn = false

-- Khung chính
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0, 10, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Name = "MainFrame"
frame.Active = true
frame.Draggable = true

-- Nút thu nhỏ
local toggle = Instance.new("TextButton", frame)
toggle.Text = "-"
toggle.Size = UDim2.new(0, 30, 0, 30)
toggle.Position = UDim2.new(1, -35, 0, 5)
toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Name = "MinimizeBtn"

-- Tiêu đề
local title = Instance.new("TextLabel", frame)
title.Text = "🌱 Grow A Garden - Trợ lý AI"
title.Size = UDim2.new(1, -40, 0, 30)
title.Position = UDim2.new(0, 5, 0, 5)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left

-- Vùng hiện phản hồi AI
local responseBox = Instance.new("TextLabel", frame)
responseBox.Size = UDim2.new(1, -10, 0, 140)
responseBox.Position = UDim2.new(0, 5, 0, 40)
responseBox.TextWrapped = true
responseBox.Text = "Xin chào! Bạn cần giúp gì trong Grow a Garden?"
responseBox.TextColor3 = Color3.new(1, 1, 1)
responseBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
responseBox.TextYAlignment = Enum.TextYAlignment.Top
responseBox.TextXAlignment = Enum.TextXAlignment.Left
responseBox.Name = "AIResponse"
responseBox.ClipsDescendants = true

-- Ô nhập
local input = Instance.new("TextBox", frame)
input.Size = UDim2.new(1, -10, 0, 30)
input.Position = UDim2.new(0, 5, 1, -35)
input.PlaceholderText = "Nhập câu hỏi về game..."
input.TextColor3 = Color3.new(1, 1, 1)
input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
input.Name = "InputBox"
input.ClearTextOnFocus = false

-- Thu nhỏ/Mở rộng
local isMinimized = false
toggle.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	if isMinimized then
		frame.Size = UDim2.new(0, 300, 0, 40)
		toggle.Text = "+"
	else
		frame.Size = UDim2.new(0, 300, 0, 250)
		toggle.Text = "-"
	end
end)

-- 🧠 Lưu và hiển thị lịch sử hội thoại
local ChatHistory = {}

-- Hàm thêm lịch sử
local function AddToHistory(question, answer)
    table.insert(ChatHistory, {q = question, a = answer})
end

-- GUI hiển thị lịch sử
local historyFrame = Instance.new("ScrollingFrame")
historyFrame.Size = UDim2.new(0, 250, 0, 150)
historyFrame.Position = UDim2.new(0, 10, 0, 230)
historyFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
historyFrame.BorderSizePixel = 1
historyFrame.Parent = screenGui
historyFrame.Visible = true
historyFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
historyFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
historyFrame.ScrollBarThickness = 6

-- Hàm cập nhật GUI lịch sử
local function UpdateHistoryUI()
    for _, child in ipairs(historyFrame:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end

    local yPos = 0
    for i, entry in ipairs(ChatHistory) do
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 0, 40)
        label.Position = UDim2.new(0, 5, 0, yPos)
        label.BackgroundTransparency = 1
        label.TextWrapped = true
        label.Text = i..". " .. entry.q .. "\n→ " .. entry.a
        label.TextColor3 = Color3.fromRGB(30, 30, 30)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.SourceSans
        label.TextSize = 14
        label.Parent = historyFrame

        yPos = yPos + 45
    end

    historyFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

table.insert(QAData, {
    question = "Làm sao để kiếm tiền nhanh trong Grow a Garden?",
    answer = "Trồng cây cấp cao, nâng cấp watering can và thường xuyên thu hoạch. Mua pet giúp tăng lợi nhuận từ mỗi cây."
})

table.insert(QAData, {
    question = "Pet nào giúp tăng tiền?",
    answer = "Các pet hiếm (Rare hoặc Legendary) có thể tăng 10-30% lợi nhuận mỗi cây. Hãy mở trứng hoặc mua trong shop pet."
})

table.insert(QAData, {
    question = "Có nên dùng gem để tăng tiền không?",
    answer = "Có, bạn có thể dùng gem để mua các boost như 'Double Coins' để tăng gấp đôi tiền trong 10 phút."
})

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "QAGui"

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.Text = "💀"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.ZIndex = 10
ToggleBtn.Draggable = true
ToggleBtn.Active = true

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0, 60, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true

local UIListLayout = Instance.new("UIListLayout", MainFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Thêm khung cuộn nếu cần nhiều câu hỏi
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, 0, 1, 0)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 4
Scroll.BackgroundTransparency = 1
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.BorderSizePixel = 0

local QAListLayout = Instance.new("UIListLayout", Scroll)
QAListLayout.SortOrder = Enum.SortOrder.LayoutOrder
QAListLayout.Padding = UDim.new(0, 4)

-- Hiển thị câu hỏi
for _, qa in ipairs(QAData) do
	local QuestionLabel = Instance.new("TextLabel", Scroll)
	QuestionLabel.Size = UDim2.new(1, -10, 0, 40)
	QuestionLabel.Text = "❓ " .. qa.question .. "\n📝 " .. qa.answer
	QuestionLabel.TextWrapped = true
	QuestionLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	QuestionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	QuestionLabel.TextXAlignment = Enum.TextXAlignment.Left
	QuestionLabel.TextYAlignment = Enum.TextYAlignment.Top
	QuestionLabel.Font = Enum.Font.SourceSans
	QuestionLabel.TextSize = 16
end

-- Toggle ẩn/hiện
ToggleBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

local Tips = {
    "🌻 Trồng nhiều cây cùng loại để nhận bonus!",
    "🛒 Ghé thăm shop thường xuyên để nâng cấp công cụ!",
    "🐌 Dọn sạch sên để tránh giảm năng suất!",
    "💧 Luôn tưới nước đúng thời điểm để cây phát triển nhanh hơn!",
    "🌟 Sử dụng phân bón để tăng tốc độ tăng trưởng!"
}

-- UI phần hiển thị mẹo
local TipsFrame = Instance.new("Frame")
TipsFrame.Size = UDim2.new(0, 280, 0, 60)
TipsFrame.Position = UDim2.new(1, -290, 1, -140)
TipsFrame.BackgroundColor3 = Color3.fromRGB(255, 250, 200)
TipsFrame.BorderSizePixel = 1
TipsFrame.Visible = true
TipsFrame.Parent = ScreenGui

local TipText = Instance.new("TextLabel")
TipText.Size = UDim2.new(1, 0, 1, 0)
TipText.BackgroundTransparency = 1
TipText.TextColor3 = Color3.fromRGB(80, 60, 0)
TipText.Font = Enum.Font.Ubuntu
TipText.TextScaled = true
TipText.TextWrapped = true
TipText.Parent = TipsFrame

-- Chức năng cập nhật mẹo mỗi 20 giây
spawn(function()
	while wait(20) do
		local randomTip = Tips[math.random(1, #Tips)]
		TipText.Text = "💡 Mẹo: " .. randomTip
	end
end)

-- Tạo GUI chính
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AI_Greet_GUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.Visible = true
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 12)

-- Nút thu nhỏ/mở rộng
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 30, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.Text = "💬"
ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

local function toggleFrame()
	Frame.Visible = not Frame.Visible
end
ToggleButton.MouseButton1Click:Connect(toggleFrame)

-- Nhãn hiển thị đoạn hội thoại
local MessageLabel = Instance.new("TextLabel", Frame)
MessageLabel.Size = UDim2.new(1, -20, 1, -20)
MessageLabel.Position = UDim2.new(0, 10, 0, 10)
MessageLabel.TextWrapped = true
MessageLabel.Font = Enum.Font.Gotham
MessageLabel.TextSize = 16
MessageLabel.TextColor3 = Color3.new(1, 1, 1)
MessageLabel.BackgroundTransparency = 1

-- Danh sách hội thoại chào hỏi ngẫu nhiên
local greetings = {
	"Ê, m là ai zợ?",
	"Chào! T là AI hướng dẫn đây 😎",
	"Cần giúp gì thì hỏi tao nhá!",
	"Hello, t đang canh vườn nè, m cần gì?",
	"Ê ku! Vô trồng cây chưa đó?",
	"Xin chào! T là trợ lý ảo của game này!",
	"Trời nóng vãi, nhớ tưới cây đó ~ 🌱"
}

-- Hiển thị đoạn chào ngẫu nhiên
local function greet()
	local chosen = greetings[math.random(1, #greetings)]
	MessageLabel.Text = chosen
end

greet() -- Gọi khi khởi động

local AdvancedQnA = {
    ["có cách nào kiếm tiền nhanh không?"] = {
        "Bạn nên trồng loại cây giá trị cao như Cây Tiền hoặc Cây Vàng!",
        "Thử đầu tư vào phân bón tăng trưởng nhé!",
        "Nhiều người dùng chiến thuật mở ô nhanh rồi trồng liên tục.",
    },
    ["tại sao cây không lớn?"] = {
        "Có thể bạn quên tưới nước đó!",
        "Nhớ đặt cây ở khu vực có ánh sáng nhé!",
        "Cây cần thời gian, kiên nhẫn chút nào!",
    },
    ["cách nâng cấp watering can?"] = {
        "Bạn có thể tìm NPC ở góc trái bản đồ.",
        "Đổi xu hoặc vật phẩm hiếm để nâng cấp bình tưới.",
        "Lên cấp và sẽ mở khóa tự động!",
    },
}

-- Phản hồi nâng cao
function respondAdvanced(input)
    input = string.lower(input)
    if AdvancedQnA[input] then
        local responses = AdvancedQnA[input]
        local index = math.random(1, #responses)
        return responses[index]
    end
    return nil
end

--// PHẦN 9: Mutation GUI TỰ TẠO \\--

local mutationFrame = Instance.new("Frame")
mutationFrame.Size = UDim2.new(0, 250, 0, 270)
mutationFrame.Position = UDim2.new(0, 400, 0, 120)
mutationFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mutationFrame.BorderSizePixel = 0
mutationFrame.Visible = false
mutationFrame.Name = "MutationFrame"
mutationFrame.Parent = mainGui

local mutationTitle = Instance.new("TextLabel")
mutationTitle.Size = UDim2.new(1, 0, 0, 30)
mutationTitle.BackgroundTransparency = 1
mutationTitle.Text = "🧬 Mutation Info"
mutationTitle.Font = Enum.Font.SourceSansBold
mutationTitle.TextSize = 20
mutationTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
mutationTitle.Parent = mutationFrame

local scrolling = Instance.new("ScrollingFrame")
scrolling.Size = UDim2.new(1, 0, 1, -30)
scrolling.Position = UDim2.new(0, 0, 0, 30)
scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
scrolling.BackgroundTransparency = 1
scrolling.ScrollBarThickness = 5
scrolling.Parent = mutationFrame

local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0, 6)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Parent = scrolling

-- Dữ liệu mutation mẫu
local mutations = {
    {Parents = {"Sunflower", "Cactus"}, Result = "🌵 Spiked Sunflower", Chance = 0.15},
    {Parents = {"Rose", "Tulip"}, Result = "🌈 Rainbow Bloom", Chance = 0.1},
    {Parents = {"Carrot", "Pumpkin"}, Result = "🥕 Mega Veggie", Chance = 0.2},
    {Parents = {"Wheat", "Corn"}, Result = "🌾 Golden Harvest", Chance = 0.05}
}

for _, mut in pairs(mutations) do
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 35)
    label.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextWrapped = true
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.Text = string.format("🔁 %s + %s → %s\n🎯 Tỉ lệ: %d%%", mut.Parents[1], mut.Parents[2], mut.Result, mut.Chance * 100)
    label.Parent = scrolling
end

scrolling.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y + 10)

-- Nút mở GUI Mutation
local mutationBtn = Instance.new("TextButton")
mutationBtn.Size = UDim2.new(0, 120, 0, 30)
mutationBtn.Position = UDim2.new(0, 140, 0, 360)
mutationBtn.Text = "🧬 Mutation Info"
mutationBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
mutationBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
mutationBtn.Font = Enum.Font.GothamBold
mutationBtn.TextSize = 14
mutationBtn.Parent = mainGui

mutationBtn.MouseButton1Click:Connect(function()
    mutationFrame.Visible = not mutationFrame.Visible
end)

-- Công thức lợi nhuận theo thời gian
local function calculateProfit(seed)
    local profit = seed.sellPrice - seed.buyPrice
    local profitPerSec = profit / seed.growTime
    return profitPerSec
end

-- Danh sách hạt giống
local seeds = {
    {name="Carrot", buyPrice=10, sellPrice=20, growTime=30},
    {name="Tomato", buyPrice=15, sellPrice=35, growTime=50},
    {name="Corn", buyPrice=25, sellPrice=60, growTime=70},
    {name="Strawberry", buyPrice=40, sellPrice=90, growTime=80}
}

-- Tìm hạt lời nhất
local function getBestSeed()
    local bestSeed = nil
    local bestRate = -math.huge

    for _, seed in ipairs(seeds) do
        local rate = calculateProfit(seed)
        if rate > bestRate then
            bestRate = rate
            bestSeed = seed
        end
    end

    return bestSeed
end

-- Hiển thị ra GUI hoặc console
local best = getBestSeed()
print("🌱 Hạt giống lời nhất hiện tại là: "..best.name.." (Lời/t giây: "..math.floor((best.sellPrice - best.buyPrice)/best.growTime * 100)/100 .. "$/s)")

-- Danh sách giá cây trong Seed Shop (ví dụ, cần cập nhật đúng giá trong game)
local Seeds = {
    {Name = "Carrot", Price = 10, GrowthTime = 15, SellPrice = 20, MutationRate = 0.05},
    {Name = "Tomato", Price = 25, GrowthTime = 20, SellPrice = 45, MutationRate = 0.10},
    {Name = "Pumpkin", Price = 60, GrowthTime = 35, SellPrice = 110, MutationRate = 0.15},
    {Name = "Cabbage", Price = 100, GrowthTime = 60, SellPrice = 200, MutationRate = 0.25},
    {Name = "Golden Apple", Price = 500, GrowthTime = 120, SellPrice = 1500, MutationRate = 0.50}
}

-- Hàm tính lời/lỗ + hiệu suất theo thời gian
local function analyzeSeeds()
    print("===== PHÂN TÍCH CÂY TRỒNG =====")
    for _, seed in pairs(Seeds) do
        local profit = seed.SellPrice - seed.Price
        local profitPerSecond = profit / seed.GrowthTime
        local mutationRate = seed.MutationRate

        print("🌱 " .. seed.Name)
        print("💰 Giá mua: " .. seed.Price .. " | 💸 Giá bán: " .. seed.SellPrice)
        print("⏱️ Thời gian lớn: " .. seed.GrowthTime .. "s")
        print("📈 Lợi nhuận: " .. profit .. " | 🔁 Lợi nhuận/s: " .. string.format("%.2f", profitPerSecond))
        print("🧬 Tỉ lệ Mutation: " .. (mutationRate * 100) .. "%")
        print("-----------------------------------")
    end
end

-- Gọi hàm phân tích
analyzeSeeds()
