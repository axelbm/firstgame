local menu = {}

local selectlist = {}
local selectlist_mt = {
	__index = selectlist,
	__type = "selectlist",
}

local selectlistitem = {}
local selectlistitem_mt = {
	__index = selectlistitem,
	__type = "selectlistitem",
}

function menu.newselectlist(margin, font, color, selectcolor)
	local self = {}
	setmetatable(self, selectlist_mt)

	self.cursor = 1
	self.items = {}
	self.margin = isnumber(margin) and margin or 0
	self.font = isfont(font) and font or love.graphics.newFont(12)
	self.color = iscolor(color) and color or game.colors.white
	self.selectcolor = iscolor(selectcolor) and selectcolor or game.colors.gray

	return self
end

function selectlist:additem(text, func, font, color, selectcolor)
	assert(isstring(text),  	"bad argument #1 to 'selectlist:additem' (string expected, got " .. type(text) .. ")")
	assert(isfunction(func),	"bad argument #2 to 'selectlist:additem' (function expected, got " .. type(func) .. ")")

	local item = {}
	setmetatable(item, selectlistitem_mt)
	item.text = text
	item.func = func
	item.font = isfont(font) and font or self.font
	item.color = iscolor(color) and color or self.color
	item.selectcolor = iscolor(selectcolor) and selectcolor or self.selectcolor

	table.insert(self.items, item)

	return item
end

function selectlist:draw(x, y, align)
	align = isstring(align) and align or "left"

	for i,item in pairs(self.items) do
		local text = love.graphics.newText(item.font, item.text)
		love.graphics.setColor(((self.cursor == i) and item.selectcolor or item.color):rgb())

		if align == "right" then
			local width = text:getWidth()
			love.graphics.draw(text, x - width, y + (item.font:getHeight() + self.margin)*(i - 1))
		elseif align == "center" then
			local width = text:getWidth()
			love.graphics.draw(text, x - width/2, y + (item.font:getHeight() + self.margin)*(i - 1))
		else
			love.graphics.draw(text, x, y + (item.font:getHeight() + self.margin)*(i - 1))
		end
	end
end

function selectlist:select(pos)
	pos = pos or self.cursor
	local item = self.items[pos]

	item:func()
end

function selectlist:getcursor()
	return self.cursor
end

function selectlist:setcursor(pos)
	assert(isnumber(text), "bad argument #1 to 'selectlist:cursorset' (number expected, got " .. type(pos) .. ")")
	pos = math.max(math.min(pos, #self.items), 1)

	self.cursor = pos
end

function selectlist:cursorup()
	self.cursor = (self.cursor - 2) % #self.items + 1
end

function selectlist:cursordown()
	self.cursor = self.cursor % #self.items + 1
end

return menu