print("🌟  FibonacciTest.lua Initialization  🌟")
print("=======================================")
task.wait(0.5)
local executorName = identifyexecutor and identifyexecutor() or "Unknown Executor"
task.wait(1)
print("✨ Loading FibonacciTest.lua... 🚀")
task.wait(0.1)
print("⏳ Please Wait... ⏳")
print("=======================================")

task.wait(2)

local function add(a, b)
	local res, carry = {}, 0
	a, b = tostring(a), tostring(b)
	local maxLen = math.max(#a, #b)
	a = string.rep("0", maxLen - #a) .. a
	b = string.rep("0", maxLen - #b) .. b
	for i = maxLen, 1, -1 do
		local sum = tonumber(a:sub(i, i)) + tonumber(b:sub(i, i)) + carry
		carry = math.floor(sum / 10)
		res[i] = sum % 10
	end
	if carry > 0 then
		table.insert(res, 1, carry)
	end
	return table.concat(res)
end

local function fib(n)
	local a, b = "0", "1"
	for _ = 2, n do
		a, b = b, add(a, b)
	end
	return b
end

local function stressTest(n)
	local start = os.clock()
	local result = fib(n)
	local duration = os.clock() - start

	local i9_14900ks_reference_time = 1.2 -- hypothetical seconds

	print("===========================================")
	print("              🔥 FIBONACCI TEST RESULTS 🔥      ")
	print("===========================================")
	print("🔢 Fibonacci Number: F(" .. n .. ")")
	print("📏 Number of Digits: " .. #result)
	print("⏱️  Time Taken: " .. string.format("%.4f", duration) .. " seconds")
	print("-------------------------------------------")
	print("⚙️ Reference CPU: Intel Core i9-14900KS")
	print("⏳ Reference Time: " .. i9_14900ks_reference_time .. " seconds")
	print("-------------------------------------------")

	local diff = duration - i9_14900ks_reference_time
	if duration > i9_14900ks_reference_time then
		local slower_by = string.format("%.2f", diff)
		local percent_perf = string.format("%.2f", (i9_14900ks_reference_time / duration) * 100)
		print("🐢 Your system is slower by " .. slower_by .. " seconds.")
		print("📉 Performance: " .. percent_perf .. "% of the i9-14900KS")
	else
		local faster_by = string.format("%.2f", -diff)
		local percent_perf = string.format("%.2f", (duration / i9_14900ks_reference_time) * 100)
		print("🚀 Your system is faster by " .. faster_by .. " seconds!")
		print("📈 i9-14900KS runs at " .. percent_perf .. "% of your system speed.")
	end
	print("===========================================")
	print("           ✅ Test Complete! ✅           ")
	print("===========================================")
end

stressTest(10000)
