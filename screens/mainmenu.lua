assert(love, "love required")
assert(game.screens, "game.screen required")

local screen = game.screens.new()
screen.name = "mainmenu"
screen.mousevisible = false

function screen:load()
	self.backgroud = love.graphics.newImage("/resources/backgrounds/plane.png")
	self.titlefont = love.graphics.newFont("/resources/fonts/bikang_struck.ttf", 100)
	self.menufont = love.graphics.newFont("/resources/fonts/bikang_struck.ttf", 65)

	self.menu = {}

	local list = menu.newselectlist(-40, self.menufont, game.colors.white, game.colors.blue)
	self.menu.main = list

	list:additem("Play", function(item)
		game.screens.load(require("/screens/game"))
	end)
	list:additem("Option", function(item)
		self.menu.active = self.menu.option
	end)
	list:additem("Exit", function(item)
		love.event.quit()
	end)

	local list = menu.newselectlist(-40, self.menufont, game.colors.white, game.colors.blue)
	self.menu.option = list

	list:additem("Fullscreen: " .. (love.window.getFullscreen() and "on" or "off"), function(item)
		love.window.setFullscreen(not love.window.getFullscreen())
		item.text = "Fullscreen: " .. (love.window.getFullscreen() and "on" or "off")
	end)
	list:additem("Language: " .. game.language, function(item)

	end)
	list:additem("Return", function(item)
		self.menu.active = self.menu.main
	end)

	self.menu.active = self.menu.main
end

function screen:keypressed(key)
	if screen.start then
		if key == "down" then
			self.menu.active:cursordown()
		elseif key == "up" then
			self.menu.active:cursorup()
		elseif key == "return" then
			self.menu.active:select()
		end
	else
		if key == "space" then
			screen.start = true
		end
	end
end

function screen.draw.background(self)
	local image = self.backgroud
	local imagesize = Vector(image:getDimensions())
	local screensize = Vector(love.graphics.getDimensions())

	local scale = math.max(screensize.x / imagesize.x, screensize.y / imagesize.y)
	local pos = screensize/2 - imagesize*scale/2

	love.graphics.setColor(game.colors.white:rgb())
	love.graphics.draw(image, pos.x, pos.y, 0, scale, scale)

end

function screen.draw.ui(self)
	local screensize = Vector(love.graphics.getDimensions())
	local title = love.graphics.newText(self.titlefont, game.title)
	love.graphics.draw(title, screensize.x/2 - title:getWidth()/2, 0)

	if screen.start then
		self.menu.active:draw(screensize.x/2, screensize.y*0.2, "center")
	else
		local start = love.graphics.newText(self.menufont, "Press space!")
		love.graphics.setColor(game.colors.white:rgb())
		love.graphics.draw(start, screensize.x/2 - start:getWidth()/2, screensize.y*0.68)
	end
end

return screen