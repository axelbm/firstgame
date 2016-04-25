
local oldtype = type
function type(...)
	local args = {...}
	local types = {}

	for _,value in pairs(args) do
		local type = oldtype(value)

		if type == "table" then
			local mt = getmetatable(value)
			if mt then
				type = mt.__type or type
			end
		elseif type == "userdata" then
			if value.type then
				return value:type()
			end
		end

		table.insert(types, type)
	end

	return unpack(types) or "nil"
end

function istype(tpe, ...)
	local args = {...}

	if #args == 0 then 
		return tpe == "nil"
	elseif #args == 1 then
		return type(args[1]) == tpe
	else
		local valid = true

		for _,arg in pairs(args) do
			if not (type(arg) == tpe) then
				valid = false
			end
		end

		return valid
	end
end

function isstring(...)
	return istype("string", ...)
end

function isnumber(...)
	return istype("number", ...)
end

function istable(...)
	return istype("table", ...)
end

function isfunction(...)
	return istype("function", ...)
end

function isbool(...)
	return istype("boolean", ...)
end

function isnil(...)
	return istype("nil", ...)
end

function isfont(...)
	return istype("Font", ...)
end