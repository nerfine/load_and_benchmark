print("=======================================")
print("🌟  ExecEnvHealthCheck.lua Initialization  🌟")
print("=======================================")
local http = game:GetService("HttpService")
local HttpService = game:GetService("HttpService")
local url1 = "https://raw.githubusercontent.com/unified-naming-convention/NamingStandard/main/UNCCheckEnv.lua"
-- local url2 = "https://pastebin.com/raw/3XS7x8mV"

task.wait(0.5)

local executorName = identifyexecutor and identifyexecutor() or "Unknown Executor"
print("   🚀 Executor Detected: " .. executorName)
print("===============================================")
task.wait(1)
print("✨ Loading ExecEnvHealthCheck.lua... 🚀")
task.wait(0.1)
print("⏳ Please Wait... ⏳")
print("=======================================")
task.wait(2)
print("✅ ExecEnvHealthCheck.lua Loaded Successfully! 🎉")
print("=======================================")
task.wait(0.5)
print("Credits:")
task.wait(0.1)
print("senS for the sUNC checker from sUNC.lol")
task.wait(0.1)
print("HTDBarsi for the function benchmark (revisited by me)")
task.wait(0.1)
print("=======================================")
task.wait(1)

local startTime = tick()
local errorLog = {}
local injectedLibraries = {}

local initialGuiState = {}
for _, gui in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
	if gui:IsA("ScreenGui") then
		initialGuiState[gui.Name] = gui
	end
end

local function unloadUILibraries()
	for _, gui in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
		if gui:IsA("ScreenGui") then
			if injectedLibraries[gui.Name] then
				gui:Destroy()
				print("[✅] UI Library removed: " .. gui.Name)
			end
		end
	end
end
local function checkLibrary(url, name, isUILib)
	local printed = false
	local function safePrint(msg)
		printed = true
		print(msg)
	end

	local function performCheck()
		local canFetch, libContent = pcall(function()
			return game:HttpGet(url, true)
		end)

		if not canFetch or not libContent or libContent:match("404: Not Found") then
			table.insert(errorLog, name .. " - HTTP 404 Error (Not Found)")
			return false
		end

		local success, libOrError = pcall(function()
			return loadstring(libContent)()
		end)

		if success and libOrError then
			safePrint("[✅] " .. name .. ": Successfully executed and integrity verified")
			injectedLibraries[name] = true
			return true
		else
			safePrint("[❌] " .. name .. ": ⛔ Failed integrity check - Error: " .. tostring(libOrError))
			table.insert(errorLog, name .. " - Integrity check failed - Error: " .. tostring(libOrError))
			return false
		end
	end

	if isUILib then
		return performCheck()
	end

	local finished = false
	local result = false

	task.spawn(function()
		result = performCheck()
		finished = true
	end)

	for i = 1, 100 do
		if printed or finished then
			break
		end
		task.wait(0.1)
	end

	if not printed then
		warn("[⏱️] " .. name .. ": No response in 10 seconds, retrying...")
		printed = false
		finished = false

		task.spawn(function()
			result = performCheck()
			finished = true
		end)

		for i = 1, 100 do
			if printed or finished then
				break
			end
			task.wait(0.1)
		end

		if not printed then
			warn("[❌] " .. name .. ": ⛔ Timed out twice - Marked as failed")
			table.insert(errorLog, name .. " - Timed out twice")
			return false
		end
	end

	return result
end

local success1, response1 = pcall(function()
	return loadstring(game:HttpGet(url1, true))()
end)

if success1 then
	print("[✅] UNC Environment Check: Successfully executed")
else
	print("[❌] UNC Environment Check: Failed to execute")
	table.insert(errorLog, "UNC Environment Check - " .. tostring(response1))
end

wait(1)

local function safeCheckLibrary(url, name)
	local success, result = pcall(checkLibrary, url, name)
	if not success then
		print("[❌] " .. name .. ": Skipped due to error")
		table.insert(errorLog, name .. " - Error occurred during check")
	end
	return result
end

local results = {}
results["OrionLib"] = safeCheckLibrary("https://raw.githubusercontent.com/jensonhirst/Orion/main/source", "OrionLib")
results["Rayfield"] = safeCheckLibrary("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua", "Rayfield")
results["SiriusLib"] = safeCheckLibrary("https://raw.githubusercontent.com/SiriusSoftwareLtd/Sirius/refs/heads/request/source.lua", "SiriusLib")
results["WallyV3"] = safeCheckLibrary("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3", "WallyV3")
results["ReGui"] = safeCheckLibrary("https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua", "ImGui")
results["Bracket"] = safeCheckLibrary("https://raw.githubusercontent.com/wis-h/ui-libraries/refs/heads/main/Bracket/Source.lua", "Bracket")
results["Obsidian"] = safeCheckLibrary("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua", "Obsidian")
results["LinoriaLib"] = safeCheckLibrary("https://raw.githubusercontent.com/mstudio45/LinoriaLib/refs/heads/main/Library.lua", "LinoriaLib")
results["Darius (Wax Bundled)"] = safeCheckLibrary("https://raw.githubusercontent.com/idonthaveoneatm/darius/refs/heads/main/bundled.luau", "DariusWax")
results["Darius (Minified)"] = safeCheckLibrary("https://raw.githubusercontent.com/idonthaveoneatm/darius/refs/heads/main/minified.luau","DariusMinified")
results["Darius (RBXM Suite)"] = safeCheckLibrary("https://raw.githubusercontent.com/idonthaveoneatm/darius/refs/heads/main/rbxmSuite.luau", "DariusRBXM")
results["Linoria (wis-h)"] = safeCheckLibrary("https://raw.githubusercontent.com/wis-h/ui-libraries/refs/heads/main/Linoria-mstudio/Library.lua","LinoriaWisH")
results["Monolith"] = safeCheckLibrary("https://raw.githubusercontent.com/wis-h/ui-libraries/refs/heads/main/Monolith/Source.lua", "Monolith")

unloadUILibraries()

for _, gui in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
	if gui:IsA("ScreenGui") then
		-- Check if it's not in the initial state
		if not initialGuiState[gui.Name] then
			gui:Destroy()
			print("[❌] New UI Library removed: " .. gui.Name)
		end
	end
end

local points = 0
local missing = {}
local functionResults = {}
local functionBenchmark = {
	["request"] = request,
	["getgc"] = getgc,
	["getgenv"] = getgenv,
	["getloadedmodules"] = getloadedmodules,
	["hookfunction"] = hookfunction,
	["getreg"] = getreg or getregistry or debug.getregistry,
	["getfenv"] = getfenv,
	["getmenv"] = getmenv,
	["getsenv"] = getsenv,
	["islclosure"] = islclosure or syn_islclosure or syn.islclosure,
	["loadstring"] = loadstring,
	["getrawmetatable"] = getrawmetatable,
	["getnilinstances"] = getnilinstances,
	["replaceclosure"] = replaceclosure,
	["settflag"] = settflag or syn_setfflag or debug.setfflag,
	["getnamecallmethod"] = getnamecallmethod,
	["setnamecallmethod"] = setnamecallmethod,
	["getspecialinfo"] = getspecialinfo,
	["isreadonly"] = isreadonly,
	["setreadonly"] = setreadonly,
	["checkcaller"] = checkcaller,
	["dumpstring"] = dumpstring,
	["newcclosure"] = newcclosure or syn.newcclosure or syn_newcclosure,
	["getcallingscript"] = getcallingscript,
	["getinstances"] = getinstances,
	["getscripts"] = getscripts,
	["getconnections"] = getconnections,
	["crypt.base64encode"] = crypt.base64encode,
	["crypt.base64decode"] = crypt.base64decode,
	["crypt.encrypt"] = crypt.encrypt,
	["crypt.decrypt"] = crypt.decrypt,
	["crypt.generatebytes"] = crypt.generatebytes,
	["crypt.generatekey"] = crypt.generatekey,
	["crypt.hash"] = crypt.hash,
}

for funcName, func in pairs(functionBenchmark) do
	if func then
		points = points + 1
		functionResults[funcName] = "[✅] Passed"
	else
		table.insert(missing, funcName)
		functionResults[funcName] = "[❌] Failed"
	end
end

local debugBenchmark = {
	["getconstants"] = getconstants or debug.getconstants,
	["getconstant"] = getconstant or debug.getconstant,
	["setconstant"] = setconstant or debug.setconstant,
	["getupvalue"] = getupvalue or debug.getupvalue,
	["setupvalue"] = setupvalue or debug.setupvalue,
	["getupvalues"] = getupvalues or debug.getupvalues,
	["getproto"] = getproto or debug.getproto,
	["getprotos"] = getprotos or debug.getprotos,
	["setproto"] = setproto or debug.setproto,
	["getstack"] = getstack or debug.getstack,
	["setstack"] = setstack or debug.setstack,
	["setmetatable"] = setmetatable or debug.setmetatable,
	["getinfo"] = getinfo or debug.getinfo,
}

local debugResults = {}
for funcName, func in pairs(debugBenchmark) do
	if func then
		points = points + 1
		debugResults[funcName] = "[✅] Passed"
	else
		table.insert(missing, funcName)
		debugResults[funcName] = "[❌] Failed"
	end
end

local miscBenchmark = {
	["gethiddenproperty"] = gethiddenproperty,
	["sethiddenproperty"] = sethiddenproperty,
	["makefolder"] = makefolder,
	["listfiles"] = listfiles,
	["writefile"] = writefile,
	["readfile"] = readfile,
	["appendfile"] = appendfile,
	["loadfile"] = loadfile,
	["delfile"] = delfile,
	["Drawing"] = Drawing,
	["decompile"] = decompile,
}

local miscResults = {}
for funcName, func in pairs(miscBenchmark) do
	if func then
		points = points + 1
		miscResults[funcName] = "[✅] Passed"
	else
		table.insert(missing, funcName)
		miscResults[funcName] = "[❌] Failed"
	end
end

wait(1)

print("===============================================")
print("   🚀 Function Benchmark by HTDBarsi")
print("===============================================")
print("Total Points: " .. points .. " / Max Points: 55")

print("--- 🛠️ Libraries ---")
for lib, status in pairs(results) do
	print(lib .. ": " .. (status and "[✅] Passed" or "[❌] Failed"))
end

print("--- ⚙️ Function Benchmark ---")
for funcName, result in pairs(functionResults) do
	print(funcName .. ": " .. result)
end

print("--- 🧰 Debug Functions ---")
for funcName, result in pairs(debugResults) do
	print(funcName .. ": " .. result)
end

print("--- 🔧 Miscellaneous Functions ---")
for funcName, result in pairs(miscResults) do
	print(funcName .. ": " .. result)
end

print("===============================================")
print("   📝 [TEST SUMMARY]")
print("===============================================")
print("Executor Used: " .. executorName)
print("Total Execution Time: " .. string.format("%.2f", tick() - startTime) .. " seconds")

if #missing > 0 then
	print("🚨 Missing Functions:")
	for _, v in pairs(missing) do
		print("- " .. v)
	end
else
	print("✅ All functions are present.")
end

if #errorLog > 0 then
	print("❌ [ERROR LOG]")
	for _, err in ipairs(errorLog) do
		print("- " .. err)
	end
else
	print("✅ No errors encountered.")
end

print("=======================================")
print("🏁 ExecEnvHealthCheck.lua Completed Successfully! ✅")
print("=======================================")
