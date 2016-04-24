
local vector  = {x = 0, y = 0}

local vector_mt = {}

-- Constructor

function Vector(x, y)
	local self = {}
	setmetatable(self, vector_mt)

	self.x = x or 0
	self.y = y or x

	assert(isnumber(self.x), "bad argument #1 to 'Vector' (number expected, got ".. type(self.x).. ")")
	assert(isnumber(self.y), "bad argument #2 to 'Vector' (number expected, got ".. type(self.y).. ")")

	return self
end

vector_mt = {
	__index = vector,
	__type = "vector",
	__tostring = function(self)
		return self:tostring()
	end,
	__len = function(self)
		return self:length()
	end,
	__call = function(self, x, y)
		self.x = x or 0
		self.y = y or x
		return self
	end,
	-- Operators
	__unm = function(self)
		return self:clone():neg()
	end,
	__add = function(vec1, vec2)
		assert(isvector(vec1) and isvector(vec2), "attempt to perform aritmetic on a vector with a " .. (isvector(vec1) and type(vec2) or type(vec1)))
		return vec1:clone():add(vec2)
	end,
	__sub = function(vec1, vec2)
		assert(isvector(vec1) and isvector(vec2), "attempt to perform aritmetic on a vector with a " .. (isvector(vec1) and type(vec2) or type(vec1)))
		return vec1:clone():sub(vec2)
	end,
	__mul = function(val1, val2)
		local vector = isvector(val1) and val1 or val2
		local other = isvector(val1) and val2 or val1
		assert(isvector(other) or isnumber(other), "attempt to perform aritmetic on a vector with a " .. type(other))
		return vector:clone():mul(other)
	end,
	__div = function(val1, val2)
		if isvector(val1) then
			assert(isvector(val2) or isnumber(val2), "attempt to perform aritmetic on a vector with a " .. type(val2))
			return val1:clone():div(val2)
		else
			assert(isnumber(val1), "attempt to perform aritmetic on a " .. type(val1) .. " with a vector")
			return Vector(val1):div(val2)
		end
	end,
	__mod = function(val1, val2)
		if isvector(val1) then
			assert(isvector(val2) or isnumber(val2), "attempt to perform aritmetic on a vector with a " .. type(val2))
			return val1:clone():mod(val2)
		else
			assert(isnumber(val1), "attempt to perform aritmetic on a " .. type(val1) .. " with a vector")
			return Vector(val1):mod(val2)
		end
	end,
	__pow = function(val1, val2)
		assert(isvector(val1) and (isvector(val2) or isnumber(val2)), "attempt to perform aritmetic on a vector with a " .. type(val1))
		return val1:clone():pow(val2)
	end,
	-- Comparison
	__eq = function(val1, val2)
		local vector = isvector(val1) and val1 or val2
		local other = isvector(val1) and val2 or val1
		return vector:equal(other)
	end,
	__lt = function(vec1, vec2)
		if not isvector(vec1) or not isvector(vec2) then return false end
		return vec1:less(vec2)
	end,
	__le = function(vec1, vec2)
		if not isvector(vec1) or not isvector(vec2) then return false end
		return vec1:lessequal(vec2)
	end
}


function vector:clone()
	return Vector(self.x, self.y)
end

function isvector(...)
	return istype(vector_mt.__type, ...)
end

function vector:xy()
	return self.x, self.y
end

-- Metatable Events

function vector:length()
	return (self.x^2 + self.y^2) ^ 0.5
end

function vector:tostring()
	return "Vector [" .. self.x .. ", " .. self.y .. "]"
end


-- Mathematic Operators

function vector:neg()
	self.x = -self.x
	self.y = -self.y

	return self
end

function vector:add(other)
	assert(isvector(other), "bad argument #1 to 'vector:add' (vector expected, got ".. type(other).. ")")
	self.x = self.x + other.x
	self.y = self.y + other.y

	return self
end

function vector:sub(other)
	assert(isvector(other), "bad argument #1 to 'vector:sub' (vector expected, got ".. type(other).. ")")
	self.x = self.x - other.x
	self.y = self.y - other.y

	return self
end

function vector:mul(other)
	if isnumber(other) then
		self.x = self.x * other
		self.y = self.y * other
	else
		assert(isvector(other), "bad argument #1 to 'vector:mul' (vector or number expected, got ".. type(other).. ")")
		self.x = self.x * other.x
		self.y = self.y * other.y
	end

	return self
end

function vector:div(other)
	if isnumber(other) then
		self.x = self.x / other
		self.y = self.y / other
	else
		assert(isvector(other), "bad argument #1 to 'vector:div' (vector or number expected, got ".. type(other).. ")")
		self.x = self.x / other.x
		self.y = self.y / other.y
	end

	return self
end

function vector:mod(other)
	if isnumber(other) then
		self.x = self.x % other
		self.y = self.y % other
	else
		assert(isvector(other), "bad argument #1 to 'vector:mod' (vector or number expected, got ".. type(other).. ")")
		self.x = self.x % other.x
		self.y = self.y % other.y
	end

	return self
end

function vector:pow(other)
	if isnumber(other) then
		self.x = self.x ^ other
		self.y = self.y ^ other
	else
		assert(isvector(other), "bad argument #1 to 'vector:pow' (vector or number expected, got ".. type(other).. ")")
		self.x = self.x ^ other.x
		self.y = self.y ^ other.y
	end

	return self
end

-- Equivalence Comparison Operators

function vector:equal(other)
	if not isvector(other) then return false end
	return (self.x == other.x and self.y == other.y)
end

function vector:less(other)
	assert(isvector(other), "bad argument #1 to 'vector:sub' (vector expected, got ".. type(other).. ")")
	return (self.x < other.x and self.y < other.y)
end

function vector:lessequal(other)
	assert(isvector(other), "bad argument #1 to 'vector:sub' (vector expected, got ".. type(other).. ")")
	return (self.x <= other.x and self.y <= other.y)
end

-- More Method

function vector:distance(other)
	assert(isvector(other), "bad argument #1 to 'vector:sub' (vector expected, got ".. type(other).. ")")
	return self:sub(other):length()
end

function vector:normalize()
	return self:div(self:length())
end

function vector:dot(other)
	assert(isvector(other), "bad argument #1 to 'vector:sub' (vector expected, got ".. type(other).. ")")
	return self.x * other.x + self.y + other.y
end

function vector:cross(other)
	assert(isvector(other), "bad argument #1 to 'vector:sub' (vector expected, got ".. type(other).. ")")
	return self.x * other.y - self.y * other.x
end

function vector:perpendicular()
	return Vector(-self.y, self.x)
end

function vector:zero()
	self.x = 0
	self.y = 0
	return self
end