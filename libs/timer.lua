local timer = {}
timer.timers = {}

function timer.adjust(index, delay, rep, func)
	assert(isstring(index), 	"bad argument #1 to 'timer.adjust' (string expected, got " .. type(index) .. ")")
	assert(isnumber(delay), 	"bad argument #2 to 'timer.adjust' (number expected, got " .. type(delay) .. ")")
	assert(isnumber(rep),   	"bad argument #3 to 'timer.adjust' (number expected, got " .. type(rep) .. ")")
	assert(isfunction(func),	"bad argument #4 to 'timer.adjust' (function expected, got " .. type(func) .. ")")
	if not timer.timers[index] then return false end

	local tmr = timer.timers[index]

	tmr = {
		delay = delay,
		repetitions = rep,
		func = func
	}

	if (tmr.lastcall + tmr.delay) > love.timer.getTime() then
		timer.run(index)
	end

	return true
end

function timer.create(index, delay, rep, func)
	assert(isstring(index), 	"bad argument #1 to 'timer.create' (string expected, got " .. type(index) .. ")")
	assert(isnumber(delay), 	"bad argument #2 to 'timer.create' (number expected, got " .. type(delay) .. ")")
	assert(isnumber(rep),   	"bad argument #3 to 'timer.create' (number expected, got " .. type(rep) .. ")")
	assert(isfunction(func),	"bad argument #4 to 'timer.create' (function expected, got " .. type(func) .. ")")

	timer.timers[index] = {
		delay = delay,
		repetitions = rep,
		count = 0,
		func = func,
		lastcall = love.timer.getTime(),
		pause = false,
		stop = false
	}
end

function timer.exists(index)
	assert(isstring(index),	"bad argument #1 to 'timer.exists' (string expected, got ".. type(index).. ")")
	return istable(timer.timers[index])
end

function timer.pause(index)
	assert(isstring(index),	"bad argument #1 to 'timer.pause' (string expected, got ".. type(index).. ")")

	if timer.timers[index] and not timer.timers[index].pause and not timer.timers[index].stop then
		timer.timers[index].pause = love.timer.getTime() 
		return true
	end
	return false
end

function timer.remove(index)
	assert(isstring(index),	"bad argument #1 to 'timer.remove' (string expected, got ".. type(index).. ")")
	timer.timers[index] = nil
end

function timer.repsleft(index)
	assert(isstring(index),	"bad argument #1 to 'timer.repsleft' (string expected, got ".. type(index).. ")")

	if timer.timers[index] and timer.timers[index].repetitions > 0 then
		return timer.timers[index].repetitions - timer.timers[index].count
	end
	return
end

function timer.simple(delay, func)
	assert(isnumber(delay), 	"bad argument #1 to 'timer.simple' (number expected, got " .. type(delay) .. ")")
	assert(isfunction(func),	"bad argument #2 to 'timer.simple' (function expected, got " .. type(func) .. ")")

	table.insert(timer.timers, {
		delay = delay,
		repetitions = 1,
		count = 0,
		func = func,
		lastcall = love.timer.getTime(),
		pause = false,
		stop = false
	})
end

function timer.start(index)
	assert(isstring(index),	"bad argument #1 to 'timer.start' (string expected, got ".. type(index).. ")")

	if timer.timers[index] then
		local tmr = timer.timers[index]
		tmr.lastcall = love.timer.getTime()
		tmr.count = 0
		tmr.pause = false
		tmr.stop = false
		return true
	end
	return false
end

function timer.stop(index)
	assert(isstring(index),	"bad argument #1 to 'timer.stop' (string expected, got ".. type(index).. ")")

	if timer.timers[index] and not timer.timers[index].stop then
		local tmr = timer.timers[index]
		tmr.lastcall = love.timer.getTime()
		tmr.count = 0
		tmr.pause = false
		tmr.stop = true
		return true
	end
	return false
end

function timer.timeleft(index)
	assert(isstring(index),	"bad argument #1 to 'timer.timeleft' (string expected, got ".. type(index).. ")")

	if timer.timers[index] then
		local tmr = timer.timers[index]
		if tmr.pause then
			return tmr.delay - (tmr.pause - tmr.lastcall)
		elseif tmr.stop then
			return tmr.delay
		else
			return love.timer.getTime() - tmr.lastcall
		end
	end
	return false
end

function timer.toggle(index)
	assert(isstring(index),	"bad argument #1 to 'timer.toggle' (string expected, got ".. type(index).. ")")

	if timer.timers[index] then
		local tmr = timer.timers[index]

		if tmr.pause then
			timer.unpause(index)
		else
			timer.pause(index)
		end
	end
end

function timer.unpause(index)
	assert(isstring(index),	"bad argument #1 to 'timer.unpause' (string expected, got ".. type(index).. ")")

	if timer.timers[index] and timer.timers[index].pause and not timer.timers[index].stop then
		local tmr = timer.timers[index]
		tmr.lastcall = love.timer.getTime() - (tmr.pause - tmr.lastcall)
		tmr.pause = false
		return true
	end
	return false
end

function timer.run(index)
	local tmr = timer.timers[index]

	tmr.count = tmr.count + 1
	local success = xpcall(tmr.func, function(err) return "TIMER ERROR["..index..":"..tmr.count.."]:" .. err end)

	if success and (tmr.count < tmr.repetitions or tmr.repetitions <= 0) then
		tmr.lastcall = tmr.lastcall + tmr.delay
	else
		timer.timers[index] = nil
	end

end


return timer