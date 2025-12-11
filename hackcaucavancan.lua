gg.hideUiButton()

--============ CONFIG & DATA ============--
local savedValues = {}
local searchHistory = {}
local config = {
    autoSearch = false,
    autoInterval = 5000,
    lastSearch = nil,
    clientMode = true
}

--============ HELPER FUNCTIONS ============--
function loadConfig()
    local file = io.open(gg.EXT_STORAGE.."/GGHackPro_config.txt", "r")
    if file then
        local data = file:read("*a")
        file:close()
        if data ~= "" then
            local loaded = load("return "..data)()
            savedValues = loaded.savedValues or {}
            searchHistory = loaded.searchHistory or {}
        end
    end
end

function saveConfig()
    local file = io.open(gg.EXT_STORAGE.."/GGHackPro_config.txt", "w")
    if file then
        file:write("{\n  savedValues = {\n")
        for k, v in pairs(savedValues) do
            file:write(string.format('    ["%s"] = {value=%s, type=%d},\n', k, v.value, v.type))
        end
        file:write("  },\n  searchHistory = {\n")
        for i, h in ipairs(searchHistory) do
            file:write(string.format('    {find="%s", replace="%s", type=%d, count=%d},\n', 
                h.find, h.replace, h.type, h.count))
        end
        file:write("  }\n}")
        file:close()
        gg.toast("💾 Đã lưu cấu hình!")
    end
end

function addToHistory(find, replace, type, count)
    table.insert(searchHistory, 1, {
        find = find,
        replace = replace,
        type = type,
        count = count,
        time = os.date("%H:%M:%S")
    })
    if #searchHistory > 20 then
        table.remove(searchHistory, 21)
    end
end

--========= MENU CHÍNH ===========--
function mainMenu()
    local status = config.autoSearch and "🟢 Đang chạy" or "⚫ Tắt"
    local m = gg.choice({
        "🎯 Tìm Client Hiện Tại",
        "🔍 Tìm & Đổi Nâng Cao", 
        "🤖 Auto Tìm ["..status.."]",
        "📜 Lịch Sử Tìm Kiếm",
        "💾 Giá Trị Đã Lưu",
        "📊 Kết Quả Hiện Tại",
        "⚙️ Cài Đặt",
        "❌ Thoát"
    }, nil, "╔═══════════════════╗\n║  🔥 GG HACK PRO 🔥  ║\n║  ✨ Ultimate Edition ✨  ║\n╚═══════════════════╝")
    
    if m == nil then return end
    if m == 1 then findClientValues() end
    if m == 2 then advancedSearch() end
    if m == 3 then autoSearchMenu() end
    if m == 4 then historyMenu() end
    if m == 5 then savedValuesMenu() end
    if m == 6 then showCurrentResults() end
    if m == 7 then settingsMenu() end
    if m == 8 then exitScript() end
    
    mainMenu()
end

--============ TÌM CLIENT HIỆN TẠI ============--
function findClientValues()
    gg.toast("🎯 Tìm kiếm giá trị trong client...")
    
    -- Bước 1: Nhập giá trị ban đầu
    local step1 = gg.prompt(
        {"🔍 Nhập giá trị hiện tại trong game:",
         "🔢 Kiểu dữ liệu:"},
        {"", "1"},
        {"text", "number"}
    )
    
    if step1 == nil then return end
    
    local typeOptions = {
        [1] = {name = "DWORD", type = gg.TYPE_DWORD},
        [2] = {name = "DOUBLE", type = gg.TYPE_DOUBLE},
        [3] = {name = "FLOAT", type = gg.TYPE_FLOAT},
        [4] = {name = "QWORD", type = gg.TYPE_QWORD}
    }
    
    local typeChoice = gg.choice({
        "📌 DWORD (số nguyên 32-bit)",
        "📌 DOUBLE (số thập phân 64-bit)",
        "📌 FLOAT (số thập phân 32-bit)",
        "📌 QWORD (số nguyên 64-bit)"
    }, tonumber(step1[2]), "🔢 Chọn kiểu dữ liệu")
    
    if typeChoice == nil then return end
    
    local searchType = typeOptions[typeChoice].type
    local searchValue = step1[1]
    
    gg.toast("🔍 Đang tìm kiếm: "..searchValue)
    gg.clearResults()
    gg.searchNumber(searchValue, searchType)
    
    local r = gg.getResults(10000)
    local resultCount = #r
    
    if resultCount == 0 then
        gg.alert("❌ Không tìm thấy giá trị nào!\n\n💡 Thử lại với:\n• Kiểu dữ liệu khác\n• Giá trị chính xác hơn")
        return
    end
    
    -- Hiển thị kết quả
    local msg = string.format("✅ Tìm thấy %d kết quả!\n\n🔍 Giá trị: %s\n📊 Kiểu: %s", 
        resultCount, searchValue, typeOptions[typeChoice].name)
    
    if resultCount > 100 then
        msg = msg.."\n\n⚠️ Quá nhiều kết quả!\n💡 Nên tinh chỉnh thêm"
    end
    
    -- Bước 2: Chọn hành động
    local action = gg.choice({
        "✏️ Đổi tất cả giá trị",
        "🔍 Tinh chỉnh thêm (tìm lại)",
        "📋 Xem danh sách kết quả",
        "💾 Lưu kết quả này",
        "⬅️ Quay lại"
    }, nil, msg)
    
    if action == nil or action == 5 then return end
    
    if action == 1 then
        -- Đổi tất cả
        local newVal = gg.prompt(
            {"💎 Nhập giá trị muốn đổi thành:",
             "💾 Lưu vào lịch sử? (1=Có/0=Không)"},
            {"", "1"},
            {"text", "number"}
        )
        
        if newVal == nil then return end
        
        gg.editAll(newVal[1], searchType)
        gg.toast("🔥 ĐÃ ĐỔI THÀNH CÔNG!")
        
        local successMsg = string.format(
            "✅ HOÀN THÀNH!\n\n🎯 Đã đổi %d giá trị\n📝 %s → %s\n⏰ %s",
            resultCount, searchValue, newVal[1], os.date("%H:%M:%S")
        )
        
        gg.alert(successMsg)
        
        -- Lưu vào lịch sử
        if tonumber(newVal[2]) == 1 then
            addToHistory(searchValue, newVal[1], searchType, resultCount)
            saveConfig()
        end
        
    elseif action == 2 then
        -- Tinh chỉnh thêm
        local refine = gg.prompt(
            {"🔍 Nhập giá trị mới để tinh chỉnh:"},
            {""},
            {"text"}
        )
        
        if refine then
            gg.refineNumber(refine[1], searchType)
            local newResults = gg.getResults(10000)
            gg.alert(string.format("🔍 Đã tinh chỉnh!\n\n📊 Còn lại: %d kết quả", #newResults))
            return findClientValues()
        end
        
    elseif action == 3 then
        -- Xem danh sách
        local display = {}
        local limit = math.min(resultCount, 50)
        for i = 1, limit do
            table.insert(display, string.format("%d. 💎 %s @ 📍 0x%X", 
                i, r[i].value, r[i].address))
        end
        
        if resultCount > 50 then
            table.insert(display, string.format("\n... và %d kết quả khác", resultCount - 50))
        end
        
        gg.alert(table.concat(display, "\n"), "📋 KẾT QUẢ TÌM KIẾM")
        return findClientValues()
        
    elseif action == 4 then
        -- Lưu kết quả
        local saveName = gg.prompt(
            {"📝 Đặt tên cho giá trị này:"},
            {"Value_"..os.time()},
            {"text"}
        )
        
        if saveName then
            savedValues[saveName[1]] = {
                value = searchValue,
                type = searchType,
                count = resultCount
            }
            saveConfig()
            gg.toast("💾 Đã lưu: "..saveName[1])
        end
        return findClientValues()
    end
end

--============ TÌM KIẾM NÂNG CAO ============--
function advancedSearch()
    local searchMode = gg.choice({
        "🎯 Tìm giá trị chính xác",
        "🔍 Tìm trong khoảng",
        "♾️ Tìm giá trị unknown",
        "🔄 Tìm thay đổi/không đổi",
        "⬅️ Quay lại"
    }, nil, "🔍 CHỌN CHẾ ĐỘ TÌM KIẾM")
    
    if searchMode == nil or searchMode == 5 then return end
    
    if searchMode == 1 then
        exactSearch()
    elseif searchMode == 2 then
        rangeSearch()
    elseif searchMode == 3 then
        unknownSearch()
    elseif searchMode == 4 then
        changeSearch()
    end
end

function exactSearch()
    local input = gg.prompt(
        {"🔍 Giá trị cần tìm:",
         "💎 Đổi thành:",
         "🔢 Kiểu (1=DWORD/2=DOUBLE/3=FLOAT):"},
        {"", "", "2"},
        {"text", "text", "number"}
    )
    
    if input == nil then return end
    
    local types = {gg.TYPE_DWORD, gg.TYPE_DOUBLE, gg.TYPE_FLOAT}
    local searchType = types[tonumber(input[3])] or gg.TYPE_DOUBLE
    
    gg.clearResults()
    gg.searchNumber(input[1], searchType)
    
    local count = gg.getResultsCount()
    if count > 0 then
        gg.editAll(input[2], searchType)
        gg.alert(string.format("✅ Tìm thấy %d kết quả\n🔥 Đã đổi thành: %s", count, input[2]))
        addToHistory(input[1], input[2], searchType, count)
    else
        gg.alert("❌ Không tìm thấy kết quả!")
    end
end

function rangeSearch()
    local input = gg.prompt(
        {"🔽 Giá trị từ:",
         "🔼 Giá trị đến:",
         "💎 Đổi thành:",
         "🔢 Kiểu (1=DWORD/2=DOUBLE/3=FLOAT):"},
        {"", "", "", "2"},
        {"text", "text", "text", "number"}
    )
    
    if input == nil then return end
    
    local types = {gg.TYPE_DWORD, gg.TYPE_DOUBLE, gg.TYPE_FLOAT}
    local searchType = types[tonumber(input[4])] or gg.TYPE_DOUBLE
    
    gg.clearResults()
    gg.searchNumber(input[1].."~"..input[2], searchType)
    
    local count = gg.getResultsCount()
    if count > 0 then
        gg.editAll(input[3], searchType)
        gg.alert(string.format("✅ Tìm thấy %d kết quả\n🔥 Đã đổi thành: %s", count, input[3]))
    else
        gg.alert("❌ Không tìm thấy kết quả!")
    end
end

function unknownSearch()
    gg.alert("💡 Unknown Search:\n\n1. Bắt đầu tìm unknown\n2. Thay đổi giá trị trong game\n3. Tìm tiếp để lọc")
    
    local types = {gg.TYPE_DWORD, gg.TYPE_DOUBLE, gg.TYPE_FLOAT}
    local typeChoice = gg.prompt({"🔢 Kiểu (1=DWORD/2=DOUBLE/3=FLOAT):"}, {"2"}, {"number"})
    
    if typeChoice == nil then return end
    
    local searchType = types[tonumber(typeChoice[1])] or gg.TYPE_DOUBLE
    
    gg.clearResults()
    gg.searchNumber("0~~0", searchType)
    
    gg.alert(string.format("✅ Đã bắt đầu unknown search\n📊 Tìm thấy: %d giá trị\n\n💡 Hãy thay đổi giá trị trong game rồi quay lại!", 
        gg.getResultsCount()))
end

function changeSearch()
    local mode = gg.choice({
        "🔼 Giá trị tăng",
        "🔽 Giá trị giảm",
        "🔄 Giá trị thay đổi",
        "⏸️ Giá trị không đổi"
    }, nil, "🔍 Chọn loại thay đổi")
    
    if mode == nil then return end
    
    local searchStr = {
        [1] = "0~~0::",
        [2] = "::0~~0",
        [3] = "!0",
        [4] = "0"
    }
    
    gg.refineNumber(searchStr[mode])
    local count = gg.getResultsCount()
    
    gg.alert(string.format("🔍 Đã lọc giá trị\n📊 Còn lại: %d kết quả", count))
end

--============ AUTO SEARCH ============--
function autoSearchMenu()
    if config.autoSearch then
        local stop = gg.alert(
            string.format("🤖 AUTO SEARCH ĐANG CHẠY\n\n🔍 Tìm: %s\n⏱️ Mỗi: %dms\n📊 Kết quả: %d",
                config.lastSearch or "N/A",
                config.autoInterval,
                gg.getResultsCount()),
            "⏸️ Dừng",
            "⚙️ Cài đặt",
            "⬅️ Quay lại"
        )
        
        if stop == 1 then
            config.autoSearch = false
            gg.toast("⏸️ Đã dừng Auto Search!")
        elseif stop == 2 then
            local cfg = gg.prompt(
                {"🔍 Giá trị tìm:",
                 "⏱️ Interval (ms):"},
                {config.lastSearch or "", config.autoInterval},
                {"text", "number"}
            )
            if cfg then
                config.lastSearch = cfg[1]
                config.autoInterval = tonumber(cfg[2])
                gg.toast("✅ Đã cập nhật cài đặt!")
            end
        end
        return
    end
    
    local setup = gg.prompt(
        {"🔍 Giá trị tự động tìm:",
         "⏱️ Interval (ms):",
         "🔢 Kiểu (1=DWORD/2=DOUBLE/3=FLOAT):"},
        {"", "3000", "2"},
        {"text", "number", "number"}
    )
    
    if setup == nil then return end
    
    config.lastSearch = setup[1]
    config.autoInterval = tonumber(setup[2])
    config.autoSearch = true
    
    gg.toast("🤖 Đã bật Auto Search!")
end

function autoSearchLoop()
    if config.autoSearch and config.lastSearch then
        gg.searchNumber(config.lastSearch, gg.TYPE_DOUBLE)
        local r = gg.getResultsCount()
        if r > 0 then
            gg.toast(string.format("🤖 Auto: %d kết quả", r))
        end
    end
end

--============ LỊCH SỬ TÌM KIẾM ============--
function historyMenu()
    loadConfig()
    
    if #searchHistory == 0 then
        gg.alert("📭 Chưa có lịch sử tìm kiếm!")
        return
    end
    
    local list = {}
    for i, h in ipairs(searchHistory) do
        table.insert(list, string.format("🕐 %s | 🔍 %s → %s (%d)", 
            h.time, h.find, h.replace, h.count))
    end
    table.insert(list, "🗑️ Xóa lịch sử")
    table.insert(list, "⬅️ Quay lại")
    
    local s = gg.choice(list, nil, "📜 LỊCH SỬ TÌM KIẾM")
    
    if s == nil or s == #list then return end
    
    if s == #list - 1 then
        searchHistory = {}
        saveConfig()
        gg.toast("🗑️ Đã xóa lịch sử!")
        return
    end
    
    local h = searchHistory[s]
    local action = gg.choice({
        "🔍 Tìm lại giá trị này",
        "📋 Sao chép thông tin",
        "🗑️ Xóa mục này",
        "⬅️ Quay lại"
    }, nil, string.format("📌 %s → %s", h.find, h.replace))
    
    if action == 1 then
        gg.clearResults()
        gg.searchNumber(h.find, h.type)
        gg.toast(string.format("🔍 Tìm thấy %d kết quả", gg.getResultsCount()))
    elseif action == 3 then
        table.remove(searchHistory, s)
        saveConfig()
        gg.toast("🗑️ Đã xóa!")
    end
    
    historyMenu()
end

--============ GIÁ TRỊ ĐÃ LƯU ============--
function savedValuesMenu()
    loadConfig()
    
    if next(savedValues) == nil then
        gg.alert("📭 Chưa có giá trị nào được lưu!")
        return
    end
    
    local list = {"➕ Thêm giá trị mới"}
    local keys = {}
    
    for k, v in pairs(savedValues) do
        table.insert(list, string.format("📌 %s = %s (%d kết quả)", k, v.value, v.count or 0))
        table.insert(keys, k)
    end
    
    table.insert(list, "🗑️ Xóa tất cả")
    table.insert(list, "⬅️ Quay lại")
    
    local s = gg.choice(list, nil, "💾 GIÁ TRỊ ĐÃ LƯU")
    
    if s == nil or s == #list then return end
    
    if s == 1 then
        local new = gg.prompt(
            {"📝 Tên:",
             "💎 Giá trị:",
             "🔢 Kiểu (1=DWORD/2=DOUBLE/3=FLOAT):"},
            {"", "", "2"},
            {"text", "text", "number"}
        )
        if new then
            local types = {gg.TYPE_DWORD, gg.TYPE_DOUBLE, gg.TYPE_FLOAT}
            savedValues[new[1]] = {
                value = new[2],
                type = types[tonumber(new[3])],
                count = 0
            }
            saveConfig()
            gg.toast("💾 Đã lưu!")
        end
        return savedValuesMenu()
    end
    
    if s == #list - 1 then
        local confirm = gg.alert("⚠️ Xóa tất cả giá trị?", "✔️ Có", "❌ Không")
        if confirm == 1 then
            savedValues = {}
            saveConfig()
            gg.toast("🗑️ Đã xóa tất cả!")
        end
        return
    end
    
    local key = keys[s - 1]
    local val = savedValues[key]
    
    local action = gg.choice({
        "🔍 Tìm giá trị này",
        "✏️ Chỉnh sửa",
        "🗑️ Xóa",
        "⬅️ Quay lại"
    }, nil, string.format("📌 %s = %s", key, val.value))
    
    if action == 1 then
        gg.clearResults()
        gg.searchNumber(val.value, val.type)
        gg.toast(string.format("🔍 Tìm thấy %d kết quả", gg.getResultsCount()))
    elseif action == 2 then
        local edit = gg.prompt({"💎 Giá trị mới:"}, {val.value}, {"text"})
        if edit then
            savedValues[key].value = edit[1]
            saveConfig()
            gg.toast("✅ Đã cập nhật!")
        end
    elseif action == 3 then
        savedValues[key] = nil
        saveConfig()
        gg.toast("🗑️ Đã xóa!")
    end
    
    savedValuesMenu()
end

--============ KẾT QUẢ HIỆN TẠI ============--
function showCurrentResults()
    local count = gg.getResultsCount()
    
    if count == 0 then
        gg.alert("📭 Không có kết quả nào!")
        return
    end
    
    local action = gg.choice({
        "📋 Xem danh sách (50 đầu)",
        "✏️ Đổi tất cả",
        "🔒 Freeze tất cả",
        "🗑️ Xóa kết quả",
        "⬅️ Quay lại"
    }, nil, string.format("📊 HIỆN CÓ %d KẾT QUẢ", count))
    
    if action == nil or action == 5 then return end
    
    if action == 1 then
        local results = gg.getResults(50)
        local msg = {}
        for i, v in ipairs(results) do
            table.insert(msg, string.format("%d. 💎 %s @ 📍 0x%X", i, v.value, v.address))
        end
        if count > 50 then
            table.insert(msg, string.format("\n... và %d kết quả khác", count - 50))
        end
        gg.alert(table.concat(msg, "\n"))
        return showCurrentResults()
        
    elseif action == 2 then
        local newVal = gg.prompt({"💎 Đổi tất cả thành:"}, {""}, {"text"})
        if newVal then
            gg.editAll(newVal[1], gg.TYPE_AUTO)
            gg.toast(string.format("🔥 Đã đổi %d giá trị!", count))
        end
        
    elseif action == 3 then
        local results = gg.getResults(count)
        for i, v in ipairs(results) do
            v.freeze = true
        end
        gg.addListItems(results)
        gg.toast(string.format("🔒 Đã freeze %d giá trị!", count))
        
    elseif action == 4 then
        gg.clearResults()
        gg.toast("🗑️ Đã xóa kết quả!")
    end
end

--============ CÀI ĐẶT ============--
function settingsMenu()
    local a = gg.choice({
        "🧹 Xóa Kết Quả",
        "🔓 Unfreeze Tất Cả",
        "💾 Xuất Cấu Hình",
        "📂 Xem File Config",
        "🔄 Reset Script",
        "⬅️ Quay Lại"
    }, nil, "⚙️ CÀI ĐẶT")
    
    if a == nil or a == 6 then return end
    
    if a == 1 then
        gg.clearResults()
        gg.toast("🧹 Đã xóa kết quả!")
        return settingsMenu()
    end
    
    if a == 2 then
        gg.clearList()
        gg.toast("🔓 Đã unfreeze tất cả!")
        return settingsMenu()
    end
    
    if a == 3 then
        saveConfig()
        gg.alert("💾 Cấu hình đã được lưu tại:\n"..gg.EXT_STORAGE.."/GGHackPro_config.txt")
        return settingsMenu()
    end
    
    if a == 4 then
        gg.alert("📂 Vị trí file:\n"..gg.EXT_STORAGE.."/GGHackPro_config.txt\n\n📊 Lịch sử: "..#searchHistory.."\n💾 Đã lưu: "..#savedValues)
        return settingsMenu()
    end
    
    if a == 5 then
        local confirm = gg.alert("⚠️ Reset toàn bộ script?\n\n• Xóa kết quả\n• Tắt auto\n• Xóa freeze", "✔️ Có", "❌ Không")
        if confirm == 1 then
            gg.clearResults()
            gg.clearList()
            config.autoSearch = false
            gg.toast("🔄 Đã reset!")
        end
        return
    end
    
    settingsMenu()
end

--============ THOÁT ============--
function exitScript()
    local confirm = gg.choice({
        "✔️ Thoát ngay",
        "💾 Lưu & Thoát",
        "❌ Hủy"
    }, nil, "╔═══════════════╗\n║  ⚠️ THOÁT SCRIPT  ║\n╚═══════════════╝")
    
    if confirm == 1 then
        gg.toast("👋 Goodbye!")
        os.exit()
    elseif confirm == 2 then
        saveConfig()
        gg.toast("💾 Đã lưu! 👋 Goodbye!")
        os.exit()
    end
end

--============= MAIN LOOP =================--
loadConfig()
local lastAutoTime = os.clock()

gg.toast("🔥 GG HACK PRO LOADED!\n✨ Ultimate Edition")

while true do
    if config.autoSearch then
        local now = os.clock()
        if (now - lastAutoTime) * 1000 >= config.autoInterval then
            autoSearchLoop()
            lastAutoTime = now
        end
    end
    
    if gg.isVisible() then
        gg.setVisible(false)
        mainMenu()
    end
    
    gg.sleep(100)
end
