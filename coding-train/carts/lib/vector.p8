pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- assert(lib_math_defined__)
lib_vector_defined_ = true

vector_type = { }

function vector_type:new(x, y)
  local o = {
    x = x or 0,
    y = y or 0
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function vector_type:add(other)
  self.x += other.x
  self.y += other.y
end

function vector_type:sub(other)
  self.x -= other.x
  self.y -= other.y
end

function vector_type:mult(amt)
  self.x *= amt
  self.y *= amt
end

function vector_type:magnitude_sq()
  return self.x ^ 2 + self.y ^ 2
end

function vector_type:magnitude()
  return sqrt(self:magnitude_sq())
end

function vector_type:set_mag(amt)
  self:normalize()
  self:mult(amt)
end

function vector_type:normalize()
  local m = self:magnitude()
  if (m == 0) m = 0.0001 -- bandaid
  self.x /= m
  self.y /= m
end

function vector_type:copy()
  return vector_type:new(self.x, self.y)
end

function vector_type.random_vector()
  local v = vector_type:new(rnd(2) - 1, rnd(2) - 1) -- good enough
  v:normalize()
  return v
end

-- 16 bit as in scaled down to prevent overflow
function vector_type.dist_16bit(v1, v2)
  local x1 = v1.x * 0.001
  local x2 = v2.x * 0.001
  local y1 = v1.y * 0.001
  local y2 = v2.y * 0.001
  local a = sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
  return a / 0.001
end
local v1 = vector_type:new(0, 0)
local v2 = vector_type:new(3000, 4000)
print(vector_type.dist_16bit(v1, v2))
