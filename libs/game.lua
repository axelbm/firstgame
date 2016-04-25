assert(love, "love required")

local game = {}

function game.conf()
	game.title = "nogame"
	game.version = "0"
	game.language = "en"
end
hook.add("preloal", "game", function() game.conf() end)

function game.settitle(title)
	game.title = title
	love.window.setTitle(game.title .. " - " .. game.version)
end

return game