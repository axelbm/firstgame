require("/libs/type")
hook = require("/libs/hook")
timer = require("/libs/timer")
game = require("/libs/game")
require("/libs/color")
require("/libs/vector")
utf8 = require("/libs/utf8")
keymap = require("/libs/keymap")
menu = require("/libs/menu")

require("/libs/screen")
print = require("/libs/console")

function game.conf()
	game.title = "First Game"
	game.version = "prot.0.2"
	game.language = "en"
end

function love.load()
	game.console.enable = true
	game.console.closekey = "escape"

	game.screens.load(require("/screens/mainmenu"))
end

function love.keypressed(key, scancode, isrepeat)
	-- if key == "escape" then
	--	love.event.quit()
	-- end
end

function love.run()
	if love.math then
		love.math.setRandomSeed(os.time())
	end

	hook.call("preloal")

	hook.call("load", arg)
	if love.load then pcall(love.load, arg) end

	if love.timer then 
		love.timer.step()
		love.timer.start = love.timer.getTime()
	end

	local dt = 0

	while true do
		if love.event then
			love.event.pump()
			for event, a, b, c, d, e, f in love.event.poll() do
				local ra = hook.call(event, a, b, c, d, e, f)

				if isnil(ra) then
					if event == "quit" then
						return
					end
					hook.call("event", event, a, b, c, d, e, f)
					pcall(love.handlers[event], a, b, c, d, e, f)
				end
			end
		end

		if love.timer then
			love.timer.step()
			dt = love.timer.getDelta()
		end

		if timer then
			for id,tmr in pairs(timer.timers) do
				if not tmr.pause and not tmr.stop then
					if (love.timer.getTime() - tmr.lastcall) > tmr.delay then
						timer.run(id)
					end
				end
			end
		end

		hook.call("update", dt)
		if love.update then pcall(love.update, dt) end

		if love.graphics and love.graphics.isActive() then
			love.graphics.clear(love.graphics.getBackgroundColor())
			love.graphics.origin()

			hook.call("draw")
			if love.draw then pcall(love.draw) end
			hook.call("postdraw")

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.015) end
	end
end

local oldpcall = pcall
function pcall(func, ...)
	local args = {...}

	local result = {oldpcall(func, ...)}
	local success = table.remove(result, 1)

	if not success then
		hook.call("error", result[1])
	end 

	return success, unpack(result)
end

function xpcall(func, errcallback, ...)
	local args = {...}

	local result = {oldpcall(func, ...)}
	local success = table.remove(result, 1)

	if not success then
		local errresult = errcallback(result[1])
		if isnil(errresult) then
			hook.call("error", result[1])
		elseif isstring(errresult) then
			hook.call("error", errresult)
		end
	end 

	return success, unpack(result)
end