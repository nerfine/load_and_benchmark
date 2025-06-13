print("=======================================")
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
