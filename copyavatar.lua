local targetName = getgenv().Nametarget
local localSave = getgenv.save
local SAVE_PATH = ("avatar_%s.json"):format(targetName)

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- ===== Utils =====
local function getUserId(name)
	local id
	local ok = pcall(function()
		id = Players:GetUserIdFromNameAsync(name)
	end)
	return ok and id or nil
end

local function waitChar(plr)
	local char = plr.Character or plr.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid")
	char:WaitForChild("Head")
	task.wait(0.2)
	return char, hum
end

local function forceWeld(accessory, char)
	local handle = accessory:FindFirstChild("Handle")
	if not handle then return end

	handle.Anchored = false
	handle.CanCollide = false
	handle.Massless = true

	for _, v in ipairs(handle:GetChildren()) do
		if v:IsA("Weld") or v:IsA("WeldConstraint") then
			v:Destroy()
		end
	end

	local preferred = {
		"HatAttachment","HairAttachment","FaceFrontAttachment","FaceCenterAttachment",
		"NeckAttachment","BodyFrontAttachment","BodyBackAttachment",
		"LeftShoulderAttachment","RightShoulderAttachment",
		"WaistFrontAttachment","WaistBackAttachment",
	}

	local accAttachment
	for _, name in ipairs(preferred) do
		local at = handle:FindFirstChild(name)
		if at and at:IsA("Attachment") then
			accAttachment = at
			break
		end
	end
	if not accAttachment then
		accAttachment = handle:FindFirstChildWhichIsA("Attachment")
	end
	if not accAttachment then return end

	local charAttachment
	for _, desc in ipairs(char:GetDescendants()) do
		if desc:IsA("Attachment") and desc.Name == accAttachment.Name then
			charAttachment = desc
			break
		end
	end
	if not charAttachment then return end

	local targetPart = charAttachment.Parent
	if not targetPart or not targetPart:IsA("BasePart") then return end

	local weld = Instance.new("Weld")
	weld.Name = "AccessoryWeld_Fixed"
	weld.Part0 = targetPart
	weld.Part1 = handle
	weld.C0 = charAttachment.CFrame
	weld.C1 = accAttachment.CFrame
	weld.Parent = handle
end

local function fixAllAccessories(char)
	for _, acc in ipairs(char:GetChildren()) do
		if acc:IsA("Accessory") then
			local h = acc:FindFirstChild("Handle")
			if h then
				h.Anchored = false
				h.CanCollide = false
				h.Massless = true
			end
			if not acc:FindFirstChildWhichIsA("Weld", true)
				and not acc:FindFirstChildWhichIsA("WeldConstraint", true) then
				forceWeld(acc, char)
			end
		end
	end
end

-- ===== Save/Load HumanoidDescription
local fields = {
	-- R6 body parts
	"Head","Torso","LeftArm","RightArm","LeftLeg","RightLeg",
	-- scales (để đủ nếu avatar có)
	"BodyTypeScale","DepthScale","HeadScale","HeightScale","ProportionScale","WidthScale",
	-- colors
	"HeadColor","LeftArmColor","RightArmColor","LeftLegColor","RightLegColor","TorsoColor",
	-- clothes
	"Shirt","Pants","GraphicTShirt",
	-- accessories (list assetIds dạng string)
	"HatAccessory","HairAccessory","FaceAccessory","NeckAccessory","ShouldersAccessory",
	"FrontAccessory","BackAccessory","WaistAccessory",
}

local function canFileIO()
	return type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
end

local function descToData(desc, userId)
	local data = {
		_targetName = targetName,
		_userId = userId,
		_savedAt = os.time(),
	}
	for _, k in ipairs(fields) do
		data[k] = desc[k]
	end
	return data
end

local function dataToDesc(data)
	local desc = Instance.new("HumanoidDescription")
	for k, v in pairs(data) do
		if typeof(desc[k]) ~= "nil" then
			desc[k] = v
		end
	end
	return desc
end

local function saveDescToFile(desc, userId)
	if not localSave then return end
	if not canFileIO() then return end
	local data = descToData(desc, userId)
	local json = HttpService:JSONEncode(data)
	writefile(SAVE_PATH, json)
end

local function loadDescFromFile()
	if not localSave then return nil end
	if not canFileIO() then return nil end
	if not isfile(SAVE_PATH) then return nil end

	local ok, data = pcall(function()
		return HttpService:JSONDecode(readfile(SAVE_PATH))
	end)
	if not ok or type(data) ~= "table" then
		return nil
	end
	return dataToDesc(data)
end

local function fetchDescFromUserId(userId)
	local ok, res = pcall(function()
		return Players:GetHumanoidDescriptionFromUserId(userId)
	end)
	return ok and res or nil
end

local cachedDesc -- HumanoidDescription sẽ dùng để apply (từ file hoặc từ userid)

local function buildCachedDesc()
	local userId = getUserId(targetName)
	if not userId then
		warn("Không tìm thấy user:", targetName)
		return nil
	end

	if localSave then
		local fileDesc = loadDescFromFile()
		if fileDesc then
			print("✅ Đã load desc từ file:", SAVE_PATH)
			return fileDesc
		end
	end

	-- fallback
	local desc = fetchDescFromUserId(userId)
	if not desc then
		warn("Không lấy được HumanoidDescription của:", targetName)
		return nil
	end

	if localSave then
		saveDescToFile(desc, userId)
		print("✅ Đã lưu desc vào file:", SAVE_PATH)
	end

	return desc
end

local function applyToCharacter(char)
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	if humanoid.RigType ~= Enum.HumanoidRigType.R6 then
		warn("Không phải R6 -> bỏ qua")
		return
	end

	if not cachedDesc then
		cachedDesc = buildCachedDesc()
		if not cachedDesc then return end
	end

	local okApply, err = pcall(function()
		humanoid:ApplyDescription(cachedDesc)
	end)
	if not okApply then
		warn("ApplyDescription fail:", err)
		return
	end

	task.wait(0.3)
	fixAllAccessories(char)
	print("✅ Đã clone FULL avatar từ:", targetName, " (localSave:", localSave, ")")
end

-- ===== RUN + auto reload on death/reset =====
cachedDesc = buildCachedDesc()

-- apply ngay nếu đang có char
if LocalPlayer.Character then
	applyToCharacter(LocalPlayer.Character)
end

-- respawn/reset -> apply
LocalPlayer.CharacterAdded:Connect(function(char)
	char:WaitForChild("Humanoid")
	char:WaitForChild("Head")
	task.wait(0.2)
	applyToCharacter(char)
end)

task.spawn(function()
	while true do
		local char = LocalPlayer.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.Died:Connect(function()
					-- wait respawn, CharacterAdded
				end)
				break
			end
		end
		task.wait(0.2)
	end
end)
