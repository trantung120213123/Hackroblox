-- FULL SCRIPT: clone avatar R6 + accessory weld fix + save/load clone json

local save = getgenv().saves
local loadfile = getgenv().loadfiles
local targetName = getgenv().targetName or "tranmyAAmac"
local CLONE_JSON_PATH = "luex/clone.json"

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

local function getAppearance(userId)
	local app
	local ok = pcall(function()
		app = Players:GetCharacterAppearanceAsync(userId)
	end)
	return ok and app or nil
end

local function getDescription(userId)
	local desc
	local ok = pcall(function()
		desc = Players:GetHumanoidDescriptionFromUserId(userId)
	end)
	return ok and desc or nil
end

local function clearLook(char)
	for _, v in ipairs(char:GetChildren()) do
		if v:IsA("Accessory")
			or v:IsA("Shirt")
			or v:IsA("Pants")
			or v:IsA("ShirtGraphic")
			or v:IsA("BodyColors")
			or v:IsA("CharacterMesh") then
			v:Destroy()
		end
	end

	local head = char:FindFirstChild("Head")
	if head then
		local face = head:FindFirstChildOfClass("Decal")
		if face then
			face:Destroy()
		end
	end
end

local function toInt(v)
	local n = tonumber(v)
	if not n then
		return nil
	end
	return math.floor(n)
end

local function snapshotDescription(desc)
	if not desc then
		return nil
	end

	local out = {}

	local intProps = {
		"Head", "Face", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg",
		"GraphicTShirt", "Shirt", "Pants",
	}

	local stringProps = {
		"HatAccessory", "HairAccessory", "FaceAccessory", "NeckAccessory", "ShouldersAccessory", "FrontAccessory", "BackAccessory", "WaistAccessory",
	}

	local numberProps = {
		"BodyTypeScale", "DepthScale", "HeadScale", "HeightScale", "ProportionScale", "WidthScale",
	}

	for _, prop in ipairs(intProps) do
		local v = toInt(desc[prop])
		if v and v > 0 then
			out[prop] = v
		end
	end

	for _, prop in ipairs(stringProps) do
		local v = desc[prop]
		if type(v) == "string" and v ~= "" then
			out[prop] = v
		end
	end

	for _, prop in ipairs(numberProps) do
		local v = tonumber(desc[prop])
		if v then
			out[prop] = v
		end
	end

	return out
end

local function buildDescriptionFromSnapshot(snapshot)
	if type(snapshot) ~= "table" then
		return nil
	end

	local desc = Instance.new("HumanoidDescription")
	for prop, value in pairs(snapshot) do
		local ok = pcall(function()
			desc[prop] = value
		end)
		if not ok then
			-- ignore unknown/invalid properties
		end
	end
	return desc
end

local function saveCloneJson(userId, desc)
	if not save then
		return
	end

	if type(makefolder) ~= "function" or type(writefile) ~= "function" then
		warn("saves=true nhung executor khong ho tro makefolder/writefile")
		return
	end

	local data = {
		userid = userId,
		target_name = targetName,
		timestamp_unix = os.time(),
		description = snapshotDescription(desc),
	}

	makefolder("luex")
	local ok, encoded = pcall(function()
		return HttpService:JSONEncode(data)
	end)
	if not ok then
		warn("Khong encode duoc clone json")
		return
	end

	writefile(CLONE_JSON_PATH, encoded)
	print("Da luu full avatar vao:", CLONE_JSON_PATH)
end

local function tryLoadDescriptionFromJson()
	if type(isfile) ~= "function" or type(readfile) ~= "function" then
		return nil, nil
	end

	if not isfile(CLONE_JSON_PATH) then
		return nil, nil
	end

	local okRead, raw = pcall(function()
		return readfile(CLONE_JSON_PATH)
	end)
	if not okRead or type(raw) ~= "string" or raw == "" then
		warn("Khong doc duoc", CLONE_JSON_PATH)
		return nil, nil
	end

	local okDecode, data = pcall(function()
		return HttpService:JSONDecode(raw)
	end)
	if not okDecode or type(data) ~= "table" then
		warn("JSON loi:", CLONE_JSON_PATH)
		return nil, nil
	end

	local desc = buildDescriptionFromSnapshot(data.description)
	if not desc then
		warn("Json clone khong co du lieu avatar hop le")
		return nil, nil
	end

	return desc, data
end

-- ===== Weld by Attachment to avoid stacking =====
local function forceWeld(accessory, char)
	local handle = accessory:FindFirstChild("Handle")
	if not handle then
		return
	end

	handle.Anchored = false
	handle.CanCollide = false
	handle.Massless = true

	for _, v in ipairs(handle:GetChildren()) do
		if v:IsA("Weld") or v:IsA("WeldConstraint") then
			v:Destroy()
		end
	end

	local preferred = {
		"HatAttachment",
		"HairAttachment",
		"FaceFrontAttachment",
		"FaceCenterAttachment",
		"NeckAttachment",
		"BodyFrontAttachment",
		"BodyBackAttachment",
		"LeftShoulderAttachment",
		"RightShoulderAttachment",
		"WaistFrontAttachment",
		"WaistBackAttachment",
	}

	local function findAccAttachment()
		for _, name in ipairs(preferred) do
			local at = handle:FindFirstChild(name)
			if at and at:IsA("Attachment") then
				return at
			end
		end
		return handle:FindFirstChildWhichIsA("Attachment")
	end

	local accAttachment = findAccAttachment()
	if not accAttachment then
		return
	end

	local charAttachment
	for _, desc in ipairs(char:GetDescendants()) do
		if desc:IsA("Attachment") and desc.Name == accAttachment.Name then
			charAttachment = desc
			break
		end
	end
	if not charAttachment then
		return
	end

	local targetPart = charAttachment.Parent
	if not targetPart or not targetPart:IsA("BasePart") then
		return
	end

	local weld = Instance.new("Weld")
	weld.Name = "AccessoryWeld_Fixed"
	weld.Part0 = targetPart
	weld.Part1 = handle
	weld.C0 = charAttachment.CFrame
	weld.C1 = accAttachment.CFrame
	weld.Parent = handle
end

-- ===== MAIN =====
local cachedUserId = nil
local cachedAppearance = nil
local cachedDescription = nil
local jsonWarned = false

local function ensureOnlineData()
	if cachedUserId and cachedAppearance then
		return true
	end

	cachedUserId = getUserId(targetName)
	if not cachedUserId then
		warn("Khong tim thay user:", targetName)
		return false
	end

	cachedAppearance = getAppearance(cachedUserId)
	if not cachedAppearance then
		warn("Khong lay duoc appearance cua:", targetName)
		return false
	end

	cachedDescription = getDescription(cachedUserId)

	local hasJson = type(isfile) == "function" and isfile(CLONE_JSON_PATH)
	if (not hasJson) and save and cachedDescription then
		saveCloneJson(cachedUserId, cachedDescription)
	end

	return true
end

local function applyFromOnlineAppearance(char, humanoid)
	if humanoid.RigType ~= Enum.HumanoidRigType.R6 then
		warn("Khong phai R6")
		return
	end

	if not ensureOnlineData() then
		return
	end

	clearLook(char)

	for _, v in ipairs(cachedAppearance:GetChildren()) do
		if v:IsA("Shirt")
			or v:IsA("Pants")
			or v:IsA("ShirtGraphic")
			or v:IsA("BodyColors")
			or v:IsA("CharacterMesh") then
			v:Clone().Parent = char
		end
	end

	local h1 = cachedAppearance:FindFirstChild("Head")
	local h2 = char:FindFirstChild("Head")
	if h1 and h2 then
		local face = h1:FindFirstChildOfClass("Decal")
		if face then
			face:Clone().Parent = h2
		end
	end

	for _, v in ipairs(cachedAppearance:GetChildren()) do
		if v:IsA("Accessory") then
			local acc = v:Clone()
			acc.Parent = char

			local h = acc:FindFirstChild("Handle")
			if h then
				h.Anchored = false
				h.CanCollide = false
				h.Massless = true
			end

			task.wait()
			if not acc:FindFirstChildWhichIsA("Weld", true)
				and not acc:FindFirstChildWhichIsA("WeldConstraint", true) then
				forceWeld(acc, char)
			end
		end
	end

	print("Da clone avatar (R6) tu:", targetName)
end

local function applyFromJson(char, humanoid)
	if humanoid.RigType ~= Enum.HumanoidRigType.R6 then
		warn("Khong phai R6")
		return false
	end

	local jsonDesc, data = tryLoadDescriptionFromJson()
	if not jsonDesc then
		if not jsonWarned then
			warn("loadfiles=true nhung json khong hop le, fallback online")
			jsonWarned = true
		end
		return false
	end

	clearLook(char)
	local okApply = pcall(function()
		humanoid:ApplyDescriptionReset(jsonDesc)
	end)
	if not okApply then
		okApply = pcall(function()
			humanoid:ApplyDescription(jsonDesc)
		end)
	end
	if not okApply then
		warn("ApplyDescription tu json that bai, fallback online")
		return false
	end

	print("Da clone avatar tu json:", CLONE_JSON_PATH, "target:", (data and data.target_name) or "unknown")
	return true
end

local function applyCloneToCharacter(char)
	local humanoid = char:WaitForChild("Humanoid")
	char:WaitForChild("Head")
	task.wait(0.2)

	if loadfile and applyFromJson(char, humanoid) then
		return
	end

	if loadfile then
		local hasJson = type(isfile) == "function" and isfile(CLONE_JSON_PATH)
		if not hasJson and not jsonWarned then
			warn("loadfiles=true nhung chua co", CLONE_JSON_PATH, "-> fallback targetName")
			jsonWarned = true
		end
	end

	applyFromOnlineAppearance(char, humanoid)
end

if getgenv()._cloneAutoReloadConn then
	getgenv()._cloneAutoReloadConn:Disconnect()
	getgenv()._cloneAutoReloadConn = nil
end

if LocalPlayer.Character then
	task.spawn(applyCloneToCharacter, LocalPlayer.Character)
end

getgenv()._cloneAutoReloadConn = LocalPlayer.CharacterAdded:Connect(function(newChar)
	task.spawn(applyCloneToCharacter, newChar)
end)
