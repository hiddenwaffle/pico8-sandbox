pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

lib_vector2_defined__ = true

-- based on the babylon.js api,
-- augmented by the processing api
vector2_type = { }

function vector2_type:new(x, y)
  local o = {
    x = x or 0,
    y = y or 0
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function vector2_type:add(other)
  local ref = self:copy()
  ref:add_in_place(other)
  return ref
end

function vector2_type:add_in_place(other)
  self.x += other.x
  self.y += other.y
  return self
end

function vector2_type:copy()
  return vector2_type:new(self.x, self.y)
end

function vector2_type:equals(other)
  return self.x == other.x and self.y == other.y
end

-- prevents 16-bit overflow by scaling down then back up
-- todo: use distance() with zero vector instead to reduce duplication
function vector2_type:length()
  local x = self.x * 0.001
  local y = self.y * 0.001
  return sqrt(x * x + y * y) / 0.001
end

-- from processing
function vector2_type:limit_in_place(s)
  if (self:length() > s) self:set_length(s)
end

function vector2_type:normalize()
  local m = self:length()
  if (m == 0) m = 0.001 -- todo: see what babylon does
  self.x /= m
  self.y /= m
  return self
end

-- from processing
function vector2_type:rotate_in_place(a)
  local temp = self.x
  self.x = self.x * cos(a) - self.y * sin(a)
  self.y = temp * sin(a) + self.y * cos(a)
  return self
end

-- from processing
function vector2_type:set_length(s)
  self:normalize()
  self:scale_in_place(s)
end

function vector2_type:subtract(other)
  local ref = self:copy()
  ref:subtract_in_place(other)
  return ref
end

function vector2_type:subtract_in_place(other)
  self.x -= other.x
  self.y -= other.y
  return self
end

function vector2_type:to_str()
  return '[' .. self.x .. ' ' .. self.y .. ']'
end

function vector2_type.lerp(v1, v2, amt)
  -- todo: one allocation instead of two
  local d = v2:copy():subtract_in_place(v1):scale(amt)
  return v1:copy():add(d)
end

-- todo: lerp_to_ref() ?

function vector2_type:scale_in_place(s)
  self.x *= s
  self.y *= s
  return self
end

function vector2_type:set(x, y)
  self.x = x
  self.y = y
end

-- from https://www.youtube.com/watch?v=YNyULRrydVI
-- is like crossing two 3d vectors with z = 0
-- returns a scalar because x and y are always 0
-- used for determining if a vector is to the left or right to another one in 2d.
function vector2_type.cross(u, v, ref)
  return u.x * v.y - u.y * v.x
end

-- scales down to prevent overflow, possible loss of precision
function vector2_type.distance(v1, v2)
  local x1 = v1.x * 0.001
  local x2 = v2.x * 0.001
  local y1 = v1.y * 0.001
  local y2 = v2.y * 0.001
  local a = sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1))
  return a / 0.001
end

function vector2_type.from_angle(a)
  return vector2_type:new(cos(a), sin(a))
end

function vector2_type.random()
  local v = vector2_type:new(rnd(2) - 1, rnd(2) - 1) -- good enough
  v:normalize()
  return v
end

function vector2_type.transform(v, m)
  local ref = vector2_type:new()
  vector2_type.transform_to_ref(v, m, ref)
  return ref
end

function vector2_type.transform_to_ref(v, m, ref)
  ref.x = v.x * m[1][1] + v.y * m[2][1]
  ref.y = v.x * m[1][2] + v.y * m[2][2]
end
