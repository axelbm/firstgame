assert(game, "game required")

local keymap = {}
keymap.map = {}
keymap.mapdown = {}

function keymap.setmap(map)
	keymap.map = map
end

function keymap.keypressed(key, scancode, isrepeat)
	if keymap.map[key] then
		local map = keymap.map[key]
		keymap.mapdown[map] = true
		hook.call("keymapreleased", map, key, scancode, isrepeat)
	end
end
hook.add("keypressed", "keymap", keymap.keypressed)

function keymap.keyreleased(key, scancode)
	if keymap.map[key] then
		local map = keymap.map[key]
		keymap.mapdown[map] = nil
		hook.call("keymapreleased", map, key, scancode)
	end
end
hook.add("keyreleased", "keymap", keymap.keyreleased)

function keymap.keyreleased(key, scancode)
	if keymap.map[key] then
		hook.call("keymapreleased", keymap.map[key], key, scancode)
	end
end
hook.add("keyreleased", "keymap", keymap.keyreleased)

function keymap.down(key)
	return keymap.mapdown[key] or false
end

return keymap