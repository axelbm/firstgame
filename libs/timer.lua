local timer = {}
timer.timers = {}

function timer.create(index, delay, rep, func)
	if not isstring(index) then return end
	if not isnumber(delay, rep) then return end
	if not isfunction(func) then return end

	timer.timers[index] = {
		delay = delay,
		repetitions = rep,
		count = 0,
		func = func,
		lastcall = love.timer.getTime()
	}
end

function timer.adjust(index, delay, rep, func)
	if not isstring(index) then return false end
	if not isnumber(delay, rep) then return false end
	if not isfunction(func) then return false end
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

function timer.run(index)
	local tmr = timer.timers[index]

	local success = xpcall(tmr.func, function(err) return "TIMER ERROR["..index..":"..tmr.count.."]:" .. err end)
	tmr.count = tmr.count + 1

	if success and tmr.count < tmr.repetitions and tmr.repetitions > 0 then
		tmr.lastcall = tmr.lastcall + tmr.delay
	else
		timer.timers[index] = nil
	end

end


return timer