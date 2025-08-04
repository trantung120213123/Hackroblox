-- PHẦN 1: TẠO GUI BÀN CỜ + HIỂN THỊ QUÂN CỜ (khởi tạo FEN)
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ChessGUI"

local boardSize = 400
local tileSize = boardSize / 8
local selected = nil
local boardState = {} -- lưu quân cờ hiện tại

-- Quân cờ Unicode
local pieces = {
    r = "♜", n = "♞", b = "♝", q = "♛", k = "♚", p = "♟",
    R = "♖", N = "♘", B = "♗", Q = "♕", K = "♔", P = "♙",
    [""] = ""
}

-- Bàn cờ chứa các ô
local boardFrame = Instance.new("Frame", gui)
boardFrame.Size = UDim2.new(0, boardSize, 0, boardSize)
boardFrame.Position = UDim2.new(0.5, -boardSize/2, 0.5, -boardSize/2)
boardFrame.BackgroundTransparency = 1

-- Tạo ô bàn cờ + quân cờ ban đầu theo FEN
local startFEN = {
    "R","N","B","Q","K","B","N","R",
    "P","P","P","P","P","P","P","P",
    "","","","","","","","",
    "","","","","","","","",
    "","","","","","","","",
    "","","","","","","","",
    "p","p","p","p","p","p","p","p",
    "r","n","b","q","k","b","n","r",
}

for row = 1, 8 do
    for col = 1, 8 do
        local i = (row - 1) * 8 + col
        local tile = Instance.new("TextButton", boardFrame)
        tile.Size = UDim2.new(0, tileSize, 0, tileSize)
        tile.Position = UDim2.new(0, (col - 1) * tileSize, 0, (row - 1) * tileSize)
        tile.BackgroundColor3 = ((row + col) % 2 == 0) and Color3.fromRGB(240, 217, 181) or Color3.fromRGB(181, 136, 99)
        tile.Text = pieces[startFEN[i]] or ""
        tile.Font = Enum.Font.SourceSans
        tile.TextSize = 32
        tile.TextColor3 = Color3.new(0, 0, 0)
        tile.Name = row .. "," .. col

        -- Lưu quân cờ vào boardState
        boardState[tile.Name] = startFEN[i]

        -- Sự kiện click xử lý di chuyển (sẽ viết ở phần sau)
        tile.MouseButton1Click:Connect(function()
            _G.OnTileClick(tile)
        end)
    end
end

-- PHẦN 2: Hàm chọn và di chuyển quân (gắn vào _G để dễ quản lý)
_G.OnTileClick = function(tile)
    local name = tile.Name
    local piece = boardState[name]

    if _G.SelectedTile == nil then
        -- Nếu chưa chọn ô nào => chọn ô hiện tại nếu có quân
        if piece ~= "" then
            _G.SelectedTile = tile
            tile.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- Tô vàng ô được chọn
        end
    else
        local from = _G.SelectedTile
        local fromName = from.Name
        local fromPiece = boardState[fromName]

        -- Di chuyển quân
        boardState[name] = fromPiece
        boardState[fromName] = ""

        tile.Text = pieces[fromPiece]
        from.Text = ""

        -- Reset màu 2 ô
        local row1, col1 = string.match(fromName, "(%d+),(%d+)")
        from.BackgroundColor3 = ((tonumber(row1)+tonumber(col1))%2==0)
            and Color3.fromRGB(240,217,181) or Color3.fromRGB(181,136,99)

        local row2, col2 = string.match(name, "(%d+),(%d+)")
        tile.BackgroundColor3 = ((tonumber(row2)+tonumber(col2))%2==0)
            and Color3.fromRGB(240,217,181) or Color3.fromRGB(181,136,99)

        -- Hủy chọn
        _G.SelectedTile = nil
    end
end

