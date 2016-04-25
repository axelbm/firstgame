assert(love, "love required")
assert(game, "game required")
assert(Vector, "vector required")
assert(Color, "color required")

local console = {
	enable = false,
	errortrace = false,
	openkey = nil,
	closekey = nil,
	togglekey = "`",
	font = love.graphics.newFont(12),
	inputcolor = game.colors.white,
	outputcolor = game.colors.yellow_green,
	backgroundcolor = game.colors.black,
}

game.console = console

local con = {
	isopen = false,
	input = "",
	cursor = 0,
	cursorstat = true,
	cursorlastblink = 0,
	linecursor = 0,
	outputs = {},
	inputs = {},
	ignoreinput = false,
	alreadykeyrepeat = false,
}

function console.keypressed(key, scancode, isrepeat)
	if console.enable then
		if not isrepeat then
			if console.isopen() then
				if scancode == (console.closekey or console.togglekey) then
					console.close()
					return true
				end
			else
				if scancode == (console.openkey or console.togglekey) then
					console.open()
					con.ignoreinput = true
				end
			end
		end

		if console.isopen() then
			if key == "return" and con.input:len() > 0 then
				console.sendinput()
			elseif key == "backspace" and con.cursor > 0 and #con.input > 0 then
				if love.keyboard.isDown("lctrl") then
					local p = con.input:len() - (con.input:reverse():find("%s", -con.cursor) or (con.input:len() + 1)) + 1
					if con.input:sub(con.cursor, con.cursor) == " " then
						p = con.input:len() - (con.input:reverse():find("%w", con.input:len() - p) or (con.input:len() + 1)) + 1
					end
					console.subtext(p, con.cursor)
				else
					console.subtext(con.cursor - 1, con.cursor)
				end
			elseif key == "left" and con.cursor > 0 then
				con.updatecursor(con.cursor - 1)
			elseif key == "right" and con.cursor < utf8.len(con.input) then
				con.updatecursor(con.cursor + 1)
			elseif key == "up" and con.linecursor < #con.inputs then
				con.linecursor = con.linecursor + 1
				console.settext(con.inputs[#con.inputs - con.linecursor + 1] or "")
			elseif key == "down" and con.linecursor > 0 then
				con.linecursor = con.linecursor - 1
				console.settext(con.inputs[#con.inputs - con.linecursor + 1] or "")
			end

			if love.keyboard.isDown("lctrl") then
				if key == "x" then
					love.system.setClipboardText(con.input)
					console.settext("")
				elseif key == "c" then
					love.system.setClipboardText(con.input)
				elseif key == "v" then
					console.appendtext(love.system.getClipboardText(), con.cursor)
				end
			end

			return true
		end
	end
end
hook.add("keypressed", "console", console.keypressed)

function console.keyreleased(key, scancode)
	if console.isopen() and scancode == (console.openkey or console.togglekey) then
		con.ignoreinput = false
	end
end
hook.add("keyreleased", "console", console.keyreleased)

function console.textinput(text)
	if console.isopen() and not con.ignoreinput then
		console.appendtext(text, con.cursor)
		return true
	end
end
hook.add("textinput", "console", console.textinput)

function con.updatecursor(pos)
	con.cursor = pos
	con.cursorlastblink = love.timer.getTime()
	con.cursorstat = true
end

function console.settext(text)
	text = tostring(text)
	con.input = text

	con.updatecursor(utf8.len(text))
end

function console.appendtext(text, pos)
	text = tostring(text)
	con.input = utf8.sub(con.input,0, pos) .. text .. utf8.sub(con.input, pos+1)
	con.updatecursor(pos + utf8.len(text))
end

function console.subtext(startpos, endpos)
	startpos = math.max(startpos, 0)
	endpos = math.min(endpos, utf8.len(con.input))

	con.input = utf8.sub(con.input, 0, startpos) .. utf8.sub(con.input,endpos + 1)
	con.updatecursor(startpos)
end

function console.sendinput()
	local input = con.input
	console.settext("")
	table.insert(con.inputs, input)
	con.linecursor = 0

	console.print(input)
	console.run(input)
end

function console.run(input)
	if hook.call("console.run") then
		return
	end

	local func = loadstring(input)
	local success, a, b, c, d, e, f = pcall(func)
	local args = {a, b, c, d, e, f}

	if success then
		if #args > 0 then
			local result = {}
			for _,value in pairs(args) do
				local v = tostring(value)
				if v then table.insert(result, v) end
			end
			console.print(game.colors.blue, table.concat(result, ", "))
		end
	end
end

function console.print(...)
	local args = {...}
	local valid = false

	for k,v in pairs(args) do
		if not iscolor(v) then
			args[k] = tostring(v)
			valid = true
		end
	end

	if valid then
		table.insert(con.outputs, args)
	end
end

function console.draw()
	if console.isopen() then
		local width, height = love.window.getMode()

		local inputcolor = console.inputcolor
		local outputscolor = console.outputcolor
		local backgroundcolor = console.backgroundcolor

		love.graphics.setColor(backgroundcolor:alpha(150):rgba())
		love.graphics.rectangle("fill", 0, height - console.font:getHeight() - 6, width, console.font:getHeight() + 6)


		local input = love.graphics.newText(console.font, con.input)
		local inputpos = Vector(0, height - console.font:getHeight() - 3)

		love.graphics.setColor(inputcolor:rgba())
		love.graphics.draw(input, inputpos.x, inputpos.y)

		local cursorpos = console.font:getWidth(utf8.sub(con.input, 0, con.cursor))
		local lastblink = con.cursorlastblink
		if love.timer.getTime() - lastblink > 0.5 then
			con.cursorlastblink = love.timer.getTime()
			con.cursorstat = not con.cursorstat
		end

		love.graphics.setColor(inputcolor:alpha(inputcolor.a * (con.cursorstat and 1 or 0)):rgba())
		love.graphics.rectangle("fill", inputpos.x + cursorpos, inputpos.y, 1, console.font:getHeight())


		local outputspos = Vector()
		local maxline = 20
		local count = math.min(#con.outputs, maxline)

		love.graphics.setColor(backgroundcolor:alpha(150):rgba())
		love.graphics.rectangle("fill", 0, 0, width, console.font:getHeight() * count)

		local i = 0
		while i < count do
			i = i + 1
			local id = #con.outputs - i + 1

			local args = con.outputs[id]

			local textcolor = inputcolor
			local texts = ""

			local outputpos = Vector(0, console.font:getHeight() * (count - i)):add(outputspos)

			love.graphics.setColor(outputscolor.r, outputscolor.g, outputscolor.b, outputscolor.a)

			for k,v in pairs(args) do
				if iscolor(v) then
					textcolor = v
					love.graphics.setColor(v:rgba())
				else
				    local textpos = Vector(console.font:getWidth(texts), 0):add(outputpos)
					texts = texts .. v

					local output = love.graphics.newText(console.font, v)
					love.graphics.draw(output, textpos.x, textpos.y)
				end
			end
		end
	end
end
hook.add("postdraw", "console", console.draw)

function console.open()
	if hook.call("console.open") then
		return
	end

	con.isopen = true

	con.alreadykeyrepeat = love.keyboard.hasKeyRepeat()

	if not con.alreadykeyrepeat then
		love.keyboard.setKeyRepeat(true)
	end
end

function console.close()
	if hook.call("console.close") then
		return
	end

	con.isopen = false

	if not con.alreadykeyrepeat then
		love.keyboard.setKeyRepeat(false)
	end
end

function console.toggle()
	if console.isopen() then
		console.close()
	else
		console.open()
	end
end

function console.isopen()
	return con.isopen
end

function console.error(msg)
	console.print(game.colors.red, "ERROR: " .. msg)

	if console.errortrace then
		local trace = debug.traceback()
		for l in string.gmatch(trace, "(.-)\n") do
			if not string.match(l, "boot.lua") then
				if not string.match(l, "oldpcall") then
					l = string.gsub(l, "stack traceback:", "Traceback\n")
					console.print(game.colors.red, "\t" .. l)
				end
			end
		end
	end
end
hook.add("error", "console", console.error)

return console.print