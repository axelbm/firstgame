local hook = {}
hook.hooks = {}

function hook.add(event, name, func)
	assert(isstring(event), 	"bad argument #1 to 'hook.add' (string expected, got ".. type(event).. ")")
	assert(name,            	"bad argument #2 to 'hook.add' (value expected, got nil)")
	assert(isfunction(func),	"bad argument #3 to 'hook.add' (function expected, got ".. type(func).. ")")

	if not hook.hooks[event] then
		hook.hooks[event] = {}
	end

	hook.hooks[event][name] = func
end

function hook.remove(event, name)
	assert(isstring(event),	"bad argument #1 to 'hook.remove' (string expected, got ".. type(event).. ")")
	assert(isstring(name), 	"bad argument #2 to 'hook.remove' (string expected, got ".. type(name).. ")")
	if not hook.hooks[event] then return end

	hook.hooks[event][name] = nil
end

function hook.call(event, ...)
	assert(isstring(event), "bad argument #1 to 'hook.call' (string expected, got ".. type(event).. ")")

	if hook.hooks[event] then
		local result = {}
		local hooks = hook.hooks[event]

		for key, func in pairs(hooks) do
			if isstring(key) then
				result = {pcall(func, ...)}
			else
			    if not isnil(key) then
					result = {pcall(func, key, ...)}
				else
					hooks[key] = nil
				end
			end

			local success = table.remove(result, 1)

			if not isnil(result[1]) then
				return unpack(result)
			end
		end
	end
end

return hook