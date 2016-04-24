assert(love, "love required")
assert(game.screens, "game.screen required")

local screen = game.screens.new()
screen.name = "mainmenu"

function screen:load()
	self.backgroud = love.graphics.newImage("/resources/backgrounds/plane.png")
	self.titlefont = love.graphics.newFont("/resources/fonts/bikang_struck.ttf", 100)
	self.menufont = love.graphics.newFont("/resources/fonts/bikang_struck.ttf", 65)

	self.menu = {
		{
			name = "Play",
			func = function()

			end
		},
		{
			name = "Option",
			func = function()

			end
		},
		{
			name = "Exit",
			func = function()
				love.event.quit()
			end
		},
	}

	self.menupos = 1
end

function screen:keypressed(key)
	if screen.start then
		if key == "down" then
			self.menupos = self.menupos % #self.menu + 1
		elseif key == "up" then
			self.menupos = (self.menupos - 2) % #self.menu + 1
		elseif key == "return" then
			self.menu[self.menupos].func()
		end
	else
		screen.start = true
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
	local title = love.graphics.newText(self.titlefont, game.title)
	love.graphics.draw(title, 50, 0)

	if screen.start then
		for i,v in pairs(self.menu) do
			local item = love.graphics.newText(self.menufont, v.name)
			love.graphics.setColor(((self.menupos == i) and game.colors.blue or game.colors.white):rgb())
			love.graphics.draw(item, self.size.x*0.7, self.size.y*(0.10 + (i-1)*0.09))
		end
	else
		local start = love.graphics.newText(self.menufont, "Press to start!")
		love.graphics.setColor(game.colors.white:rgb())
		love.graphics.draw(start, self.size.x/2 - start:getWidth()/2, self.size.y*0.68)
	end
end

return screen