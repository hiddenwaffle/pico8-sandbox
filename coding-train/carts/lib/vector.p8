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
