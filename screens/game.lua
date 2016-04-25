assert(love, "love required")
assert(game.screens, "game.screen required")

local screen = game.screens.new()
screen.name = "game"
screen.mousevisible = false

function screen:load()

end

function screen.draw(self)

end

return screen