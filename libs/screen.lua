assert(game, "game required")

local screens = {
	active = nil,

}
game.screens = screens

local screen = {}
local screen_mt = {
	__index = screen,
	__type = "screen",
	__tostring = function(self)
		return "screen: " .. (self.name or "No name")
	end,
}

screen.draw = {}

function isscreen(...)
	return istype("screen", ...)
end

function screens.new()
	local self = {}
	setmetatable(self, screen_mt)

	self.title = game.title
	self.size = Vector(love.window.getMode())

	return self
end

function screens.load(screen)
	screens.active = screen

	screen.load(screen)

	if not isnil(screen.mousevisible) then
		love.mouse.setVisible(screen.mousevisible) 
	end

	if screen.title then
		game.settitle(screen.title)
	end

	if screen.fullscreen then
		love.window.setMode(screen.size.x, screen.size.y, {fullscreen = screen.fullscreen})
	else
		if screen.size and screen.size ~= Vector(love.window.getMode()) then
			love.window.setMode(screen.size:xy())
		end
	end
end

function screens.event(event, ...)
	if isscreen(screens.active) then
		local args = {...}
		local screen = screens.active

		if screen[event] then
			return screen[event](screen, unpack(args))
		end
	end
end
hook.add("event", "screens", screens.event)

function screens.draw()
	if screens.active and isscreen(screens.active) then
		local screen = screens.active
		local draw = screen.draw

		if isfunction(draw) then
			draw(screen)
		elseif istable(draw) then
			if draw.background then
				if istable(draw.background) then
					for i,f in pairs(draw.background) do
						f(screen)
					end
				else
					draw.background(screen)
				end
			end

			if draw.game then
				if istable(draw.game) then
					for i,f in pairs(draw.game) do
						f(screen)
					end
				else
					draw.game(screen)
				end
			end

			if draw.ui then
				if istable(draw.ui) then
					for i,f in pairs(draw.ui) do
						f(screen)
					end
				else
					draw.ui(screen)
				end
			end
		end
	end
end
hook.add("draw", "screens", screens.draw)

function screens.update(delta)
	if screens.active and isscreen(screens.active) then
		local screen = screens.active

		if screen.update then
			return screen.update(screen, delta)
		end
	end
end
hook.add("update", "screens", screens.update)