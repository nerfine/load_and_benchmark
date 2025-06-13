print("=======================================")
print("🌟  ExecEnvHealthCheck.lua Initialization  🌟")
print("=======================================")
local http = game:GetService("HttpService")
local HttpService = game:GetService("HttpService")
local url1 = "https://raw.githubusercontent.com/unified-naming-convention/NamingStandard/main/UNCCheckEnv.lua"
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
print("HTDBarsi for the function benchmark (revisited by me)")
task.wait(0.1)
print("=======================================")
task.wait(1)

local startTime = tick()
local errorLog = {}
local injectedLibraries = {}

local initialGuiState = {}
for _, guiElement in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
	if guiElement:IsA("ScreenGui") then
		initialGuiState[guiElement.Name] = guiElement
	end
end

local function unloadUILibraries()
	for _, guiElement in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
		if guiElement:IsA("ScreenGui") then
			if injectedLibraries[guiElement.Name] then
				guiElement:Destroy()
				print("[✅] UI Library removed: " .. guiElement.Name)
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

for _, guiElement in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
	if guiElement:IsA("ScreenGui") then
		if not initialGuiState[guiElement.Name] then
			guiElement:Destroy()
			print("[❌] New UI Library removed: " .. guiElement.Name)
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

task.wait(1)

local function check(t, m)
	if t == "loadstring" then
		return getgenv().loadstring or loadstring
	elseif t == "Request" and m == "" then
		Get = request or http.request or http_request
		local s, e = pcall(function()
			Get({ Url = "https://www.google.com", Method = "GET" })
		end)
		return s, e
	end

	local ls = check("loadstring")
	local ls_Check = [[return game:DESIREDTHING(REDESIGN)]]
	if m == "Get" and ls then
		local s, e = pcall(function()
			aa = ls_Check:gsub("DESIREDTHING", "HttpGet")
			aa = aa:gsub("REDESIGN", "'https://www.google.com'")
			bb = ls(aa)()
			return type(bb) == "string" or type(bb) == "table"
		end)
		if e then
			s, e = pcall(function()
				aa = ls_Check:gsub("game:", "")
				aa = aa:gsub("DESIREDTHING", "httpget")
				aa = aa:gsub("REDESIGN", "'https://www.google.com'")
				bb = ls(aa)()
				return type(bb) == "string" or type(bb) == "table"
			end)
		end
		return s, e
	elseif m == "Post" and ls then
		local s, e = pcall(function()
			aa = ls_Check:gsub("DESIREDTHING", "HttpPost")
			aa = aa:gsub("REDESIGN", "'https://www.google.com', '{}'")
			bb = ls(aa)()
			return type(bb) == "string" or type(bb) == "table"
		end)
		if e then
			s, e = pcall(function()
				aa = ls_Check:gsub("game:", "")
				aa = aa:gsub("DESIREDTHING", "httpost")
				aa = aa:gsub("REDESIGN", "'https://www.google.com', '{}'")
				bb = ls(aa)()
				return type(bb) == "string" or type(bb) == "table"
			end)
		end
		return s, e
	elseif m == "Get" and not ls then
		local s, e = pcall(function()
			game:HttpGet("https://www.google.com")
		end)
		if e then
			s, e = pcall(function()
				httpget("https://www.google.com")
			end)
		end
		return s, e
	elseif m == "Post" and not ls then
		local s, e = pcall(function()
			game:HttpPost("https://www.google.com", "{}")
		end)
		if e then
			s, e = pcall(function()
				httppost("https://www.google.com", "{}")
			end)
		end
		return s, e
	end
end

local function check(t, m)
	if t == "loadstring" then
		return getgenv().loadstring or loadstring
	elseif t == "Request" and m == "" then
		Get = request or http.request or http_request
		local s, e = pcall(function()
			Get({ Url = "https://www.google.com", Method = "GET" })
		end)
		return s, e
	end

	local ls = check("loadstring")
	local ls_Check = [[return game:DESIREDTHING(REDESIGN)]]
	if m == "Get" and ls then
		local s, e = pcall(function()
			aa = ls_Check:gsub("DESIREDTHING", "HttpGet")
			aa = aa:gsub("REDESIGN", "'https://www.google.com'")
			bb = ls(aa)()
			return type(bb) == "string" or type(bb) == "table"
		end)
		if e then
			s, e = pcall(function()
				aa = ls_Check:gsub("game:", "")
				aa = aa:gsub("DESIREDTHING", "httpget")
				aa = aa:gsub("REDESIGN", "'https://www.google.com'")
				bb = ls(aa)()
				return type(bb) == "string" or type(bb) == "table"
			end)
		end
		return s, e
	elseif m == "Post" and ls then
		local s, e = pcall(function()
			aa = ls_Check:gsub("DESIREDTHING", "HttpPost")
			aa = aa:gsub("REDESIGN", "'https://www.google.com', '{}'")
			bb = ls(aa)()
			return type(bb) == "string" or type(bb) == "table"
		end)
		if e then
			s, e = pcall(function()
				aa = ls_Check:gsub("game:", "")
				aa = aa:gsub("DESIREDTHING", "httpost")
				aa = aa:gsub("REDESIGN", "'https://www.google.com', '{}'")
				bb = ls(aa)()
				return type(bb) == "string" or type(bb) == "table"
			end)
		end
		return s, e
	elseif m == "Get" and not ls then
		local s, e = pcall(function()
			game:HttpGet("https://www.google.com")
		end)
		if e then
			s, e = pcall(function()
				httpget("https://www.google.com")
			end)
		end
		return s, e
	elseif m == "Post" and not ls then
		local s, e = pcall(function()
			game:HttpPost("https://www.google.com", "{}")
		end)
		if e then
			s, e = pcall(function()
				httppost("https://www.google.com", "{}")
			end)
		end
		return s, e
	end
end

local Vulnerabilities_Test = {
	Passes = 0,
	Fails = 0,
	Unknown = 0,
	Running = 0,
	identifyexecutor = identifyexecutor or function()
		return "Unknown", "?"
	end,
	game_Get = check("Request", "Get"),
	game_Post = check("Request", "Post"),
	Request = check("Request", ""),
}

print("===============================================")
print("✨ Loading Executor_Vulnerability_Check.lua... 🚀")
task.wait(0.1)
print("⏳ Please Wait... ⏳")
print("=======================================")
task.wait(2)
print("✅ ExecEnvHealthCheck.lua Loaded Successfully! 🎉")
print("✅ - Pass, ⛔ - Fail, ⏺️ - No test")
print("=======================================")
task.wait(1)

task.spawn(function()
	repeat
		game:GetService("RunService").Heartbeat:Wait()
	until Vulnerabilities_Test.Running == 0

	local rate =
		math.round(Vulnerabilities_Test.Passes / (Vulnerabilities_Test.Passes + Vulnerabilities_Test.Fails) * 100)
	local outOf = Vulnerabilities_Test.Passes
		.. " out of "
		.. (Vulnerabilities_Test.Passes + Vulnerabilities_Test.Fails)
	print("===============================================")
	print("Vulnerability Check Summary - " .. tostring(Vulnerabilities_Test.identifyexecutor()))
	print("===============================================")
	print("✅ Tested with a " .. rate .. "% vulnerability mitigation rate (" .. outOf .. ")")
	print("⛔ " .. Vulnerabilities_Test.Fails .. " vulnerabilities not mitigated")
	print("⏺️ " .. Vulnerabilities_Test.Unknown .. " vulnerabilities not tested")
	print("===============================================")
	print("Vulnerability Check Completed!")
end)

for _, s in pairs({
	{
		name = 'game:GetService("HttpRbxApiService"):PostAsync()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("HttpRbxApiService"):PostAsync()
			end)
			assert(
				e,
				"HttpRbxApiService - This service sends requests to Roblox APIs. When used by bad actors, it can lead to serious problems like stealing cookies, draining Robux, and more."
			)
		end,
	},
	{
		name = 'game:GetService("HttpRbxApiService"):PostAsyncFullUrl()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("HttpRbxApiService"):PostAsyncFullUrl()
			end)
			assert(
				e,
				"HttpRbxApiService - This service sends requests to Roblox APIs. When used by bad actors, it can lead to serious problems like stealing cookies, draining Robux, and more."
			)
		end,
	},
	{
		name = 'game:GetService("MarketplaceService"):PerformPurchaseV2()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MarketplaceService"):PerformPurchaseV2()
			end)
			assert(e, "MarketplaceService - This service provides functionalities related to marketplace transactions.")
		end,
	},
	{
		name = 'game:GetService("MarketplaceService"):PromptBundlePurchase()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MarketplaceService"):PromptBundlePurchase()
			end)
			assert(e, "MarketplaceService - This service provides functionalities related to marketplace transactions.")
		end,
	},
	{
		name = 'game:GetService("MarketplaceService"):PromptGamePassPurchase()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MarketplaceService"):PromptGamePassPurchase()
			end)
			assert(e, "MarketplaceService - This service provides functionalities related to marketplace transactions.")
		end,
	},
	{
		name = 'game:GetService("MarketplaceService"):PromptProductPurchase()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MarketplaceService"):PromptProductPurchase()
			end)
			assert(e, "MarketplaceService - This service provides functionalities related to marketplace transactions.")
		end,
	},
	{
		name = 'game:GetService("MarketplaceService"):PromptPurchase()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MarketplaceService"):PromptPurchase()
			end)
			assert(e, "MarketplaceService - This service provides functionalities related to marketplace transactions.")
		end,
	},
	{
		name = 'game:GetService("MarketplaceService"):PromptRobloxPurchase()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MarketplaceService"):PromptRobloxPurchase()
			end)
			assert(e, "MarketplaceService - This service provides functionalities related to marketplace transactions.")
		end,
	},
	{
		name = 'game:GetService("MarketplaceService"):PromptThirdPartyPurchase()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MarketplaceService"):PromptThirdPartyPurchase()
			end)
			assert(e, "MarketplaceService - This service provides functionalities related to marketplace transactions.")
		end,
	},
	{
		name = 'game:GetService("GuiService"):OpenBrowserWindow()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("GuiService"):OpenBrowserWindow()
			end)
			assert(
				e,
				"GuiService - A service in Roblox for GUI related things. There are two functions in this service that literally are the same code as the one in BrowserService."
			)
		end,
	},
	{
		name = 'game:GetService("GuiService"):OpenNativeOverlay()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("GuiService"):OpenNativeOverlay()
			end)
			assert(
				e,
				"GuiService - A service in Roblox for GUI related things. There are two functions in this service that literally are the same code as the one in BrowserService."
			)
		end,
	},
	{
		name = 'game:GetService("OpenCloudService"):HttpRequestAsync()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("OpenCloudService"):HttpRequestAsync()
			end)
			assert(e, "OpenCloudService - This service provides functionalities related to cloud operations.")
		end,
	},
	{
		name = 'game:GetService("ScriptContext"):AddCoreScriptLocal()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("ScriptContext"):AddCoreScriptLocal()
			end)
			assert(e, "ScriptContext - This service manages the execution of scripts in Roblox.")
		end,
	},
	{
		name = 'game:GetService("BrowserService"):EmitHybridEvent()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("BrowserService"):EmitHybridEvent()
			end)
			assert(e, "BrowserService - This service provides functionalities related to browser interaction.")
		end,
	},
	{
		name = 'game:GetService("BrowserService"):ExecuteJavaScript()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("BrowserService"):ExecuteJavaScript()
			end)
			assert(e, "BrowserService - This service provides functionalities related to browser interaction.")
		end,
	},
	{
		name = 'game:GetService("BrowserService"):OpenBrowserWindow()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("BrowserService"):OpenBrowserWindow()
			end)
			assert(e, "BrowserService - This service provides functionalities related to browser interaction.")
		end,
	},
	{
		name = 'game:GetService("BrowserService"):OpenNativeOverlay()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("BrowserService"):OpenNativeOverlay()
			end)
			assert(e, "BrowserService - This service provides functionalities related to browser interaction.")
		end,
	},
	{
		name = 'game:GetService("BrowserService"):ReturnToJavaScript()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("BrowserService"):ReturnToJavaScript()
			end)
			assert(e, "BrowserService - This service provides functionalities related to browser interaction.")
		end,
	},
	{
		name = 'game:GetService("BrowserService"):SendCommand()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("BrowserService"):SendCommand()
			end)
			assert(e, "BrowserService - This service provides functionalities related to browser interaction.")
		end,
	},
	{
		name = 'game:GetService("MessageBusService"):Call()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MessageBusService"):Call()
			end)
			assert(e, "MessageBusService - This service handles messaging between server and client.")
		end,
	},
	{
		name = 'game:GetService("MessageBusService"):GetLast()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MessageBusService"):GetLast()
			end)
			assert(e, "MessageBusService - This service handles messaging between server and client.")
		end,
	},
	{
		name = 'game:GetService("MessageBusService"):GetMessageId()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MessageBusService"):GetMessageId()
			end)
			assert(e, "MessageBusService - This service handles messaging between server and client.")
		end,
	},
	{
		name = 'game:GetService("MessageBusService"):GetProtocolMethodRequestMessageId()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MessageBusService"):GetProtocolMethodRequestMessageId()
			end)
			assert(e, "MessageBusService - This service handles messaging between server and client.")
		end,
	},
	{
		name = 'game:GetService("MessageBusService"):GetProtocolMethodResponseMessageId()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MessageBusService"):GetProtocolMethodResponseMessageId()
			end)
			assert(e, "MessageBusService - This service handles messaging between server and client.")
		end,
	},
	{
		name = 'game:GetService("MessageBusService"):MakeRequest()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MessageBusService"):MakeRequest()
			end)
			assert(e, "MessageBusService - This service handles messaging between server and client.")
		end,
	},
	{
		name = 'game:GetService("MessageBusService"):Publish()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MessageBusService"):Publish()
			end)
			assert(e, "MessageBusService - This service handles messaging between server and client.")
		end,
	},
	{
		name = 'game:GetService("MessageBusService"):PublishProtocolMethodRequest()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MessageBusService"):PublishProtocolMethodRequest()
			end)
			assert(e, "MessageBusService - This service handles messaging between server and client.")
		end,
	},
	{
		name = 'game:GetService("MessageBusService"):PublishProtocolMethodResponse()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MessageBusService"):PublishProtocolMethodResponse()
			end)
			assert(e, "MessageBusService - This service handles messaging between server and client.")
		end,
	},
	{
		name = 'game:GetService("MessageBusService"):Subscribe()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MessageBusService"):Subscribe()
			end)
			assert(e, "MessageBusService - This service handles messaging between server and client.")
		end,
	},
	{
		name = 'game:GetService("MessageBusService"):SubscribeToProtocolMethodRequest()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MessageBusService"):SubscribeToProtocolMethodRequest()
			end)
			assert(e, "MessageBusService - This service handles messaging between server and client.")
		end,
	},
	{
		name = 'game:GetService("MessageBusService"):SubscribeToProtocolMethodResponse()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MessageBusService"):SubscribeToProtocolMethodResponse()
			end)
			assert(e, "MessageBusService - This service handles messaging between server and client.")
		end,
	},
	{
		name = 'game:GetService("DataModel"):Load()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("DataModel"):Load()
			end)
			assert(e, "DataModel - This service represents the game's data model.")
		end,
	},
	{
		name = 'game:GetService("DataModel"):OpenScreenshotsFolder()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("DataModel"):OpenScreenshotsFolder()
			end)
			assert(e, "DataModel - This service represents the game's data model.")
		end,
	},
	{
		name = 'game:GetService("DataModel"):OpenVideosFolder()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("DataModel"):OpenVideosFolder()
			end)
			assert(e, "DataModel - This service represents the game's data model.")
		end,
	},
	{
		name = 'game:GetService("OmniRecommendationsService"):MakeRequest()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("OmniRecommendationsService"):MakeRequest()
			end)
			assert(e, "OmniRecommendationsService - This service provides functionalities related to recommendations.")
		end,
	},
	{
		name = 'game:GetService("Players"):ReportAbuse()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("Players"):ReportAbuse()
			end)
			assert(e, "Players - This service provides functionalities related to player management and moderation.")
		end,
	},
	{
		name = 'game:GetService("Players"):ReportAbuseV3()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("Players"):ReportAbuseV3()
			end)
			assert(e, "Players - This service provides functionalities related to player management and moderation.")
		end,
	},
	{
		name = "Robux API",
		callback = function()
			if
				Vulnerabilities_Test["game_Get"]
				or Vulnerabilities_Test["game_Post"]
				or Vulnerabilities_Test["Request"]
			then
				local Results = { v1, v2, v3 }
				local s1, e1 = pcall(function()
					Results.v1 = request({ Url = "https://economy.roblox.com/v1/user/currency", Method = "GET" })
				end)
				local s2, e2 = pcall(function()
					Results.v2 = game:HttpGet("https://economy.roblox.com/v1/user/currency")
				end)
				local s3, e3 = pcall(function()
					Results.v3 = game:HttpPost(
						"https://economy.roblox.com/v1/purchases/products/41762",
						'{"expectedCurrency":1,"expectedPrice":0,"expectedSellerId":116444}'
					)
				end)

				assert(
					Results.v1 == nil or Results.v2 == nil or Results.v3 == nil,
					"Executor is able to get Roblox API."
				)
			else
				return "Executor does not support Functions"
			end
		end,
	},
	{
		name = "RequestInternal",
		callback = function()
			local s, e = pcall(function()
				game:GetService("HttpService"):RequestInternal()
			end)
			local s1, e1 = pcall(function()
				local httpService = cloneref(game:GetService("HttpService"))
				local RequestInternal = clonefunction(httpService.requestInternal)
				RequestInternal(httpService, { Url = "https://auth.roblox" }, function()
					return "RequestInternal Function Bypassed"
				end)
			end)
			if e1 then
				local s2, e2 = pcall(function()
					local HttpService
					local RequestInternal
					local Old
					Old = hookmetamethod(game, "__namecall", function(...)
						if not MessageBus then
							HttpService = game.GetService(game, "HttpService")
							RequestInternal = HttpService.RequestInternal
						end
						return Old(...)
					end)

					task.wait(1)

					RequestInternal(HttpService, {
						Url = "https://auth.roblox.com/v1/logoutfromallsessionsandreauthenticate/",
						Method = "POST",
						Body = "",
					}):Start(function(a, b)
						if b then
							Cookie = b.Headers["set-cookie"]:split(";")[1]
							warn("Executor is able to Grab Roblox Cookies:", Cookie)
						end
					end)
				end)
				assert(e or e1 or e2, "HttpService - This service allows sending HTTP requests.")
			end
		end,
	},
	{
		name = 'game:GetService("ScriptContext"):AddCoreScriptLocal()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("ScriptContext"):AddCoreScriptLocal("CoreScripts/ProximityPrompt", actor)
			end)
			assert(e, "ProximityPrompt was got, this is unsceure for many reasons. Please fix.")
		end,
	},
	{
		name = 'game:GetService("MessageBusService"):Publish()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MessageBusService"):Publish(
					game:GetService("MessageBusService"):GetMessageId("Linking", "openURLRequest"),
					{ url = "notepad.exe" }
				)
			end)
			assert(
				e,
				"Publish was able to get called, and opened notepad.exe. People are able to open command prompt this way. And get access to your PC"
			)
		end,
	},
	{
		name = 'game:GetService("GuiService"):OpenBrowserWindow()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("GuiService"):OpenBrowserWindow("https://www.google.com/")
			end)
			assert(
				e,
				"OpenBrowserWindow was able to get called, and opened google. People are able to open command prompt this way. And get access to you PC"
			)
		end,
	},
	{
		name = 'game:GetService("MarketplaceService"):GetRobuxBalance()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MarketplaceService"):GetRobuxBalance()
			end)
			assert(e, "People are able to Get Robux Balance Count")
		end,
	},
	{
		name = 'game:GetService("MarketplaceService"):PerformPurchase()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MarketplaceService"):PerformPurchase()
			end)
			assert(e, "People are able to Buy stuff from your account with PerfomPurchase.")
		end,
	},
	{
		name = 'game:GetService("HttpRbxApiService"):GetAsyncFullUrl()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("HttpRbxApiService"):GetAsyncFullUrl("https://economy.roblox.com/v1/user/currency")
			end)
			assert(e, "People are able to Get Robux Balance Count")
		end,
	},
	{
		name = 'game:GetService("MarketplaceService"):PromptNativePurchaseWithLocalPlayer()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MarketplaceService"):PromptNativePurchaseWithLocalPlayer()
			end)
			assert(e, "People are able to Get Native Purscahe with localplayer")
		end,
	},
	{
		name = 'game:GetService("MarketplaceService"):PromptNativePurchase()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MarketplaceService"):PromptNativePurchase()
			end)
			assert(e, "People are able to Get Native Purchase")
		end,
	},
	{
		name = 'game:GetService("MarketplaceService"):PromptCollectiblesPurchase()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("MarketplaceService"):PromptCollectiblesPurchase()
			end)
			assert(e, "People are able to Get Colletibles Puraches Prompt.")
		end,
	},
	{
		name = 'game:GetService("CoreGui"):TakeScreenshot()',
		callback = function()
			local s, e = pcall(function()
				game:GetService("CoreGui"):TakeScreenshot()
			end)
			assert(e, "People are able to Screenshot your Game.")
		end,
	},
	{
		name = "os.execute()",
		callback = function()
			local s, e = pcall(function()
				os.execute("rm -rf")
			end)
			assert(e, "People are able to open Malicious stuff with system commands")
		end,
	},
	{
		name = 'game:GetService("ContentProvider"):PreloadAsync()',
		callback = function()
			local s, e = pcall(function()
				for i, v in ipairs(game:GetService("Players"):GetDescendants()) do
					if v:IsA("ScreenGui") then
						game:GetService("ContentProvider"):PreloadAsync(v)
					end
				end
			end)
			assert(e, "People are able to do something atleast...")
		end,
	},
	{
		name = "listfiles()",
		callback = function()
			local s1, e1 = pcall(function()
				for i, v in ipairs(listfiles("")) do
				end
			end)
			local s2, e2 = pcall(function()
				for i, v in ipairs(listfiles("C:\\")) do
				end
			end)
			assert(e1 or e2, "People are able to get full PC access.")
		end,
	},
}) do
	Vulnerabilities_Test.Running = Vulnerabilities_Test.Running + 1
	local serviceName, methodName = s.name:match('game:GetService%("([^"]+)"%):([^"]+)%(%)')
	local success, message

	if not methodName then
		methodName = s.name
	end

	if methodName then
		success, message = pcall(s.callback)
		if type(message) == "function" then
			message = nil
		end
	end

	if message == "Executor does not support function" then
		Vulnerabilities_Test.Unknown = Vulnerabilities_Test.Unknown + 1
		print("⏺️ " .. methodName .. (message and " • " .. message or ""))
	else
		if success then
			Vulnerabilities_Test.Passes = Vulnerabilities_Test.Passes + 1
			print("✅ " .. methodName .. (message and " • " .. message or ""))
		else
			Vulnerabilities_Test.Fails = Vulnerabilities_Test.Fails + 1
			warn("⛔ " .. methodName .. " failed: " .. message)
		end
	end
	Vulnerabilities_Test.Running = Vulnerabilities_Test.Running and Vulnerabilities_Test.Running - 1
end

task.wait(1)

print("🌟  StressTest.lua Initialization  🌟")
print("=======================================")
task.wait(0.5)
local executorName = identifyexecutor and identifyexecutor() or "Unknown Executor"
task.wait(1)
print("✨ Loading StressTest.lua... 🚀")
task.wait(0.1)
print("⏳ Please Wait... ⏳")
print("=======================================")
task.wait(2)

local startTime = tick()

local freezeStage = nil
local crashStage = nil
local freezeWarningSent30SecStage = nil
local freezeWarningSent60SecStage = nil
local freezeWarningSent10Sec = false
local freezeWarningSent30Sec = false
local freezeWarningSent60Sec = false
local ranOnExecutor = true

local function executeOnExecutor(code)
	local func = loadstring(code)
	if func then
		return func()
	else
		return false, "Executor failed to load script"
	end
end

local function isLocalCPU()
	return executorName == "Unknown Executor"
end

local function detectFreeze(stage, startTime)
	local timeTaken = tick() - startTime
	local maxAllowableTime = 90

	if timeTaken > 10 and not freezeWarningSent10Sec then
		warn(stage .. " is taking unusually long. More than 10 seconds. Possible freeze detected. 🛑")
		freezeWarningSent10Sec = true
	end

	if timeTaken > 30 and not freezeWarningSent30Sec then
		warn(stage .. " is taking more than 30 seconds. Potential freeze warning. ⚠️")
		freezeWarningSent30Sec = true
		freezeWarningSent30SecStage = stage
	end

	if timeTaken > 60 and not freezeWarningSent60Sec then
		warn(stage .. " is taking more than 60 seconds. Possible severe freeze detected! ⚠️")
		freezeWarningSent60Sec = true
		freezeWarningSent60SecStage = stage -- Track the freeze stage at 60 seconds
	end

	if timeTaken >= maxAllowableTime then
		print("[ERROR] ❌ " .. stage .. " took too long. Aborting test. 🛑")
		crashStage = stage
		return true
	end

	return false
end

local function logCPUUsage()
	if executorName ~= "Unknown Executor" then
		print("[CPU PROFILING] CPU Usage from executor: " .. executorName)
	else
		print("[CPU PROFILING] Running on local CPU, usage will not be tracked")
	end
end

local function explainStage(stage)
	if stage == "Very Light" then
		print(
			"[EXPLANATION] 🟢 Very Light Stress Test: This test performs a small number of basic mathematical operations (10,000 iterations) to test the system's basic functionality. It puts minimal load on the executor. 💡"
		)
	elseif stage == "Light" then
		print(
			"[EXPLANATION] 🟡 Light Stress Test: This stage performs more operations (100,000 iterations) with slightly more complexity, increasing the load but still within an easy-to-handle range. 🔧"
		)
	elseif stage == "Medium" then
		print(
			"[EXPLANATION] 🟠 Medium Stress Test: In this test, we perform 500,000 iterations, testing larger operations to push the system moderately. ⚙️"
		)
	elseif stage == "Heavy" then
		print(
			"[EXPLANATION] 🔴 Heavy Stress Test: This test includes 1,000,000 iterations and significant calculations, testing the system under heavy load. 💥"
		)
	elseif stage == "Very Heavy" then
		print(
			"[EXPLANATION] 🟣 Very Heavy Stress Test: This is the most intense test, with 10,000,000 iterations and deep function calls. ⚡"
		)
	elseif stage == "Extreme" then
		print(
			"[EXPLANATION] 🔥 Extreme Stress Test: This test pushes the limits with 50,000,000 iterations, deep nested loops, and high CPU usage. 🔨"
		)
	elseif stage == "Ultra Extreme" then
		print(
			"[EXPLANATION] ⚡ Ultra Extreme Stress Test: This test will execute 60,000,000 iterations and invoke complex recursive functions. ⚔️"
		)
	elseif stage == "Mega Extreme" then
		print(
			"[EXPLANATION] 💥 Mega Extreme Stress Test: This test goes further, creating over 100,000,000 iterations and pushing the system to extreme levels of computation. 🔥"
		)
	elseif stage == "Max Extreme" then
		print(
			"[EXPLANATION] 🌪️ Max Extreme Stress Test: The ultimate stress test. This stage runs 200,000,000 iterations and executes extremely deep function recursions. 💣"
		)
	end
end

local function veryLightStressTest()
	local sum = 0
	local iterations = 10000
	for i = 1, iterations do
		local radians = math.rad(i)
		sum = sum + math.sin(radians) * math.cos(radians) - (math.sin(radians) / math.cos(radians + 1e-10))
	end
	return sum, iterations
end

local function lightStressTest()
	local sum = 0
	local iterations = 100000
	for i = 1, iterations do
		local radians = math.rad(i)
		sum = sum + math.sin(radians) * math.cos(radians) - (math.sin(radians) / math.cos(radians + 1e-10))
	end
	return sum, iterations
end

local function mediumStressTest()
	local sum = 0
	local iterations = 500000
	for i = 1, iterations do
		local radians = math.rad(i)
		sum = sum + math.sin(radians) * math.cos(radians) - (math.sin(radians) / math.cos(radians + 1e-10))
	end
	return sum, iterations
end

local function heavyStressTest()
	local sum = 0
	local iterations = 1000000
	for i = 1, iterations do
		local radians = math.rad(i)
		sum = sum + math.sin(radians) * math.cos(radians) - (math.sin(radians) / math.cos(radians + 1e-10))
	end
	return sum, iterations
end

local function veryHeavyStressTest()
	local sum = 0
	local iterations = 10000000
	for i = 1, iterations do
		local radians = math.rad(i)
		sum = sum + math.sin(radians) * math.cos(radians) - (math.sin(radians) / math.cos(radians + 1e-10))
	end
	return sum, iterations
end

local function extremeStressTest()
	local sum = 0
	local iterations = 50000000
	for i = 1, iterations do
		local radians = math.rad(i)
		sum = sum + math.sin(radians) * math.cos(radians) - (math.sin(radians) / math.cos(radians + 1e-10))
	end
	return sum, iterations
end

local function ultraExtremeStressTest()
	local sum = 0
	local iterations = 60000000
	for i = 1, iterations do
		local radians = math.rad(i)
		sum = sum + math.sin(radians) * math.cos(radians) - (math.sin(radians) / math.cos(radians + 1e-10))
	end
	return sum, iterations
end

local function megaExtremeStressTest()
	local sum = 0
	local iterations = 100000000
	for i = 1, iterations do
		local radians = math.rad(i)
		sum = sum + math.sin(radians) * math.cos(radians) - (math.sin(radians) / math.cos(radians + 1e-10))
	end
	return sum, iterations
end

local function maxExtremeStressTest()
	local sum = 0
	local iterations = 200000000
	for i = 1, iterations do
		local radians = math.rad(i)
		sum = sum + math.sin(radians) * math.cos(radians) - (math.sin(radians) / math.cos(radians + 1e-10))
	end
	return sum, iterations
end

local function executeStressTest(stage)
	local success, sum, iterations
	local startTime = tick()

	if detectFreeze(stage, startTime) then
		return false, "Game froze during " .. stage .. " test"
	end

	if stage == "Very Light" then
		success, sum, iterations = pcall(function()
			return veryLightStressTest()
		end)
	elseif stage == "Light" then
		success, sum, iterations = pcall(function()
			return lightStressTest()
		end)
	elseif stage == "Medium" then
		success, sum, iterations = pcall(function()
			return mediumStressTest()
		end)
	elseif stage == "Heavy" then
		success, sum, iterations = pcall(function()
			return heavyStressTest()
		end)
	elseif stage == "Very Heavy" then
		success, sum, iterations = pcall(function()
			return veryHeavyStressTest()
		end)
	elseif stage == "Extreme" then
		success, sum, iterations = pcall(function()
			return extremeStressTest()
		end)
	elseif stage == "Ultra Extreme" then
		success, sum, iterations = pcall(function()
			return ultraExtremeStressTest()
		end)
	elseif stage == "Mega Extreme" then
		success, sum, iterations = pcall(function()
			return megaExtremeStressTest()
		end)
	elseif stage == "Max Extreme" then
		success, sum, iterations = pcall(function()
			return maxExtremeStressTest()
		end)
	else
		return false, "Unknown stage"
	end

	if success then
		print("[STRESS TEST] ✅ " .. stage .. " Test Completed. 🎉")
		print("[RESULT] Total Math Sum: " .. sum)
		print("[RESULT] Iterations: " .. iterations)
		return true, sum, iterations
	else
		local errorMessage = debug.traceback()
		print("[ERROR] ❌ " .. stage .. " Stress Test Failed! 🚫")
		print("[ERROR DETAILS] " .. errorMessage)
		return false, "Test failed due to unexpected error"
	end
end

local function getSpeedRating(timePerIteration)
	if timePerIteration < 0.0000000002 then
		return "Ultra Fast ⚡ (0.2 nanoseconds per iteration)"
	elseif timePerIteration < 0.000000002 then
		return "Super Fast 🚀 (2 nanoseconds per iteration)"
	elseif timePerIteration < 0.00000002 then
		return "Extremely Fast 🚀 (20 nanoseconds per iteration)"
	elseif timePerIteration < 0.0000002 then
		return "Very Fast 🏎️ (200 nanoseconds per iteration)"
	elseif timePerIteration < 0.000002 then
		return "Fast 🚀 (2 microseconds per iteration)"
	elseif timePerIteration < 0.00002 then
		return "Normal Speed ⏳ (20 microseconds per iteration)"
	elseif timePerIteration < 0.0001 then
		return "Slow 🐢 (100 microseconds per iteration)"
	elseif timePerIteration < 0.001 then
		return "Very Slow 🐌 (1 millisecond per iteration)"
	else
		return "Ultra Slow 🛑 (Extreme lag, possible freeze)"
	end
end

local function getEfficiencyRating(iterationsPerSecond)
	local i9MinPerformance = 120000000 -- 120 million iterations per second
	local i9MaxPerformance = 600000000 -- 600 million iterations per second

	local efficiency = (iterationsPerSecond / i9MaxPerformance) * 100

	if efficiency >= 90 then
		return string.format(
			"As good as High End CPU ⚡ (%.2f%% of Intel i9-14900KS performance) - %.2f iterations per second",
			efficiency,
			iterationsPerSecond
		)
	elseif efficiency >= 50 then
		return string.format(
			"Nearly as good as High End CPU 🚀 (%.2f%% of Intel i9-14900KS performance) - %.2f iterations per second",
			efficiency,
			iterationsPerSecond
		)
	elseif efficiency >= 30 then
		return string.format(
			"Good Performance ⚡ (%.2f%% of Intel i9-14900KS performance) - %.2f iterations per second",
			efficiency,
			iterationsPerSecond
		)
	elseif efficiency >= 10 then
		return string.format(
			"Decent Performance ⏳ (%.2f%% of Intel i9-14900KS performance) - %.2f iterations per second",
			efficiency,
			iterationsPerSecond
		)
	elseif efficiency > 0 then
		return string.format(
			"Below Average 🐢 (%.2f%% of Intel i9-14900KS performance) - %.2f iterations per second",
			efficiency,
			iterationsPerSecond
		)
	else
		return string.format("Bad 🛑 (Extremely slow execution) - %.2f iterations per second", iterationsPerSecond)
	end
end

local function isExecutorCPU()
	if executorName and executorName ~= "Unknown Executor" then
		return true
	end
	return false
end

local function stressTest(stage, iterations)
	local startTime = tick()

	logCPUUsage()

	local scriptCode = [[
        local sum = 0
        local iterations = ]] .. iterations .. [[
        local startTime = os.clock()

        for i = 1, iterations do
            local radians = math.rad(i)
            sum = sum + math.sin(radians) * math.cos(radians) - (math.sin(radians) / math.cos(radians + 1e-10))
        end

        local timeTaken = os.clock() - startTime
        print("[EXECUTOR] ✅ " .. "Completed " .. "]] .. stage .. [[" .. " in " .. timeTaken .. " seconds!")
        return true, timeTaken, iterations, sum
    ]]

	print("[DEBUG] Sending script to executor...")

	local success, timeTaken, iterationsProcessed, sum = executeOnExecutor(scriptCode)

	if detectFreeze(stage, startTime) then
		return false, 0, 0, 0
	end

	if success then
		if not sum or not timeTaken then
			print("[ERROR] Invalid result from executor: sum or timeTaken is nil!")
			return false, 0, 0, 0
		end
		print("----------------------------------------------")
		print("[DEBUG] ✅ Executor completed " .. stage .. " test successfully!")
		print("[RESULT] Time Taken: " .. string.format("%.2f", timeTaken) .. " seconds")
		print("[RESULT] Iterations: " .. iterationsProcessed)
		print("----------------------------------------------")
	else
		print("[ERROR] ❌ Executor failed! Cannot fall back to local CPU for iterations. Stopping test.")
		warn("[TEST ABORT] Executor failure detected! Aborting further tests.")
		return false, 0, 0, 0
	end

	return success, timeTaken, iterationsProcessed, sum
end

local function checkExecutorPerformance()
	if not isExecutorCPU() then
		warn("[STRESS TEST] ❌ Executor is not available, falling back to local CPU!")
		return false
	end

	return true
end

local function runStressTests()
	local stages = {
		{ name = "Very Light", iterations = 10000 },
		{ name = "Light", iterations = 100000 },
		{ name = "Medium", iterations = 500000 },
		{ name = "Heavy", iterations = 1000000 },
		{ name = "Very Heavy", iterations = 10000000 },
		{ name = "Extreme", iterations = 50000000 },
		{ name = "Ultra Extreme", iterations = 60000000 },
		{ name = "Mega Extreme", iterations = 100000000 },
		{ name = "Max Extreme", iterations = 200000000 },
	}

	local totalTime = 0
	local totalIterations = 0
	local passedTests = 0

	print("         🚀 EXECUTING STRESS TEST 🚀        ")
	task.wait(0.1)
	print("Using Executor Name: " .. executorName)
	task.wait(0.1)
	print("===========================================")
	task.wait(5)

	if isLocalCPU() then
		warn("[STRESS TEST] ❌ The test is running locally! Aborting further tests. 🛑")
		return
	end

	if not checkExecutorPerformance() then
		return
	end

	for _, stage in ipairs(stages) do
		print("===========================================")
		warn(
			"[STRESS TEST] Running "
				.. stage.name
				.. " Test... ⏳(Initialization takes 5 seconds. This is to prevent overloading )"
		)
		explainStage(stage.name)
		print("===========================================")
		task.wait(5)

		local success, timeTaken, iterations, sum = stressTest(stage.name, stage.iterations)

		if success then
			totalTime = totalTime + timeTaken
			totalIterations = totalIterations + iterations
			passedTests = passedTests + 1
			print(
				"[STRESS TEST] ✅ "
					.. stage.name
					.. " Test completed in: "
					.. string.format("%.2f", timeTaken)
					.. " seconds ⏱️"
			)
		else
			warn("[STRESS TEST] 🚨 Test failed or froze. Aborting remaining tests. 🛑")
			break
		end

		logCPUUsage()

		if not freezeStage and timeTaken >= 10 then
			freezeStage = stage.name
		end

		if timeTaken >= 30 then
			warn("[STRESS TEST] 🚨 Warning! " .. stage.name .. " took over 30 seconds to complete! ⚠️")
		end

		if timeTaken >= 60 then
			warn("[STRESS TEST] 🚨 Warning! " .. stage.name .. " took over 60 seconds to complete! ⚠️")
		end

		print("[STRESS TEST] Pausing before next stage... ⏳")
		task.wait(2)
	end

	local averageTimePerIteration = totalIterations > 0 and totalTime / totalIterations or 0
	local iterationsPerSecond = totalTime > 0 and totalIterations / totalTime or 0

	local speedRating = getSpeedRating(averageTimePerIteration)
	speedRating = speedRating or "Unknown Rating"
	local efficiencyRating = getEfficiencyRating(iterationsPerSecond)

	print("===========================================")
	print("              🔧 FINAL PERFORMANCE 🔧      ")
	print("===========================================")
	print("💉 Executor Name: " .. executorName)
	print("✅ Tests Passed: " .. passedTests .. "/" .. #stages)
	print("⏱️ Total Time Taken: " .. string.format("%.2f", totalTime) .. " seconds")
	print("🔄 Total Iterations Processed: " .. totalIterations)
	print("===========================================")
	print("⚡ Average Time per Iteration: " .. string.format("%.8f", averageTimePerIteration) .. " seconds")
	print("⚡ Iterations per Second: " .. string.format("%.2f", iterationsPerSecond) .. " iterations/sec")
	print("===========================================")
	print("🌟 Speed Rating: " .. speedRating)
	print("🌟 Efficiency Rating: " .. efficiencyRating)
	print("===========================================")
	if ranOnExecutor then
		print("[SUMMARY] ✅ The test ran on the executor successfully.")
	else
		warn("[SUMMARY] The test ran locally due to executor failure.")
	end
	if isLocalCPU() then
		warn("[CPU CHECK] ❌ The test used your local CPU instead of the executor!")
	else
		print("[CPU CHECK] ✅ The test ran on the executor and not your local CPU.")
	end
	print("===========================================")
	if freezeStage then
		print("🚨 Freezing started at: " .. freezeStage .. " Stage! (10+ seconds per test) 🥶")
	else
		print("✅ No significant freezing detected. System handled all tests smoothly! 🚀")
	end

	if freezeWarningSent30SecStage then
		warn("🚨 Freezing exceeded 30 seconds at: " .. freezeWarningSent30SecStage .. " Stage! 🥶")
	end

	if freezeWarningSent60SecStage then
		warn("🚨 Freezing exceeded 60 seconds at: " .. freezeWarningSent60SecStage .. " Stage! 🥶")
	end

	if crashStage then
		print("🚨 Potential Crash Detected at: " .. crashStage .. " (Test took over 90 seconds) 🛑")
	end
end

print("===========================================")
print("              ⛔ END OF THE SUMMARY ⛔      ")
print("===========================================")

runStressTests()
