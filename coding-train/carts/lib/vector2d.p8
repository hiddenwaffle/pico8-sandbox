pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- assert(lib_math_defined__)
lib_vector2d_defined_ = true

vector2d_type = { }

function vector2d_type:new(x, y)
  local o = {
    x = x or 0,
    y = y or 0
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function vector2d_type:add(other)
  self.x += other.x
  self.y += other.y
  return self
end

function vector2d_type:sub(other)
  self.x -= other.x
  self.y -= other.y
  return self
end

function vector2d_type:mult(amt)
  self.x *= amt
  self.y *= amt
  return self
end

function vector2d_type:magnitude_sq()
  return self.x ^ 2 + self.y ^ 2
end

function vector2d_type:magnitude()
  return sqrt(self:magnitude_sq())
end

function vector2d_type:set_mag(amt)
  self:normalize()
  self:mult(amt)
  return self
end

function vector2d_type:normalize()
  local m = self:magnitude()
  if (m == 0) m = 0.0001 -- bandaid
  self.x /= m
  self.y /= m
  return self
end

function vector2d_type:copy()
  return vector2d_type:new(self.x, self.y)
end

function vector2d_type:copy_to_ref(ref)
  ref.x = self.x
  ref.y = self.y
  -- todo: return self or ref here?
end

function vector2d_type.random_vector()
  local v = vector2d_type:new(rnd(2) - 1, rnd(2) - 1) -- good enough
  v:normalize()
  return v
end

-- 16 bit as in scaled down to prevent overflow
function vector2d_type.dist_16bit(v1, v2)
  local x1 = v1.x * 0.001
  local x2 = v2.x * 0.001
  local y1 = v1.y * 0.001
  local y2 = v2.y * 0.001
  local a = sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
  return a / 0.001
end
-- local v1 = vector2d_type:new(0, 0)
-- local v2 = vector2d_type:new(3000, 4000)
-- print(vector2d_type.dist_16bit(v1, v2))

function vector2d_type.dot(v1, v2)
  return v1.x * v2.x + v1.y * v2.y
end

-- arccos of the dot product over the product of the magnitudes
function vector2d_type.angle_between(v1, v2)
  return vector2d_type.acos(
    vector2d_type.dot(g.v1, g.v2)
    /
    (v1:magnitude() * v2:magnitude()))
end

function vector2d_type.from_angle(angle)
  return vector2d_type:new(cos(angle), sin(angle))
end

-- From:
-- https://www.lexaloffle.com/bbs/?pid=52433
-- http://developer.download.nvidia.com/cg/acos.html
function vector2d_type.acos(x)
  local negate = (x < 0 and 1.0 or 0.0)
  x = abs(x)
  local ret = -0.0187293
  ret *= x
  ret += 0.0742610
  ret *= x
  ret -= 0.2121144
  ret *= x
  ret += 1.5707288
  ret *= sqrt(1.0 - x)
  ret -= 2 * negate * ret
  ret = negate * 3.14159265358979 + ret
  return ret / (2 * 3.14159265358979) -- map to [0, 1)
end
